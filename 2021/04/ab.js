#!/usr/bin/node

class Board {
    constructor(numbers) {

        this.bingo = false;
        this.score = null;

        this.rowCounts = [0, 0, 0, 0, 0];
        this.colCounts = [0, 0, 0, 0, 0];

        this.entries = new Map();

        for (let [y, row] of numbers.entries()) {
            for (let [x, n] of row.entries()) {
                this.entries.set(n, { position: [x, y], marked: false });
            }
        }
    }

    markNumber(n) {
        const handle = this.entries.get(n);

        if (handle === undefined) {
            return;
        }

        const [x, y] = handle.position;

        if (handle.marked === false) {
            handle.marked = true;

            this.rowCounts[x] += 1;
            this.colCounts[y] += 1;

            if (this.rowCounts[x] === 5 || this.colCounts[y] === 5) {
                const unmarkedSum = Array.from(this.entries, e => { const [k, h] = e; return h.marked ? 0 : k })
                    .reduce((a, b) => (a + b), 0);

                this.bingo = true;
                this.score = unmarkedSum * n;
            }
        }
    }
}

function main(data) {
    const lines = data.split("\n");
    const sequence = lines.shift()
        .trim()
        .split(",")
        .map((s) => { return parseInt(s, 10) });

    lines.shift();

    let boards = [];

    while (lines.length) {
        let rows = [];
        for (let i = 0; i < 5; ++i) {
            rows.push(
                lines.shift()
                    .trim()
                    .split(/\s+/)
                    .map((s) => parseInt(s, 10))
            );
        }
        lines.shift();

        boards.push(new Board(rows));
    }

    for (const n of sequence) {
        for (const [i, board] of boards.entries()) {

            if (board.bingo) continue;

            board.markNumber(n);
            if (board.bingo) {
                console.log(`Bingo on board ${i+1} with score ${board.score}`);
            }
        }
    }
}

process.stdin.on('readable', () => {
    let chunk;
    let data = "";

    while ((chunk = process.stdin.read()) !== null) {
        data += chunk;
    }

    main(data);
    process.exit(0);
})