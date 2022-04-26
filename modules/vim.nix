{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    (
      symlinkJoin {
        name = "vim-with-config";
        nativeBuildInputs = [ makeWrapper ];
        paths = [
          (vim_configurable.overrideAttrs (oldAttrs: rec {
            version = "8.2.4774";
            src = fetchFromGitHub {
              owner = "vim";
              repo = "vim";
              rev = "v${version}";
              sha256 = "sha256-XHuzhT6wgjEl7cprkIANGN5LE0cjZbu4VEQ5Zrdpnk4=";
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
            rnix-lsp
            yamllint
            deno
            nodejs
            ]}
        '';
      }
    )
  ];
}
