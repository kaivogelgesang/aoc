import sys

def parse():
    games = dict()

    for line in sys.stdin.readlines():
        [a, b] = line.split(":")
        game_id = int(a.split()[-1])
        game_samples = []

        for samples in b.split(";"):
            rgb = [0, 0, 0]
            for sample in samples.split(","):
                [count, channel] = list(map(str.strip, sample.split()))
                rgb[["red", "green", "blue"].index(channel)] = int(count)
            game_samples.append(tuple(rgb))

        games[game_id] = game_samples
    
    return games

def is_valid(samples):

    max_r = 12
    max_g = 13
    max_b = 14

    for (r, g, b) in samples:
        if r > max_r or g > max_g or b > max_b:
            return False

    return True

if __name__ == "__main__":
    games = parse()

    game_sum = 0

    for (game_id, samples) in games.items():
        if is_valid(samples):
            game_sum += game_id

    print(game_sum)
