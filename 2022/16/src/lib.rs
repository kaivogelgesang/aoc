use std::{
    collections::{HashMap, VecDeque},
    io,
};

pub type AdjList = Vec<Vec<usize>>;

pub fn parse() -> (Vec<i64>, AdjList, usize) {
    let mut flow = Vec::new();
    let mut name_to_id_map = HashMap::new();

    let input = io::stdin()
        .lines()
        .enumerate()
        .map(|(i, line)| {
            let line = line.unwrap();
            let tokens = line.split_ascii_whitespace().collect::<Vec<_>>();
            let (description, neighbors) = tokens.split_at(9);

            let id = description[1].to_string();
            name_to_id_map.insert(id.clone(), i);

            let rate = description[4]
                .strip_prefix("rate=")
                .expect("bad input")
                .strip_suffix(';')
                .expect("bad input")
                .to_string()
                .parse()
                .expect("bad input");

            flow.push(rate);

            let neighbors = neighbors
                .iter()
                .map(|s| s.trim_end_matches(',').to_string())
                .collect::<Vec<_>>();

            (id, neighbors)
        })
        .collect::<Vec<_>>();

    let name_to_id = |s: &str| *name_to_id_map.get(s).expect("bad input");

    let mut adj = vec![Vec::new(); input.len()];

    for (name, neighbors) in input {
        let id = name_to_id(&name);

        for n in neighbors {
            adj[id].push(name_to_id(&n));
        }
    }

    (flow, adj, name_to_id("AA"))
}

pub fn bfs(adj: &AdjList, start: usize) -> Vec<Option<usize>> {
    let mut dist = vec![None; adj.len()];

    let mut q = VecDeque::new();
    q.push_back((start, 0));
    while let Some((node, d)) = q.pop_front() {
        dist[node] = Some(d);
        for &next in adj[node].iter() {
            if dist[next].is_some() {
                continue;
            }
            q.push_back((next, d + 1));
        }
    }

    dist
}

pub fn apsp(adj: &AdjList) -> Vec<Vec<Option<usize>>> {
    (0..adj.len()).map(|i| bfs(adj, i)).collect()
}
