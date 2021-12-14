{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    brave
    google-chrome
    element-desktop
    thunderbird
    libreoffice
    anydesk
    vnote
    broot
    tdesktop
    keepassxc
    (pkgs.chromium.override {
      commandLineArgs = lib.intersperse " " [
        "--ignore-gpu-blacklist"
        "--enable-gpu-rasterization"
        "--use-gl=desktop"
        "--enable-accelerated-video-decode"
        "--enable-features=VaapiVideoDecoder"
      ];
    })
  ];
}
