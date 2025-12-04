use solution::*;

fn concat(a: u64, b: u64) -> u64 {
    let digit_count = b.ilog10() + 1;
    a * 10u64.pow(digit_count) + b
}

fn search(target: u64, current: u64, rest: &[u64]) -> bool {
    if rest.is_empty() {
        return target == current;
    }

    if current > target {
        return false;
    }

    let next = rest[0];
    
    search(target, current + next, &rest[1..])
    | search(target, current * next, &rest[1..])
    | search(target, concat(current, next), &rest[1..])
}

fn main() {
    let rows = parse();
    let mut s = 0;
    for (target, row) in rows {
        if search(target, 0, &row) { s += target; }
    }
    println!("{}", s);
}