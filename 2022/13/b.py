import functools
from a import read_input, cmp

if __name__ == "__main__":
    packets = []
    for (a, b) in read_input():
        packets.append(a)
        packets.append(b)
        
    packets.append([[2]])
    packets.append([[6]])

    packets.sort(key=functools.cmp_to_key(cmp))

    res = (packets.index([[2]]) + 1) * (packets.index([[6]]) + 1)
    print(res)