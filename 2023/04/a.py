import sys
from dataclasses import dataclass

@dataclass
class Card:
    number: int
    winning: list[int]
    have: list[int]

    def matching(self):
        return len(self.winning & self.have)

    def score(self):
        matching = self.matching()
        return 1 << (matching - 1) if matching > 0 else 0

def parse() -> list[Card]:
    cards = []
    for line in sys.stdin.readlines():
        a, b = line.split(":")
        number = int(a.split()[-1])
        w, h = b.split("|")
        winning = set(map(int, w.split()))
        have = set(map(int, h.split()))

        cards.append(Card(number, winning, have))
    
    return cards

if __name__ == "__main__":
    result = 0

    for card in parse():
        result += card.score()
    
    print(result)
