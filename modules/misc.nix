{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    firefox
    element-desktop
    thunderbird
    libreoffice
    peek
    gifski
    vokoscreen
    anydesk
    vnote
    broot
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
