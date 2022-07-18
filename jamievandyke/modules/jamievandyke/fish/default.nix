{
  config,
  lib,
  pkgs,
  jix,
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
        # Magit
        ms = "mg SPC g g";
        # status
        mc = "mg SPC g / c";
        # commit
        md = "mg SPC g / d u";
        # diff unstaged
        ml = "mg SPC g / l l";
        tig = "mg SPC g / l l";
        # log
        mr = "mg SPC g / r i";
        # rebase interactive
        mz = "mg SPC g / Z l";
        # list stash
      };
      interactiveShellInit = ''
        set -g fish_key_bindings fish_hybrid_key_bindings
        direnv hook fish | source
      '';
      functions = {
        jix-activate.description = "Activate a new jix system generation";
        jix-activate.body = "nix run /a/git/jix";
        jix-shell.description = "Run nix shell with jix's nixpkgs";
        jix-shell.body = "nix shell --inputs-from $HOME/.nix-out/nixpkgs";
        jix-nixpkg-search.description = "Nix search on jix's nixpkgs input";
        jix-nixpkg-search.body = "nix search --inputs-from $HOME/.nix-out/jix nixpkgs $argv";
        rg-jix-inputs.description = "Search on jix flake inputs";
        rg-jix-inputs.body = let
          maybeFlakePaths = f:
            if builtins.hasAttr "inputs" f
            then flakePaths f
            else [];
          flakePaths = flake:
            [flake.outPath]
            ++ lib.flatten
            (lib.mapAttrsToList (_: maybeFlakePaths) flake.inputs);
          paths = builtins.concatStringsSep " " (flakePaths jix);
        in "rg $argv ${paths}";
        rg-jix.description = "Search on current jix";
        rg-jix.body = "rg $argv $HOME/.nix-out/jix";
        rg-nixpkgs.description = "Search on current nixpkgs";
        rg-nixpkgs.body = "rg $argv $HOME/.nix-out/nixpkgs";
        rg-home-manager.description = "Search on current home-manager";
        rg-home-manager.body = "rg $argv $HOME/.nix-out/home-manager";
        rg-nix-darwin.description = "Search on current nix-darwin";
        rg-nix-darwin.body = "rg $argv $HOME/.nix-out/nix-darwin";
        nixos-opt.description = "Open a browser on search.nixos.org for options";
        nixos-opt.body = ''
          open "https://search.nixos.org/options?sort=relevance&query=$argv"'';
        nixos-pkg.description = "Open a browser on search.nixos.org for packages";
        nixos-pkg.body = ''
          open "https://search.nixos.org/packages?sort=relevance&query=$argv"'';
        repology-nixpkgs.description = "Open a browser on search for nixpkgs on repology.org";
        repology-nixpkgs.body = ''
          open "https://repology.org/projects/?inrepo=nix_unstable&search=$argv"'';
      };
      plugins =
        map jix.lib.nivFishPlugin ["pure" "done" "fzf.fish" "pisces" "z"];
    };
    home.file = {
      ".local/share/fish/fish_history".source = "${DOTS}/fish/fish_history";
    };
  };
}
