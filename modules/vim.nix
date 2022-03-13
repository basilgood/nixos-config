{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    (
      symlinkJoin {
        name = "vim-with-config";
        nativeBuildInputs = [ makeWrapper ];
        paths = [
          ((vim_configurable.override { python = python3; }).overrideAttrs (oldAttrs: rec {
            version = "8.2.4664";
            src = fetchFromGitHub {
              owner = "vim";
              repo = "vim";
              rev = "v${version}";
              sha256 = "sha256-v0jub3bwyPS8OehU+md+TCF+YUW94UPHiXRbMWqoiF8=";
            };
          }))
        ];
        postBuild = ''
          wrapProgram $out/bin/vim --prefix PATH : ${lib.makeBinPath [
            nodePackages.jsonlint
            shfmt
            shellcheck
            vim-vint
            nixpkgs-fmt
            statix
            yamllint
            deno
            nodejs
          ]}
        '';
      }
    )
  ];
}
