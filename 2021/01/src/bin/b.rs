#![feature(stdin_forwarders)]
use std::io;

use anyhow::Result;

fn main() -> Result<()> {
    let mut measurements = Vec::<u64>::new();
    for line in io::stdin().lines() {
        measurements.push(line?.parse()?);
    }

    let mut last: u64 = measurements[0..=2].iter().sum();
    let mut n = 0;

    for i in 1..=measurements.len() - 3 {
        let current = measurements[i..=i + 2].iter().sum();
        if current > last {
            n += 1;
        }
        last = current;
    }

    println!("{}", n);

    Ok(())
}
