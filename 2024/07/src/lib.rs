use std::io::stdin;

pub fn parse() -> Vec<(u64, Vec<u64>)>{
    let mut result = vec![];

    for line in stdin().lines() {
        let line = line.unwrap();
        let mut ints = line.split_ascii_whitespace();
        let a = ints.next().unwrap();
        let a = a.trim_end_matches(":").parse().unwrap();

        let rest = ints.map(|i| i.parse()).collect::<Result<Vec<_>, _>>().unwrap();

        result.push((a, rest));
    }

    result
}
