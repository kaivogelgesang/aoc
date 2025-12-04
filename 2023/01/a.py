import sys


def parse() -> list[int]:
    result = []
    for line in sys.stdin.readlines():
        digits = list(map(int, filter(str.isdigit, line)))
        value = digits[0] * 10 + digits[-1]
        result.append(value)
    return result


if __name__ == "__main__":
    print(sum(parse()))
