const std = @import("std");

pub fn parse(stdin: *std.io.Reader, gpa: std.mem.Allocator) !std.ArrayList(i32) {
    var turns = try std.ArrayList(i32).initCapacity(gpa, 5000);

    while (try stdin.takeDelimiter('\n')) |line| {
        var value = try std.fmt.parseInt(i32, line[1..], 10);
        switch (line[0]) {
            'L' => value *= -1,
            'R' => {},
            else => return error.BadInput
        }
        try turns.append(gpa, value);
    }

    return turns;
}

pub fn solve(turns: []i32) usize {
    var result: usize = 0;
    var position: i32 = 50;
    for (turns) |turn| {
        position = @mod(position + turn, 100);
        if (position == 0) {
            result += 1;
        }
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

    const turns = try parse(stdin, allocator);
    const result = solve(turns.items);

    // print result

    try stdout.print("{d}\n", .{result});
    try stdout.flush();
}
