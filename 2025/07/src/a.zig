const std = @import("std");

pub const PuzzleInput = @import("util/Board.zig");

pub const parse = PuzzleInput.parse;

pub fn solve(gpa: std.mem.Allocator, input: PuzzleInput) !usize {
    var result: usize = 0;
    
    const n = input.width();
    var scan_current = try gpa.alloc(bool, n);
    var scan_next = try gpa.alloc(bool, n);

    std.debug.print("[{:3}]", .{0});
    for (input.row(0) orelse return error.BadInput, 0..) |c, x| {
        if (c == 'S') {
            std.debug.print("S", .{});
            scan_current[x] = true;
        } else {
            std.debug.print(".", .{});
            scan_current[x] = false;
        }
    }
    std.debug.print("\n", .{});

    for (1..input.height()) |y| {

        std.debug.print("[{:3}]", .{y});
        for (scan_current) |b| {
            std.debug.print("{c}", .{".|"[@as(usize, @intFromBool(b))]});
        }
        std.debug.print("\n", .{});

        for (scan_next) |*b| {
            b.* = false;
        }
        for (input.row(@as(i32, @intCast(y))) orelse unreachable, 0..) |c, x| {
            if (!scan_current[x]) { continue; }
            switch (c) {
                '.' => {
                    scan_next[x] = true;
                },
                '^' => {
                    result += 1;
                    scan_next[x-1] = true;
                    scan_next[x+1] = true;
                },
                else => {
                    return error.BadInput;
                }
            }
        }
        std.mem.swap([]bool, &scan_current, &scan_next);
    }

    return result;
}

test "sanity check" {
    const gpa = std.testing.allocator;
    var cur = try gpa.alloc(bool, 10);
    defer gpa.free(cur);
    var next = try gpa.alloc(bool, 10);
    defer gpa.free(next);

    for (cur) |*b| { b.* = false; }
    for (next) |*b| { b.* = false; }

    const dbg = struct { pub fn impl(a: []bool) void {
        std.debug.print("[", .{});
        for (a) |b| {
            std.debug.print("{c}", .{".#"[@as(usize, @intFromBool(b))]});
        }
        std.debug.print("]\n", .{});
    } }.impl;

    cur[3] = true;
    next[7] = true;
    std.debug.print("\na: ", .{});
    dbg(cur);
    std.debug.print("b: ", .{});
    dbg(next);

    std.debug.print("swap\n", .{});
    std.mem.swap([]bool, &cur, &next);
    
    std.debug.print("a: ", .{});
    dbg(cur);
    std.debug.print("b: ", .{});
    dbg(next);
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
