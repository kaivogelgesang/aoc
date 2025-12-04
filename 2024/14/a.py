import sys
from dataclasses import dataclass
import numpy as np
from math import prod


@dataclass
class Robot:
    p: np.ndarray
    v: np.ndarray


def parse():
    robots = []

    for line in sys.stdin.readlines():
        if not line:
            continue
        
        p, v = line.split()
        robots.append(Robot(
            np.array([int(c) for c in p.strip("p=").split(",")]),
            np.array([int(c) for c in  v.strip("v=").split(",")])
        ))
    
    return robots

w = 101
h = 103


def dbg(robots):
    counts = [[0 for _ in range(w)] for _ in range(h)]
    for r in robots:
        x, y = r.p
        counts[y][x] += 1
    
    for row in counts:
        for n in row:
            if n == 0:
                print(".", file=sys.stderr, end="")
            else:
                print(n, file=sys.stderr, end="")
        print(file=sys.stderr)

mod = np.array([w, h])
def step(robots):
    for r in robots:
        r.p += r.v
        r.p %= mod


def quads(robots):
    q = [0, 0, 0, 0]

    split_x = w // 2
    split_y = h // 2

    for r in robots:
        x, y = r.p
        if x == split_x or y == split_y:
            continue
        lr = 1 if x < split_x else 0
        ud = 2 if y < split_y else 0
        q[lr + ud] += 1
    
    return q


if __name__ == "__main__":
    robots = parse()

    dbg(robots)

    for _ in range(100):
        step(robots)

    print("\nafter 100 steps:", file=sys.stderr)
    dbg(robots)

    q = quads(robots)
    
    print(prod(q))

