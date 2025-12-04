use std::collections::HashMap;

use solution::*;

fn main() {
    let row = parse();
    let step_count = 75;

    let mut stones = HashMap::new();
    for x in row {
        *stones.entry(x).or_insert(0u64) += 1;
    }

    for i in 0..step_count {
        eprintln!("{}/{} n={}", i, step_count, stones.len());
        let mut new_stones = HashMap::new();
        for (&x, n) in stones.iter() {
            let (a, b) = step(x);
            *new_stones.entry(a).or_insert(0) += n;
            if let Some(b) = b {
                *new_stones.entry(b).or_insert(0) += n;
            }
        }
        stones = new_stones;
    }

    println!("{}", stones.values().sum::<u64>());
}