const std = @import("std");

pub const PuzzleInput = std.ArrayList(struct{ i64, i64 });

pub fn parse(gpa: std.mem.Allocator, stdin: *std.io.Reader) !PuzzleInput {
    var line_buffer = std.io.Writer.Allocating.init(gpa);

    var points = try PuzzleInput.initCapacity(gpa, 500);

    while (try stdin.streamDelimiterEnding(&line_buffer.writer, '\n') > 0) : ({
        _ = try stdin.discardDelimiterInclusive('\n');
        line_buffer.clearRetainingCapacity();
    }) {
        const line = try line_buffer.toOwnedSlice();
        const split = std.mem.indexOfScalar(u8, line, ',') orelse return error.BadInput;
        const x = try std.fmt.parseInt(i64, line[0..split], 10);
        const y = try std.fmt.parseInt(i64, line[split+1..], 10);
        try points.append(gpa, .{x, y});
    }
    return points;
}

pub fn solve(gpa: std.mem.Allocator, input: PuzzleInput) !usize {
    _ = gpa;
    var result: usize = 0;
    const points = input.items;

    for (points, 0..) |p, x| {
        const x1, const y1 = p;
        for (points[x+1..]) |q| {
            const x2, const y2 = q;
            const area = @as(usize, @intCast((@abs(x2 - x1) + 1) * (@abs(y2 - y1) + 1)));
            if (area > result) {
                std.debug.print("best candidate: {},{} <-> {},{}\n", .{x1, y1, x2, y2});
                result = area;
            }
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

    const input = try parse(allocator, stdin);
    const result = try solve(allocator, input);

    // print result

    try stdout.print("{d}\n", .{result});
    try stdout.flush();
}
