{pkgs, ...}: {
  programs = {
    mpv = {
      enable = true;
      config = {
        ytdl-format = "bestvideo+bestaudio";
      };
      scripts = [
        pkgs.mpvScripts.uosc
      ];
      bindings = {
        "Alt+0" = "set window-scale 0.5";
        "F3" = "cycle keepaspect";
        "F4" = "cycle-values panscan 1 0";
        "F10" = "cycle-values video-rotate 90 180 270 0";
      };
    };
    # obs-studio = {
    #   enable = true;
    #   plugins = [pkgs.obs-studio-plugins.wlrobs];
    # };
  };
}
