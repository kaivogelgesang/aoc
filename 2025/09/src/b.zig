const std = @import("std");
const part_a = @import("a.zig");
const PuzzleInput = part_a.PuzzleInput;
const parse = part_a.parse;

fn sortAndDedup(comptime T: type, a: *std.ArrayList(T)) void {
    if (a.items.len < 2) {
        return;
    }
    std.mem.sort(T, a.items, {}, std.sort.asc(T));

    var r: usize = 1;
    var w: usize = 1;

    while (r < a.items.len) : (r += 1) {
        if (a.items[r] != a.items[w - 1]) {
            a.items[w] = a.items[r];
            w += 1;
        }
    }

    a.shrinkRetainingCapacity(w);
}

test "sort | uniq" {
    const gpa = std.testing.allocator;

    var a = try std.ArrayList(i64).initCapacity(gpa, 8);
    defer a.deinit(gpa);

    const items = [_]i64{ 4, 4, 3, 2, 2, 1, 4, 1 };

    for (items) |i| {
        try a.append(gpa, i);
    }

    sortAndDedup(i64, &a);

    try std.testing.expectEqualSlices(i64, a.items, &[_]i64{ 1, 2, 3, 4 });
}

pub fn solve(gpa: std.mem.Allocator, input: PuzzleInput) !usize {
    const points = input.items;

    // coordinate compression

    var cc_x: std.ArrayList(i64) = .empty;
    var cc_y: std.ArrayList(i64) = .empty;

    for (points) |p| {
        const x, const y = p;
        try cc_x.append(gpa, x);
        try cc_y.append(gpa, y);
    }

    sortAndDedup(i64, &cc_x);
    sortAndDedup(i64, &cc_y);

    const cc: struct {
        cx: []i64,
        cy: []i64,

        const Self = @This();

        fn cmp(a: i64, b: i64) std.math.Order {
            return std.math.order(a, b);
        }

        pub fn x(self: *const Self, item: i64) !usize {
            return std.sort.binarySearch(i64, self.cx, item, Self.cmp) orelse return error.NotFound;
        }

        pub fn y(self: *const Self, item: i64) !usize {
            return std.sort.binarySearch(i64, self.cy, item, Self.cmp) orelse return error.NotFound;
        }
    } = .{ .cx = cc_x.items, .cy = cc_y.items };

    const w = cc_x.getLast();
    const h = cc_y.getLast();

    const c_w = cc_x.items.len;
    const c_h = cc_y.items.len;

    std.debug.print("{}x{} compressed to {}x{}\n", .{ w, h, c_w, c_h });

    // draw walls

    var board = try gpa.alloc([]usize, c_h);
    for (board) |*s| {
        s.* = try gpa.alloc(usize, c_w);
        for (s.*) |*b| {
            b.* = 0;
        }
    }

    var i = points.len - 1;
    for (0..points.len) |j| {
        const x1, const y1 = points[i];
        const x2, const y2 = points[j];

        if (x1 == x2) {
            // vertical
            const cx = try cc.x(x1);
            const lo = try cc.y(@min(y1, y2));
            const hi = try cc.y(@max(y1, y2));
            for (lo..hi + 1) |cy| {
                board[cy][cx] = 1;
            }
        } else {
            // horizontal
            const cy = try cc.y(y1);
            const lo = try cc.x(@min(x1, x2));
            const hi = try cc.x(@max(x1, x2));
            for (lo..hi + 1) |cx| {
                board[cy][cx] = 1;
            }
        }

        i += 1;
        i %= points.len;
    }

    // fill interior

    const interior_point = blk: {
        const y: usize = 1;
        for (1..board[y].len) |x| {
            if (board[y][x-1] == 1 and board[y][x] == 0) {
                break :blk .{ x, y };
            }
        }
        return error.BadInput;
    };
    

    // for (0..board.len) |y| {
    //     for (0..board[y].len) |x| {
    //         if (interior_point.@"0" == x and interior_point.@"1" == y) {
    //             std.debug.print("o", .{});
    //         } else if (board[y][x] == 1) {
    //             std.debug.print("#", .{});
    //         } else {
    //             std.debug.print(".", .{});
    //         }
    //     }
    //     std.debug.print("\n", .{});
    // }
    //
    // std.debug.print("\n\n", .{});


    var q: std.ArrayList(struct { usize, usize }) = .empty;
    try q.append(gpa, interior_point);
    
    while (q.pop()) |p| {
        const x, const y = p;
        if (board[y][x] != 0) {
            continue;
        }
        board[y][x] = 1;
        try q.append(gpa, .{x-1, y});
        try q.append(gpa, .{x+1, y});
        try q.append(gpa, .{x, y+1});
        try q.append(gpa, .{x, y-1});
    }

    // for (board) |row| {
    //     for (row) |b| {
    //         std.debug.print("{c}", .{".x"[b]});
    //     }
    //     std.debug.print("\n", .{});
    // }
    
    // prefix sum

    for (1..board[0].len) |x| {
        board[0][x] += board[0][x-1];
    }
    for (1..board.len) |y| {
        board[y][0] += board[y-1][0];
        for (1..board[y].len) |x| {
            board[y][x] += board[y][x-1];
            board[y][x] += board[y-1][x];
            board[y][x] -= board[y-1][x-1];
        }
    }

    const ps: struct {
        board: [][]usize,

        const Self = @This();

        pub fn get(self: *const Self, y: i64, x: i64) i64 {
            if (x < 0 or y < 0) { return 0; }
            return @as(i64, @intCast(self.board[@as(usize, @intCast(y))][@as(usize, @intCast(x))]));
        }
    } = .{ .board = board };

    // std.debug.print("\n", .{});
    // const alphabet = "0123456789abcdefghijklmnopqrstuvwxyz";
    // for (board) |row| {
    //     for (row) |b| {
    //         std.debug.print("{c}", .{if (b < alphabet.len) alphabet[b] else '#'});
    //     }
    //     std.debug.print("\n", .{});
    // }
    // std.debug.print("\n", .{});

    var result: usize = 0;
    
    for (points, 0..) |p1, j| {
        const x1, const y1 = p1;
        const cx1 = try cc.x(x1); const cy1 = try cc.y(y1);

        for (points[j+1..]) |p2| {
            const x2, const y2 = p2;
            const cx2 = try cc.x(x2); const cy2 = try cc.y(y2);

            const to_i = struct {
                fn impl(a: anytype) i64 {
                    return @as(i64, @intCast(a));
                }
            }.impl;

            const to_u = struct {
                fn impl(a: anytype) usize {
                    return @as(usize, @intCast(a));
                }
            }.impl;

            const area = to_u((@abs(x2 - x1) + 1) * (@abs(y2 - y1) + 1));
            const c_area = to_u((@abs(to_i(cx2) - to_i(cx1)) + 1) * (@abs(to_i(cy2) - to_i(cy1)) + 1));
            
            // [y]
            //  a o--o
            //    |  |
            //  b o--o
            //    c  d [x]

            const a = to_i(@min(cy1, cy2));
            const b = to_i(@max(cy1, cy2));
            const c = to_i(@min(cx1, cx2));
            const d = to_i(@max(cx1, cx2));

            // std.debug.print("a={} b={} c={} d={}\n", .{a, b, c, d});
            
            const actual_area = to_u(blk: {
                const full = ps.get(b, d);
                const left = ps.get(b,c-1);
                const top = ps.get(a-1,d);
                const topleft = ps.get(a-1,c-1);

                // std.debug.print("[{} - {} - {} + {}]\n", .{full, left, top, topleft});

                break :blk full - left - top + topleft;
            });
            
            // std.debug.print("rect {},{} ({},{}) <-> {},{} ({},{}), area={} ({}/{}): ", .{x1, y1, cx1, cy1, x2, y2, cx2, cy2, area, actual_area, c_area});

            if (actual_area != c_area) {
                // rect contains exterior points
                // std.debug.print("skip\n", .{});
                continue;
            }

            if (area > result) {
                // std.debug.print("best candidate: {},{} <-> {},{}\n", .{x1, y1, x2, y2});
                result = area;
            } else {
                // std.debug.print("too smol\n", .{});
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
