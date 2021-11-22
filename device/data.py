from device.states import State
from device.device import Device

# handles the different states of the logic
class Data:
    def __init__(self) -> None:
        self.can_open = False  # whether or not the device is allowed to be opened
        self.device = Device()  # the device object
        self.state = State.SETUP  # the current state of the logic

    # updates the current state of the logic
    def update_state(self, new_state):
        self.state = new_state

    # runs the logic
    def run(self):
        match self.state:
            case State.SETUP:
                pass
            case State.IDLE:
                self.device.update_device_states(self.can_open)
                pass
            case State.PASSWORD:
                pass
            case State.DISABLED:
                pass