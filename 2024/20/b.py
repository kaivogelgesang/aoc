from a import *

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

    dxdy = [
        (dx, dy)
        for dx in range(-20, 21)
        for dy in range(-20, 21)
        if abs(dx) + abs(dy) <= 20
    ]

    cheats = dict()

    for y, row in enumerate(board):
        for x, _ in enumerate(row):
            a = (x, y)
            if a not in d:
                continue
            for dx, dy in dxdy:
                x2, y2 = x + dx, y + dy
                b = (x2, y2)
                if b not in d2:
                    continue

                dist = d[a] + abs(dx) + abs(dy) + d2[b]
                saved = no_cheat_dist - dist

                if saved > 0:
                    assert ((a, b) not in cheats) or (cheats[(a, b)] == saved)
                    cheats[(a, b)] = saved

    print(len([1 for v in cheats.values() if v >= 100]))