const std = @import("std");
const part_a = @import("a.zig");
const PuzzleInput = part_a.PuzzleInput;
const parse = part_a.parse;

pub fn solve(gpa: std.mem.Allocator, input: PuzzleInput) !usize {
    _ = gpa;
    var result: usize = 0;

    // TODO implement
    _ = input;
    result = 0;

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
