use solution::{parse, FS};

trait TotalSize {
    fn total_size(&self, sizes: &mut Vec<usize>) -> usize;
}

impl TotalSize for FS {
    fn total_size(&self, sizes: &mut Vec<usize>) -> usize {
        match self {
            FS::File { name: _, size } => *size,
            FS::Dir { name: _, content } => {
                let size = content.values().map(|c| c.total_size(sizes)).sum();
                sizes.push(size);
                size
            }
        }
    }
}

fn main() {
    let input = parse();
    let mut sizes = Vec::new();
    let total_size = input.total_size(&mut sizes);
    let unused = 70000000 - total_size;
    let delete_required = 30000000 - unused;

    sizes.sort();
    let index = match sizes.binary_search(&delete_required) {
        Ok(index) => index,
        Err(index) => index,
    };
    println!("{}", sizes[index]);
}
