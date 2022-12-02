import sys

score = 0
for line in sys.stdin.readlines():
    abc, xyz = line.strip().split()
    score += {"X": 0, "Y": 3, "Z": 6}[xyz]
    match (abc, xyz):
        # rock
        case ("A", "Y") | ("B", "X") | ("C", "Z"):
            score += 1
        # paper
        case ("A", "Z") | ("B", "Y") | ("C", "X"):
            score += 2
        # scissors
        case ("A", "X") | ("B", "Z") | ("C", "Y"):
            score += 3

print(score)
