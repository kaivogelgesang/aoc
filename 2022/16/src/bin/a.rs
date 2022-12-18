use std::cmp::max;

use solution::*;

fn dfs(node: usize, t: i64, adj: &[Vec<(usize, i64)>], flow: &[i64], visited: &mut [bool]) -> i64 {
    if t <= 0 {
        return 0;
    }

    visited[node] = true;
    let mut res = 0;
    for &(next, d) in adj[node].iter() {
        if visited[next] {
            continue;
        }
        res = max(res, dfs(next, t - d - 1, adj, flow, visited));
    }
    res += t * flow[node];
    visited[node] = false;

    res
}

fn main() {
    let (flow, adj, aa) = parse();

    let dist = apsp(&adj);

    let mut candidates = vec![aa];

    candidates.extend((0..adj.len()).filter(|&n| n != aa && flow[n] > 0));

    let mut adj_reduced = vec![Vec::new(); adj.len()];
    for &a in candidates.iter() {
        for &b in candidates.iter() {
            if a == b {
                continue;
            }
            if let Some(d) = dist[a][b] {
                adj_reduced[a].push((b, d as i64))
            }
        }
    }

    let mut visited = vec![false; adj.len()];
    let res = dfs(aa, 30, &adj_reduced, &flow, &mut visited);

    println!("{res}");
}
