const std = @import("std");

pub const Interval = struct {
    start: i64,
    end: i64
};

pub const PuzzleInput = struct {
    intervals: std.ArrayList(Interval),
    points: std.ArrayList(i64),
};

pub fn parse(gpa: std.mem.Allocator, stdin: *std.io.Reader) !PuzzleInput {
    var intervals = try std.ArrayList(Interval).initCapacity(gpa, 200);
    var points = try std.ArrayList(i64).initCapacity(gpa, 1000);
    while (try stdin.takeDelimiter('\n')) |line| {
        if (line.len == 0) {
            continue;
        }
        if (std.mem.indexOfScalar(u8, line, '-')) |split| {
            // a-b
            const a = try std.fmt.parseInt(i64, line[0..split], 10);
            const b = try std.fmt.parseInt(i64, line[split+1..], 10);
            try intervals.append(gpa, .{.start = a, .end = b});
        } else {
            // a
            const a = try std.fmt.parseInt(i64, line, 10);
            try points.append(gpa, a);
        }
    }
    return .{
        .intervals = intervals,
        .points = points
    };
}

pub fn solve(gpa: std.mem.Allocator, input: PuzzleInput) !usize {
    _ = gpa;
    var result: usize = 0;
    for (input.points.items) |p| {
        for (input.intervals.items) |i| {
            if (i.start <= p and p <= i.end) {
                std.debug.print("{} is fresh\n", .{p});
                result += 1;
                break;
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
