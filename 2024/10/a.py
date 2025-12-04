import sys

def parse():
    return [
        [int(c) if c in "0123456789" else -1 for c in line.strip()]
        for line in sys.stdin.readlines()
    ]

if __name__ == "__main__":
    board = parse()
    h = len(board)
    w = len(board[0])

    def get(x, y):
        if 0 <= x < w and 0 <= y < h:
            return board[y][x]
        else:
            return None
    
    def dfs(x, y, h, visited, succ):
        if (x, y, h) in visited:
            return 0
        visited.add((x, y, h))

        if get(x, y) != h:
            return 0
        if h == 9:
            succ.add((x, y))
            return 1
        
        s = 0
        for dx in [-1, 1]:
            s += dfs(x + dx, y, h+1, visited, succ)
        for dy in [-1, 1]:
            s += dfs(x, y + dy, h+1, visited, succ)
        return s

    scores = 0
    
    for y, row in enumerate(board):
        for x, i in enumerate(row):
            if i == 0:
                succ = set()
                s = dfs(x, y, 0, set(), succ)
                """
                print(f"@{x}/{y}: {s=}")
                for y2 in range(h):
                    for x2 in range(w):
                        c = board[y2][x2]
                        if (x2, y2) == (x, y):
                            c = f"\033[32m{c}\033[0m"
                        elif (x2, y2) in succ:
                            c = f"\033[31m{c}\033[0m"
                        print(c, end="")
                    print()
                print()
                """
                
                scores += s
    
    print(scores)
