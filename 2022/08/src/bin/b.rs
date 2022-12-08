use solution::parse;

fn check_line<I: Iterator<Item = (usize, usize)>>(
    xys: I,
    trees: &[Vec<u32>],
    score: &mut [Vec<i32>],
) {
    let mut dp = [0; 10];
    for (x, y) in xys {
        let current_height = trees[y][x] as usize;

        score[y][x] *= dp[current_height];
        
        for (height, entry) in dp.iter_mut().enumerate() {
            *entry = if height > current_height {
                *entry + 1
            } else {
                1
            };
        }
    }
}

fn main() {
    let trees = parse();

    let height = trees.len();
    let width = trees[0].len();

    let mut score = vec![vec![1; width]; height];

    // top / bottom

    for x in 0..width {
        check_line((0..height).map(|y| (x, y)), &trees, &mut score);
        check_line((0..height).rev().map(|y| (x, y)), &trees, &mut score);
    }

    // left / right

    for y in 0..height {
        check_line((0..width).map(|x| (x, y)), &trees, &mut score);
        check_line((0..width).rev().map(|x| (x, y)), &trees, &mut score);
    }

    let n = score.iter().flatten().max().unwrap();
    println!("{:?}", n);
}
