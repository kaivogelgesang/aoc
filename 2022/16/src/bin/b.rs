use std::{cmp::max, collections::HashMap};

use solution::*;

fn dfs(
    node: usize,
    t: i64,
    adj: &[Vec<(usize, i64)>],
    flow: &[i64],
    visited: &mut u64,
    cache: &mut HashMap<(usize, i64, u64), i64>,
) -> i64 {
    if t <= 0 {
        return 0;
    }

    let key = (node, t, *visited);

    if let Some(&result) = cache.get(&key) {
        return result;
    }

    *visited |= 1 << node;
    let mut res = 0;
    for &(next, d) in adj[node].iter() {
        if *visited & (1 << next) != 0 {
            continue;
        }
        res = max(res, dfs(next, t - d - 1, adj, flow, visited, cache));
    }
    res += t * flow[node];
    *visited &= !(1 << node);

    cache.insert(key, res);
    res
}

fn main() {
    let (flow, adj, aa) = parse();

    let dist = apsp(&adj);

    let mut candidates = vec![aa];

    candidates.extend((0..adj.len()).filter(|&n| n != aa && flow[n] > 0));

    let mut adj_reduced = vec![Vec::new(); candidates.len()];
    let mut flow_reduced = vec![];

    for (i, &a) in candidates.iter().enumerate() {
        flow_reduced.push(flow[a]);
        for (j, &b) in candidates.iter().enumerate() {
            if a == b {
                continue;
            }
            if let Some(d) = dist[a][b] {
                adj_reduced[i].push((j, d as i64))
            }
        }
    }

    let mut cache = HashMap::new();

    // I can't believe it's not TLE
    let res = (0..1 << adj_reduced.len())
        .map(|set| {
            let mut v1 = set;
            let mut v2 = !set;
            dfs(0, 26, &adj_reduced, &flow_reduced, &mut v1, &mut cache)
                + dfs(0, 26, &adj_reduced, &flow_reduced, &mut v2, &mut cache)
        })
        .max();

    println!("{res:?}");
}
