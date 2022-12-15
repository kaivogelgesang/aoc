use std::io;

pub enum Operand {
    Old,
    Num(i64),
}

pub enum Operation {
    Add,
    Sub,
    Mul,
    // Div,
}

pub struct Monkey {
    pub items: Vec<i64>,
    pub operation: (Operand, Operation, Operand),
    pub test: (i64, usize, usize),
}

pub fn parse() -> Vec<Monkey> {
    let lines = io::stdin().lines().collect::<Result<Vec<_>, _>>().unwrap();
    let mut result = vec![];

    for group in lines.split(|line| line.is_empty()) {
        let items = group[1]
            .split_ascii_whitespace()
            .skip(2)
            .map(|i| i.trim_end_matches(',').trim().parse().unwrap())
            .collect();
        let operation = {
            if let [a, b, c, ..] = group[2]
                .split_ascii_whitespace()
                .skip(3)
                .take(3)
                .collect::<Vec<_>>()[..]
            {
                (
                    match a {
                        "old" => Operand::Old,
                        a => Operand::Num(a.parse().unwrap()),
                    },
                    match b {
                        "+" => Operation::Add,
                        "-" => Operation::Sub,
                        "*" => Operation::Mul,
                        _ => panic!("bad input"),
                    },
                    match c {
                        "old" => Operand::Old,
                        c => Operand::Num(c.parse().unwrap()),
                    },
                )
            } else {
                panic!("bad input")
            }
        };
        let modulus = group[3]
            .split_ascii_whitespace()
            .last()
            .unwrap()
            .parse()
            .unwrap();
        let m_true = group[4]
            .split_ascii_whitespace()
            .last()
            .unwrap()
            .parse()
            .unwrap();
        let m_false = group[5]
            .split_ascii_whitespace()
            .last()
            .unwrap()
            .parse()
            .unwrap();

        result.push(Monkey {
            items,
            operation,
            test: (modulus, m_true, m_false),
        })
    }

    result
}
