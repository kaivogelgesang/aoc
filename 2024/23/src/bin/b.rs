use std::collections::HashSet;

use solution::*;

fn node_name(node: u16) -> String {
    let a0 = (node >> 8) as u8;
    let a1 = (node & 0xFF) as u8;

    String::from_utf8_lossy(&[a0, a1]).to_string()
}

fn main() {
    let (ts, adj) = parse();
    
    let connected = |a, b| adj.get()

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