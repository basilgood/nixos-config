{ buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "act";
  version = "0.1.7";

  goPackagePath = "github.com/gumieri/act";

  # subPackages = [ "." ];
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "gumieri";
    repo = "act";
    rev = "v${version}";
    sha256 = "sha256-QW0yifGjA7q//uh/Txao8RqOn5TBlq9JmyBvJ54jfcs=";
  };
}
