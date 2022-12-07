use solution::{parse, FS};

trait Size100kSum {
    fn size100ksum(&self, accumulator: &mut usize) -> usize;
}

impl Size100kSum for FS {
    fn size100ksum(&self, accumulator: &mut usize) -> usize {
        match self {
            FS::File { name: _, size } => *size,
            FS::Dir { name, content } => {
                let sum = content
                    .iter()
                    .map(|(_, c)| c.size100ksum(accumulator))
                    .sum();
                println!("Directory {name}: {sum} bytes total");
                if sum <= 100_000 {
                    *accumulator += sum;
                }
                sum
            }
        }
    }
}

fn main() {
    let input = parse();
    let mut a = 0;
    input.size100ksum(&mut a);
    println!("{}", a);
}
