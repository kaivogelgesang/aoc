const std = @import("std");
const part_a = @import("a.zig");
const PuzzleInput = part_a.PuzzleInput;
const parse = part_a.parse;

const EndpointTag = enum {
    left,
    right
};
const Endpoint = union(EndpointTag) {
    left: i64,
    right: i64,
        
    pub fn inner(self: @This()) i64 {
        return switch (self) {
            .left => |v| v,
            .right => |v| v,
        };
    }
};

const CX = struct {
    pub fn compare(self: @This(), a: Endpoint, b: Endpoint) std.math.Order {
        switch (std.math.order(a.inner(), b.inner())) {
            .eq => {
                if (@as(EndpointTag, a) == @as(EndpointTag, b)) {
                    // L(x) L(x) | R(x) R(x)
                    return .eq;
                }
                if (@as(EndpointTag, a) == .right) {
                    // R(x) L(x)
                    return .gt;
                } else {
                    // L(x) R(x)
                    return .lt;
                }
            },
            else => |o| return o
        }
        _ = self;
    }
};

pub fn solve(gpa: std.mem.Allocator, input: PuzzleInput) !usize {
    var q = std.PriorityQueue(Endpoint, CX, CX.compare).init(gpa, .{});

    for (input.intervals.items) |i| {
        try q.add(.{.left = i.start});
        try q.add(.{.right = i.end});
    }

    var overlap: isize = 0;
    var start: i64 = 0;

    var result: usize = 0;

    while (q.removeOrNull()) |e| {
        switch (e) {
            .left => |v| {
                // std.debug.print("L {}\n" ,.{v});
                if (overlap == 0) {
                    start = v;
                }
                overlap += 1;
            },
            .right => |v| {
                // std.debug.print("R {}\n" ,.{v});
                overlap -= 1;
                if (overlap == 0) {
                    const count = @as(usize, @intCast(v - start + 1));
                    std.debug.print("+ {}\n", .{count});
                    result += count;
                }
            },
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
