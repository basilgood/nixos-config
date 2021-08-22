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

      set-option -wg mode-style bg="#706c27",fg="#000000"
      set-option -g status-style bg=terminal,fg="#a89984"
      set-option -wg window-status-style bg="#000000",fg="#7c6f64"
      set-option -wg window-status-activity-style bg="#000000",fg="brightred"
      set-option -wg window-status-bell-style bg="#000000",fg="#706c27"
      set-option -wg window-status-current-style bg="#706c27",fg="#000000"
      set-option -g pane-active-border-style fg="#706c27"
      set-option -g pane-border-style fg="#000000"
      set-option -g message-style bg="#706c27",fg="#000000"
      set-option -g message-command-style bg="#a89984",fg="#000000"
      set-option -g display-panes-active-colour "#706c27"
      set-option -g display-panes-colour "#3C3836"
      set-option -g status-left ""
      set-option -g status-right "#[bg=#a89984, fg=#000000]#{?client_prefix,#[bg=#706c27],#[bg=#a89984]} #h"
    '';
  };
}
