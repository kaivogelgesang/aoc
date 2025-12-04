const std = @import("std");
const parse = @import("a.zig").parse;

pub fn solve(turns: []i32) usize {
    var result: usize = 0;
    var position: i32 = 50;
    for (turns) |turn| {
        position += turn;
        while (position >= 100) : (position -= 100) {
            result += 1;
        }
        while (position < 0) : (position += 100) {
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
