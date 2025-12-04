use solution::*;

fn main() {
    let mut row = parse();
    let step_count = 25;

    for _ in 0..step_count {
        let mut new_row = Vec::with_capacity(row.len());
        for (a, b) in row.iter().map(|&x | step(x)) {
            new_row.push(a);
            if let Some(b) = b { new_row.push(b) }
        }
        row = new_row;
    }

    println!("{}", row.len());
}