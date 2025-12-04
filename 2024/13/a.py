import sys
import re
from dataclasses import dataclass
import numpy as np

@dataclass
class Machine:
    a: (int, int)
    b: (int, int)
    prize: (int, int)

    def solve(self):
        (ax, ay) = self.a
        (bx, by) = self.b
        (px, py) = self.prize

        m = np.array([[ax, bx],
                      [ay, by]])
        
        p = np.array([px, py])

        try:
            a0, b0 = map(int, np.linalg.solve(m, p))
        except np.linalg.LinAlgError:
            return None
        
        for da in [0, 1, -1]:
            for db in [0, 1, -1]:
                a1 = a0 + da
                b1 = b0 + db
                if a1 * ax + b1 * bx == px and a1 * ay + b1 * by == py:
                    return (a1, b1)
        
        return None


def parse():
    r = re.compile(r"Button A: X\+(?P<ax>\d+), Y\+(?P<ay>\d+)\nButton B: X\+(?P<bx>\d+), Y\+(?P<by>\d+)\nPrize: X=(?P<px>\d+), Y=(?P<py>\d+)")
    machines = []

    for m in r.finditer(sys.stdin.read()):
        g = m.groupdict()
        a = (int(g["ax"]), int(g["ay"]))
        b = (int(g["bx"]), int(g["by"]))
        prize = (int(g["px"]), int(g["py"]))
        machines.append(Machine(a, b, prize))
    
    return machines

if __name__ == "__main__":
    machines = parse()
    
    total = 0
    for m in machines:
        if (s := m.solve()) is not None:
            a, b = s
            total += 3 * a + b
    
    print(total)
