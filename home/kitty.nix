_: {
  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Nerd Font Mono";
      size = 16;
    };
    shellIntegration.mode = "no-cursor";
    settings = {
      term = "xterm-256color";
      scrollback_lines = 10000;
      cursor_shape = "block";
      cursor_blink_interval = 0;
      disable_ligatures = "never";
      # adjust_line_height = "110%";
    };
  };
}
