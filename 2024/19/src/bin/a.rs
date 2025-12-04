use solution::*;

fn valid(w: &[u8], a: &Trie) -> bool {
    let n = w.len();
    let mut dp = vec![false; n + 1];
    dp[0] = true;
    for i in 0..n {
        if !dp[i] { continue; }
        for j in a.query(&w[i..]) {
            dp[i+j] = true;
        }
    }

    dp[n]
}

fn main() {
    let (alphabet, words) = parse();

    let n = words.iter().enumerate().filter(|(i, w)| {
        eprintln!("{}/{}", i, words.len());
        valid(w, &alphabet)
    }).count();

    println!("{n}");
}