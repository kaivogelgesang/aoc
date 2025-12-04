from a import *
from functools import cache
from itertools import pairwise

DPAD_COUNT = 2

@cache
def apsp(a, b, layer):
    paths = PATHS_9 if layer == 0 else PATHS_D

    if layer == DPAD_COUNT:
        return min(len(p) for p in paths[a][b])

    return min([
        sum(apsp(c1, c2, layer + 1)) + 1
        for seq in paths[a][b]
        for c1, c2 in pairwise("A" + seq + "A")
    ])

if __name__ == "__main__":
    r = 0

    codes = parse()
    for code in codes:
        shortest_len = sum(apsp(a, b, 0) for a, b in pairwise(code))

        c = shortest_len * int(code[:-1])
        r += c

    print(r)