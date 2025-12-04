import sys
from collections import defaultdict
import numpy as np

global w, h, r

def parse():
    global w, h, r
    lines = [line.strip() for line in sys.stdin.readlines()]
    
    board = defaultdict(lambda: "#")
    instructions = ""
    
    w = len(lines[0])
    h = 0

    for line in lines:
        if line.startswith("#"):
            for (x, c) in enumerate(line):
                coord = np.array([x, h])
                board[tuple(coord)] = c
                if c == "@":
                    r = np.array([x, h])
            h += 1
        else:
            instructions += line
    
    return board, instructions


def dbg(board):
    for y in range(h):
        for x in range(w):
            print(board[(x, y)], end="", file=sys.stderr)
        print(file=sys.stderr)


if __name__ == "__main__":
    board, instructions = parse()

    print("Initial state:", file=sys.stderr)
    dbg(board)

    dxdy = {
        "<": np.array([-1, 0]),
        "^": np.array([0, -1]),
        ">": np.array([1, 0]),
        "v": np.array([0, 1])
    }

    def push(i):
        # print(f"instruction {i}: ", end="", file=sys.stderr)
        global r
        d = dxdy[i]
        p = r + d
        while True:
            c = board[tuple(p)]
            if c == "#":
                # print("wall detected", file=sys.stderr)
                return
            elif c == "O":
                p += d
                # print(".", end="", file=sys.stderr)
            else:
                assert c == "."
                break

        rel_x, rel_y = p - r
        # print(f"movnig to {rel_x}/{rel_y}", file=sys.stderr)
        
        while np.any(p - r):
            board[tuple(p)] = board[tuple(p-d)]
            # print("board[{}] = board[{}]".format(tuple(map(int, p)), tuple(map(int, p-d))))
            p -= d
        
        board[tuple(r)] = "."
        r += d

    for i in instructions:
        # print(file=sys.stderr)
        # print(f"Move {i}:", file=sys.stderr)
        push(i)
        # dbg(board)

        assert board[tuple(r)] == "@"

    s = 0

    for y in range(h):
        for x in range(w):
            coord = np.array([x, y])
            if board[tuple(coord)] == "O":
                g = 100 * y + x
                s += g
    
    print(s)
