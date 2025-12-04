use solution::*;

fn main() {
    let (mut state, instructions) = parse();
    while state.step(&instructions) {}
    println!("{}", state.output.iter().map(|i| i.to_string()).collect::<Vec<_>>().join(","))
}