use std::io;

fn contained(a: (u64, u64), b: (u64, u64)) -> bool {
    let (a1, a2) = a;
    let (b1, b2) = b;

    b1 >= a1 && b2 <= a2
}

fn main() {
    let mut count = 0;

    for line in io::stdin().lines() {
        let line = line.expect("no line");
        let (a, b) = match line
            .split(&[',', '-'])
            .map(|c| c.trim().parse::<u64>())
            .collect::<Result<Vec<_>, _>>()
            .expect("bad input")[..]
        {
            [a1, a2, b1, b2] => ((a1, a2), (b1, b2)),
            _ => unreachable!(),
        };
        if contained(a, b) || contained(b, a) {
            count += 1
        }
    }

    println!("{}", count);
}
