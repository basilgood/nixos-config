{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      cantarell-fonts
      noto-fonts
      (nerdfonts.override { fonts = [ "IBMPlexMono" "JetBrainsMono" "DejaVuSansMono" ]; })
    ];
  };
}
