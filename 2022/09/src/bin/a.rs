use std::{cell::RefCell, collections::HashSet};

use solution::{parse, track_movement};

fn main() {
    let input = parse();
    let tail_coords = RefCell::new(HashSet::new());

    track_movement(
        |_, t| {
            tail_coords.borrow_mut().insert(t);
        },
        input.into_iter(),
    );

    println!("{}", tail_coords.borrow().len());
}
