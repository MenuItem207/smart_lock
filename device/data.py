import json
import pyrebase
import uuid

from device.states import State
from device.device import Device

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
        self.db.child("devices").child(uuid).stream(self.sync_data)
    
    # logic that syncs data with database
    def sync_data(self, message):
        # see this post for more info:
        # stackoverflow.com/questions/49863708/python-firebase-realtime-listener
        
        # get the data from the database
        data = message["data"]
        passwords = data["passwords"] 
        self.can_open = json.loads(data["can_open"])
        self.state = State(json.loads(data["state"]))

    # updates the current state of the logic
    def update_state(self, new_state):
        self.state = new_state
        self.db.child("devices").child(uuid).update({"state": new_state.value})
        
    # run when the device is opened or closed
    def on_is_open_change(self, new_bool: bool):
        self.db.child("devices").child(uuid).update({"is_open": new_bool})

    # runs the logic
    def run(self):
        match self.state:
            case State.SETUP:
                # generate uuid and show user
                _uuid = uuid.uuid4()
                self.device.show_message("Login code:")
                self.device.show_message(_uuid)

                self.device.await_input(" ") # wait for user to press next

                self.device.show_message("Set password in app")
                
                # update backend
                self.db.child("devices").child(uuid).update({"passwords": [], "can_open": "false", "state": self.state.value})
                self.update_state(State.IDLE)
                pass
            case State.IDLE:
                self.device.update_device_states(self.can_open, self.on_is_open_change)
                pass
            case State.PASSWORD:
                # TODO: code for entering password
                pass
            case State.DISABLED:
                # TODO: code for disabling device
                pass