use solution::*;

// hardcoded to work with sample + given input ^^"
const PRIMES: [i64; 9] = [
    2, 3, 5, 7, 11, 13, 17, 19, 23
];

#[derive(Debug, Clone)]
struct Cheese(Vec<i64>); // Chinese remainder theorem or something idk

impl Cheese {
    pub fn from(n: i64) -> Self {
        Self(PRIMES.iter().map(|p| n % p).collect())
    }
}

impl std::ops::Add for Cheese {
    type Output = Cheese;

    fn add(self, rhs: Self) -> Self::Output {
        let Cheese(s) = self;
        let Cheese(o) = rhs;
        Cheese(PRIMES.iter().zip(s.iter().zip(o.iter())).map(|(p, (l, r))| (l + r) % p).collect())
    }
}
impl std::ops::Sub for Cheese {
    type Output = Cheese;

    fn sub(self, rhs: Self) -> Self::Output {
        let Cheese(s) = self;
        let Cheese(o) = rhs;
        Cheese(PRIMES.iter().zip(s.iter().zip(o.iter())).map(|(p, (l, r))| (l - r) % p).collect())
    }
}
impl std::ops::Mul for Cheese {
    type Output = Cheese;

    fn mul(self, rhs: Self) -> Self::Output {
        let Cheese(s) = self;
        let Cheese(o) = rhs;
        Cheese(PRIMES.iter().zip(s.iter().zip(o.iter())).map(|(p, (l, r))| (l * r) % p).collect())
    }
}

fn main() {
    let input = parse();
    let mut items = input.iter().map(|Monkey { items, .. }|
        items.iter().map(|i| Cheese::from(*i)).collect::<Vec<_>>()
    ).collect::<Vec<_>>();
    let mut counts = vec![0; input.len()];

    for round in 0..10_000 {
        for (i, Monkey { operation: (l, op, r), test: (m, t, f), .. }) in input.iter().enumerate() {
            let current = items[i].drain(..).collect::<Vec<_>>();
            for item in current {
                let l = match l { Operand::Old => item.clone(), Operand::Num(n) => Cheese::from(*n) };
                let r = match r { Operand::Old => item.clone(), Operand::Num(n) => Cheese::from(*n) };
                let item = match op {
                    Operation::Add => l + r,
                    Operation::Sub => l - r,
                    Operation::Mul => l * r,
                };
                counts[i] += 1;

                let Cheese(a) = &item;
                let prime_index = match PRIMES.binary_search(m) {
                    Ok(i) => i,
                    Err(i) => i,
                };
                let target = if a[prime_index] == 0 {
                    t
                } else {
                    f
                };

                items[*target].push(item);
            }
        }

        if (round + 1) % 1000 == 0 {
            println!("\n== After Round {} ==", round + 1);
            for (i, c) in counts.iter().enumerate() {
                println!("Monkey {i} inspected items {c} times.");
            }
        }
    }

    counts.sort();
    let result: i64 = counts.iter().rev().take(2).product();
    println!("{result}");
}
