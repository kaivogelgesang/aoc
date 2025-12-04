const std = @import("std");
const part_a = @import("a.zig");
const parse = part_a.parse;
const Vec = part_a.Vec;

pub fn solve(gpa: std.mem.Allocator, rows: Vec(Vec(u8))) !usize {
    const n = rows.items[0].items.len;
    const digits = 12;

    std.debug.print("n = {}\n", .{n});
    
    var dp: [digits][]u64 = undefined;
    for (0..digits) |i| {
        dp[i] = try gpa.alloc(u64, n);
    }

    var result: usize = 0;

    for (rows.items) |row| {
        for (row.items, 0..) |digit, i| {
            dp[0][i] = digit;
        }
        for (1..digits) |k| {
            // std.debug.print("n - k = {}\n", .{n-k});
            const limit = n - k + 1;

            for (row.items, 0..) |digit, i| {
                dp[k][i] = 0;
                var written = false;
                // std.debug.print("i = {}\n", .{i});
                if (i+1 > limit) {
                    continue;
                }
                
                for (i+1..limit) |j| {
                    const current = std.math.pow(u64, 10, k) * digit + dp[k-1][j];
                    if (current > dp[k][i]) {
                        // std.debug.print("update: max <- {} (i={} j={} k={})\n", .{current, i, j, k});
                        dp[k][i] = current;
                        written = true;
                    }
                }
                if (!written) {
                    // std.debug.print("dp[{}][{}] not written :O\n", .{k, i});
                }
            }
        }
        var max: u64 = 0;
        for (0..n) |i| {
            const current = dp[11][i];
            if (current > max) {
                max = current;
            }
        }
        std.debug.print("+ {}\n", .{max});
        result += max;
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

    const rows = try parse(stdin, allocator);
    const result = try solve(allocator, rows);

    // print result

    try stdout.print("{d}\n", .{result});
    try stdout.flush();
}
