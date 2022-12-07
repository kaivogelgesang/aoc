use std::{io, collections::HashSet};

fn main() {
    let input = io::stdin().lines().next().unwrap().unwrap();
    for (i, w) in input.chars().collect::<Vec<_>>().windows(4).enumerate() {
        let mut h = HashSet::new();
        for c in w {
            h.insert(c);
        }
        if h.len() == 4 {
            println!("{}", i + 4);
            return;
        }
    }
}