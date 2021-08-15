{ pkgs, ... }:
{
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.neovim.configure = {
    configure = {
      customRC = ''
    '';
    packages.myVimPackage = with pkgs.vimPlugins; {
      start = [ fugitive ];
      opt = [ ];
    };
  };
  };
}

