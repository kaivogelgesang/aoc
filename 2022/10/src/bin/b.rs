use solution::{parse, Instruction};

fn main() {
    let mut sprite_pos = 1; // 0, 1, 2
    let mut crt_pos = 0;
    let mut display = String::new();

    for dx in parse().iter().flat_map(|i| match i {
        Instruction::Noop => vec![0],
        Instruction::Addx(dx) => vec![0, *dx],
    }) {
        if sprite_pos - 1 <= crt_pos && crt_pos <= sprite_pos + 1 {
            display.push('#');
        } else {
            display.push('.');
        }

        crt_pos += 1;
        if crt_pos == 40 {
            display.push('\n');
            crt_pos = 0;
        }

        sprite_pos += dx;
    }

    println!("{}", display);
}
