from a import parse

if __name__ == "__main__":
    result = 0

    cards = parse()
    counts = [1 for _ in cards]

    for i, card in enumerate(cards):
        for j in range(card.matching()):
            counts[i + j + 1] += counts[i]  # quadratic lol
    
    print(sum(counts))
