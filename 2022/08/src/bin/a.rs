use solution::parse;

fn check_line<I: Iterator<Item = (usize, usize)>>(
    mut xys: I,
    trees: &[Vec<u32>],
    visible: &mut [Vec<bool>],
) {
    let (x, y) = xys.next().unwrap();
    visible[y][x] = true;
    let mut min_height = trees[y][x];
    for (x, y) in xys {
        let current_height = trees[y][x];
        if current_height > min_height {
            visible[y][x] = true;
            min_height = current_height;
        }
    }
}

fn main() {
    let trees = parse();

    let height = trees.len();
    let width = trees[0].len();

    let mut visible = vec![vec![false; width]; height];

    // visible from top / bottom

    for x in 0..width {
        check_line((0..height).map(|y| (x, y)), &trees, &mut visible);
        check_line((0..height).rev().map(|y| (x, y)), &trees, &mut visible);
    }

    // visible from left / right

    for y in 0..height {
        check_line((0..width).map(|x| (x, y)), &trees, &mut visible);
        check_line((0..width).rev().map(|x| (x, y)), &trees, &mut visible);
    }

    let n = visible.iter().flatten().filter(|b| **b).count();
    println!("{}", n);
}
