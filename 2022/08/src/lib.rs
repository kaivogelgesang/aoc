use std::io;

pub fn parse() -> Vec<Vec<u32>> {
    io::stdin()
        .lines()
        .map(|l| {
            l.unwrap()
                .chars()
                .map(|c| c.to_digit(10).unwrap())
                .collect()
        })
        .collect()
}
