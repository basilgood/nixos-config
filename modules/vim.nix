{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    (
      symlinkJoin {
        name = "vim-with-config";
        buildInputs = [ makeWrapper ];
        paths = [
          (vim_configurable.override { python = python3; })
          nodejs-slim
          shfmt
          vim-vint
          nixpkgs-fmt
          statix
        ];
        postBuild = ''
          wrapProgram "$out/bin/vim"
          makeWrapper ${nodePackages.typescript-language-server}/bin/typescript-language-server $out/bin/typescript-language-server
          makeWrapper ${nodePackages.prettier}/bin/prettier $out/bin/prettier
        '';
      }
    )
  ];
}
