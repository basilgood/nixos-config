{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "bartib";
  version = "f1b60e80ce04b7fd073becd9b9a78e656a179de3";

  src = fetchFromGitHub {
    owner = "nikolassv";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-cK5Z6QbypRrIxfSLBWn1MVkfbPnjmxfdvKi0VS56ryg=";
  };

  doCheck = false;
  cargoSha256 = "sha256-+uPsyOBtz0F6i3yBoFfKaawcCTZr+YJgPjUNYwwbZVk=";
}
