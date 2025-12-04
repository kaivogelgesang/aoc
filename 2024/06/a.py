import sys

type coord = (int, int)
type obstacles = set[coord]

def parse() -> (obstacles, coord, coord):
    start = None
    w = None
    h = 0
    obstacles = set()

    for (y, line) in enumerate(sys.stdin.readlines()):
        w = len(line)
        h += 1
        for (x, c) in enumerate(line):
            if c == "#":
                obstacles.add((x, y))
            elif c == "^":
                start = (x, y)
    
    return obstacles, (w, h), start

d = [
    (0, -1), # up
    (1, 0),  # right
    (0, 1),  # down
    (-1, 0), # left
]

if __name__ == "__main__":
    obstacles, (w, h), (x, y) = parse()

    visited = set()
    r = 0  # up

    def guard_in_board():
        return 0 <= x < w and 0 <= y < h

    def next_pos():
        dx, dy = d[r]
        return x + dx, y + dy
    
    while guard_in_board():
        visited.add((x, y))

        while next_pos() in obstacles:
            r += 1
            r %= 4
        
        x, y = next_pos()
    
    print(len(visited))
