use solution::*;

fn main() {
    let input = parse();
    let mut items = input
        .iter()
        .map(|Monkey { items, .. }| items.clone())
        .collect::<Vec<_>>();
    let mut counts = vec![0; input.len()];

    for _ in 0..20 {
        for (
            i,
            Monkey {
                operation: (l, op, r),
                test: (m, t, f),
                ..
            },
        ) in input.iter().enumerate()
        {
            let current = items[i].drain(..).collect::<Vec<_>>();
            for item in current {
                let l = match l {
                    Operand::Old => item,
                    Operand::Num(n) => *n,
                };
                let r = match r {
                    Operand::Old => item,
                    Operand::Num(n) => *n,
                };
                let item = match op {
                    Operation::Add => l + r,
                    Operation::Sub => l - r,
                    Operation::Mul => l * r,
                } / 3;
                counts[i] += 1;

                let target = if item % m == 0 { t } else { f };

                items[*target].push(item);
            }
        }
    }

    for (i, c) in counts.iter().enumerate() {
        println!("Monkey {i} inspected items {c} times.");
    }

    counts.sort();
    let result: i64 = counts.iter().rev().take(2).product();
    println!("{result}");
}
