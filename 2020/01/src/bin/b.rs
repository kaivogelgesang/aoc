#![feature(stdin_forwarders)]
use anyhow::Result;
use std::io;

fn main() -> Result<()> {
    let mut numbers = Vec::<u64>::new();

    for line in io::stdin().lines() {
        numbers.push(line?.parse()?);
    }

    numbers.sort_unstable();

    'outer: for a in numbers.iter() {
        let mut i = 0;
        let mut j = numbers.len() - 1;

        while i < numbers.len() - 1 && j > 0 {
            let (b, c) = (numbers[i], numbers[j]);

            let s = a + b + c;

            if s < 2020 {
                i += 1;
            } else if s > 2020 {
                j -= 1;
            } else {
                println!("{}", a * b * c);
                break 'outer;
            }
        }
    }

    Ok(())
}
