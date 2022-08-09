{
  config,
  lib,
  pkgs,
  jamievandyke,
  USER,
  DOTS,
  ...
}: {
  home-manager.users.${USER} = {
    programs.fzf.enable = true;
    programs.fzf.enableFishIntegration = true;
    programs.fish = {
      enable = true;
      shellAliases = {
        l = "exa -l";
        ll = "exa -l -@ --git";
        tree = "exa -T";
        # "." = "exa -g";
        ".." = "cd ..";
      };
      shellAbbrs = {
        ls = "exa";
        top = "btm";
        cat = "bat";
        grep = "rg";
        find = "fd";
        nr = "nix run";
        nf = "fd --glob '*.nix' -X nixfmt {}";
        gr = "git recents";
        gc = "git commit";
        gb = "git branch";
        gd = "git dff";
        gs = "git status";
        gco = "git checkout";
        gcb = "git checkout -b";
        gp = "git pull --rebase --no-commit";
        gz = "git stash";
        gza = "git stash apply";
        gfp = "git push --force-with-lease";
        gfap = "git fetch --all -p";
        groh = "git rebase remotes/origin/HEAD";
        grih = "git rebase -i remotes/origin/HEAD";
        grom = "git rebase remotes/origin/master";
        grim = "git rebase -i remotes/origin/master";
        gpfh = "git push --force-with-lease origin HEAD";
        gfix = "git commit --all --fixup amend:HEAD";
        gcm = "git commit --all --message";
        ga = "git commit --amend --reuse-message HEAD --all";
        gcam = "git commit --amend --all --message";
        gbDm = "git rm-merged";
      };
      interactiveShellInit = ''
        set -g fish_key_bindings fish_hybrid_key_bindings
        set -xg RUBY_CFLAGS "-w"
        set -xg OPENSSL_CFLAGS "-Wno-error=implicit-function-declaration"
        direnv hook fish | source
      '';
      functions = {
        # jvd-activate.description = "Activate a new jvd system generation";
        # jvd-activate.body = "nix run /a/git/fearoffish/nixpkgs";
        # jvd-shell.description = "Run nix shell with jvd's nixpkgs";
        # jvd-shell.body = "nix shell --inputs-from $HOME/.nix-out/nixpkgs";
        # jvd-nixpkg-search.description = "Nix search on jvd's nixpkgs input";
        # jvd-nixpkg-search.body = "nix search --inputs-from $HOME/.nix-out/jvd nixpkgs $argv";
        # rg-jvd-inputs.description = "Search on jvd flake inputs";
        # rg-jvd-inputs.body = let
        #   maybeFlakePaths = f:
        #     if builtins.hasAttr "inputs" f
        #     then flakePaths f
        #     else [];
        #   flakePaths = flake:
        #     [flake.outPath]
        #     ++ lib.flatten
        #     (lib.mapAttrsToList (_: maybeFlakePaths) flake.inputs);
        #   paths = builtins.concatStringsSep " " (flakePaths jamievandyke);
        # in "rg $argv ${paths}";
        # rg-jvd.description = "Search on current jvd";
        # rg-jvd.body = "rg $argv $HOME/.nix-out/jvd";
        # rg-nixpkgs.description = "Search on current nixpkgs";
        # rg-nixpkgs.body = "rg $argv $HOME/.nix-out/nixpkgs";
        nsearch.description = "Search on current home-manager";
        nsearch.body = "rg $argv $HOME/.nix-out/home-manager";
        # rg-nix-darwin.description = "Search on current nix-darwin";
        # rg-nix-darwin.body = "rg $argv $HOME/.nix-out/nix-darwin";
        # nixos-opt.description = "Open a browser on search.nixos.org for options";
        # nixos-opt.body = ''
        #   open "https://search.nixos.org/options?sort=relevance&query=$argv"'';
        # nixos-pkg.description = "Open a browser on search.nixos.org for packages";
        # nixos-pkg.body = ''
        #   open "https://search.nixos.org/packages?sort=relevance&query=$argv"'';
        # repology-nixpkgs.description = "Open a browser on search for nixpkgs on repology.org";
        # repology-nixpkgs.body = ''
        #   open "https://repology.org/projects/?inrepo=nix_unstable&search=$argv"'';
      };
      plugins =
        map jamievandyke.lib.nivFishPlugin ["pure" "done" "fzf.fish" "pisces"];
    };
    programs.bat = {
      enable = true;
      config = {
        theme = "GitHub";
        italic-text = "always";
      };
    };

    programs.direnv = {
      enable = true;
      # enableFishIntegration = true; # This is automatic so unnecessary
      enableZshIntegration = true;
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      settings = {
        command_timeout = 2000;
        format = "$username$hostname$shlvl$vcsh$directory$git_branch$git_commit$git_state$git_metrics$git_status$nix_shell$custom$cmd_duration$line_break$jobs$time$status$shell$character";
      };
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    xdg = {
      enable = true;

      # configFile."gnupg/gpg-agent.conf".text = ''
      #   enable-ssh-support
      #   default-cache-ttl 86400
      #   max-cache-ttl 86400
      #   pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
      # '';
    };

    home.file = {
      # ".local/share/fish/fish_history".source = "${DOTS}/fish/fish_history";
    };
  };
}
