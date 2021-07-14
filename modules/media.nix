{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    mpv-with-scripts
    play-with-mpv
    feh
    zathura
    youtube-dl
  ];

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };
}
