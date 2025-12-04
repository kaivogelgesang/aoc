import sys
from collections import defaultdict
from queue import Queue


def parse():
    return [list(line.strip()) for line in sys.stdin.readlines() if line]


def build_graph(board):
    w = len(board[0])
    h = len(board)

    start = None
    end = None
    adj = defaultdict(list)

    for y, row in enumerate(board):
        for x, c in enumerate(row):
            if c == "#":
                continue
            if c == "S":
                start = (x, y)
            if c == "E":
                end = (x, y)
            for dx, dy in [(0, 1), (1, 0), (0, -1), (-1, 0)]:
                x2, y2 = x + dx, y + dy
                if 0 <= x2 < w and 0 <= y2 < h and board[y2][x2] != "#":
                    adj[(x, y)].append((x2, y2))

    return start, end, adj


def dbg(board, highlight):
    for y, row in enumerate(board):
        for x, c in enumerate(row):
            s = highlight.get((x, y)) or c
            print(s, end="", file=sys.stderr)
        print(file=sys.stderr)


def bfs(start, adj):
    d = dict()
    q = Queue()

    q.put((start, 0))
    while not q.empty():
        cur, dist = q.get()
        if cur in d:
            continue
        d[cur] = dist
        for node in adj[cur]:
            q.put((node, dist + 1))

    return d


if __name__ == "__main__":
    board = parse()
    start, end, adj = build_graph(board)

    d = bfs(start, adj)
    for x, y in d:
        assert board[y][x] != "#"

    no_cheat_dist = d[end]
    print(f"{no_cheat_dist=}", file=sys.stderr)

    radj = defaultdict(list)
    for node in adj:
        for child in adj[node]:
            radj[child].append(node)

    d2 = bfs(end, radj)
    for x, y in d2:
        assert board[y][x] != "#"

    dxdy = [(-1, 0), (0, 1), (1, 0), (0, -1)]

    cheats = dict()

    for y, row in enumerate(board):
        for x, c in enumerate(row):
            if c != "#":
                continue
            for dx, dy in dxdy:
                a = (x + dx, y + dy)
                if a not in d:
                    continue
                for dx2, dy2 in dxdy:
                    b = (x + dx2, y + dy2)
                    if b == a or b not in d2:
                        continue

                    dist = d[a] + 2 + d2[b]
                    saved = no_cheat_dist - dist

                    if saved > 0:
                        assert ((a, b) not in cheats) or (cheats[(a, b)] == saved)
                        cheats[(a, b)] = saved

    print(len([1 for v in cheats.values() if v >= 100]))
