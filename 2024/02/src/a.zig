const std = @import("std");
const lib = @import("root.zig");

fn is_safe_report(report: lib.Report) bool {

    const sorted_asc = std.sort.isSorted(lib.Num, report.items, {}, std.sort.asc(lib.Num));
    const sorted_desc = std.sort.isSorted(lib.Num, report.items, {}, std.sort.desc(lib.Num));

    if (!(sorted_asc or sorted_desc)) {
        return false;
    }

    for (1..report.items.len) |i| {
        const d = @abs(report.items[i] - report.items[i-1]);
        if (d < 1 or d > 3) {
            return false;
        }
    }

    return true;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const input = try lib.parse(allocator);
    defer {
        for (input.items) |report| report.deinit();
        input.deinit();
    }

    var safe_reports: u64 = 0;

    for (input.items) |report| {
        if (is_safe_report(report)) safe_reports += 1;
    }

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("{d}\n", .{safe_reports});
    try bw.flush();
}
