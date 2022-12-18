use std::io;

pub type Tetris = Vec<Vec<bool>>;

#[derive(Debug, Clone, Copy)]
pub enum Move {
    Left,
    Right,
}

const PIECES: &str = "####

.#.
###
.#.

..#
..#
###

#
#
#
#

##
##";

pub fn parse() -> (Vec<Tetris>, Vec<Move>) {
    let pieces = PIECES
        .split("\n\n")
        .map(|piece| {
            piece
                .lines()
                .rev() // go from bottom to top, in positive y direction
                .map(|line| line.chars().map(|c| c == '#').collect())
                .collect()
        })
        .collect();

    let moves = io::stdin()
        .lines()
        .next()
        .unwrap()
        .unwrap()
        .chars()
        .map(|c| match c {
            '<' => Move::Left,
            '>' => Move::Right,
            _ => panic!("bad input"),
        })
        .collect();

    (pieces, moves)
}
