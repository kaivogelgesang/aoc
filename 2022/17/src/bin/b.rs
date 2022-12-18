use std::{collections::{HashSet, HashMap}, cmp::max};

use solution::*;

fn collides(piece: &[Vec<bool>], x: i64, y: i64, board: &HashSet<(i64, i64)>) -> bool {
    for (dy, row) in piece.iter().enumerate() {
        for (dx, b) in row.iter().enumerate() {
            let x = x + dx as i64;
            let y = y + dy as i64;
            // walls
            if !(0..7).contains(&x) {
                return true;
            }
            // floor
            if y < 0 {
                return true;
            }
            if *b && board.contains(&(x, y)) {
                return true;
            }
        }
    }

    false
}

fn main() {
    let n = 1000000000000;
    let (pieces, dir) = parse();

    let mut board = HashSet::new();

    let mut visited = HashMap::new();
    let mut heights = Vec::new();

    let mut dir = dir.into_iter().enumerate().cycle().peekable();
    let mut max_y = 0;
    for (k, (i, piece)) in pieces.iter().enumerate().cycle().take(n).enumerate() {
        // bottom left corner
        let (mut x, mut y) = (2, max_y + 3);

        let &(j, _) = dir.peek().unwrap();

        let row_state = (0..7).filter(|&x| board.contains(&(x, max_y - 1))).map(|x| 1 << x).sum::<usize>();

        // simulate as before
        loop {
            let (_, d) = dir.next().unwrap();

            // move left/right
            let x2 = match d {
                Move::Left => x - 1,
                Move::Right => x + 1,
            };
            if !collides(piece, x2, y, &board) {
                x = x2;
            }

            // move down
            if !collides(piece, x, y - 1, &board) {
                y -= 1;
            } else {
                break;
            }
        }
        for (dy, row) in piece.iter().enumerate() {
            for (dx, b) in row.iter().enumerate() {
                if *b {
                    board.insert((x + dx as i64, y + dy as i64));
                }
            }
        }

        max_y = max(max_y, y + piece.len() as i64);

        heights.push(max_y);

        // if a state was repeated, calculate final height using modulo
        if let Some(&prev) = visited.get(&(i, j, row_state)) {

            let cycle_len = k - prev;
            let cycle_start = prev;
            let cycle_diff = heights[cycle_start + cycle_len] - heights[cycle_start];
            let (d, m) = ((n - cycle_start) / cycle_len, (n - cycle_start) % cycle_len);
            let result = heights[m + cycle_start] + d as i64 * cycle_diff - 1;

            println!("{result}");
            return;
        }
        visited.insert((i, j, row_state), k);

    }

    println!("{max_y}");
}
