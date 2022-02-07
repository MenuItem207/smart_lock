import enum

# different states of the logic
class State(enum.Enum):
    SETUP = 1  # state for setting up the device
    IDLE = 2  # state for normal device operation
    PASSWORD = 3  # state for entering the password
    DISABLED = 4  # state for disabling the device
    NOTHING = 5  # state meant for testing purposes


# converts State to name
stateToName = {
    State.SETUP: "SETUP",
    State.IDLE: "IDLE",
    State.PASSWORD: "PASSWORD",
}
