use std::collections::HashSet;

use solution::*;

fn main() {
    let mut s = HashSet::new();
    for point in parse() {
        s.insert(point);
    }

    let mut result = 0;
    for &(x, y, z) in s.iter() {
        for (dx, dy, dz) in [
            (-1, 0, 0),
            (1, 0, 0),
            (0, -1, 0),
            (0, 1, 0),
            (0, 0, -1),
            (0, 0, 1),
        ] {
            if !s.contains(&(x + dx, y + dy, z + dz)) {
                result += 1;
            }
        }
    }

    println!("{result}");
}
