use std::io;

type Stacks = Vec<Vec<char>>;
type Instructions = Vec<(usize, usize, usize)>;

pub fn parse() -> (Stacks, Instructions) {
    let mut input = io::stdin()
        .lines()
        .collect::<Result<Vec<_>, _>>()
        .expect("input error");

    let split_pos = input.iter().position(|s| s.is_empty()).expect("bad input");

    let input2 = input.split_off(split_pos);

    let mut stack_lines = input.iter().rev();
    let stack_count = stack_lines
        .next()
        .expect("bad input")
        .split_ascii_whitespace()
        .count();
    let mut stacks = vec![Vec::new(); stack_count];

    for line in stack_lines {
        for (c, s) in line.chars().skip(1).step_by(4).zip(stacks.iter_mut()) {
            if !c.is_whitespace() {
                s.push(c);
            }
        }
    }

    let mut instructions = Vec::new();

    for line in input2.iter().skip(1) {
        match line.split_ascii_whitespace().collect::<Vec<_>>()[..] {
            [_, a, _, b, _, c] => {
                let a = a.parse().expect("bad input");
                let b: isize = b.parse().expect("bad input");
                let c: isize = c.parse().expect("bad input");
                instructions.push((a, (b - 1) as usize, (c - 1) as usize));
            }
            _ => panic!("bad input"),
        };
    }

    (stacks, instructions)
}
