{ fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "volnoti-dbus";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "jbonachera";
    repo = "volnoti-dbus";
    rev = "v${version}";
    sha256 = "sha256-NyOVi0DAl4BGBIg5mFnDaYuaskCglZChpjzQEKGsc5o=";
  };

  vendorSha256 = "sha256-eNRAGtU3n69QmuYLTM9bnSgOCsg9qUBkP1jSe6Ai08s=";

  doCheck = false;
}
