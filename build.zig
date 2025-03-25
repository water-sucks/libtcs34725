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

    const src_dir = try fs.cwd().openDir("src", .{ .iterate = true });
    var src_iter = src_dir.iterate();

    const common_c_flags = &.{ "-Wall", "-Wextra", "-Werror", "-fPIC", "-g" };

    while (try src_iter.next()) |entry| {
        if (mem.endsWith(u8, entry.name, ".c")) {
            const src_file = b.fmt("{s}/{s}", .{ "src", entry.name });
            libtcs34725.addCSourceFiles(.{
                .files = &.{src_file},
                .flags = common_c_flags,
            });
        }
    }
}
