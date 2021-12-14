{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    (
      symlinkJoin {
        name = "nvim-with-config";
        buildInputs = [ makeWrapper ];
        paths = [
          neovim-unwrapped
          shfmt
          vim-vint
          nixpkgs-fmt
          statix
          stylua
          gcc
        ];
        postBuild = ''
          wrapProgram "$out/bin/nvim"
          makeWrapper ${nodePackages.typescript-language-server}/bin/typescript-language-server $out/bin/typescript-language-server
          makeWrapper ${nodePackages.prettier}/bin/prettier $out/bin/prettier
        '';
      }
    )
  ];
}
