import sys
from collections import defaultdict

def parse():
    return [
        list(line.strip())
        for line in sys.stdin.readlines()
        if line
    ]

if __name__ == "__main__":
    board = parse()
    h = len(board)
    w = len(board[0])

    size = defaultdict(lambda: 0)
    fence = defaultdict(lambda: 0)

    def get(x, y):
        if 0 <= x < w and 0 <= y < h:
            return board[y][x]
        return None
    
    visited = set()

    def dfs(x, y, c, region):
        if get(x, y) != c:
            return
        if (x, y) in visited:
            return
        visited.add((x, y))

        size[region] += 1

        for (dx, dy) in [
            (-1, 0),
            (1, 0),
            (0, 1),
            (0, -1),
        ]:
                x2 = x + dx
                y2 = y + dy
                if get(x2, y2) != c:
                    fence[region] += 1
                else:
                    dfs(x2, y2, c, region)
    
    r = 0
    for y in range(h):
        for x in range(w):
            if (x, y) in visited:
                continue
            dfs(x, y, get(x, y), r)
            r += 1
    
    s = 0
    for r in size:
        print("{} * {} = {}".format(size[r], fence[r], size[r] * fence[r]), file=sys.stderr)
        s += size[r] * fence[r]
    
    print(s)
                
        