const std = @import("std");
const part_a = @import("a.zig");
const PuzzleInput = part_a.PuzzleInput;
const parse = part_a.parse;

pub fn solve(gpa: std.mem.Allocator, input: PuzzleInput) !usize {
    var result: usize = 0;
    const n = input.width();
    var scan_current = try gpa.alloc(usize, n);
    var scan_next = try gpa.alloc(usize, n);

    for (input.row(0) orelse return error.BadInput, 0..) |c, x| {
        if (c == 'S') {
            scan_current[x] = 1;
        } else {
            scan_current[x] = 0;
        }
    }

    for (1..input.height()) |y| {

        std.debug.print("[{:3}] ", .{y});
        for (scan_current) |u| {
            if (u < 36) {
                std.debug.print("{c}", .{".123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[u]});
            } else {
                std.debug.print("#", .{});
            }
        }
        std.debug.print("\n", .{});

        for (scan_next) |*u| { u.* = 0; }
        for (input.row(@as(i32, @intCast(y))) orelse unreachable, 0..) |c, x| {
            if (scan_current[x] == 0) { continue; }
            switch (c) {
                '.' => {
                    scan_next[x] += scan_current[x];
                },
                '^' => {
                    scan_next[x-1] += scan_current[x];
                    scan_next[x+1] += scan_current[x];
                },
                else => return error.BadInput,
            }
        }

        std.mem.swap([]usize, &scan_current, &scan_next);
    }

    for (scan_current) |u| { result += u; }
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
