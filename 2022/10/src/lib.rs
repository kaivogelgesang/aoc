use std::io;

pub enum Instruction {
    Noop,
    Addx(i64),
}

pub fn parse() -> Vec<Instruction> {
    io::stdin()
        .lines()
        .map(
            |line| match &line.unwrap().split_ascii_whitespace().collect::<Vec<_>>()[..] {
                ["noop"] => Instruction::Noop,
                ["addx", n] => Instruction::Addx(n.parse().unwrap()),
                _ => panic!("bad input"),
            },
        )
        .collect()
}
