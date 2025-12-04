import sys

if __name__ == "__main__":
    data = sys.stdin.readlines()
    for i in range(len(data)):
        data[i] = data[i].strip() + '.'  # fix right border

    h = len(data)
    w = len(data[0])

    def symbols_adjacent(x, y):
        result = set()
        for dx in (-1, 0, 1):
            for dy in (-1, 0, 1):
                x2 = x + dx
                y2 = y + dy
                if not (0 <= x2 < w and 0 <= y2 < h):
                    continue
                c2 = data[y2][x2]
                if c2 != '.' and not c2.isdigit():
                    result.add((x2, y2, c2))
        return result
    
    gears = dict()

    for y, line in enumerate(data):
        current_num = 0
        symbols = set()
        for x, c in enumerate(line):
            if c.isdigit():
                current_num *= 10
                current_num += int(c)
                symbols |= symbols_adjacent(x, y)
            else:
                for (x2, y2, s) in symbols:
                    if s != "*":
                        continue
                    if (x2, y2) not in gears:
                        gears[(x2, y2)] = []
                    gears[(x2, y2)].append(current_num)
                current_num = 0
                symbols = set()

    result = 0
    for pos, nums in gears.items():
        #print(f"gear @ {pos}: {nums}")
        match nums:
            case [a, b]:
                #print(f"gear ratio {a * b}")
                result += a * b
    
    print(result)