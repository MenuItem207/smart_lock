import enum

from test_mode import TestMode
from states import State

# handles the testing states
class Test:
    def __init__(self, test_mode: TestMode):
        self.test_mode = test_mode
        self.id = test_mode.value

        if self.test_mode == TestMode.NORMAL:
            self.state = State.IDLE
        else:
            self.state = State.SETUP
