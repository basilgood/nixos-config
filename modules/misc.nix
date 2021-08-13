{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    alacritty
    firefox
    element-desktop
    thunderbird
    libreoffice
    peek
    gifski
    vokoscreen
    anydesk
    vnote
    kotatogram-desktop
    keepassxc
    (pkgs.chromium.override {
      commandLineArgs = lib.intersperse " " ([
        "--ignore-gpu-blacklist"
        "--enable-gpu-rasterization"
        "--use-gl=desktop"
        "--enable-accelerated-video-decode"
        "--enable-features=VaapiVideoDecoder"
      ]);
    })
  ];
}
