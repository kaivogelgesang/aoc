import sys


def prio(c: str):
    if "a" <= c <= "z":
        return ord(c) - ord("a") + 1
    elif "A" <= c <= "Z":
        return ord(c) - ord("A") + 27


result = 0

for line in sys.stdin.readlines():
    n = len(line)
    item = (set(line[: n // 2]) & set(line[n // 2 :])).pop()
    result += prio(item)

print(result)
