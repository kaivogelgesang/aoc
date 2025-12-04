from a import parse
import functools

if __name__ == "__main__":
    o, updates = parse()

    def cmp(a, b):
        if (a, b) in o:
            return -1
        elif (b, a) in o:
            return 1
        else:
            return 0

    s = 0

    for row in updates:
        fixed = sorted(row, key=functools.cmp_to_key(cmp))
        if row != fixed:
            middle = fixed[len(fixed) // 2]
            s += middle
    
    print(s)
