const std = @import("std");

const B = u10;

pub const Machine = struct {
    indicators: B,
    buttons: std.ArrayList(B),
    joltages: std.ArrayList(u32),
};

pub const PuzzleInput = std.ArrayList(Machine);

pub fn parse(gpa: std.mem.Allocator, stdin: *std.io.Reader) !PuzzleInput {
    var line_buffer = std.io.Writer.Allocating.init(gpa);

    var machines = try std.ArrayList(Machine).initCapacity(gpa, 200);

    while (try stdin.streamDelimiterEnding(&line_buffer.writer, '\n') > 0) : ({
        _ = try stdin.discardDelimiterInclusive('\n');
        line_buffer.clearRetainingCapacity();
    }) {
        const line = try line_buffer.toOwnedSlice();
        
        var indicators: B = 0;
        const indicator_end = std.mem.indexOfScalar(u8, line, ']') orelse return error.BadInput;
        for (line[1..indicator_end], 0..) |light, i| {
            if (light == '#') { indicators |= (@as(B, 1) << @as(u4, @intCast(i))); }
        }

        var buttons = try std.ArrayList(B).initCapacity(gpa, indicator_end);  // indicator_end == number of lights + 1
        const joltage_start = std.mem.indexOfScalar(u8, line, '{') orelse return error.BadInput;
        var it = std.mem.tokenizeAny(u8, line[indicator_end + 1 .. joltage_start], &std.ascii.whitespace);
        while (it.next()) |token| {
            var b: B = 0;
            var it2 = std.mem.tokenizeScalar(u8, token[1..token.len-1], ',');
            while (it2.next()) |i| {
                b |= @as(B, 1) << try std.fmt.parseInt(u4, i, 10);
            }
            try buttons.append(gpa, b);
        }

        var joltages = try std.ArrayList(u32).initCapacity(gpa, indicator_end);
        var it3 = std.mem.tokenizeScalar(u8, line[joltage_start+1..line.len-1], ',');
        while (it3.next()) |token| {
            const j = try std.fmt.parseInt(u32, token, 10);
            try joltages.append(gpa, j);
        }

        try machines.append(gpa, .{
            .indicators = indicators,
            .buttons = buttons,
            .joltages = joltages
        });
    }
    return machines;
}

pub fn bfs(gpa: std.mem.Allocator, adj: []const B) ![]?usize {
    const dist = try gpa.alloc(?usize, 1 << @typeInfo(B).int.bits);
    for (dist) |*d| { d.* = null; }
    
    // so it turns out zig has PriorityQueue, but no Queue -_-
    const Item = struct {
        d: usize,
        v: u10,

        const Self = @This();

        pub fn compare(cx: void, a: Self, b: Self) std.math.Order {
            _ = cx;
            return std.math.order(a.d, b.d);
        }
    };
    
    var q = std.PriorityQueue(Item, void, Item.compare).init(gpa, {});
    try q.add(.{.d = 0, .v = 0});

    while (q.removeOrNull()) |cur| {
        if (dist[cur.v] != null) { continue; }
        dist[cur.v] = cur.d;
        for (adj) |edge| {
            try q.add(.{.d = cur.d + 1, .v = cur.v ^ edge});
        }
    }

    return dist;
}

pub fn solve(gpa: std.mem.Allocator, input: PuzzleInput) !usize {
    var result: usize = 0; result = 0;

    const machines = input.items;

    // for (machines) |m| {
    //     std.debug.print("indicators: {b}\n", .{m.indicators});
    //     std.debug.print("buttons:", .{});
    //     for (m.buttons.items) |b| {
    //         std.debug.print(" {b}", .{b});
    //     }
    //     std.debug.print("\n", .{});
    //     std.debug.print("joltages:", .{});
    //     for (m.joltages.items) |j| {
    //         std.debug.print(" {}", .{j});
    //     }
    //     std.debug.print("\n", .{});
    // }

    for (machines) |m| {
        const dist = try bfs(gpa, m.buttons.items);
        const n = dist[m.indicators] orelse return error.Unsolvable;
        std.debug.print("+ {}\n", .{n});
        result += n;
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
