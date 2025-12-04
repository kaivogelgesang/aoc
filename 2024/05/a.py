import sys

type ordering = set[(int, int)]
type updates = list[int]

def parse() -> (ordering, updates):
    ordering = set()
    updates = list()

    for line in sys.stdin.readlines():
        if "|" in line:
            [a, b] = line.split("|")
            ordering.add((int(a), int(b)))
        elif "," in line:
            updates.append([int(v) for v in line.split(",")])

    return (ordering, updates)

if __name__ == "__main__":
    o, updates = parse()
    s = 0

    def in_order(row):
        for (i, b) in enumerate(row):
            if i == 0:
                continue
            for (j, a) in enumerate(row[:i]):
                if (b, a) in o:
                    return False
        return True
    
    def middle_page(row):
        return row[len(row) // 2]
    
    for row in updates:
        if in_order(row):
            s += middle_page(row)
    
    print(s)
