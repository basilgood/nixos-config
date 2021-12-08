{ fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "arcli";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "mightymatth";
    repo = "arcli";
    rev = "v${version}";
    sha256 = "sha256-Gc2NJLHF/KAQqTN4wHBt1eORKgZmmOu5deYNsa/mI7w=";
  };

  vendorSha256 = "sha256-sw3bw0EI1nlptjABSzRMi8pSI3df1tLgCtDUXFMqtPs=";

  doCheck = false;

  # postInstall = ''
  #   mv $out/bin/main $out/bin/arcli
  # '';
}
