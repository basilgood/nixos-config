{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    firefox
    element-desktop
    thunderbird
    libreoffice
    keepassxc
    (pkgs.chromium.override {
      commandLineArgs = lib.intersperse " " ([
        "--password-store=basic"
        "--ignore-gpu-blacklist"
        "--enable-gpu-rasterization"
        "--use-gl=desktop"
        "--enable-accelerated-video-decode"
        "--enable-features=VaapiVideoDecoder"
      ]);
    })
  ];
}
