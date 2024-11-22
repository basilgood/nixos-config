{
  pkgs,
  inputs,
  ...
}: {
  programs = {
    neovim = {
      enable = true;
      package = inputs.neovim-nightly.packages."x86_64-linux".neovim;
      extraLuaPackages = ps: [ps.magick];
      extraPackages = with pkgs; [
        nixd
        nixfmt-rfc-style
        statix
        vscode-langservers-extracted
        shfmt
        yamllint
        jq
        fixjson
        gcc
        imagemagick
      ];
    };
  };
}
