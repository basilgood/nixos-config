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

      set-option -g status-style bg=black,fg=yellow #,attr=default
      set-window-option -g window-status-style bg=default,fg=white #,attr=dim
      set-window-option -g window-status-current-style bg=default,fg=brightblue #,attr=dim
      set-window-option -g window-status-activity-style bg=black,fg=brightred
      set-option -g message-style bg=black,fg=brightred
      set-option -g display-panes-active-colour brightblue
      set-option -g display-panes-colour brightred
      set -g status-left ""
      set -g status-right "#{?client_prefix,#[fg=black]#[bg=brightblue],#[fg=brightblue]#[bg=black]} #h"
    '';
  };
  programs.bash = {
    shellAliases = {
      ".n" = "tmux new-session -d -s";
      ".r" = "tmux rename-session";
      ".k" = "tmux ls -F '#{session_name}' | fzf -m | xargs tmux kill-session -t";
      ".s" = "tmux kill-server";
      ".l" = "tmux ls -F '#{session_name}' | fzf | xargs tmux switch-client -t";
    };
  };
}
