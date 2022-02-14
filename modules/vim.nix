{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    (
      symlinkJoin {
        name = "vim-with-config";
        nativeBuildInputs = [ makeWrapper ];
        paths = [
          ((vim_configurable.override { python = python3; }).overrideAttrs (oldAttrs: rec {
            version = "8.2.4375";
            src = fetchFromGitHub {
              owner = "vim";
              repo = "vim";
              rev = "v${version}";
              sha256 = "sha256-e+3PpCr9HSd9glTNKBbsxWjO9f/yQGre/b3/+TBxdyc=";
            };
          }))
        ];
        postBuild = ''
          wrapProgram $out/bin/vim --prefix PATH : ${lib.makeBinPath [
            nodejs
            nodePackages.jsonlint
            shfmt
            shellcheck
            rnix-lsp
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
