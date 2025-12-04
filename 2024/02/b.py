from a import parse
from itertools import pairwise

def is_safe(r):
    def _safe(r, lo, hi):
        return all([
            lo <= (b - a) <= hi
            for (a, b) in pairwise(r)
        ])

    if not _safe(r, 1, 3):
        return _safe(r, -3, -1)
    return True

if __name__ == "__main__":
    reports = parse()
    s = 0

    for r in reports:
        if is_safe(r):
            s += 1
        else:
            print(f"{r} unsafe")
            for i in range(len(r)):
                r2 = r[:i] + r[i+1:]
                if is_safe(r2):
                    s += 1
                    break
    
    print(s)
