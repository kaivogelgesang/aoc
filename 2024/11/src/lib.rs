use std::io;

pub fn parse() -> Vec<u64> {
    io::stdin()
        .lines()
        .next()
        .unwrap()
        .unwrap()
        .split_ascii_whitespace()
        .map(|s| s.parse())
        .collect::<Result<_, _>>()
        .unwrap()
}

pub fn step(x: u64) -> (u64, Option<u64>) {
    if x == 0 {
        return (1, None);
    }

    let digit_count = x.ilog10() + 1;
    if digit_count % 2 == 0 {
        let half = 10u64.pow(digit_count / 2);
        return (x / half, Some(x % half));
    }

    (x * 2024, None)
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_digit_count() {
        let f = |x: u64| x.ilog10() + 1;

        for x in [1, 9, 10, 99, 100] {
            println!("{}: {}", x, f(x));
        }
    }

    #[test]
    fn test_split() {
        assert_eq!(step(0), (1, None));
        assert_eq!(step(1), (2024, None));
        assert_eq!(step(10), (1, Some(0)));
        assert_eq!(step(99), (9, Some(9)));
        assert_eq!(step(999), (2021976, None));
    }
}