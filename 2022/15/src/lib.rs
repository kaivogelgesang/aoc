use std::io;

pub type Sensor = (i64, i64);
pub type Beacon = (i64, i64);

pub fn parse() -> Vec<(Sensor, Beacon)> {
    io::stdin()
        .lines()
        .map(|line| {
            let trim: &[_] = &['x', 'y', '=', ',', ':'];
            if let [_, _, x1, y1, _, _, _, _, x2, y2] = line
                .unwrap()
                .split_ascii_whitespace()
                .map(|s| s.trim_matches(trim))
                .collect::<Vec<_>>()[..]
            {
                (
                    (
                        x1.parse().expect("bad input"),
                        y1.parse().expect("bad input"),
                    ),
                    (
                        x2.parse().expect("bad input"),
                        y2.parse().expect("bad input"),
                    ),
                )
            } else {
                panic!("bad input")
            }
        })
        .collect()
}
