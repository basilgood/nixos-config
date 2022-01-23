{ pkgs, inputs, ... }:
{
  programs.bash = {
    shellAliases =
      {
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
      if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
        . ${pkgs.fzf}/share/fzf/completion.bash
        . ${pkgs.fzf}/share/fzf/key-bindings.bash
        . ${pkgs.git}/share/git/contrib/completion/git-completion.bash
      fi
      export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'
      bind -x '"\C-r": history -n; __fzf_history__'
      eval "$(${pkgs.z-lua}/bin/z.lua --init bash enhanced once fzf)"
    '';
    promptInit = ''
      RED="\033[31m"
      YELLOW="\033[33m"
      BLUE="\033[34m"
      GREEN="\033[32m"
      RST="\[\e[0m\]"
      PROMPT='➞'
      JOBS='✦ '
      NIX='❄ '
      CONTINUED='↪︎'
      AHEAD='⇡'
      BEHIND='⇣'
      DIRTY='٭'
      STAGED='+'
      UNTRACKED='?'
      STASH='≡'
      function jobs_module {
        jobsval=$(jobs -p | wc -l)
        [ $jobsval -ne 0 ] && echo " "$YELLOW$JOBS$RST
      }
      function git_module {
        local meta
        # branch name
        local ref=$(git symbolic-ref --short HEAD 2>/dev/null)
        # tag name or hash
        [[ -n "$ref" ]] && ref=$ref || ref=$(git describe --tags --always 2>/dev/null)
        local status="$(git status --porcelain -b 2>/dev/null)"
        [[ $status =~ ([[:cntrl:]][A-Z][A-Z\ ]\ ) ]] && meta+=$STAGED
        [[ $status =~ ([[:cntrl:]][A-Z\ ][A-Z]\ ) ]] && meta+=$DIRTY
        [[ $status =~ ([[:cntrl:]]\?\?\ ) ]] && meta+=$UNTRACKED
        [[ $status =~ ahead\ ([0-9]+) ]] && meta+=$AHEAD''${BASH_REMATCH[1]}
        [[ $status =~ behind\ ([0-9]+) ]] && meta+=$BEHIND''${BASH_REMATCH[1]}
        [[ -e "$PWD/.git/refs/stash" ]] && meta+=$STASH
        echo " "$GREEN$ref" "$RED$meta$RST
      }
      function nix_module {
        [ -n "$IN_NIX_SHELL" ] && echo " "$BLUE$NIX$RST
      }
      function dir_module {
        echo $BLUE'\W'$RST
      }
      function end_module {
        echo $PROMPT" "$RST
      }
      function set_bash_prompt {
        PS1='\n'$(dir_module)$(git_module)$(jobs_module)$(nix_module)
        PS1+='\n'$(end_module)
        PS2=$CONTINUED$RST
      }
      PROMPT_COMMAND='history -a; set_bash_prompt'
      bash_history_file=$(mktemp "$USER"_bash_historyXXXXXX)
      awk 'NR == FNR { a[$0]++; next; }; ++b[$0] == a[$0]' \
        "$HOME/.bash_history" "$HOME/.bash_history" > "$bash_history_file"
      mv "$bash_history_file" "$HOME/.bash_history"
      unset bash_history_file
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };

}
