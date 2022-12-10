use solution::{parse, Instruction};

fn main() {
    let mut x = 1;
    let mut cycle = 1;
    let mut target_cycles = [20, 60, 100, 140, 180, 220]
        .into_iter()
        .rev()
        .collect::<Vec<_>>();

    let mut result = 0;

    for instruction in parse() {
        if target_cycles.is_empty() {
            break;
        };

        let (dc, dx) = match instruction {
            Instruction::Noop => (1, 0),
            Instruction::Addx(dx) => (2, dx),
        };
        cycle += dc;

        let target = target_cycles.last().unwrap();
        if cycle > *target {
            result += target * x;
            target_cycles.pop();
        }

        x += dx;
    }

    println!("{}", result);
}
