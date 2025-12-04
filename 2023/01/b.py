import sys

digits = {
    "1": 1,
    "one": 1,
    "2": 2,
    "two": 2,
    "3": 3,
    "three": 3,
    "4": 4,
    "four": 4,
    "5": 5,
    "five": 5,
    "6": 6,
    "six": 6,
    "7": 7,
    "seven": 7,
    "8": 8,
    "eight": 8,
    "9": 9,
    "nine": 9,
}


if __name__ == "__main__":
    result = 0
    for line in sys.stdin.readlines():
        leftmost = len(line)
        l_digit = None
        rightmost = -1
        r_digit = None

        for name, value in digits.items():
            l = line.find(name)
            if 0 <= l < leftmost:
                leftmost = l
                l_digit = value

            r = line.rfind(name)
            if r > rightmost:
                rightmost = r
                r_digit = value

        result += 10 * l_digit + r_digit

    print(result)
