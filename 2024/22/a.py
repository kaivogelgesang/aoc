import sys
import numpy as np
from datetime import datetime


def parse():
    return [int(line.strip()) for line in sys.stdin.readlines() if line]


def step(state):
    state ^= state << 6
    state &= 0xFFFFFF
    state ^= state >> 5
    state &= 0xFFFFFF
    state ^= state << 11
    state &= 0xFFFFFF
    return state


if __name__ == "__main__":
    t0 = datetime.now()

    rngs = np.array(parse())

    for _ in range(2000):
        step(rngs)

    print(np.sum(rngs))

    t1 = datetime.now()
    dt = t1 - t0
    print(dt.seconds, dt.microseconds / 1000)
