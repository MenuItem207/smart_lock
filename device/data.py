import json
import pyrebase
import uuid

from states import State
from device import Device

from credentials.firebase_config import config

# handles the different states of the logic
class Data:
    def __init__(self) -> None:
        self.can_open = False  # whether or not the device is allowed to be opened
        self.device = Device()  # the device object
        self.state = State.SETUP  # the current state of the logic
        self.passwords = []  # the list of passwords that work, the first index is the default password
        self.uuid = "" # the uuid of the device
        
        # backend
        firebase = pyrebase.initialize_app(config)
        self.db = firebase.database()
    
    # logic that syncs data with database
    def sync_data(self, message):
        print('data received from backend')
        # see this post for more info:
        # stackoverflow.com/questions/49863708/python-firebase-realtime-listener
        
        # get the data from the database
        print("Decoding")
        data = message["data"]
        passwords = data["passwords"] 
        self.can_open = json.loads(data["can_open"])
        self.state = State(data["state"])
        print("sucessful decoding")

    # updates the current state of the logic
    def update_state(self, new_state):
        self.state = new_state
        self.db.child("devices").child(self.uuid).update({"state": new_state.value})
        
    # state functions

    # called when the device is first set up
    def setup(self):
        # generate uuid and show user
        print('generating uuid')
        _uuid = uuid.uuid4()
        self.device.show_message("Login code:")
        self.device.show_message(_uuid)
        self.uuid = _uuid
        print('awaiting input')
        self.device.await_input(" ") # wait for user to press next
        self.device.show_message("Set password in app")
        # update backend
        print('creating user')
        print(_uuid)
        self.db.child("devices").child(_uuid).update({"passwords": "[]", "can_open": "false", "state": self.state.value})
        print('created')
        self.update_state(State.IDLE)
        # init stream
        print('initialising stream')
        self.db.child("devices").child(self.uuid).stream(self.sync_data)

    # run when the device is in IDLE state and the user opens or closes the device 
    def on_is_open_change(self, new_bool: bool):
        self.db.child("devices").child(self.uuid).update({"is_open": new_bool})

    # runs the logic
    def run(self):
        print(self.state)
        match self.state:
            case State.SETUP:
                self.setup()
            case State.IDLE:
                self.device.update_device_states(self.can_open, self.on_is_open_change)
            case State.PASSWORD:
                # TODO: code for entering password
                pass
            case State.DISABLED:
                # TODO: code for disabling device
                pass