{ ... }:
{
  programs.tmux = {
    enable = true;
    shortcut = "Space";
    baseIndex = 1;
    terminal = "xterm-256color";
    aggressiveResize = true;
    historyLimit = 500000;
    resizeAmount = 5;
    escapeTime = 0;
    extraConfig = ''
      bind | split-window -h -c "#{pane_current_path}"
      bind "\\" split-window -fh -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind "_" split-window -fv -c "#{pane_current_path}"
      bind "c" new-window -c "#{pane_current_path}"
      bind C-p previous-window
      bind C-n next-window
      bind -r "<" swap-window -d -t -1
      bind -r ">" swap-window -d -t +1
      bind -r K resize-pane -U 5
      bind -r J resize-pane -D 5
      bind -r H resize-pane -L 5
      bind -r L resize-pane -R 5
      bind-key -T copy-mode C-y send-keys -X begin-selection

      set -ga terminal-overrides ",*col*:Tc"
      set-window-option -g automatic-rename on
      set-option -g set-titles on
      set-option -g renumber-windows on
      set-window-option -g xterm-keys on
      set -g focus-events on
      setw -g mouse on
      setw -g monitor-activity on

      set -g status-style fg=#81A1C1,bg=#3B4252
      set-window-option -ga window-status-activity-style fg=#3B4252,bg=#D08770
      set-option -g status-left ""
      set -g status-right " #{?client_prefix,🤗,😊} "
      set -g window-status-current-format "#[bg=#4C566A] #F#I:#W#F "
      set -g window-status-format " #F#I:#W#F "
    '';
  };
}
