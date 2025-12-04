const std = @import("std");
const part_a = @import("a.zig");
const parse = part_a.parse;
const Interval = part_a.Interval;

pub fn nextSplit(parts: usize, x: u64) u64 {
    // std.debug.print("nextSplit(parts={d}, x={d}):\n", .{ parts, x });
    const digits = std.math.log10_int(x) + 1;

    if (@mod(digits, parts) != 0) {
        // std.debug.print("uneven split\n", .{});
        return std.math.pow(u64, 10, digits / parts);
    }

    const digits_per_part = digits / parts;
    // std.debug.print("{} digits per part\n", .{digits_per_part});

    if (digits_per_part == 0) {
        // std.debug.print("<1 digit per part", .{});
        return 1;
    }

    const modulus = std.math.pow(u64, 10, digits_per_part);
    // std.debug.print("mod={}\n", .{modulus});

    const a = x / std.math.pow(u64, 10, (parts - 1) * digits_per_part);
    // std.debug.print("a={}\n", .{a});

    var group = parts - 1;
    while (group > 0) {
        group -= 1;
        const b = @mod(x / std.math.pow(u64, 10, group * digits_per_part), modulus);
        // std.debug.print("b={}\n", .{b});
        if (b < a) {
            return a;
        }
        if (b > a) {
            return a + 1;
        }
    }
    return a;
}

test "debug" {
    const r = nextSplit(5, 6161588270);
    std.debug.print("result: {}\n", .{r});
}

test "nextSplit" {
    const expectEqual = std.testing.expectEqual;
    const nextHalf = @import("a.zig").nextHalf;
    for (1..15000) |x| {
        try expectEqual(nextHalf(x), nextSplit(2, x));
    }

    try expectEqual(9, nextSplit(3, 998));
    try expectEqual(2, nextSplit(6, 222220));
    try expectEqual(56, nextSplit(3, 565653));
}

pub fn repeat(count: usize, x: u64) u64 {
    const digits = std.math.log10_int(x) + 1;
    const modulus = std.math.pow(u64, 10, digits);
    
    var exponent: u64 = 1;
    var result: u64 = 0;
    for (0..count) |_| {
        result += x * exponent;
        exponent *= modulus;
    }
    return result;
}

test "full" {
    const expectEqual = std.testing.expectEqual;
    const halfToFull = @import("a.zig").halfToFull;
    for (1..15000) |x| {
        try expectEqual(halfToFull(x), repeat(2, x));
    }
    
    try expectEqual(123123123, repeat(3, 123));
    try expectEqual(2121212121, repeat(5, 21));
}

pub fn solve(intervals: []Interval, gpa: std.mem.Allocator) !usize {
    var seen = std.HashMap(u64, bool, struct {
        pub fn hash(self: @This(), k: u64) u64 { _ = self; return k; }
        pub fn eql(self: @This(), k1: u64, k2: u64) bool { _ = self; return k1 == k2; }
    }, 50).init(gpa);

    var result: usize = 0;
    for (intervals) |interval| {
        std.debug.print("Interval {}-{}:\n", .{interval.start, interval.end});
        const max_split = std.math.log10_int(interval.end) + 1;
        for (2..max_split+1) |parts| {
            var a = nextSplit(parts, interval.start);
            var full = repeat(parts, a);

            while (full <= interval.end) : ({a += 1; full = repeat(parts, a);}) {
                if (seen.contains(full)) {
                    std.debug.print("[ {} (parts = {}) skipped]\n", .{full, parts});
                    continue;
                }
                try seen.put(full, true);
                std.debug.print("+ {} (parts = {})\n", .{full, parts});
                result += full;
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

    const intervals = try parse(stdin, allocator);
    const result = try solve(intervals.items, allocator);

    // print result

    try stdout.print("{d}\n", .{result});
    try stdout.flush();
}
