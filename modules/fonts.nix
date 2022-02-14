{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      cantarell_fonts
      noto-fonts
      (nerdfonts.override { fonts = [ "IBMPlexMono" "DejaVuSansMono" ]; })
    ];
  };
}
