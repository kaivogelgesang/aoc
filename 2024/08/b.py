from a import parse

if __name__ == "__main__":
    (w, h), board = parse()
    visited = set()
    locations = set()

    def is_in_bounds(x, y):
        return 0 <= x < w and 0 <= y < h

    for a in board.items():
        visited.add(a)
        for b in board.items():
            if b in visited:
                continue
            
            (x0, y0), c = a
            (x1, y1), c2 = b

            if c != c2:
                continue
            
            dx = x1 - x0
            dy = y1 - y0
            
            # positive
            x, y = x0, y0
            while is_in_bounds(x, y):
                locations.add((x, y))
                x += dx
                y += dy
            
            # negative
            x, y = x0, y0
            while is_in_bounds(x, y):
                locations.add((x, y))
                x -= dx
                y -= dy
    
    print(len(locations))