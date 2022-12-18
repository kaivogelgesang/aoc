use std::io;

pub fn parse() -> Vec<(i64, i64, i64)> {
    io::stdin()
        .lines()
        .map(|line| {
            match line
                .unwrap()
                .split(',')
                .map(|c| c.parse().expect("bad number"))
                .collect::<Vec<_>>()[..]
            {
                [x, y, z] => (x, y, z),
                _ => panic!("bad input"),
            }
        })
        .collect()
}
