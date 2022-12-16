use solution::parse;

fn main() {
    let (mut stacks, instructions) = parse();

    for (count, from, to) in instructions {
        let index = stacks[from].len() - count;
        let crates = stacks[from].split_off(index);
        stacks[to].extend(crates);
    }

    let result = stacks
        .iter()
        .map(|s| s.last())
        .collect::<Option<String>>()
        .expect("stack was empty?");

    println!("{}", result);
}
