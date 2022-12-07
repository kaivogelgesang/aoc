from itertools import islice
import sys


def prio(c: str):
    if "a" <= c <= "z":
        return ord(c) - ord("a") + 1
    elif "A" <= c <= "Z":
        return ord(c) - ord("A") + 27


def batched(iterable, n):
    it = iter(iterable)
    while batch := list(islice(it, n)):
        yield batch


result = 0

for [a, b, c] in batched(sys.stdin.readlines(), 3):
    item = ((set(a) & set(b) & set(c)) - set('\n')).pop()
    result += prio(item)

print(result)
