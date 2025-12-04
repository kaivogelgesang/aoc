use solution::*;

fn count_valid(w: &[u8], a: &Trie) -> usize {
    let n = w.len();
    let mut dp = vec![0; n + 1];
    dp[0] = 1;
    for i in 0..n {
        if dp[i] == 0 { continue; }
        for j in a.query(&w[i..]) {
            dp[i+j] += dp[i];
        }
    }

    dp[n]
}

fn main() {
    let (alphabet, words) = parse();

    let n = words.iter().enumerate().map(|(i, w)| {
        eprintln!("{}/{}", i, words.len());
        count_valid(w, &alphabet)
    }).sum::<usize>();

    println!("{n}");
}