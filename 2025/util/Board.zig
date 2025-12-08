const std = @import("std");

inner: std.ArrayList(std.ArrayList(u8)),

const Board = @This();

pub fn height(self: *const Board) usize {
    return self.inner.items.len;
}

pub fn width(self: *const Board) usize {
    return self.inner.items[0].items.len;
}

pub fn row(self: *const Board, y: i32) ?[]u8 {
    if (y < 0 or self.inner.items.len <= y) {
        return null;
    }
    const row_ = self.inner.items[@as(usize, @intCast(y))];
    return row_.items;
}

pub fn get(self: *const Board, x: i32, y: i32) ?u8 {
    const row_ = self.row(y) orelse return null;
    if (x < 0 or row_.len <= x) {
        return null;
    }
    return row_[@as(usize, @intCast(x))];
}

pub fn set(self: *const Board, x: i32, y: i32, c: u8) void {
    const row_ = self.row(y) orelse return null;
    if (x < 0 or row_.len <= x) {
        return;
    }
    row_[@as(usize, @intCast(x))] = c;
}

pub fn parse(allocator: std.mem.Allocator, stdin: *std.io.Reader) !Board {
    var inner: std.ArrayList(std.ArrayList(u8)) = .empty;

    while (try stdin.takeDelimiter('\n')) |line| {
        var row_ = try std.ArrayList(u8).initCapacity(allocator, line.len);
        try row_.appendSlice(allocator, line);
        try inner.append(allocator, row_);
    }

    return .{ .inner = inner };
}
