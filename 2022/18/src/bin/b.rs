use std::collections::{HashSet, VecDeque};

use solution::*;

const DIRS: [(i64, i64, i64); 6] = [
    (-1, 0, 0),
    (1, 0, 0),
    (0, -1, 0),
    (0, 1, 0),
    (0, 0, -1),
    (0, 0, 1),
];

fn main() {
    let mut s = HashSet::new();
    let input = parse();
    for point in input.iter() {
        s.insert(point);
    }

    let min_x = input.iter().map(|(x, _, _)| x).min().unwrap() - 1;
    let max_x = input.iter().map(|(x, _, _)| x).max().unwrap() + 1;
    let min_y = input.iter().map(|(_, y, _)| y).min().unwrap() - 1;
    let max_y = input.iter().map(|(_, y, _)| y).max().unwrap() + 1;
    let min_z = input.iter().map(|(_, _, z)| z).min().unwrap() - 1;
    let max_z = input.iter().map(|(_, _, z)| z).max().unwrap() + 1;

    let mut q = VecDeque::new();
    let mut outside = HashSet::new();
    q.push_back((min_x, min_y, min_z));
    while let Some((x, y, z)) = q.pop_front() {
        if outside.contains(&(x, y, z)) {
            continue;
        }
        outside.insert((x, y, z));
        for (dx, dy, dz) in DIRS {
            let (x, y, z) = (x + dx, y + dy, z + dz);
            if x < min_x || max_x < x {
                continue;
            }
            if y < min_y || max_y < y {
                continue;
            }
            if z < min_z || max_z < z {
                continue;
            }
            if outside.contains(&(x, y, z)) {
                continue;
            }
            if s.contains(&(x, y, z)) {
                continue;
            }
            q.push_back((x, y, z));
        }
    }

    let mut result = 0;
    for &(x, y, z) in s.iter() {
        for (dx, dy, dz) in DIRS {
            if outside.contains(&(x + dx, y + dy, z + dz)) {
                result += 1;
            }
        }
    }

    println!("{result}");
}
