{ pkgs, ... }: {
  users.users.vasy.packages = with pkgs;
    [
      (symlinkJoin {
        name = "nvim-with-config";
        buildInputs = [ makeWrapper ];
        paths = [ neovim-unwrapped ];
        postBuild = ''
          wrapProgram $out/bin/nvim --prefix PATH : ${
            lib.makeBinPath [
              shfmt
              vim-vint
              statix
              nixfmt
              stylua
              lua53Packages.luacheck
              yamllint
              gcc
              rnix-lsp
              nodePackages.typescript-language-server
              nodePackages.prettier
            ]
          }
        '';
      })
    ];
}
