import sys
import re

if __name__ == "__main__":
    do = True
    s = 0

    r = re.compile(r"mul\((?P<a>\d{1,3}),(?P<b>\d{1,3})\)|(?P<do>do)\(\)|(?P<dont>don\'t)\(\)")
    for m in r.finditer(sys.stdin.read()):
        if m.group("a"):
            # mul instruction
            if not do:
                continue
            s += int(m.group("a")) * int(m.group("b"))
        elif m.group("do"):
            do = True
        elif m.group("dont"):
            do = False
            
    print(s)