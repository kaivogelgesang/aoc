use std::{collections::HashSet, iter::repeat};

use solution::{follow, parse, step};

const N: usize = 10;

fn main() {
    let input = parse();
    let mut rope = [(0, 0); N];

    let mut positions = HashSet::new();

    for dir in input.iter().flat_map(|(dir, n)| repeat(dir).take(*n)) {
        // step every knot in rope

        (rope[0], rope[1]) = step(rope[0], rope[1], *dir);
        for i in 1..N - 1 {
            rope[i + 1] = follow(rope[i], rope[i + 1]);
        }

        // track movement of last knot
        positions.insert(*rope.iter().last().unwrap());
    }

    println!("{}", positions.len());
}
