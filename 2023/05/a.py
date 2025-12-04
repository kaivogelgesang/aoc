import sys
import re
from dataclasses import dataclass


@dataclass
class Map:
    source: str
    destination: str
    ranges: list[tuple[int, int, int]]
    
    def map(self, x: int) -> int:
        for (d, s, n) in self.ranges:
            if s <= x < s + n:
                return d + x - s
        return x



r = re.compile(r"(?P<a>[a-z]+)-to-(?P<b>[a-z]+) map:")


def parse():
    lines = sys.stdin.readlines()
    lines.append("\n")

    seeds = list(map(int, lines[0].split(":")[1].split()))
    maps = []

    current_map = None

    for line in lines[1:]:
        if line.isspace():
            if current_map:
                maps.append(current_map)
                current_map = None
        elif m := r.match(line):
            current_map = Map(m.group("a"), m.group("b"), [])
        else:
            a, b, c = map(int, line.split())
            current_map.ranges.append((a, b, c))

    return seeds, maps


if __name__ == "__main__":
    seeds, maps = parse()

    result = []
    
    for seed in seeds:
        location = seed
        for m in maps:
            location = m.map(location)
        result.append(location)
    
    print(min(result))

