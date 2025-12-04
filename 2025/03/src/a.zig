const std = @import("std");
pub const Vec = std.ArrayList;

pub fn parse(stdin: *std.io.Reader, gpa: std.mem.Allocator) !Vec(Vec(u8)) {
    var lines = try Vec(Vec(u8)).initCapacity(gpa, 200);

    while (try stdin.takeDelimiter('\n')) |line| {
        var line_vec = try Vec(u8).initCapacity(gpa, 100);
        for (line) |c| {
            try line_vec.append(gpa, c - '0');
        }
        try lines.append(gpa, line_vec);
    }

    return lines;
}

pub fn solve(lines: Vec(Vec(u8))) usize {
    var result: usize = 0;
    for (lines.items) |line| {
        var max: u8 = 0;
        for (line.items, 0..) |a, i| {
            for (line.items[i+1..]) |b| {
                const current = 10 * a + b;
                if (current > max) {
                    max = current;
                }
            }
        }
        result += max;
    }
    return result;
}

pub fn main() !void {

    // setup stdio and alloc

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
    const stdin = &stdin_reader.interface;

    // https://ziglang.org/documentation/0.15.2/#Choosing-an-Allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // do the thing

    const rows = try parse(stdin, allocator);
    const result = solve(rows);

    // print result

    try stdout.print("{d}\n", .{result});
    try stdout.flush();
}
