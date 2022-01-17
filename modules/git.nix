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
    lazygit = "lazygit -ucf ${ ../assets/config.yml }";
  };

  users.users.vasy.packages = with pkgs; [
    delta
    icdiff
    lazygit
    tig
  ];
}
