import sys

def parse():
    return [
        list(line.strip())
        for line in sys.stdin.readlines()
    ]

if __name__ == "__main__":
    rows = parse()
    cols = list(zip(*rows))

    w = len(rows[0])
    h = len(rows)

    diag_slash = [[] for _ in range(w+h)]
    diag_backslash = [[] for _ in range(w+h)]

    for y in range(h):
        for x in range(w):
            c = rows[y][x]
            diag_slash[x + y].append(c)
            diag_backslash[h - y + x].append(c)

    xmas = 0
    for needles in [rows, cols, diag_slash, diag_backslash]:
        for s in needles:
            s = "".join(s)
            xmas += s.count("XMAS")
            xmas += s.count("SAMX")
    print(xmas)

