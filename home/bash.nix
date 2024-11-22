{pkgs, ...}: {
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        grep = "grep --color=auto";
        lt = "${pkgs.tree}/bin/tree -L 1";
        hm = "sed 's/[[:space:]]*$//' $HISTFILE | tac | awk '!x[$0]++' | tac | ${pkgs.moreutils}/bin/sponge $HISTFILE";
        b = "${pkgs.bartib}/bin/bartib -f ~/.bartib";
        ns = "nh os switch -H liberty ~/Projects/dots/";
        nc = "nh clean all";
      };
      historySize = -1;
      historyFileSize = -1;
      historyControl = ["ignoredups" "erasedups"];
      historyIgnore = ["l" "ls" "ll" "lt" "cd" "rm" "rm rf" "hm" "yt" "exit" "history" "kill" "pkill" "fg" "bg" "mpv" "aria2c" "yazi"];
      shellOptions = ["nocaseglob" "autocd" "dirspell" "cdspell" "cmdhist" "histappend"];
      initExtra = ''
        set -o notify
        bind "set completion-ignore-case on"
        bind "set completion-map-case on"
        bind "set show-all-if-ambiguous on"
        bind "set menu-complete-display-prefix on"
        bind "set mark-symlinked-directories on"
        bind "set colored-stats on"
        bind "set visible-stats on"
        bind "set page-completions off"
        bind "set skip-completed-text on"
        bind "set bell-style none"
        bind 'TAB':menu-complete
        bind '"\e[Z": menu-complete-backward'
        bind '"\e[A": history-search-backward'
        bind '"\e[B": history-search-forward'
        bind '"\C-h": backward-kill-word'
        stty -ixon
      '';

      sessionVariables = {
        VLC_PLUGIN_PATH = "${pkgs.vlc-bittorrent}";
      };
    };

    starship = {
      enable = true;
      settings = {
        format = "$character$jobs$directory$git_branch$git_status$nix_shell \n› ";
        character = {
          format = "$symbol";
          error_symbol = "[  ](bold fg:red bg:#19172C)";
          success_symbol = "[  ](bold fg:green bg:#19172C)";
        };

        directory = {
          format = "[   $path ](bg:#2D2B40 fg:bright-white)[](fg:#2D2B40)";
        };

        git_branch = {
          format = "[  $branch ](fg:bright-white)";
        };

        jobs = {
          symbol = " 󰠜 ";
          style = "bright-white";
        };

        hostname = {
          ssh_only = true;
          format = "[ $hostname ](italic fg:bright-white bg:#19172C)";
        };

        nix_shell = {
          format = " [❄ $state( \($name\))](bold blue)";
        };

      };
    };
  };
}
