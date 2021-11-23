from data import Data
from states import State


def main():
    data = Data()
    while True:
        data.run(old_state, on_state_change)


old_state = State.NOTHING  # remembers the last state


def on_state_change(new_state: State):
    global old_state
    old_state = new_state


# run main
if __name__ == "__main__":
    main()
