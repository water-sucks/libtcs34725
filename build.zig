const std = @import("std");
const fs = std.fs;
const mem = std.mem;

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const tcs34725_header_dir = b.addWriteFiles();
    const tcs34725_header = tcs34725_header_dir.addCopyDirectory(b.path("include"), "", .{});

    const libtcs34725_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    const libtcs34725 = b.addLibrary(.{
        .name = "tcs34725",
        .linkage = .static,
        .root_module = libtcs34725_mod,
    });
    b.installArtifact(libtcs34725);

    libtcs34725.addIncludePath(b.path("include"));
    libtcs34725.installHeadersDirectory(tcs34725_header, "", .{});

    libtcs34725.addCSourceFiles(.{
        .files = &.{"src/tcs34725.c"},
        .flags = &.{ "-Wall", "-Wextra", "-Werror", "-fPIC", "-g" },
    });
}
