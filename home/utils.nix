_: {
  programs.eza = {
    enable = true;
    extraOptions = [
      "--group-directories-first"
    ];
  };
  programs.ripgrep.enable = true;
  programs.ripgrep.arguments = ["--pretty"];
  programs.fzf.enable = true;
  programs.fzf.defaultOptions = [
    "--height 40%"
    "--layout=reverse"
    "--ansi"
  ];
  programs.fzf.defaultCommand = "fd -tf -L -H -E=.git -E=node_modules --strip-cwd-prefix";
  programs.fzf.tmux.enableShellIntegration = true;
  programs.direnv.enable = true;
  programs.bat = {
    enable = true;
    # config.theme = "TwoDark";
  };
  programs.btop = {
    enable = true;
  };
}
