from a import *

if __name__ == "__main__":
    obstacles = parse()

    def query(i):
        adj = get_adj(obstacles[:i])
        d = dijkstra((0,0), adj)
        return (n, n) in d

    l = 0
    r = len(obstacles)

    assert query(l)
    print("query(l) ok", file=sys.stderr)
    assert not query(r)
    print("query(r) ok", file=sys.stderr)

    while l+1 < r:
        m = (l + r) // 2
        print(f"bisect @ {m}", file=sys.stderr)
        if query(m):
            l = m
        else:
            r = m
    
    (x, y) = obstacles[m]
    print(f"{x},{y}")