#![feature(stdin_forwarders)]
use std::io;

use anyhow::{Result, anyhow};

fn main() -> Result<()> {
    let mut measurements = Vec::<u64>::new();
    for line in io::stdin().lines() {
        measurements.push(line?.parse()?);
    }
    
    let mut last = measurements.first().ok_or(anyhow!(""))?;
    let mut n = 0;

    for current in measurements.iter().skip(1) {
        if current > last {
            n += 1;
        }
        last = current;
    }

    println!("{}", n);

    Ok(())
}
