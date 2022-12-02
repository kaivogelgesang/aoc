import sys

score = 0
for line in sys.stdin.readlines():
    abc, xyz = line.strip().split()
    score += {"X": 1, "Y": 2, "Z": 3}[xyz]
    match (abc, xyz):
        # lose
        case ("A", "Z") | ("B", "X") | ("C", "Y"):
            pass
        # draw
        case ("A", "X") | ("B", "Y") | ("C", "Z"):
            score += 3
        # win
        case ("A", "Y") | ("B", "Z") | ("C", "X"):
            score += 6

print(score)
