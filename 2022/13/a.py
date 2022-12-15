import itertools
import sys

def read_input():
    res = []
    lines = sys.stdin.read().split("\n\n")
    for (a, b) in map(lambda s: s.split("\n"), lines):
        res.append((eval(a), eval(b)))
    return res

def cmp(a: int | list, b: int | list):
    if isinstance(a, int) and isinstance(b, int):
        return a - b

    if isinstance(a, list) and isinstance(b, list):
        for (l, r) in itertools.zip_longest(a, b):
            if l is None:
                return -1
            if r is None:
                return 1
            c = cmp(l, r)
            if c < 0:
                return -1
            elif c > 0:
                return 1
        return 0

    if isinstance(a, int):
        return cmp([a], b)
    
    if isinstance(b, int):
        return cmp(a, [b])

    raise Exception(f"bad input? {a=!r} {b=!r}")

if __name__ == "__main__":
    result = sum(
        i
        for (i, (a, b)) in enumerate(read_input(), start=1)
        if cmp(a, b) < 0
    )
    
    print(result)