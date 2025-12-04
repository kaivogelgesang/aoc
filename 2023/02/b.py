from a import parse
import math

if __name__ == "__main__":
    games = parse()

    result = 0

    for samples in games.values():
        r = max(r for (r, _, _) in samples)
        g = max(g for (_, g, _) in samples)
        b = max(b for (_, _, b) in samples)

        power = r * g * b

        result += power
    
    print(result)