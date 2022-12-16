use std::{
    cmp::{max, min},
    collections::HashMap,
    io,
};

pub enum Tile {
    Wall,
    Sand,
}

pub type Board = HashMap<(i64, i64), Tile>;

pub fn print_board(board: &Board) {
    let x0 = board.keys().map(|(x, _)| x).min();
    let x1 = board.keys().map(|(x, _)| x).max();
    let y0 = 0;
    let y1 = board.keys().map(|(_, y)| y).max();

    if let (Some(&x0), Some(&x1), Some(&y1)) = (x0, x1, y1) {
        for y in y0..=y1 {
            for x in x0..=x1 {
                match board.get(&(x, y)) {
                    Some(Tile::Wall) => print!("#"),
                    Some(Tile::Sand) => print!("o"),
                    None => print!("."),
                }
            }
            println!()
        }
    }
}

pub fn parse() -> Board {
    let mut board = HashMap::new();

    for line in io::stdin().lines() {
        let pairs: Vec<(i64, i64)> = line
            .unwrap()
            .split(" -> ")
            .map(|p| {
                let (a, b) = p.split_once(',').expect("bad input");
                (
                    a.parse().expect("bad number"),
                    b.parse().expect("bad number"),
                )
            })
            .collect();

        let mut it = pairs.windows(2);
        while let Some(&[(a, b), (c, d)]) = it.next() {
            if a == c {
                for y in min(b, d)..=max(b, d) {
                    board.insert((a, y), Tile::Wall);
                }
            } else if b == d {
                for x in min(a, c)..=max(a, c) {
                    board.insert((x, b), Tile::Wall);
                }
            } else {
                eprintln!("bad input? {a},{b} -> {c},{d}");
            }
        }
    }

    board
}
