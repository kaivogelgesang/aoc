use std::{collections::{HashMap, HashSet}, io};

pub fn parse() -> (Vec<u16>, HashMap<u16, HashSet<u16>>) {
    let mut ts = Vec::new();
    let mut adj = HashMap::new();
    for line in io::stdin().lines() {
        let [a0, a1, _, b0, b1] = line.unwrap().chars().collect::<Vec<_>>()[..] else { continue };
        let a = (a0 as u16) << 8 | a1 as u16;
        let b = (b0 as u16) << 8 | b1 as u16;

        if a0 == 't' {
            ts.push(a);
        }

        adj.entry(a).or_insert(HashSet::new()).insert(b);
        adj.entry(b).or_insert(HashSet::new()).insert(a);
    }
    (ts, adj)
}
