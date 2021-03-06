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
    };
  };
}
