const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "temphia-zig",
        .root_source_file = .{ .path = "src/root.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "temphia-zig",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    // ########_DEPS_START_########

    // sqlite
    const sqlite = b.dependency("sqlite", .{
        .target = target,
        .optimize = optimize,
    });

    exe.root_module.addImport("sqlite", sqlite.module("sqlite"));
    exe.linkLibrary(sqlite.artifact("sqlite"));

    lib.root_module.addImport("sqlite", sqlite.module("sqlite"));
    lib.linkLibrary(sqlite.artifact("sqlite"));

    // quickjs

    const quickjs = b.dependency("quickjs", .{
        .target = target,
        .optimize = optimize,
    });

    const libquickjs = b.addStaticLibrary(.{
        .name = "quick",
        .target = target,
        .optimize = optimize,
    });

    libquickjs.addIncludePath(quickjs.path("."));
    libquickjs.addCSourceFiles(.{
        .dependency = quickjs,
        .files = &[_][]const u8{ "cutils.c", "libbf.c", "libregexp.c", "libbf.c", "libunicode.c", "qjs.c", "qjsc.c", "quickjs-libc.c", "quickjs.c", "unicode_gen.c" },
        .flags = &.{
            "-std=c11",
            "-fno-sanitize=undefined",
        },
    });

    // exe.addCSourceFile(.{ .dependency = quickjs });

    exe.addIncludePath(quickjs.path("."));
    exe.linkLibrary(libquickjs);

    // ########_DEPS_END_########

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const lib_unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/root.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
