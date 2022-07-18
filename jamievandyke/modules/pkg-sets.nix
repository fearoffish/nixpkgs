{
  config,
  pkgs,
  lib,
  ...
}: {
  options = with lib; {
    pkgSets = mkOption {
      type = types.attrsOf (types.listOf types.package);
      default = {};
      description = "Package sets";
    };
  };
  config = {
    pkgSets = with pkgs; let
      # System level packages
      podmans = [
        # for podman docker
        podman
        qemu
        xz
        gvproxy
      ];
      # Home level packages
      jamievandyke =
        [
          difftastic
          direnv
          bottom
          #xbarApp
          FirefoxDevApp
          KeybaseApp
          Iterm2App
          IdeaApp
          TunnelblickApp
          VimMotionApp
          KeyttyApp
          PosticoApp
          #leader
          pass
          # git-annex
          gping
          xsv
          broot
          htop
          gitAndTools.delta
          gitui
          k9s
          # hyperfine
          xh
          # fetch things
          bat
          # better cat
          # browsh # Firefox on shell
          exa
          # alias ls
          fd
          # alias find
          fish
          # thanks for all the fish
          fzf
          # ctrl+r history
          git-lfs
          # large binary files in git
          jq
          # query json
          ripgrep
          # grep faster
          ripgrep-all
          # rg faster grep on many file types
          tig
          # terminal git ui
          # victor-mono # fontz ligatures
          # tor-browser-bundle-bin # darkz web
          # beaker-browser # p2p geocities
          # firefox-devedition-bin # firefox with dev nicities
          # iterm2 # terminal
          # flux # late programming
          # pock # make touchbar useful
          # keybase # secure comms
          # jetbrains.idea-community # just to follow linked libs
          # nodePackages.hyp # hyperspace://
          git
          # work around patches
          # neovim # you can move, but there is no escape
        ]
        ++ podmans;
      # bash = [ shfmt shellcheck ];
      nix = [niv nixfmt alejandra];
    in {inherit oeiuwq vic scala gleam_dev nix;};
    nixpkgs.overlays = [
      (new: old: {
        pkgShells =
          lib.mapAttrs (name: packages: new.mkShell {inherit name packages;})
          config.pkgSets;
        pkgSets =
          lib.mapAttrs (name: paths: new.buildEnv {inherit name paths;})
          config.pkgSets;
      })
    ];
  };
}
