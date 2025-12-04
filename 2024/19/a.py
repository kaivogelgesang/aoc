import sys

def parse():
    lines = [ line.strip() for line in sys.stdin.readlines() ]

    alphabet = [c.strip() for c in lines[0].split(",")]
    words = lines[2:]

    return alphabet, words


if __name__ == "__main__":
    alphabet, words = parse()
    print(f"{len(alphabet)=}", file=sys.stderr)
    exit(1)

    def dfs(word: str, i: int):
        if i >= len(word):
            return True

        return any(
            dfs(word, i + len(c))
            for c in alphabet
            if word[i:].startswith(c)
        )

    n = len(words)
    s = 0

    for i, word in enumerate(words):
        print(f"{i}/{n}", file=sys.stderr)
        if dfs(word, 0):
            s += 1
    print(s)
