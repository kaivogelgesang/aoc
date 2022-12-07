use std::{io, collections::HashSet};

fn main() {
    let input = io::stdin().lines().next().unwrap().unwrap();
    for (i, w) in input.chars().collect::<Vec<_>>().windows(14).enumerate() {
        let mut h = HashSet::new();
        for c in w {
            h.insert(c);
        }
        if h.len() == 14 {
            println!("{}", i + 14);
            return;
        }
    }
}