use std::{cmp::max, io};

#[derive(Clone, Copy)]
pub enum Direction {
    Up,
    Down,
    Left,
    Right,
}

impl Direction {
    fn from_char(c: char) -> Option<Self> {
        match c {
            'U' => Some(Self::Up),
            'D' => Some(Self::Down),
            'L' => Some(Self::Left),
            'R' => Some(Self::Right),
            _ => None,
        }
    }
}

pub fn parse() -> Vec<(Direction, usize)> {
    io::stdin()
        .lines()
        .map(|line| {
            let line = line.unwrap();
            let (d, n) = (line.chars().next(), &line[2..]);
            (
                Direction::from_char(d.unwrap()).unwrap(),
                n.parse().unwrap(),
            )
        })
        .collect()
}

pub type Position = (i64, i64);

pub fn follow(head: Position, tail: Position) -> Position {
    let (hx, hy) = head;
    let (tx, ty) = tail;

    let (dx, dy) = match (hx - tx, hy - ty) {
        // directly two steps -> follow one step
        (a, 0) if a.abs() == 2 => (a.signum(), 0),
        (0, b) if b.abs() == 2 => (0, b.signum()),

        // otherwise, if they aren't touching and aren't in the same row or column, move diagonally
        (a, b) if max(a.abs(), b.abs()) <= 1 => (0, 0), // touching
        (a, b) if a != 0 && b != 0 => (a.signum(), b.signum()),

        // otherwise, movement is unspecified
        (a, b) => {
            eprintln!("! unspecified movement {a}/{b}");
            (0, 0)
        }
    };

    (tx + dx, ty + dy)
}

pub fn step(head: Position, tail: Position, dir: Direction) -> (Position, Position) {
    let (hx, hy) = head;

    let (dx, dy) = match dir {
        Direction::Up => (0, 1),
        Direction::Down => (0, -1),
        Direction::Left => (-1, 0),
        Direction::Right => (1, 0),
    };

    // move head
    let (hx, hy) = (hx + dx, hy + dy);

    // follow tail
    let (tx, ty) = follow((hx, hy), tail);

    ((hx, hy), (tx, ty))
}

pub fn track_movement<F, I>(visit: F, it: I)
where
    F: Fn(Position, Position),
    I: Iterator<Item = (Direction, usize)>,
{
    let mut head = (0, 0);
    let mut tail = (0, 0);

    visit(head, tail);
    // eprintln!("@ head: {head:?} tail: {tail:?}");

    for (dir, n) in it {
        for _ in 0..n {
            (head, tail) = step(head, tail, dir);
            visit(head, tail);
            // eprintln!("@ head: {head:?} tail: {tail:?}");
        }
    }
}
