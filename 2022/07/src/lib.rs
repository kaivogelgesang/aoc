use std::{collections::HashMap, io};

pub enum FS {
    Dir {
        name: String,
        content: HashMap<String, FS>,
    },
    File {
        name: String,
        size: usize,
    },
}

impl FS {
    fn insert(&mut self, path: &[String], child: FS) {
        match self {
            FS::File { name: _, size: _ } => panic!("attempt to insert child into file"),
            FS::Dir { name: _, content } => match path.split_first() {
                Some((subdir, path)) => {
                    content
                        .get_mut(subdir)
                        .expect("insert into nonexistent subdir")
                        .insert(path, child);
                }
                None => {
                    let name = match &child {
                        FS::Dir { name, content: _ } => name,
                        FS::File { name, size: _ } => name,
                    };
                    content.insert(name.clone(), child);
                }
            },
        }
    }
}

pub fn parse() -> FS {
    let mut fs = FS::Dir {
        name: "/".into(),
        content: HashMap::new(),
    };
    let mut path = Vec::new();

    for line in io::stdin().lines() {
        let line = line.expect("io error");

        match &line.split_ascii_whitespace().collect::<Vec<_>>()[..] {
            ["$", "cd", "/"] => {
                path = vec![];
            }
            ["$", "cd", ".."] => {
                path.pop().expect("bad input");
            }
            ["$", "cd", dirname] => {
                path.push(dirname.to_string());
            }
            ["$", "ls"] => {
                // println!("listing");
            }
            ["dir", dirname] => {
                // println!("insert directory {dirname} into {path:?}");
                let child = FS::Dir {
                    name: dirname.to_string(),
                    content: HashMap::new(),
                };
                fs.insert(&path, child);
            }
            [size, filename] => {
                // println!("insert file {filename} with size {size} into {path:?}");
                let child = FS::File {
                    name: filename.to_string(),
                    size: size.parse().expect("could not parse file size"),
                };
                fs.insert(&path, child);
            }
            other => {
                eprintln!("unhandled input line: {:?}", other);
            }
        }
    }

    fs
}
