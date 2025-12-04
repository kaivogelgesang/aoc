use std::{collections::BTreeSet, io};

pub struct Trie {
    children: [Option<Box<Self>>; 26],
    mark: bool,
}

impl Trie {
    pub fn new() -> Self {
        Self { children: [const { None }; 26], mark: false }
    }

    pub fn push(&mut self, s: &[u8]) {
        if s.is_empty() {
            self.mark = true;
            return;
        }

        let (c, s2) = (s[0], &s[1..]);
        let i = (c - 'a' as u8) as usize;

        let child = self.children[i].get_or_insert(Box::new(Self::new()));
        child.push(s2);
    }

    pub fn query(&self, s: &[u8]) -> BTreeSet<usize> {
        let mut r = BTreeSet::new();
        self._walk(s, 0, &mut r);
        r
    }

    fn _walk(&self, s: &[u8], depth: usize, result: &mut BTreeSet<usize>) {
        if self.mark {
            result.insert(depth);
        }

        if s.is_empty() {
            return;
        }

        let (c, s2) = (s[0], &s[1..]);
        let i = (c - 'a' as u8) as usize;

        if let Some(child) = &self.children[i] {
            child._walk(s2, depth + 1, result);
        }
    }
}

pub fn parse() -> (Trie, Vec<Vec<u8>>) {

    let mut lines = io::stdin().lines();
    let mut alphabet = Trie::new();
    for word in lines.next().unwrap().unwrap().trim().split(", ") {
        alphabet.push(word.as_bytes());
    };

    lines.next().unwrap().unwrap();
    
    let words = lines.map(|line| Vec::from(line.unwrap().trim().as_bytes()) ).collect();

    (alphabet, words)
}