from a import parse, d, sys

def find_fourth_corner(a, b, c):
    xs = set(x for (x, y) in (a, b, c))
    ys = set(y for (x, y) in (a, b, c))
    for x in xs:
        for y in ys:
            if (x, y) in (a, b, c):
                continue
            return (x, y)

def simulate(obstacles, board, start, on_hit=None):
    (w, h) = board
    (x, y) = start
    r = 0

    visited = set()

    def guard_in_board():
        return 0 <= x < w and 0 <= y < h

    def next_pos():
        dx, dy = d[r]
        return x + dx, y + dy
    
    while True:
        if not guard_in_board():
            return "exit"
        
        if (x, y, r) in visited:
            return "loop"
        visited.add((x, y, r))

        while next_pos() in obstacles:
            if on_hit:
                on_hit(x, y, r)
            r += 1
            r %= 4
        
        x, y = next_pos()

if __name__ == "__main__":
    obstacles, (w, h), (x, y) = parse()

    class Hits:
        def __init__(self):
            self.a = None
            self.b = None
            self.c = None
            
            self.candidates = set()
        
        def on_hit(self, x, y, r):
            self.a, self.b, self.c = self.b, self.c, (x, y)
            if not self.a:
                return
            cx, cy = find_fourth_corner(self.a, self.b, self.c)
            dx, dy = d[(r+1)%4]
            self.candidates.add((cx + dx, cy + dy))

    state = Hits() 

    # simulate(obstacles, (w, h), (x, y), on_hit=state.on_hit)
    
    #for c in state.candidates:
    for stupid_y in range(h):
        print(f"{stupid_y} / {h}", file=sys.stderr)
        for stupid_x in range(w):
            c = (stupid_x, stupid_y)
            result = simulate(obstacles | {c}, (w, h), (x, y))
            # print(f"run {c=} {result=}")
            if result == "loop":
                print(f"loop @ {c}")
    