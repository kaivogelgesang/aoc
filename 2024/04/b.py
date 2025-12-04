from a import parse

if __name__ == "__main__":
    grid = parse()
    s = 0

    h = len(grid)
    w = len(grid[0])

    def check_m_s(x1, y1, x2, y2):
        if not 0 <= x1 < w:
            return False
        if not 0 <= x2 < w:
            return False
        if not 0 <= y1 < h:
            return False
        if not 0 <= y2 < h:
            return False

        a = grid[y1][x1]
        b = grid[y2][x2]

        return (a == "M" and b == "S") \
            or (a == "S" and b == "M")

    for y in range(h):
        for x in range(w):
            if grid[y][x] != "A":
                continue

            # + shape
            # if check_m_s(x - 1, y, x+1, y) and check_m_s(x, y-1, x, y+1):
            #     s += 1

            # x shape
            if check_m_s(x-1, y-1, x+1, y+1) and check_m_s(x-1, y+1, x+1, y-1):
                s += 1
    
    print(s)
