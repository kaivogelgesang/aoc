const std = @import("std");

pub fn build(bld: *std.Build) void {
    const target = bld.standardTargetOptions(.{});
    const optimize = bld.standardOptimizeOption(.{});

    const a = bld.addExecutable(.{
        .name = "a",
        .root_module = bld.createModule(.{
            .root_source_file = bld.path("src/a.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{},
        }),
    });
    
    const b = bld.addExecutable(.{
        .name = "b",
        .root_module = bld.createModule(.{
            .root_source_file = bld.path("src/b.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{},
            .link_libc = true,
        }),
    });

    b.root_module.linkSystemLibrary("z3", .{});

    bld.installArtifact(a);
    bld.installArtifact(b);

    const run_a = bld.step("run-a", "Run the solution for (a)");
    const run_b = bld.step("run-b", "Run the solution for (b)");

    const run_a_cmd = bld.addRunArtifact(a);
    run_a.dependOn(&run_a_cmd.step);
    run_a_cmd.step.dependOn(bld.getInstallStep());
    
    const run_b_cmd = bld.addRunArtifact(b);
    run_b.dependOn(&run_b_cmd.step);
    run_b_cmd.step.dependOn(bld.getInstallStep());

    if (bld.args) |args| {
        run_a_cmd.addArgs(args);
        run_b_cmd.addArgs(args);
    }

    const a_exe_tests = bld.addTest(.{
        .root_module = a.root_module,
    });
    const run_a_exe_tests = bld.addRunArtifact(a_exe_tests);
    
    const b_exe_tests = bld.addTest(.{
        .root_module = b.root_module,
    });
    const run_b_exe_tests = bld.addRunArtifact(b_exe_tests);

    const test_step = bld.step("test", "Run tests");
    test_step.dependOn(&run_a_exe_tests.step);
    test_step.dependOn(&run_b_exe_tests.step);
}
