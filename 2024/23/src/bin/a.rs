use std::collections::HashSet;

use solution::*;

fn clique_id(a: u16, b: u16, c: u16) -> u64 {
    let mut abc = [a as u64, b as u64, c as u64];
    abc.sort();
    abc[0] | abc[1] << 16 | abc[2] << 32
}

fn main() {
    let (ts, adj) = parse();

    let mut cliques = HashSet::new();

    for (i, &t) in ts.iter().enumerate() {
        // eprintln!("{}", node_name(t));
        eprintln!("{} / {}", i, ts.len());
        let Some(neighbors) = adj.get(&t) else { continue }; 
        for &a in neighbors {
            // adj[a] contains at least t
            for &b in adj.get(&a).unwrap() {
                if neighbors.contains(&b) {
                    cliques.insert(clique_id(a, b, t));
                }
            }
        }
    }

    println!("{}", cliques.len());
}