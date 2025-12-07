const std = @import("std");
// why is this puzzle only ugly input parsing? -_-

pub fn bruh(gpa: std.mem.Allocator, stdin: *std.io.Reader) !usize {

    var input_buf = std.io.Writer.Allocating.init(gpa);
    _ = try stdin.stream(&input_buf.writer, .unlimited);
    const input = try input_buf.toOwnedSlice();
    const line_length = std.mem.indexOf(u8, input, "\n") orelse return error.BadInput;
    const last_line_start = std.mem.indexOfAny(u8, input, "+*") orelse return error.BadInput;
    const line_count = std.mem.count(u8, input[0..last_line_start], "\n");

    std.debug.print("grid: w={} x h={}\n", .{line_length, line_count});

    const b: struct {
        buf: []u8,
        stride: usize,

        pub fn get(self: @This(), x: usize, y: usize) u8 {
            const i = self.stride * y + x;
            if (i >= self.buf.len) { return ' '; }
            return self.buf[i];
        }
    } = .{ .buf = input, .stride = line_length + 1 }; // include newlines

    var col: std.ArrayList(usize) = .empty;
    var result: usize = 0;
    
    for (0..line_length) |mx| {
        const x = line_length - mx - 1;
        std.debug.print("x = {}\n", .{x});
        var current: usize = 0;
        var non_space = false;
        for (0..line_count) |y| {
            const c = b.get(x,y);
            std.debug.print("y = {} => c = '{c}'\n", .{y, c});
            if ('0' < c and c <= '9') {
                non_space = true;
                current *= 10;
                current += c - '0';
            }
        }
        if (non_space) {
            std.debug.print("append {}\n", .{current});
            try col.append(gpa, current);
        }

        switch (b.get(x, line_count)) {
            '+' => {
                var a: usize = 0;
                for (col.items) |c| {
                    a += c;
                }
                std.debug.print("+ {}\n", .{a});
                result += a;
                col.clearRetainingCapacity();
            },
            '*' => {
                var a: usize = 1;
                for (col.items) |c| {
                    a *= c;
                }
                col.clearRetainingCapacity();
                std.debug.print("+ {}\n", .{a});
                result += a;
            },
            else => {}
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

    const result = try bruh(allocator, stdin);

    // print result

    try stdout.print("{d}\n", .{result});
    try stdout.flush();
}
