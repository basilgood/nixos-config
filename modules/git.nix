{ pkgs, ... }:
{
  programs.git.enable = true;
  programs.git.config = {
    user.name = "Luta Vasile";
    user.email = "elsile69@yahoo.com";
    core.editor = "vim";
    init.defaultBranch = "main";
    merge.conflictStyle = "diff3";
  };
  programs.bash.shellAliases = {
    glog = "git log --graph --all --pretty=format:'%C(240)%h %Cred%d %C(244)%cr%n %C(240)%an - %C(244)%s%n'";
  };

  users.users.vasy.packages = with pkgs; [
    delta
    icdiff
    tig
    (
      let config = ''
        gui:
          theme:
            lightTheme: false
            activeBorderColor:
              - blue
              - bold
            inactiveBorderColor:
              - black
              - bold
            optionsTextColor:
              - blue
            selectedLineBgColor:
              - reverse
              - black
            selectedRangeBgColor:
              - blue
            cherryPickedCommitBgColor:
              - blue
            cherryPickedCommitFgColor:
              - cyan
        git:
          paging:
            colorArg: always
            useConfig: false
            pager: delta --paging=never --24-bit-color=never --diff-so-fancy
        keybinding:
          universal:
            undo: Z
      '';
      in
      symlinkJoin {
        name = "lazygit-with-config";
        buildInputs = [ makeWrapper ];
        paths = [ lazygit ];
        postBuild = ''
          wrapProgram "$out/bin/lazygit" \
          --add-flags "--use-config-file ${writeText "config" config}"
        '';
      }
    )
  ];
}
