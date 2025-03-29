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

    const libtcs34725_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .pic = true,
    });

    const tcs34725_header_dir = b.addWriteFiles();
    const tcs34725_header = tcs34725_header_dir.addCopyDirectory(b.path("include"), "", .{});

    const libtcs34725 = b.addLibrary(.{
        .name = "tcs34725",
        .linkage = linkage,
        .root_module = libtcs34725_mod,
    });
    b.installArtifact(libtcs34725);

    libtcs34725.addIncludePath(b.path("include"));
    libtcs34725.installHeadersDirectory(tcs34725_header, "", .{});

    libtcs34725.addCSourceFiles(.{
        .root = b.path("src"),
        .files = src_files,
        .flags = cflags,
    });

    var targets = std.ArrayList(*Compile).init(b.allocator);
    try targets.append(libtcs34725);
    zcc.createStep(b, "cdb", try targets.toOwnedSlice());
}

const src_files = &.{
    "tcs34725.c",
    "i2c.c",
};

const cflags = &.{ "-Wall", "-Wextra", "-Werror" };
