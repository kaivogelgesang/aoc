import sys

def parse():
    l = []
    r = []
    for line in sys.stdin.readlines():
        a, b = line.split()
        a = int(a)
        b = int(b)
        l.append(a)
        r.append(b)
    return l, r

if __name__ == "__main__":
    l, r = parse()
    s = 0
    
    for (a, b) in zip(sorted(l), sorted(r)):
        s += abs(b - a)

    print(s)
