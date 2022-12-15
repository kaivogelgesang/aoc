use solution::*;
use std::io;

fn main() {
    let mut adj = vec![vec![]; 2]; // 0: start, 1: end

    let h = io::stdin()
        .lines()
        .map(|line| {
            line.unwrap()
                .trim()
                .chars()
                .map(|c| {
                    adj.push(vec![]);
                    let current = adj.len() - 1;
                    match c {
                        'a' | 'S' => {
                            adj[START].push(current);
                            0
                        }
                        'E' => {
                            adj[current].push(END);
                            (b'z' - b'a') as i64
                        }
                        'b'..='z' => (c as u8 - b'a') as i64,
                        _ => panic!("bad input"),
                    }
                })
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();

    let height = h.len() as isize;
    let width = h[0].len() as isize;

    let index = |x: usize, y: usize| width as usize * y + x + 2;

    for y in 0..height {
        for x in 0..width {
            for (dx, dy) in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
                let x2 = x + dx;
                if x2 < 0 || x2 >= width {
                    continue;
                }
                let y2 = y + dy;
                if y2 < 0 || y2 >= height {
                    continue;
                }
                let (x2, y2) = (x2 as usize, y2 as usize);
                if h[y2][x2] <= h[y as usize][x as usize] + 1 {
                    let current = index(x as usize, y as usize);
                    let neighbor = index(x2, y2);
                    adj[current].push(neighbor);
                }
            }
        }
    }

    let dist = bfs(&adj);

    match dist[END] {
        Some(d) => println!("{}", d - 2),
        None => println!("unreachable"),
    }
}
