const std = @import("std");
const part_a = @import("a.zig");
const PuzzleInput = part_a.PuzzleInput;
const Machine = part_a.Machine;
const parse = part_a.parse;

// props to zig for having such good C interop
const z3 = @cImport({
    @cInclude("z3.h");
});

pub fn optimize(gpa: std.mem.Allocator, m: Machine) !usize {

    // setup z3
    const cx = blk: {
        const cfg = z3.Z3_mk_config();
        const ctx = z3.Z3_mk_context(cfg);
        z3.Z3_del_config(cfg);
        break :blk ctx;
    };
    defer z3.Z3_del_context(cx);

    // setup optimizer
    const opt = z3.Z3_mk_optimize(cx);
    z3.Z3_optimize_inc_ref(cx, opt);
    defer z3.Z3_optimize_dec_ref(cx, opt);

    const n = m.buttons.items.len;
    
    // create x_1 .. x_n

    const ty = z3.Z3_mk_int_sort(cx);
    const zero = z3.Z3_mk_int(cx, 0, ty);

    const x = try gpa.alloc(z3.Z3_ast, n);
    for (x, 0..) |*x_i, i| {
        const s = z3.Z3_mk_int_symbol(cx, @as(c_int, @intCast(i)));
        x_i.* = z3.Z3_mk_const(cx, s, ty);

        const ge = z3.Z3_mk_ge(cx, x_i.*, zero);
        z3.Z3_optimize_assert(cx, opt, ge);
    }

    // encode constraints

    const dim = m.joltages.items.len;

    for (0..dim) |i| {
        // 0 <= i < dim
        const b_i = z3.Z3_mk_int(cx, @as(c_int, @intCast(m.joltages.items[i])), ty);

        var args = try gpa.alloc(z3.Z3_ast, n);        
        for (x, 0..) |x_j, j| {
            // 0 <= j < n
            const v = (m.buttons.items[j] >> @as(u4, @intCast(i))) & 1;
            const a_ij = z3.Z3_mk_int(cx, @as(c_int, @intCast(v)), ty);
            const mul_args = [_]z3.Z3_ast {a_ij, x_j};
            args[j] = z3.Z3_mk_mul(cx, 2, @ptrCast(&mul_args));
        }
        const sum = z3.Z3_mk_add(cx, @as(c_uint, @intCast(n)), @ptrCast(args));

        const eq = z3.Z3_mk_eq(cx, b_i, sum);
        z3.Z3_optimize_assert(cx, opt, eq);
    }

    // solve for min weight
    
    const sum = z3.Z3_mk_add(cx, @as(c_uint, @intCast(n)), @ptrCast(x));
    const optmin = z3.Z3_optimize_minimize(cx, opt, sum);
    std.debug.assert(optmin == 0);

    const check = z3.Z3_optimize_check(cx, opt, 0, 0);
    std.debug.assert(check == z3.Z3_L_TRUE);
    
    const model = z3.Z3_optimize_get_model(cx, opt);
    z3.Z3_model_inc_ref(cx, model);
    defer z3.Z3_model_dec_ref(cx, model);

    var presses: usize = 0;

    for (x, 0..) |x_i, i| {
        var val: z3.Z3_ast = undefined;
        const r = z3.Z3_model_eval(cx, model, x_i, true, @ptrCast(&val));
        std.debug.assert(r == true);
        var i_val: c_int = undefined;
        const r2 = z3.Z3_get_numeral_int(cx, val, @ptrCast(&i_val));
        std.debug.assert(r2 == true);
        
        _ = i; // std.debug.print("x_{} = {}\n", .{i, i_val});

        presses += @as(usize, @intCast(i_val));
    }

    return presses;
}

pub fn solve(gpa: std.mem.Allocator, input: PuzzleInput) !usize {
    var result: usize = 0;
    
    for (input.items) |m| {
        const x = try optimize(gpa, m);
        std.debug.print("+ {}\n", .{x});
        result += x;
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
