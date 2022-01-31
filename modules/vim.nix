{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    (
      symlinkJoin {
        name = "vim-with-config";
        nativeBuildInputs = [ makeWrapper ];
        paths = [
          (vim_configurable.override { python = python3; })
        ];
        postBuild = ''
          wrapProgram $out/bin/vim --prefix PATH : ${lib.makeBinPath [ nodePackages.jsonlint deno nodejs shfmt nixpkgs-fmt statix ]}
        '';
      }
    )
  ];
}
