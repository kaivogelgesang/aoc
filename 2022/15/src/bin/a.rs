use std::{collections::HashSet, env::args};

use solution::*;

fn main() {
    let row: i64 = args()
    .nth(1).ok_or(())
    .map(|s| s.parse().expect("bad arg"))
    .expect("no arg");

    let mut visited = HashSet::new();

    let input = parse();
    for (s, b) in input.iter() {
        let (x0, y0) = s;
        let (x1, y1) = b;
        let dist = (x0 - x1).abs() + (y0 - y1).abs();

        let dh = (y0 - row).abs();
        for x in (x0 - dist + dh)..=(x0 + dist - dh) {
            visited.insert(x);
        }
    }

    for (_, b) in input.iter() {
        let &(x, y) = b;
        if y == row {
            visited.remove(&x);
        }
    }

    /*
    for x in -4..=26 {
        if visited.contains(&x) {
            print!("#")
        } else {
            print!(".")
        }
    }
    println!();
    */

    println!("{}", visited.len());
}
