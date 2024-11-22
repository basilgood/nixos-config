_: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "basilgood";
    userEmail = "elsile69@yahoo.com";
    extraConfig = {
      core.editor = "nvim";
      init.defaultBranch = "master";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        diff-so-fancy = true;
      };
    };
  };

  programs.lazygit = {
    enable = true;

    settings = {
      gui = {
        nerdFontsVersion = "3";
      };
      customCommands = [
        {
          command = "git fetch --all --tags --prune --prune-tags";
          context = "global";
          key = "F";
          showOutput = true;
        }
      ];
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never";
      };
      keybinding = {
        universal = {
          undo = "Z";
        };
      };
    };
  };
}
