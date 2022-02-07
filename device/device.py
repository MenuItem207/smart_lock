import RPi.GPIO as GPIO
import subprocess
import base64
from time import sleep
from time import *
import I2C_LCD_driver

from states import State

# class that handles the rasberry pi device
class Device:
    def __init__(self, is_test_mode: bool) -> None:
        self.is_open = False  # whether or not the device is open
        self.is_test_mode = is_test_mode  # whether or not the device is in test mode
        self.has_taken_image = False  # whether or not the device has taken an image
        self.display = I2C_LCD_driver.lcd()  # lcd display on the raspberry pi

        # initialise pi
        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)
        GPIO.setup(18, GPIO.OUT)  # buzzer
        GPIO.setup(24, GPIO.OUT)  # LED
        GPIO.setup(22, GPIO.IN)  # switch

    # logic that updates the device states
    def update_device_states(
        self,
        can_open: bool,
        on_is_open_changed,
        update_images,
        change_state,
    ):
        self.check_for_open(on_is_open_changed)

        if self.is_open:
            if can_open:
                self.stop_alarm()
                self.has_taken_image = False
            else:
                # breach
                self.sound_alarm()
                if not self.has_taken_image:
                    subprocess.run(["fswebcam", "pic.jpg"])
                    with open("pic.jpg", "rb") as image:
                        b64string = base64.b64encode(image.read()).decode("utf-8")
                        update_images(b64string)
                        self.has_taken_image = True

        else:
            # device is closed
            if can_open:
                self.unlock_device()
                self.stop_alarm()
                self.has_taken_image = False
            else:
                self.lock_device()
                # TODO: check if potentiometer has reached threshold
                # change the state to PASSWORD
                if False:
                    change_state(State.PASSWORD)

    # output ------------------------------
    # sounds the alarm
    def sound_alarm(self):
        GPIO.output(18, 1)
        self.test_print("Alarm is on")

    # stops the alarm
    def stop_alarm(self):
        GPIO.output(18, 0)
        self.test_print("Alarm is off")

    # unlocks the device
    def unlock_device(self):
        GPIO.output(24, 1)  # turn on LED if unlocked

    # locks the device
    def lock_device(self):
        GPIO.output(24, 0)  # turn off LED if locked

    # shows a message on the lcd
    def show_message(self, message):
        self.test_print("Test message: " + message)
        self.display.lcd_display_string(message)

    # clears the lcd
    def clear_lcd(self):
        self.display.lcd_display_string("           ")

    # input ------------------------------
    def check_for_open(self, on_is_open_changed):
        new_bool = GPIO.input(22)  # if switch is high, device is open

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

    # gets a input from the user
    def get_input(self) -> str:
        MATRIX = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
            ["*", 0, "#"],
        ]  # layout of keys on keypad
        ROW = [6, 20, 19, 13]  # row pins
        COL = [12, 5, 16]  # column pins

        # set column pins as outputs, and write default value of 1 to each
        for i in range(3):
            GPIO.setup(COL[i], GPIO.OUT)
            GPIO.output(COL[i], 1)

        # set row pins as inputs, with pull up
        for j in range(4):
            GPIO.setup(ROW[j], GPIO.IN, pull_up_down=GPIO.PUD_UP)

        fourdigits = []

        self.display.lcd_display_string("Password?")

        # scan keypad
        while True:
            for i in range(3):  # loop thru’ all columns
                GPIO.output(COL[i], 0)  # pull one column pin low
                for j in range(4):  # check which row pin becomes low
                    if GPIO.input(ROW[j]) == 0:  # if a key is pressed
                        self.display.lcd_display_string("                        ")
                        if MATRIX[j][i] == "#":
                            fourdigits = []
                            input = ""
                            self.display.lcd_display_string("                        ")
                        else:
                            # print (MATRIX[j][i]) #print the key pressed
                            fourdigits.append(str(MATRIX[j][i]))
                        input = "".join(fourdigits)
                        print(input)
                        self.display.lcd_display_string(input)
                        if len(fourdigits) > 3:
                            return input

                        while GPIO.input(ROW[j]) == 0:  # debounce
                            sleep(0.1)
                GPIO.output(COL[i], 1)  # write back default value of 1

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
