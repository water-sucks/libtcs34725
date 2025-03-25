const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const libtcs34725_dep = b.dependency("libtcs34725", .{});

    const exe_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    const exe = b.addExecutable(.{
        .name = "example",
        .root_module = exe_mod,
    });
    b.installArtifact(exe);

    exe.addCSourceFile(.{
        .file = b.path("example.c"),
        .flags = &.{ "-Wall", "-Wextra", "-Werror" },
    });

    exe.linkLibrary(libtcs34725_dep.artifact("tcs34725"));

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
