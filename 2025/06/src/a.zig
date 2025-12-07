const std = @import("std");

const Op = enum {
    plus,
    times,
};

const Column = struct {
    numbers: std.ArrayList(i64),
    op: Op,
};

pub const PuzzleInput = struct {
    columns: std.ArrayList(Column),
};

pub fn parse(gpa: std.mem.Allocator, stdin: *std.io.Reader) !PuzzleInput {
    var columns = try std.ArrayList(Column).initCapacity(gpa, 1000);
    var is_first_line = true;
    
    var line_buffer = std.io.Writer.Allocating.init(gpa);

    while (try stdin.streamDelimiterEnding(&line_buffer.writer, '\n') > 0) : (line_buffer.clearRetainingCapacity()) {
        _ = try stdin.discardDelimiterInclusive('\n');
        const line = try line_buffer.toOwnedSlice();
        std.debug.print("line = {s}\n", .{line});
        var it = std.mem.tokenizeAny(u8, line, &std.ascii.whitespace);
        var i: usize = 0;
        while (it.next()) |token| {
            std.debug.print("token = {s}\n", .{token});
            if (is_first_line) {
                try columns.append(gpa, .{ .numbers = .empty, .op = undefined });
            }
            
            if (std.mem.eql(u8, token, "+")) {
                columns.items[i].op = .plus;
            } else if (std.mem.eql(u8, token, "*")) {
                columns.items[i].op = .times;
            } else {
                const a = try std.fmt.parseInt(i64, token, 10);
                try columns.items[i].numbers.append(gpa, a);
            }

            i += 1;
        }
        is_first_line = false;
    }
    std.debug.print("parsed:\n{}\n", .{columns});
    return .{
        .columns = columns
    };
}

pub fn solve(gpa: std.mem.Allocator, input: PuzzleInput) !usize {
    _ = gpa;
    var result: usize = 0;
    for (input.columns.items) |col| {
        var current: usize = switch (col.op) { .plus => 0, .times => 1 };
        for (col.numbers.items) |n| {
            switch (col.op) {
                .plus => { current += @as(usize, @intCast(n)); },
                .times => { current *= @as(usize, @intCast(n)); },
            }
        }
        result += current;
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
