{ pkgs, ... }:
{
  users.users.vasy.packages = with pkgs; [
    git-brunch
    lazygit
    (symlinkJoin {
      name = "git-custom";
      paths = [ git ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/git \
          --set-default GIT_AUTHOR_NAME 'Vasile Luta' \
          --set-default GIT_AUTHOR_EMAIL 'elsile69@yahoo.com' \
          --set-default GIT_COMMITTER_NAME 'Vasile Luta' \
          --set-default GIT_COMMITTER_EMAIL 'elsile69@yahoo.com'
      '';
    })
    (
      let
        tigrc = ''
          set main-view = \
            line-number:no,interval=5 \
            id:yes \
            author:abbreviated,width=2 \
            date:relative-compact \
            commit-title:yes,graph,refs,overflow=no
          set refs-view = \
            line-number:no \
            id:no \
            date:relative-compact \
            author:full ref commit-title

          set mouse = 1
          set mouse-scroll = 1
          set blame-options              = -C -C -C
          set show-notes                 = yes
          set show-changes               = yes
          set status-show-untracked-dirs = yes
          set refresh-mode               = periodic
          set refresh-interval           = 3
          set line-graphics              = utf-8

          color cursor                   default 237 bold
          color status                   250     235
          color title-focus              16      24  bold
          color title-blur               16      24  bold
          color id                       8   default bold
          color author                   8   default bold
          color date                     8   default bold
          color "Merge: "                cyan default
          color graph-commit             red  default

          bind generic ; none
          bind generic ;y !@sh -c "echo -n %(commit) | ${xsel}/bin/xsel --clipboard --input"
          bind generic ;s :!git status
          bind generic ;f :!git fetch --all --prune
          bind generic ;1 :!git stash
          bind generic ;! :!git stash pop
          bind generic ;p :!git push
          bind generic ;P :!git push -f
          bind generic ;ra :!git rebase --abort
          bind generic ;rc :!git rebase --continue
          bind generic ;ca :!git cherry-pick --abort
          bind generic ;cc :!git cherry-pick --continue
          bind main    > ?git rebase -i %(commit)
          bind main    ;r ?git rebase %(branch)
          bind main    ^ ?git reset --soft %(commit)
          bind main    . ?git reset --hard %(commit)
          bind status  a !?git commit --amend
          bind status  + !?git commit --amend --no-edit
        '';
      in
      symlinkJoin
        {
          name = "tig";
          buildInputs = [ makeWrapper ];
          paths = [ tig ];
          postBuild = ''
            mkdir -p $out/share/config/tig
            cp ${writeText "tigrc" tigrc} $out/share/config/tig/config
            wrapProgram "$out/bin/tig" \
            --set XDG_CONFIG_HOME "$out/share/config" \
            --set-default GIT_AUTHOR_NAME 'Vasile Luta' \
            --set-default GIT_AUTHOR_EMAIL 'elsile69@yahoo.com' \
            --set-default GIT_COMMITTER_NAME 'Vasile Luta' \
            --set-default GIT_COMMITTER_EMAIL 'elsile69@yahoo.com'
          '';
        }
    )
  ];
}
