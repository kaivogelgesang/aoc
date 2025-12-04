import sys
import re

def parse():
    r = re.compile(r"mul\((?P<a>\d{1,3}),(?P<b>\d{1,3})\)")
    return [
        (int(m.group("a")), int(m.group("b")))
        for m in r.finditer(sys.stdin.read())
    ]

if __name__ == "__main__":
    print(sum([
        a * b for (a, b) in parse()
    ]))
