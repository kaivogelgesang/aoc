from a import *

if __name__ == "__main__":
    with open(sys.argv[1], "r") as f:
        wires, depends, ops = parse(f)
    order = list(TopologicalSorter(depends).static_order())

    depth = dict()
    for w, v in wires.items():
        if v is not None:
            depth[w] = 0

    def query(name):
        red = "\033[31m"
        rst = "\033[0m"
        for (c, (a, b, op)) in ops.items():
            o = op.__name__.strip("_").upper()
            if a == name:
                print(f"{red}{a}{rst} {o} {b} -> {c}")
            elif b == name:
                print(f"{a} {o} {red}{name}{rst} -> {c}")
            elif c == name:
                print(f"{a} {o} {b} -> {red}{name}{rst}")


    def find_full_adder(i):
        x = f"x{i:02d}"
        y = f"y{i:02d}"
        z = f"z{i:02d}"

        (t, c, op) = ops[z]
        if op.__name__ != "xor":
            print(f"sus z: {z}", file=sys.stderr)
            return z

        (a, b, op) = ops[c]
        if op.__name__ == "xor":
            t, c = c, t

        (a, b, op) = ops[c]
        if op.__name__ != "or_":
            print(f"sus c: {c}", file=sys.stderr)
            return True

        (x2, y2, op) = ops[t]
        if op.__name__ != "xor" or tuple(sorted((x2, y2))) != (x, y):
            print(f"sus t: {t}", file=sys.stderr)
            return True
        
        (x2, y2, op) = ops[a]
        if x2 not in (x, y):
            a, b = b, a
        
        (x2, y2, op) = ops[a]
        if op.__name__ != "and_" or tuple(sorted((x2, y2))) != (x, y):
            print(f"sus a: {a}", file=sys.stderr)
            return True

        return False
        
        """
        (t2, c2, op) = ops[b]
        if t2 != t or c2 != c or op.__name__.strip("_") != "and":
            print(f"sus: {b}", file=sys.stderr)
            return b
        (x2, y2, op) = ops[a]
        if x2 != x or y2 != y or op.__name__.strip("_") != "and":
            print(f"sus: {a}", file=sys.stderr)
            return a
        """
        
    
    for wire in order:
        if wire in depth:
            continue
        (x, y, _) = ops[wire]
        depth[wire] = max(depth[x], depth[y]) + 1
    
    zs = [f"z{i:02d}" for i in range(45)]

    for z in zs:
        print(f"depth[{z}] = {depth[z]}", file=sys.stderr)
        
    
    for i in range(1, 45):
        if find_full_adder(i):
            print(f"full adder {i} is sus", file=sys.stderr)
    
