use std::{collections::HashSet, env::args, cmp::max};

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
    let n = args().nth(1).expect("no arg").parse().expect("bad arg");
    let (pieces, dir) = parse();

    let mut board = HashSet::new();

    let mut dir = dir.into_iter().cycle();
    let mut max_y = 0;
    for piece in pieces.iter().cycle().take(n) {
        // bottom left corner
        let (mut x, mut y) = (2, max_y + 3);
        loop {
            // move left/right
            let x2 = match dir.next().unwrap() {
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
    }

    println!("{max_y}");
}
