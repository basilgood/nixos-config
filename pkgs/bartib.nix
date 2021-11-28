{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "bartib";
  version = "64177d0c335f3283be50cac1b6fd62531cbaa15b";

  src = fetchFromGitHub {
    owner = "nikolassv";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-p4talrApXklsygD2f0DRV1BX/jPYTYAEKCT4hUp9hhw=";
  };

  doCheck = false;
  cargoSha256 = "sha256-sJHlkleeM0627MG4qd44QUzaEoHj901iUosymYQS9ts=";
}
