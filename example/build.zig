const std = @import("std");
const zcc = @import("compile_commands");

const Compile = std.Build.Step.Compile;

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const linkage = b.option(
        std.builtin.LinkMode,
        "linkage",
        "whether to statically or dynamically link the library",
    ) orelse @as(
        std.builtin.LinkMode,
        if (target.result.isGnuLibC())
            .dynamic
        else
            .static,
    );

    const libtcs34725_dep = b.dependency("libtcs34725", .{
        .target = target,
        .optimize = optimize,
        .linkage = linkage,
    });

    const exe_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    const exe = b.addExecutable(.{
        .name = "tcs34725-example",
        .root_module = exe_mod,
        .linkage = linkage,
    });
    b.installArtifact(exe);

    exe.addCSourceFiles(.{
        .files = src_files,
        .flags = cflags,
    });

    exe.linkLibrary(libtcs34725_dep.artifact("tcs34725"));

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    var targets = std.ArrayList(*Compile).init(b.allocator);
    try targets.append(exe);
    zcc.createStep(b, "cdb", try targets.toOwnedSlice());
}

const src_files = &.{
    "example.c",
};

const cflags = &.{ "-Wall", "-Wextra", "-Werror", "-gen-cdb-fragment-path", ".zig-cache/cdb" };
