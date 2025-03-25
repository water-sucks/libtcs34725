{
  description = "bruh";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    tcs34725.url = ../.;
  };

  outputs = inputs @ {
    flake-parts,
    tcs34725,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        libtcs34725 = tcs34725.packages.${system}.default;
      in {
        packages = let
          example = pkgs.callPackage ./package.nix {inherit libtcs34725;};
        in {
          inherit example;
          default = example;
        };

        devShells.default = pkgs.mkShell {
          name = "tcs34725-shell";

          buildInputs = with pkgs; [
            gnumake
            gcc

            bear
            pkg-config

            libtcs34725

            zig
          ];
        };
      };
    };
}
