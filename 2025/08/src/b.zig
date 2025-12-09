const std = @import("std");
const part_a = @import("a.zig");
const PuzzleInput = part_a.PuzzleInput;
const parse = part_a.parse;
const Point = part_a.Point;

pub const UnionFind = struct {
    parent: []usize,

    const Self = @This();

    pub fn init(gpa: std.mem.Allocator, n: usize) !Self {
        const self: Self = .{
            .parent = try gpa.alloc(usize, n)
        };

        for (self.parent, 0..) |*u, i| {
            u.* = i;
        }

        return self;
    }

    pub fn find(self: *Self, x: usize) usize {
        if (self.parent[x] != x) {
            self.parent[x] = self.find(self.parent[x]);
            return self.parent[x];
        } else {
            return x;
        }
    }

    pub fn union_(self: *Self, x: usize, y: usize) bool {
        const px = self.find(x);
        const py = self.find(y);

        if (px == py) {
            return false;
        }

        self.parent[py] = px;
        return true;
    }
};


pub fn solve(gpa: std.mem.Allocator, input: PuzzleInput) !usize {
    var t: struct {
        t: std.time.Timer,

        pub fn tick(self: *@This(), message: []const u8) !void {
            const nanos = @as(f64, @floatFromInt(self.t.lap()));
            const seconds = nanos / 1_000_000_000.0;
            std.debug.print("[{:.2}s] {s}\n", .{seconds, message});
        }
    } = .{ .t = try std.time.Timer.start() };

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
    
    var uf = try UnionFind.init(gpa, points.len);
    var last: ?Edge = null;

    for (edges.items) |e| {
        if (uf.union_(e.i, e.j)) {
            last = e;
        }
    }

    try t.tick("union find");

    const e = last orelse unreachable;

    std.debug.print("Last edge: {} <-> {}\n", .{points[e.i], points[e.j]});

    return @as(usize, @intCast(points[e.i].x * points[e.j].x));
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
