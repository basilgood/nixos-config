{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    terminal = "xterm-256color";
    aggressiveResize = true;
    historyLimit = 500000;
    resizeAmount = 5;
    escapeTime = 0;
    mouse = true;
    shortcut = "Space";
    plugins = with pkgs.tmuxPlugins; [catppuccin];
    extraConfig = ''
      unbind C-b
      bind-key \\ split-window -h -c "#{pane_current_path}"
      bind-key - split-window -v -c "#{pane_current_path}"
      bind-key c new-window -c "#{pane_current_path}"
      bind-key -T copy-mode 'v' send-keys -X begin-selection
      bind-key -r g display-popup -d '#{pane_current_path}' -w80% -h80% -E lazygit
      set -gq allow-passthrough on
      set -ga terminal-overrides ",*col*:Tc"
      set -g set-titles on
      set -g renumber-windows on
      set -g focus-events on
      set -g detach-on-destroy off
      set -g @catppuccin_flavour 'mocha'
    '';
  };
  home.packages = [pkgs.smug];
}
