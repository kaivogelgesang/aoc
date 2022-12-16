use std::env::args;

use solution::*;

#[derive(PartialEq, Eq, PartialOrd, Ord, Clone, Copy, Debug)]
enum Marker {
    Start,
    End
}

fn main() {
    let input = parse();

    let size: usize = args().nth(1).expect("bad arg").parse().expect("bad number");
    let mut ranges = vec![Vec::new(); size + 1];
    
    for (row, range) in ranges.iter_mut().enumerate() {
        for (s, b) in input.iter() {
            let (x0, y0) = s;
            let (x1, y1) = b;
            let dist = (x0 - x1).abs() + (y0 - y1).abs();

            let dh = (y0 - row as i64).abs();
            let l = x0 - dist + dh;
            let r = x0 + dist - dh;
            
            if l <= r {
                range.push((l, Marker::Start));
                range.push((r + 1, Marker::End));
            }
        }
        range.sort();
    }

    println!("ranges done");

    for (y, range) in ranges.iter().enumerate() {
        let mut current = 0;

        // check x=0
        let &(start, _) = range.get(0).unwrap();
        if start > 0 {
            println!("sus {y} 0..{start}");
        }

        for &(x, marker) in range.iter() {
            if x > size as i64 {
                break
            }
            match marker {
                Marker::Start => current += 1,
                Marker::End => current -= 1,
            }
            if current == 0 {
                let freq = 4000000 * x + y as i64;
                println!("found {x},{y} (freq {freq})");
            }
        }

        // todo check x = size
        let &(end, _) = range.last().unwrap();
        if end < size as i64 {
            println!("sus {y} {end}..={size}");
        }
    }
}