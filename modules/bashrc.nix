{ pkgs, ... }:
{
  programs.bash = {
    shellAliases = {
      "~" = "cd ~";
      ".." = "cd ../";
      grep = "grep --color=auto";
    };
    interactiveShellInit = ''
      shopt -s autocd
      shopt -s cdspell
      shopt -s direxpand
      shopt -s histappend
      set -o notify
      bind 'set completion-ignore-case on'
      bind 'set completion-map-case on'
      bind 'set show-all-if-ambiguous on'
      bind 'set menu-complete-display-prefix on'
      bind 'set mark-symlinked-directories on'
      bind 'set colored-stats on'
      bind 'set visible-stats on'
      bind 'set page-completions off'
      bind 'set skip-completed-text on'
      bind 'set bell-style none'
      bind 'Tab: menu-complete'
      bind '"\e[Z": menu-complete-backward'
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'
      bind '"\e[3;5~":kill-word'
      bind '"\C-h": backward-kill-word'
      HISTCONTROL=erasedups
      HISTSIZE=-1
      HISTFILESIZE=-1
      HISTIGNORE="&:[ ]*:exit:l:ls:ll:bg:fg:history*:clear:kill*:?:??"
      update_history() {
        history -a
        exec {history_lock}<"$HISTFILE" && flock -x $history_lock
        sed 's/[[:space:]]*$//' $HISTFILE | tac | awk '!x[$0]++' | tac | ${pkgs.moreutils}/bin/sponge $HISTFILE
        flock -u $history_lock && unset history_lock
      }
      PROMPT_COMMAND="update_history; $PROMPT_COMMAND"
      eval "$(${ pkgs.starship }/bin/starship init bash)"
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
      stty -ixon
    '';
  };

}
