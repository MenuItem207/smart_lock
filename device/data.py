import json
import pyrebase
import uuid
import time
import base64

from test import Test
from test_mode import TestMode

from states import State
from states import stateToName
from device import Device

from credentials.firebase_config import config


# handles the different states of the logic
class Data:
    def __init__(self) -> None:
        self.test = Test(TestMode.DISABLED)  # change this to set test mode
        self.uuid = self.test.id  # the uuid of the device
        self.state = self.test.state  # the current state of the logic

        self.can_open = False  # whether or not the device is allowed to be opened
        self.device = Device(False)  # the device object
        self.passwords = (
            []
        )  # the list of passwords that work, the first index is the default password
        self.images = []  # list of {timestamp, images}
        print("uuid: %s" % (self.uuid))

        # backend
        firebase = pyrebase.initialize_app(config)
        self.db = firebase.database()
        if self.test.test_mode == TestMode.NORMAL:
            self.db.child("devices").child(self.uuid).stream(self.sync_data)

    # logic that syncs data with database
    def sync_data(self, message):
        print("data received from backend")
        # see this post for more info:
        # stackoverflow.com/questions/49863708/python-firebase-realtime-listener

        # get the data from the database
        data = list(self.db.child("devices").child(self.uuid).get().val().items())
        self.can_open = json.loads(data[0][1])
        self.passwords = json.loads(data[3][1])
        self.state = State(data[4][1])

    # updates the current state of the logic
    def update_state(self, new_state):
        self.state = new_state
        self.db.child("devices").child(self.uuid).update({"state": new_state.value})

    # state functions

    # called when the device is first set up
    def setup(self):
        # generate uuid and show user
        print("generating uuid")
        _uuid = str(uuid.uuid4())[0:4]
        # update backend
        print("creating user: %s", self.uuid)
        self.db.child("devices").child(_uuid).update(
            {
                "passwords": '["1234"]',
                "can_open": "false",
                "images": "[]",
                "state": self.state.value,
                "is_open": "false",
            }
        )
        print("created")
        self.device.show_message("Login code:")
        time.sleep(2)
        self.device.show_message(str(_uuid))
        time.sleep(10)
        self.uuid = _uuid
        self.device.show_message("Device operating")
        time.sleep(2)
        self.device.clear_lcd()

        self.update_state(State.IDLE)
        # init stream
        print("initialising stream")
        self.db.child("devices").child(self.uuid).stream(self.sync_data)

    # run when the device is in IDLE state and the user opens or closes the device
    def on_is_open_change(self, new_bool: bool):
        self.db.child("devices").child(self.uuid).update(
            {"is_open": json.dumps(new_bool)}
        )

    # called when the device is in PASSWORD state and the user enters a correct password
    def on_password_correct(self):
        self.db.child("devices").child(self.uuid).update(
            {
                "can_open": json.dumps(True),
                "passwords": json.dumps(self.passwords),
            }
        )

    # called when the device state is change
    def change_state(self, state):
        self.db.child("devices").child(self.uuid).update({"state": state.value})

    # updates backend with new image
    def update_images(self, img):
        print("updating images")
        self.images.append(img)
        self.db.child("devices").child(self.uuid).update(
            {"images": json.dumps(self.images)}
        )
        self.db.child("devices").child(self.uuid).stream(self.sync_data)

    # runs the logic
    def run(self, old_state, on_state_changed):
        if old_state != self.state:
            on_state_changed(self.state)
            self.device.show_message(stateToName[self.state])
            print(self.state)

        if self.state == State.SETUP:
            self.setup()
        elif self.state == State.IDLE:
            self.device.update_device_states(
                self.can_open,
                self.on_is_open_change,
                self.update_images,
                self.change_state,
            )
        elif self.state == State.PASSWORD:
            # gets a 4 digit input and goes back to IDLE after
            # if 4 digit input is correct, update backend
            attempt = self.device.get_input()
            if attempt in self.passwords:
                # check if attempt is a temporary password (passwords that have index > 0)
                if self.passwords[0] != attempt:
                    self.passwords.remove(attempt)
                self.on_password_correct()
            self.change_state(State.IDLE)

        elif self.state == State.DISABLED:
            pass
