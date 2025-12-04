const std = @import("std");

pub const Num = i64;
pub const Report = std.ArrayList(Num);
pub const PuzzleInput = std.ArrayList(Report);

pub fn parse(allocator: std.mem.Allocator) !PuzzleInput {

    var result = PuzzleInput.init(allocator);
    
    const stdin = std.io.getStdIn();
    const reader = stdin.reader();

    var line = std.ArrayList(u8).init(allocator);
    defer line.deinit();

    while (reader.streamUntilDelimiter(line.writer(), '\n', null)) {
        if (line.getLastOrNull() == '\r') _ = line.pop();

        var report = Report.init(allocator);
        
        var it = std.mem.tokenizeScalar(u8, line.items, ' ');
        while (it.next()) |value| {
            const n = try std.fmt.parseInt(Num, value, 10);
            try report.append(n);
        }

        try result.append(report);

        line.clearRetainingCapacity();
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => |e| return e,
    }

    return result;
}
