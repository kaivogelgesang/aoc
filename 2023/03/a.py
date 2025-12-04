import sys

if __name__ == "__main__":
    data = sys.stdin.readlines()
    for i in range(len(data)):
        data[i] = data[i].strip() + '.'  # fix right border

    h = len(data)
    w = len(data[0])

    def symbol_adjacent(x, y):
        for dx in (-1, 0, 1):
            for dy in (-1, 0, 1):
                x2 = x + dx
                y2 = y + dy
                if not (0 <= x2 < w and 0 <= y2 < h):
                    continue
                c2 = data[y2][x2]
                if c2 != '.' and not c2.isdigit():
                    return c2
    
    result = 0

    for y, line in enumerate(data):
        current_num = 0
        symbols = set()
        for x, c in enumerate(line):
            if c.isdigit():
                current_num *= 10
                current_num += int(c)
                s = symbol_adjacent(x, y)
                if s:
                    symbols.add(s)
            else:
                if len(symbols) > 0:
                    # print(f"adding {current_num} (adjacent to {symbols})")
                    result += current_num
                current_num = 0
                symbols = set()

    print(result)
