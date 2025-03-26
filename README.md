# CSC-615-RGB-Sensor (libtcs34725)

A library to interact with the
[TCS34725 RGB sensor](https://www.adafruit.com/product/1334), primarily intended
for usage with general-purpose computers such as the Raspberry Pi.

## Installation

**NOTE: This is a Linux-only library that relies on an I2C interface. Prefer
using and/or developing this on Linux hosts.**

There are a few ways to install this for local development: a `Makefile`, using
Zig, or using Nix.

### Makefile

Run `make install` to create both dynamic and static libraries.

`PREFIX` can be used to change the install location, like below:

```
make PREFIX=/usr install
```

This will also install `pkg-config` files for usage in a Makefile or with other
`pkg-config`-compliant systems. There are two that are provided, one for dynamic
linking, and the other for static linking. Currently, static linking is only
supported on `musl` targets.

In order to use `pkg-config` properly, refer to the [Usage](#Usage) section.

### Nix

A [Nix](https://nixos.org) derivation is also available as a flake package.

An example with a basic development shell:

```
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    tcs34725.url = "github:water-sucks/libtcs34725";
    tcs34725.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {tcs34725, ...}@inputs: let
    pkgs = nixpkgs.legacyPackages.aarch64-linux;

    libtcs34725 = tcs34725.packages.aarch64-linux.default;
  in {
    devShells.aarch64-linux.default = pkgs.mkShell {
      name = "tcs34725-example-shell";
      buildInputs = [
        gnumake
        gcc

        libtcs34725
        pkg-config
      ];
    };
  };
}
```

This will automatically set up the `pkg-config` discovery variables, which will
enable the usage of a normal Makefile as provided in the Makefile example.

An example derivation is provided in the
[example directory](./example/package.nix). This package is exposed in this
repository's flake as well, and can be built with `nix build .#example`.

## Usage

### Makefile

An example is provided in the [example directory](./example/Makefile).

If installed in a local directory separate from the system libraries in `/usr`
or `/usr/local`, use the `PKG_CONFIG_PATH` environment variable to change this.
Finding the library can be verified by using `pkg-config --modversion tcs34725`.

```
export PKG_CONFIG_PATH=/path/to/tcs34725/install/prefix/lib/pkgconfig:$PKG_CONFIG_PATH
```

Verify that this library can be discovered using
`pkg-config --modversion tcs34725`.

### Zig

Importing this library as a [Zig](https://ziglang.org) dependency is explicitly
supported through the `build.zig.zon` package manifest.

Prefer using Zig when cross-compiling; using Zig also allows for purely static
building. It is not possible to link against `glibc` statically when using Zig,
so prefer the `linux-musl` targets when doing this.

An example `build.zig` is provided in the
[example directory](./example/build.zig) that can be built with `zig build`.

To cross-compile the provided example, provide the target as a build option:

```
zig build -Dtarget=aarch64-linux-musl
```

Using the `musl` target will ensure static compilation for easy copying between
development and target machines. Using a `gnu` target in order to link `glibc`
is possible, but take care to make sure that the proper `glibc` location exists
on the target system, and make sure to use the proper linkage variable for the
`libtcs34725` dependency.

If installed system-wide, the `linkSystemLibrary("tcs34725")` function can be
used. This will use `pkg-config` to find the library. This is preferred if using
`glibc` as the linked `libc`.

### Nix

Refer to the [example Nix derivation](./examples/package.nix) mentioned prior.

## Assignment Description

This is a group assignment.

This is a physical class, so I will want to see what you do in action.
Documentation, including short video clips (can use your phone) are required as
part of the submission. It might be handy to have a friend record while you
execute your program.

You will also need to submit hardware drawings. These should be neat (can be
either electronic or hand drawn, then scanned) of how the hardware is connected
to the Raspberry Pi. This includes which pin (physical and GPIO), positive and
negative flow, resistors, etc. I should be able to rebuild your setup from this
diagram and then run your program and get the same results. Also see
https://www.circuit-diagram.org/editor/# if you want to use that (they have a
Raspberry Pi template).

This project is to get the RGB sensor working and properly detecting colors.

This is a group project.

It should be designed as a library/module that can be easily included in another
project.

The main program should call the necessary functions and output should be BOTH
an RGB value set (in hex) and a color name (color can be approximated with a
confidence value).

The code should be as concise as possible and well documented.

The writeup should not only contain the normal sections but for the analysis
section should include a "Use section" that describes how to use the library.
