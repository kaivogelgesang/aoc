import sys

def parse():
    return [
        int(c)
        for c in sys.stdin.readline().strip()
    ]

if __name__ == "__main__":
    row = parse()
    space = False
    disk = []
    i = 0
    for f in row:
        if space:
            disk.extend([None] * f)
            space = False
        else:
            disk.extend([i] * f)
            i += 1
            space = True
            
    l = 0
    r = len(disk) - 1
    while True:
        if disk[l] is not None:
            l += 1
            continue

        while disk[r] is None:
            r -= 1

        if l > r:
            break

        disk[l] = disk[r]
        disk[r] = None

    print(sum(i * b for (i, b) in enumerate(disk[:l])))