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
      stty -ixon
      HISTCONTROL=erasedups
      HISTSIZE=-1
      HISTFILESIZE=-1
      HISTIGNORE="&:[ ]*:exit:l:ls:ll:bg:fg:history*:clear:kill*:?:??"
      hm() {
        sed 's/[[:space:]]*$//' $HISTFILE | tac | awk '!x[$0]++' | tac | ${pkgs.moreutils}/bin/sponge $HISTFILE
      }
      PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
      if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
        . ${pkgs.fzf}/share/fzf/completion.bash
        . ${pkgs.fzf}/share/fzf/key-bindings.bash
        . ${pkgs.git}/share/git/contrib/completion/git-completion.bash
      fi
      export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'
      bind -x '"\C-r": history -n; __fzf_history__'
      function br {
        f=$(mktemp)
        (
          set +e
          broot --outcmd "$f" "$@"
          code=$?
          if [ "$code" != 0 ]; then
              rm -f "$f"
              exit "$code"
          fi
        )
        code=$?
        if [ "$code" != 0 ]; then
          return "$code"
        fi
        d=$(cat "$f")
        rm -f "$f"
        eval "$d"
      }
      eval "$(${ pkgs.starship }/bin/starship init bash)"
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };

}
