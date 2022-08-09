{
  config,
  lib,
  pkgs,
  USER,
  DOTS,
  ...
}: {
  home-manager.users.${USER} = {
    programs.git = {
      enable = true;
      userEmail = "me@fearof.fish";
      userName = "Jamie van Dyke";
      signing = {
        key = "C89DD29350A9E797";
        signByDefault = false;
      };
      delta = {
        enable = true;
        options = {
          navigate = true;
          line-numbers = true;
          side-by-side = false;
          syntax-theme = "GitHub";
        };
      };
      ignores = [ ".DS_Store" "*.swp" ".overcommit.yml" ];
      includes = [
        {
          path = "/Users/C5343288/SAPDevelop/.gitconfig-work";
          condition = "gitdir:/Users/C5343288/SAPDevelop/";
        }
      ];
      extraConfig = {
        init = {defaultBranch = "main";};
        pager.difftool = true;
        diff.tool = "difftastic";
        difftool.prompt = false;
        difftool.difftastic.cmd = "${pkgs.difftastic}/bin/difft $LOCAL $REMOTE";

        merge.tool = "Kaleidoscope";
        mergetool.Kaleidoscope.cmd = "/usr/local/bin/ksdiff --merge --output \"$MERGED\" --base \"$BASE\" -- \"$LOCAL\" --snapshot \"$REMOTE\" --snapshot";
        mergetool.trustExitCode = true;

        github.user = "fearoffish";
        gitlab.user = "fearoffish";
      };
      aliases = {
        # View abbreviated SHA, description, and history graph of the latest 20 commits
        l = "log --pretty=oneline -n 20 --graph --abbrev-commit";

        # View the current working tree status using the short format
        s = "status -s";

        # Show the diff between the latest commit and the current state
        d = "!\"git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat\"";

        # `git di $number` shows the diff between the state `$number` revisions ago and the current state
        di = "!\"d() { git diff --patch-with-stat HEAD~$1; }; git diff-index --quiet HEAD -- || clear; d\"";

        # Color graph log view
        graph = "log --graph --color --pretty=format:\"%C(yellow)%H%C(green)%d%C(reset)%n%x20%cd%n%x20%cn%x20(%ce)%n%x20%s%n\"";

        # submodules update and init recursive
        suri = "submodule update --init --recursive --force";
        # submodules update with merge
        supdate = "submodule update --remote --merge";

        # diff with submodules
        sdiff = "'!'\"git diff && git submodule foreach 'git diff'\"";

        # push with submodules
        spush = "push --recurse-submodules=on-demand";
      };
    };
  };
}
