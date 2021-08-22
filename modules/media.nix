{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    smplayer
    mpv-with-scripts
    play-with-mpv
    feh
    zathura
    youtube-dl
    audio-recorder
    peek
    gifski
    vokoscreen
  ];

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };
}
