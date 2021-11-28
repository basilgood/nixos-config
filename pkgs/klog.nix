{ fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "klog";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "jotaen";
    repo = "klog";
    rev = "v${version}";
    sha256 = "sha256-640BWGfiGWCLwgntbNbjxFeFQfJLLnVS1gpKaPD+SZM=";
  };

  vendorSha256 = "sha256-2VYWhNSJOX/r6r2VISDJ8fP34hmk5upIQPHDoKdKCnM=";

  doCheck = false;

  postInstall = ''
    mv $out/bin/main $out/bin/klog
  '';
}
