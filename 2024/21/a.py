import sys
from collections import defaultdict
from queue import PriorityQueue
from itertools import permutations


def parse():
    return [line.strip() for line in sys.stdin.readlines() if line]


K_9 = [[ "7", "8", "9"],
       [ "4", "5", "6"],
       [ "1", "2", "3"],
       [None, "0", "A"]]

K_D = [[None, "^", "A"],
       [ "<", "v", ">"]]

DIRS = {
    (1, 0): ">",
    (-1, 0): "<",
    (0, 1): "v",
    (0, -1): "^",
}

RDIRS = {
    v: k
    for (k, v) in DIRS.items()
}

def sim(x, y, p, board):
    for c in p:
        dx, dy = RDIRS[c]
        x += dx
        y += dy
        if board[y][x] == None:
            return None
    
    return x, y

def calc_paths(board):
    w = len(board[0])
    h = len(board)

    paths = defaultdict(dict)

    pos = [
        (x, y, board[y][x])
        for y in range(h)
        for x in range(w)
        if board[y][x] is not None
    ]

    for a in pos:
        for b in pos:
            #if a == b:
            #    continue
            (x, y, c) = a
            (x2, y2, c2) = b
            dx = x2 - x
            dy = y2 - y

            cx = ">"
            cy = "v"

            if dx < 0:
                dx = -dx
                cx = "<"
            
            if dy < 0:
                dy = -dy
                cy = "^"
            
            paths[c][c2] = []

            s = set("".join(p) for p in permutations(dx * cx + dy * cy))
            for p in s:
                s_x = x
                s_y = y
                if sim(x, y, p, board) == (x2, y2):
                    paths[c][c2].append(p)
    
    return paths


PATHS_9 = calc_paths(K_9)
PATHS_D = calc_paths(K_D)


def sequences(target, target_paths):
    pos = "A"
    r = set([""])
    for c in target:
        r = {
            prefix + path + "A"
            for prefix in r
            for path in target_paths[pos][c]
        }
        pos = c
    
    return r


if __name__ == "__main__":
    r = 0

    codes = parse()
    for code in codes:
        s1 = sequences(code, PATHS_9)

        s2 = set()
        for s in s1:
            s2 |= sequences(s, PATHS_D)
            
        s3 = set()
        for s in s2:
            s3 |= sequences(s, PATHS_D)

        shortest_len = min(len(s) for s in s3)

        c = shortest_len * int(code[:-1])
        r += c

    print(r)