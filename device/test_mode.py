import enum

# different test modes
class TestMode(enum.Enum):
    DISABLED = ""
    SETUP = ""  # create new user
    NORMAL = "test_user"  # start from user: user
