from a import *

# had a look at https://github.com/shack/aoc/blob/1857866fa79a6aa635a0bb137de7e93d57ca9847/2024/14/d14p2.py
# because what the fuck is a christmas tree?

if __name__ == "__main__":
    robots = parse()

    n = len(robots)
    i = 0

    while True:
        s = set(tuple(r.p) for r in robots)
        if len(s) == n:
            dbg(robots)
            print(i)

        step(robots)
        i += 1
    