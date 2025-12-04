use std::io;

#[derive(Debug)]
pub struct State {
    pub a: u64,
    pub b: u64,
    pub c: u64,
    pub pc: usize,

    pub output: Vec<u64>,
}

impl State {
    pub fn combo(&self, operand: u64) -> u64 {
        match operand {
            0..=3 => operand,
            4 => self.a,
            5 => self.b,
            6 => self.c,
            7.. => panic!("reserved"),
        }
    }

    pub fn step(&mut self, instructions: &[u64]) -> bool {
        let (Some(&instruction), Some(&operand)) =
            (instructions.get(self.pc), instructions.get(self.pc + 1))
        else {
            return false;
        };
        match instruction {
            0 => {
                // adv
                self.a = self.a >> self.combo(operand);
                self.pc += 2;
            }
            1 => {
                // bxl
                self.b ^= operand;
                self.pc += 2;
            }
            2 => {
                // bst
                self.b = self.combo(operand) & 0b111;
                self.pc += 2;
            }
            3 => {
                // jnz
                if self.a != 0 {
                    self.pc = operand as usize;
                } else {
                    self.pc += 2;
                }
            }
            4 => {
                // bxc
                self.b ^= self.c;
                self.pc += 2;
            }
            5 => {
                // out
                self.output.push(self.combo(operand) & 0b111);
                self.pc += 2;
            }
            6 => {
                // bdv
                self.b = self.a >> self.combo(operand);
                self.pc += 2;
            }
            7 => {
                // cdv
                self.c = self.a >> self.combo(operand);
                self.pc += 2;
            }
            _ => {
                panic!("illegal instruction")
            }
        }
        true
    }
}

pub fn parse() -> (State, Vec<u64>) {
    let mut lines = io::stdin().lines();
    let a = lines
        .next()
        .unwrap()
        .unwrap()
        .split_ascii_whitespace()
        .last()
        .unwrap()
        .parse()
        .unwrap();
    let b = lines
        .next()
        .unwrap()
        .unwrap()
        .split_ascii_whitespace()
        .last()
        .unwrap()
        .parse()
        .unwrap();
    let c = lines
        .next()
        .unwrap()
        .unwrap()
        .split_ascii_whitespace()
        .last()
        .unwrap()
        .parse()
        .unwrap();
    lines.next().unwrap().unwrap();

    let instructions = lines
        .next()
        .unwrap()
        .unwrap()
        .split(": ")
        .nth(1)
        .unwrap()
        .split(",")
        .map(|s| s.parse())
        .collect::<Result<_, _>>()
        .unwrap();

    (
        State {
            a,
            b,
            c,
            pc: 0,
            output: vec![],
        },
        instructions,
    )
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_example_1() {
        let mut s = State {
            a: 0,
            b: 0,
            c: 9,
            pc: 0,
            output: vec![],
        };
        s.step(&[2, 6]);
        assert_eq!(s.b, 1);
    }
    #[test]
    fn test_example_2() {
        let mut s = State {
            a: 10,
            b: 0,
            c: 0,
            pc: 0,
            output: vec![],
        };
        let instructions = [5, 0, 5, 1, 5, 2];
        while s.step(&instructions) {}
        assert_eq!(s.output, &[0, 1, 2]);
    }
}

#[cfg(test)]
mod ai_test {
    use super::*;

    #[test]
    fn test_example_1() {
        let mut s = State {
            a: 0,
            b: 0,
            c: 9,
            pc: 0,
            output: vec![],
        };
        s.step(&[2, 6]);
        assert_eq!(s.b, 1);
    }

    #[test]
    fn test_example_2() {
        let mut s = State {
            a: 10,
            b: 0,
            c: 0,
            pc: 0,
            output: vec![],
        };
        let instructions = [5, 0, 5, 1, 5, 2];
        while s.step(&instructions) {}
        assert_eq!(s.output, &[0, 1, 2]);
    }

    #[test]
    fn test_example_3() {
        let mut s = State {
            a: 2024,
            b: 0,
            c: 0,
            pc: 0,
            output: vec![],
        };
        let instructions = [0, 1, 5, 4, 3, 0];
        while s.step(&instructions) {}
        assert_eq!(s.output, &[4, 2, 5, 6, 7, 7, 7, 7, 3, 1, 0]);
        assert_eq!(s.a, 0);
    }

    #[test]
    fn test_example_4() {
        let mut s = State {
            a: 0,
            b: 29,
            c: 0,
            pc: 0,
            output: vec![],
        };
        s.step(&[1, 7]);
        assert_eq!(s.b, 26);
    }

    #[test]
    fn test_example_5() {
        let mut s = State {
            a: 0,
            b: 2024,
            c: 43690,
            pc: 0,
            output: vec![],
        };
        s.step(&[4, 0]);
        assert_eq!(s.b, 44354);
    }
}
