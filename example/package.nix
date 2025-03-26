{
  stdenv,
  pkg-config,
  libtcs34725,
}:
stdenv.mkDerivation {
  pname = "tcs34725-example";
  version = "0.1.0";
  src = ./.;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libtcs34725
  ];

  makeFlags = ["PREFIX=$(out)"];
}
