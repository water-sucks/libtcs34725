{
  lib,
  stdenv,
  nix-gitignore,
}:
stdenv.mkDerivation {
  pname = "libtcs34725";
  version = "0.1.0";

  src = nix-gitignore.gitignoreSource [] ./.;

  makeFlags = ["PREFIX=$(out)"];

  meta = {
    description = "A library for the TCS34725 color sensor";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [water-sucks];
  };
}
