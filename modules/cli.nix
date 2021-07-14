{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    wget
    archivemount
    unzip
    zip
    unrar
    jq
    htop
    bat
    usbutils
    bashmount
    psmisc
    parted
    fzf
    fd
    ripgrep
    lm_sensors
    nix-prefetch-scripts
    nixpkgs-fmt
    libnotify
    xsel
    direnv
  ];
}
