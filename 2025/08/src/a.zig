const std = @import("std");


pub const Point = struct {
    x: i64,
    y: i64,
    z: i64,

    const Self = @This();

    pub fn parse(s: []const u8) !Self {
        var reader = std.io.Reader.fixed(s);
        const a = try reader.takeDelimiter(',') orelse return error.MissingCharacter;
        const x = try std.fmt.parseInt(i64, a, 10);
        const b = try reader.takeDelimiter(',') orelse return error.MissingCharacter;
        const y = try std.fmt.parseInt(i64, b, 10);
        const c = reader.buffered();
        const z = try std.fmt.parseInt(i64, c, 10);

        return .{
            .x = x,
            .y = y,
            .z = z,
        };
    }

    pub fn distanceSquared(self: *const Self, other: *const Self) i64 {
        const dx = other.x - self.x;
        const dy = other.y - self.y;
        const dz = other.z - self.z;

        return dx * dx + dy * dy + dz * dz;
    }
};


pub const PuzzleInput = std.ArrayList(Point);


pub fn parse(gpa: std.mem.Allocator, stdin: *std.io.Reader) !PuzzleInput {
    var line_buffer = std.io.Writer.Allocating.init(gpa);

    var points = try PuzzleInput.initCapacity(gpa, 1000);

    while (try stdin.streamDelimiterEnding(&line_buffer.writer, '\n') > 0) : ({
        _ = try stdin.discardDelimiterInclusive('\n');
        line_buffer.clearRetainingCapacity();
    }) {
        const line = try line_buffer.toOwnedSlice();

        const point = try Point.parse(line);
        std.debug.print("{}\n", .{point});
        try points.append(gpa, point);
    }
    return points;
}


pub fn solve(gpa: std.mem.Allocator, input: PuzzleInput) !usize {
    var t: struct {
        t: std.time.Timer,

        pub fn tick(self: *@This(), message: []const u8) !void {
            const nanos = @as(f64, @floatFromInt(self.t.lap()));
            const seconds = nanos / 1_000_000_000.0;
            std.debug.print("[{:.2}s] {s}\n", .{seconds, message});
        }
    } = .{ .t = try std.time.Timer.start() };

    var result: usize = 0;

    const points = input.items;
    
    const Edge = struct {
        i: usize,
        j: usize,
    };
    
    var edges = try std.ArrayList(Edge).initCapacity(gpa, points.len * points.len);

    for (points, 0..) |_, i| {
        for (points[i+1..], i+1..) |_, j| {
            // std.debug.print("{} <-> {}\n", .{i, j});
            try edges.append(gpa, .{.i = i, .j = j});
        }
    }

    try t.tick("create edges");
    
    const CX = struct {
        points: []const Point,

        pub fn lessThan(self: @This(), a: Edge, b: Edge) bool {
            const d_a = self.points[a.i].distanceSquared(&self.points[a.j]);
            const d_b = self.points[b.i].distanceSquared(&self.points[b.j]);
            return d_a < d_b;
        }
    };

    const cx: CX = .{ .points = points };

    std.mem.sort(Edge, edges.items, cx, CX.lessThan);

    try t.tick("sort edges");

    var circuits = try gpa.alloc(usize, points.len);
    for (circuits) |*c| { c.* = 0; }
    var next_circuit: usize = 1;

    for (0..1000) |i| {
        const e = edges.items[i];

        if (circuits[e.i] == 0 and circuits[e.j] == 0) {
            circuits[e.i] = next_circuit;
            circuits[e.j] = next_circuit;
            next_circuit += 1;
            std.debug.print("new circuit {} between {} and {}\n", .{circuits[e.i], points[e.i], points[e.j]});
        } else {
            // one box is already in a circuit, connect the other
            if (circuits[e.i] == 0) {
                circuits[e.i] = circuits[e.j];
                std.debug.print("connecting {} to circuit {}\n", .{points[e.i], circuits[e.j]});
            } else if (circuits[e.j] == 0) {
                std.debug.print("connecting {} to circuit {}\n", .{points[e.j], circuits[e.i]});
                circuits[e.j] = circuits[e.i];
            } else {
                const cj = circuits[e.j];
                const ci = circuits[e.i];
                std.debug.print("both {} and {} are connected. {} <- {}\n", .{points[e.i], points[e.j], cj, ci});
                for (circuits) |*c| {
                    if (c.* == cj) { c.* = ci; }
                }
            }
        }
        // std.debug.print("circuits: {any}\n", .{circuits});
    }

    try t.tick("union find");

    var counts = try gpa.alloc(usize, circuits.len);
    for (counts) |*c| { c.* = 0; }
    for (circuits) |i| {
        counts[i] += 1;
    }

    std.mem.sort(usize, counts, {}, comptime std.sort.desc(usize));

    std.debug.print("{any}\n", .{counts});

    try t.tick("extract largest");

    result = counts[1] * counts[2] * counts[3];

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
