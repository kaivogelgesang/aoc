import sys
from collections import defaultdict
from queue import PriorityQueue
from math import inf

def parse():
    board = [
        list(line.strip())
        for line in sys.stdin.readlines()
        if line
    ]

    h = len(board)
    w = len(board[0])

    def get(x, y):
        if 0 <= x < w and 0 <= y < h:
            return board[y][x]
        return "#"

    adj = defaultdict(list)
    dirs = "NESW"

    start = None
    end = None

    for y, row in enumerate(board):
        for x, c in enumerate(row):

            if c == "S":
                start = (x, y, "E")
            
            if c == "E":
                for d in dirs:
                    adj[(x, y, d)].append(((-1, -1, "goal"), 0))
            
            # turns
            for i, d in enumerate(dirs):
                adj[(x, y, d)].append(((x, y, dirs[(i+1)%4]), 1000))
                adj[(x, y, d)].append(((x, y, dirs[(i-1)%4]), 1000))
            
            # steps
            for (d, dx, dy) in [
                ("N", 0, -1),
                ("E", 1, 0),
                ("S", 0, 1),
                ("W", -1, 0),
            ]:
                if get(x+dx, y+dy) != "#":
                    adj[(x, y, d)].append(((x+dx, y+dy, d), 1))
    
    return start, adj


def dijkstra(start, adj):
    q = PriorityQueue()
    q.put((0, start))
    
    d = dict()

    while not q.empty():
        (dist, cur) = q.get()
        if cur in d:
            continue
        d[cur] = dist
        
        for (node, cost) in adj[cur]:
            q.put((dist + cost, node))
    
    return d


if __name__ == "__main__":
    start, adj = parse()
    d = dijkstra(start, adj)
    
    print(d[(-1, -1, "goal")])
