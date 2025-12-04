const std = @import("std");
const lib = @import("root.zig");

fn count_violations(report: lib.Report, a: lib.Num, b: lib.Num) u64 {
    var i: usize = 2;
    var v: u64 = 0;

    while (i < report.items.len) {
        const x = report.items[i-2];
        const y = report.items[i-1];
        const z = report.items[i];

        const d1 = y - x;
        const d2 = z - x;

        const d1_ok = !(d1 < a or d1 > b);

        if (!d1_ok) {
            // std.debug.print("step {} -> {} = {}\n", .{x, y, d1});
            const d2_ok = !(d2 < a or d2 > b);
            if (d2_ok) {
                i += 1;
            } else {
                // std.debug.print("step {} -> {} = {} also not ok\n", .{x, z, d2});
                v += 1;
            }
        }

        i += 1;
    }
    // std.debug.print("v({},{}) = {}\n", .{a, b, v});
    return v;
}

fn is_safe_report(report: lib.Report) bool {
    const limit = 0;

    if (count_violations(report, 1, 3) > limit) {
        return count_violations(report, -3, -1) <= limit;
    } else {
        return true;
    }
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
        if (is_safe_report(report)) {
            std.debug.print("safe\n", .{});
            safe_reports += 1;
        } else {
            std.debug.print("unsafe\n", .{});
        }
    }

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("{d}\n", .{safe_reports});
    try bw.flush();
}

