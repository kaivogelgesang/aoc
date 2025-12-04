import numpy as np
from a import parse, step, sys


STEP_COUNT = 2000


if __name__ == "__main__":
    rngs = np.array(parse())

    seqs = np.zeros((19, 19, 19, 19), dtype=np.uint64)
    visited = [set() for _ in rngs]

    diffs = np.zeros((len(rngs), 4), dtype=np.int64)
    
    for i in range(3):
        prev = np.copy(rngs)
        step(rngs)
        # print(f"step {prev} -> {rngs}")
        difference = (rngs % 10) - (prev % 10)
        # print(f"{difference=}")

        diffs = np.roll(diffs, -1, axis=1)
        diffs[:, -1] = difference
    
    prev = np.copy(rngs) % 10

    for s in range(3, STEP_COUNT):
        print(f"{s}/{STEP_COUNT}", file=sys.stderr)
        step(rngs)
        current = rngs % 10
        diffs = np.roll(diffs, -1, axis=1)
        diffs[:, -1] = current - prev

        for i, [x, y, z, w] in enumerate(diffs):
            coord = (x, y, z, w)
            if coord in visited[i]:
                continue
            visited[i].add(coord)
            if coord == (-2, 1, -1, 3):
                print(f"[{i}]: {current[i]}", file=sys.stderr)
            seqs[x,y,z,w] += current[i]
        
        prev = current

        # print(f"{diffs} -> {current}")
        
    print(np.max(seqs))
