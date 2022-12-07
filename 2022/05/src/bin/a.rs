use solution::parse;

fn main() {
    let (mut stacks, instructions) = parse();
    
    for (count, from, to) in instructions {
        for _ in 0..count {
            if let Some(c) = stacks[from].pop() {
                stacks[to].push(c);
            }
        }
    }

    let result = stacks
        .iter()
        .map(|s| s.last())
        .collect::<Option<String>>()
        .expect("stack was empty?");
    
    println!("{}", result);
}
