import sys
import math

def parse() -> list[tuple[int, int]]:
    lines = sys.stdin.readlines()
    times = map(int, lines[0].split(":")[1].split())
    distances = map(int, lines[1].split(":")[1].split())

    return list(zip(times, distances))

def s(t, d):
    a = t / 2
    b = math.sqrt(t*t/4 - d)
    return a - b, a + b

if __name__ == "__main__":
    races = parse()

    result = 1

    for (t, d) in races:
        lower, upper = s(t, d)

        lower = math.floor(lower) - 1
        while lower * (t - lower) <= d:
            lower += 1

        upper = math.ceil(upper) + 1
        while upper * (t - upper) <= d:
            upper -= 1
        
        result *= upper - lower + 1
    
    print(result)
