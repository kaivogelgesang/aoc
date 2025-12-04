import sys
from itertools import pairwise


def parse():
    return [[int(i) for i in line.split()] for line in sys.stdin.readlines()]


if __name__ == "__main__":
    reports = parse()
    s = 0
    for r in reports:

        is_asc = all([a <= b for (a, b) in pairwise(r)])
        is_desc = all([a >= b for (a, b) in pairwise(r)])
        distance_ok = all([1 <= abs(b - a) <= 3 for (a, b) in pairwise(r)])

        if (is_asc or is_desc) and distance_ok:
            s += 1

    print(s)
