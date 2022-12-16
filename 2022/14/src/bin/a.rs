use solution::*;

fn main() {
    let mut board = parse();
    print_board(&board);

    let &max_y = board.keys().map(|(_, y)| y).max().expect("empty input?");
    let mut n = 0;
    'outer: loop {
        let (mut x, mut y) = (500, 0);
        loop {
            if y > max_y {
                break 'outer;
            }
            match (
                board.get(&(x - 1, y + 1)),
                board.get(&(x, y + 1)),
                board.get(&(x + 1, y + 1)),
            ) {
                // straight down
                (_, None, _) => {
                    y += 1;
                }

                // left diagonal
                (None, Some(_), _) => {
                    y += 1;
                    x -= 1;
                }

                // right diagonal
                (Some(_), Some(_), None) => {
                    y += 1;
                    x += 1;
                }

                // rest
                (Some(_), Some(_), Some(_)) => {
                    board.insert((x, y), Tile::Sand);
                    break;
                }
            }
        }
        n += 1;
    }

    println!("{n}");
}
