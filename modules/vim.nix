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
          wrapProgram $out/bin/vim --prefix PATH : ${lib.makeBinPath [
            nodejs
            nodePackages.typescript-language-server
            nodePackages.jsonlint
            shfmt
            shellcheck
            rnix-lsp
            efm-langserver
            vim-vint
            nixpkgs-fmt
            statix
            yamllint
            deno
          ]}
        '';
      }
    )
  ];
}
