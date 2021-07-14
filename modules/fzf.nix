{ pkgs, ... }:
{
  programs.bash = {
    interactiveShellInit = ''
      if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
        . ${pkgs.fzf}/share/fzf/completion.bash
        . ${pkgs.fzf}/share/fzf/key-bindings.bash
        . ${pkgs.git}/share/git/contrib/completion/git-completion.bash
      fi
      export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'
      bind -x '"\C-r": history -n; __fzf_history__'
    '';
  };
}
