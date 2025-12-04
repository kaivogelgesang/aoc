import sys

type coord = (int, int)

def parse() -> (coord, dict[coord, str]):
    board = dict()
    w = 0
    h = 0
    for (y, line) in enumerate(sys.stdin.readlines()):
        h += 1
        line = line.strip()
        w = len(line)
        for (x, char) in enumerate(line):
            if char != ".":
                board[(x, y)] = char
    return (w, h), board

if __name__ == "__main__":
    (w, h), board = parse()
    visited = set()
    locations = set()

    for a in board.items():
        visited.add(a)
        for b in board.items():
            if b in visited:
                continue

            (x, y), c = a
            (x2, y2), c2 = b

            if c != c2:
                continue
            
            dx = x2 - x
            dy = y2 - y

            locations.add((x - dx, y - dy))
            locations.add((x2 + dx, y2 + dy))
    
    in_bounds = [
        (x, y)
        for (x, y) in locations
        if 0 <= x < w and 0 <= y < h
    ]

    print(len(in_bounds))
