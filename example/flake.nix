{
  description = "CSC-615 Assignment 5 - TCS34725 color sensor C library";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      perSystem = {pkgs, ...}: {
        packages = let
          tcs34725 = pkgs.callPackage (import ./package.nix) {};

          example = pkgs.callPackage (import ./examples) {libtcs34725 = tcs34725;};
        in {
          inherit tcs34725 example;
          default = tcs34725;
        };

        devShells.default = pkgs.mkShell {
          name = "tcs34725-shell";
          buildInputs = with pkgs; [
            gnumake
            gcc

            bear
            pkg-config
          ];
        };
      };
    };
}
