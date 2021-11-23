# class that handles the rasberry pi device
class Device:
    def __init__(self) -> None:
        self.is_open = False  # whether or not the device is open
        self.should_sound_alarm = False

    # logic that updates the device states
    # returns is_open
    def update_device_states(self, can_open: bool, on_is_open_changed) -> bool:
        self.check_for_open(on_is_open_changed)

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

        return self.is_open

    # output ------------------------------
    # sounds the alarm
    def sound_alarm(self):
        self.should_sound_alarm = True
        while self.should_sound_alarm:
            # TODO: sound alarm
            pass

    # stops the alarm
    def stop_alarm(self):
        self.should_sound_alarm = False

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
        # TODO: show message
        pass

    # input ------------------------------
    def check_for_open(self, new_bool):
        # TODO: add logic to check if the device is open
        new_bool = False

        if self.is_open != new_bool:
            self.is_open = new_bool
            self.on_is_open_changed(new_bool)
        pass

    # awaits for user to press key
    def await_input(self, key) -> str:
        while self.get_input() == key:
            pass
        pass

    # gets a input from the user
    def get_input(self) -> str:
        # TODO: get input from user
        pass

    # gets a input from the user
    # and displays message with it
    def get_input_with_message(self) -> str:
        # TODO: show message
        # TODO: get input from user
        pass
