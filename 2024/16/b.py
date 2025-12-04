from a import parse, dijkstra, defaultdict

if __name__ == "__main__":
    start, adj = parse()
    end = (-1, -1, "goal")

    radj = defaultdict(list)

    for a, bs in adj.items():
        for (b, cost) in bs:
            radj[b].append((a, cost))
    
    d = dijkstra(start, adj)
    d2 = dijkstra(end, radj)

    path_len = d[end]
    os = set()

    for node in d:
        (x, y, v) = node
        if v == "goal":
            continue

        if d[node] + d2[node] == path_len:
            os.add((x, y))
    
    print(len(os))