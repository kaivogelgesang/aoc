use std::collections::{HashMap, HashSet};
use std::io::{self, BufRead};

fn main() {
    let stdin = io::stdin();
    let mut data: Vec<String> = stdin.lock().lines().map(|line| line.unwrap()).collect();
    for s in data.iter_mut() {
        *s = s.trim().to_string();
        s.push('.');
    }

    let mut gears: HashMap<(usize, usize), Vec<usize>> = HashMap::new();

    for (y, line) in data.iter().enumerate() {
        let mut current_num = 0;
        let mut symbols = HashSet::new();

        for (x, c) in line.chars().enumerate() {
            if c.is_digit(10) {
                current_num *= 10;
                current_num += c.to_digit(10).unwrap() as usize;
                symbols.extend(symbols_adjacent(x, y, &data));
            } else {
                for &(x, y, s) in symbols.iter() {
                    if s != '*' {
                        continue;
                    }
                    gears
                        .entry((x, y))
                        .or_insert_with(Vec::new)
                        .push(current_num);
                }
                current_num = 0;
                symbols.clear();
            }
        }
    }

    let mut result = 0;

    for (&(x, y), nums) in gears.iter() {
        match nums[..] {
            [a, b] => {
                println!("gear @ ({x},{y}): ratio {a} * {b}");
                result += a * b;
            }
            _ => (),
        };
    }
    println!("{}", result);
}

fn symbols_adjacent(x: usize, y: usize, data: &Vec<String>) -> HashSet<(usize, usize, char)> {
    let mut result = HashSet::new();

    let h = data.len();
    let w = data[0].len();

    for &dx in &[1, 0, -1] {
        for &dy in &[1, 0, -1] {
            let x2 = (x as isize + dx) as usize;
            let y2 = (y as isize + dy) as usize;
            if x2 < w && y2 < h {
                if let Some(c2) = data.get(y2).and_then(|line| line.chars().nth(x2)) {
                    if c2 != '.' && !c2.is_digit(10) {
                        result.insert((x2, y2, c2));
                    }
                }
            }
        }
    }

    result
}
