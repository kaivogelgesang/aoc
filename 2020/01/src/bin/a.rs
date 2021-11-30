#![feature(stdin_forwarders)]
use anyhow::Result;
use std::{collections::HashMap, io};

fn main() -> Result<()> {
    let mut numbers = Vec::<u64>::new();

    for line in io::stdin().lines() {
        numbers.push(line?.parse()?);
    }

    let mut map = HashMap::new();

    for n in numbers.iter() {
        map.insert(2020 - n, n);
    }

    for n in numbers.iter() {
        if let Some(m) = map.get(n) {
            println!("{}", *n * *m);
            break;
        }
    }

    Ok(())
}
