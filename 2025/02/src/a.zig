const std = @import("std");

pub const Interval = struct {
    start: u64,
    end: u64,
};

pub fn parse(stdin: *std.io.Reader, gpa: std.mem.Allocator) !std.ArrayList(Interval) {
    var intervals = try std.ArrayList(Interval).initCapacity(gpa, 100);

    while (try stdin.takeDelimiter(',')) |range| {
        const split = std.mem.indexOfScalar(u8, range, '-') orelse return error.BadInput;

        const a = std.mem.trim(u8, range[0..split], &std.ascii.whitespace);
        const b = std.mem.trim(u8, range[split+1..], &std.ascii.whitespace);

        const start = try std.fmt.parseInt(u64, a, 10);
        const end = try std.fmt.parseInt(u64, b, 10);

        try intervals.append(gpa, .{ .start = start, .end = end });
    }

    return intervals;
}

/// Returns half of the next higher or equal invalid id
pub fn nextHalf(x: u64) u64 {
    const digits = std.math.log10_int(x) + 1;

    // odd
    if (@mod(digits, 2) == 1) {
        return std.math.pow(u64, 10, digits / 2);
    }

    // even
    const mod = std.math.pow(u64, 10, digits / 2);
    const a = x / mod;
    const b = @mod(x, mod);

    if (b > a) {
        return a + 1;
    }

    return a;
}

test "nextHalf" {
    const expectEqual = std.testing.expectEqual;
    try expectEqual(1, nextHalf(9));
    try expectEqual(1, nextHalf(10));
    try expectEqual(1, nextHalf(11));
    try expectEqual(2, nextHalf(12));
    try expectEqual(2, nextHalf(13));
    try expectEqual(9, nextHalf(99));
    try expectEqual(10, nextHalf(100));

    try expectEqual(10, nextHalf(998));
    try expectEqual(11885, nextHalf(1188511880));
}

pub fn halfToFull(x: u64) u64 {
        const digits = std.math.log10_int(x) + 1;
        return x * std.math.pow(u32, 10, digits) + x;
}

test "halfToFull" {
    const expectEqual = std.testing.expectEqual;
    try expectEqual(11, halfToFull(1));
    try expectEqual(22, halfToFull(2));
    try expectEqual(99, halfToFull(9));
    try expectEqual(1010, halfToFull(10));
    try expectEqual(11851185, halfToFull(1185));
}

pub fn solve(intervals: []Interval) usize {
    var result: usize = 0;
    for (intervals) |interval| {
        std.debug.print("Interval {d}-{d}\n", .{interval.start, interval.end});

        var half = nextHalf(interval.start);
        var full = halfToFull(half);

        while (full <= interval.end) {
            result += full;

            half += 1;
            full = halfToFull(half);
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
    const result = solve(intervals.items);

    // print result

    try stdout.print("{d}\n", .{result});
    try stdout.flush();
}
