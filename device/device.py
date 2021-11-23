# class that handles the rasberry pi device
class Device:
    def __init__(self, is_test_mode: bool) -> None:
        self.is_open = False  # whether or not the device is open
        self.should_sound_alarm = False
        self.is_test_mode = is_test_mode  # whether or not the device is in test mode

    # logic that updates the device states
    # returns is_open
    def update_device_states(self, can_open: bool, on_is_open_changed):
        self.check_for_open(on_is_open_changed)

        print(can_open)
        if self.is_open:
            if can_open:
                self.stop_alarm()
                pass
            else:
                self.sound_alarm()
        else:
            # device is closed
            if can_open:
                self.unlock_device()
            else:
                self.lock_device()

    # output ------------------------------
    # sounds the alarm
    def sound_alarm(self):
        self.should_sound_alarm = True
        while self.should_sound_alarm:
            self.test_print("Alarm is on")
            # TODO: sound alarm
            pass

    # stops the alarm
    def stop_alarm(self):
        self.should_sound_alarm = False
        self.test_print("Alarm is off")

    # unlocks the device
    def unlock_device(self):
        # should include logic to check if already unlocked
        # TODO: add logic to unlock the device
        pass

    # locks the device
    def lock_device(self):
        # should include logic to check if already locked
        # TODO: add logic to lock the device
        pass

    # shows a message on the lcd
    def show_message(self, message):
        self.test_print("Test message: " + message)
        # TODO: show message
        pass

    # input ------------------------------
    def check_for_open(self, on_is_open_changed):
        # TODO: add logic to check if the device is open
        new_bool = False

        if self.is_test_mode:
            result = self.test_input("Enter 1 to set as open, 0 to set as closed")
            if result == "1":
                new_bool = True
            elif result == "0":
                new_bool = False

        if self.is_open != new_bool:
            self.is_open = new_bool
            on_is_open_changed(new_bool)
            self.test_print("is_open: " + str(new_bool))
        pass

    # awaits for user to press key
    def await_input(self, key) -> str:
        if self.is_test_mode:
            while self.test_input("Enter a:") != key:
                pass
            return

        while self.get_input() == key:
            pass
        pass

    # gets a input from the user
    def get_input(self) -> str:
        # TODO: get input from user
        return self.test_input("Enter a: ")

    # gets a input from the user
    # and displays message with it
    def get_input_with_message(self, message) -> str:
        # TODO: show message
        # TODO: get input from user

        self.test_input(message)

    # test mode functions

    # prints a message to the console
    def test_print(self, message):
        if self.is_test_mode:
            print(message)

    def test_input(self, message):
        if self.is_test_mode:
            return input(message)
