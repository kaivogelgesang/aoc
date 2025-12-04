import operator
import sys
from graphlib import TopologicalSorter

def parse(f=sys.stdin):
    wires = dict()
    depends = dict()
    ops = dict()

    for line in f.readlines():
        if ": " in line:
            wire, val = line.strip().split(": ")
            wires[wire] = (val == "1")

        if "->" in line:
            x, op, y, _, z = line.strip().split()
            assert z not in depends
            depends[z] = {x, y}
            ops[z] = (x, y, {
                "AND": operator.and_,
                "OR": operator.or_,
                "XOR": operator.xor
            }[op])
            wires[z] = None
    
    return wires, depends, ops


if __name__ == "__main__":
    wires, depends, ops = parse()

    # for w in sorted(wires.keys()):
    #     s = {False: "0", True: "1", None: "?"}[wires[w]]
    #     print(f"{w}: {s}")

    for wire in TopologicalSorter(depends).static_order():
        if wires[wire] is not None:
            continue
        (x, y, op) = ops[wire]
        wires[wire] = op(wires[x], wires[y])

    r = 0 
    for wire in reversed(sorted([w for w in wires if w.startswith("z")])):
        # print(f"{wire}: {wires[wire]}")
        r <<= 1
        r |= wires[wire]
    print(r)
