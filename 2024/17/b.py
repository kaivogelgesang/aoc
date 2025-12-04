from collections import defaultdict

def get(a):
    b = a & 7 ^ 3
    b ^= a >> b
    b ^= 5
    return b & 7

def sim(a):
    out = []
    while a:
        out.append(get(a))
        a >>= 3
    # print(",".join(map(str, out)))
    return out

target = [2,4,1,3,7,5,4,2,0,3,1,5,5,5,3,0]
target.reverse()

options = []

def dfs(current):
    prefix = sim(current)
    # print(f"[dfs] {current=} {prefix=}")
    prefix.reverse()
    if target[:len(prefix)] != prefix:
        return

    if len(prefix) == len(target):
        print(current)
        options.append(current)

    for i in range(8):
        dfs(current << 3 | i)

for i in range(1, 8):
    dfs(i)

print(min(options))