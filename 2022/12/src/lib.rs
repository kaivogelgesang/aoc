use std::collections::VecDeque;

pub const START: usize = 0;
pub const END: usize = 1;

pub fn bfs(adj: &[Vec<usize>]) -> Vec<Option<i64>> {
    let mut dist = vec![None; adj.len()];

    let mut q = VecDeque::new();
    q.push_back((START, 0));
    while let Some((node, d)) = q.pop_front() {
        if dist[node].is_some() {
            continue;
        }
        dist[node] = Some(d);
        for &next in adj[node].iter() {
            q.push_back((next, d + 1));
        }
    }

    dist
}
