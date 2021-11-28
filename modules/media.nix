{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    mpv
    audio-recorder
    peek
    gifski
    simplescreenrecorder
    flameshot
    screenkey
    qbittorrent
    zoom-us
  ];

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };
}
