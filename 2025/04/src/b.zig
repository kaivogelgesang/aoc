const std = @import("std");
const parse = @import("a.zig").parse;

pub fn solve(board: std.ArrayList(std.ArrayList(u8))) usize {
    var result: usize = 0;

    var b: struct {
        board: std.ArrayList(std.ArrayList(u8)),

        fn get(self: *@This(), x: i32, y: i32) bool {
            if (y < 0 or self.board.items.len <= y) {
                return false;
            }
            const row = self.board.items[@as(usize, @intCast(y))];
            if (x < 0 or row.items.len <= x) {
                return false;
            }
            return row.items[@as(usize, @intCast(x))] == '@';
        }

        fn scan(self: *@This()) usize {
            var marked: usize = 0;

            for (self.board.items, 0..) |row, uy| {
                const y = @as(i32, @intCast(uy));
                for (row.items, 0..) |_, ux| {
                    const x = @as(i32, @intCast(ux));
                    if (!self.get(x, y)) { continue; }

                    var adjacent: usize = 0;
                    for ([_]i32{-1, 0, 1}) |dy| {
                        for ([_]i32{-1, 0, 1}) |dx| {
                            if (dx == 0 and dy == 0) { continue; }
                            if (self.get(x + dx, y + dy)) {
                                adjacent += 1;
                            }
                        }
                    }
                    if (adjacent < 4) {
                        self.board.items[uy].items[ux] = 'x';
                        marked += 1;
                    }
                }
            }

            return marked;
        }

        fn clear(self: @This()) void {
            for (self.board.items) |row| {
                for (row.items, 0..) |c, i| {
                    if (c == 'x') {
                        row.items[i] = '.';
                    }
                }
            }
        }
    } = .{ .board = board };

    var marked = b.scan();
    while (marked > 0) {
        result += marked;
        b.clear();
        marked = b.scan();
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

    const board = try parse(stdin, allocator);
    const result = solve(board);

    // print result

    try stdout.print("{d}\n", .{result});
    try stdout.flush();
}
