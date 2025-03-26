{
  description = "CSC-615 Assignment 5 - TCS34725 color sensor C library";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin"];

      perSystem = {pkgs, ...}: {
        packages = let
          libtcs34725 = pkgs.callPackage (import ./package.nix) {};
        in {
          inherit libtcs34725;
          default = libtcs34725;
        };

        devShells.default = pkgs.mkShell {
          name = "tcs34725-shell";
          buildInputs = with pkgs; [
            gnumake
            gcc

            bear
            pkg-config

            zig
          ];
        };
      };
    };
}
