use solution::*;

fn bruteforce(target: u64, row: &[u64]) -> bool {
    if row.is_empty() {
        return target == 0;
    }

    let &b = row.last().unwrap();

    if target % b == 0 {
        if bruteforce(target / b, &row[..row.len()-1]) {
            return true;
        }
    }

    if target >= b {
        if bruteforce(target - b, &row[..row.len()-1]) {
            return true;
        }
    }

    false
}

fn main() {
    let rows = parse();

    let mut s = 0;

    for (target, row) in rows {
        if bruteforce(target, &row) {
            s += target;
        }
    }

    println!("{}", s);
}