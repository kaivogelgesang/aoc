import sys
from collections import defaultdict
from queue import PriorityQueue


def parse():
    return [tuple(map(int, line.split(","))) for line in sys.stdin.readlines() if line]


def get_adj(obstacles):

    obs = set(obstacles)
    adj = defaultdict(list)

    for y in range(n + 1):
        for x in range(n + 1):
            for dx, dy in [(1, 0), (0, 1), (-1, 0), (0, -1)]:
                x2, y2 = x + dx, y + dy
                if not (0 <= x2 <= n and 0 <= y2 <= n):
                    continue
                if (x2, y2) in obs:
                    continue
                adj[(x, y)].append(((x2, y2), 1))
                
    return adj


def dijkstra(start, adj):
    d = dict()

    q = PriorityQueue()
    q.put((0, start))
    while not q.empty():
        dist, current = q.get()
        if current in d:
            continue
        d[current] = dist
        for node, cost in adj[current]:
            q.put((dist + cost, node))

    return d


n = 70  # 70
byte_count = 1024  # 1024


if __name__ == "__main__":
    adj = get_adj(parse()[:byte_count])

    d = dijkstra((0, 0), adj)

    print(d[(n, n)])
