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
          asdf-vm
          autoconf # Broadly used tool, no clue what it does
          # awscli2 # Amazon Web Services CLI
          bash # /bin/bash
          bat
          # bosh-cli # cli for cloudfoundry bosh
          bottom # istat menus on the cli
          # broot
          # buildpack # Cloud Native buildpacks
          # bundix # for bundling gems into nix
          # cargo # rust language
          # cheat # a cheat sheet lookup tool
          # credhub-cli
          curl # An old classic
          difftastic
          direnv # Per-directory environment variables
          # dstp # run common networking tests against your site
          exa # ls replacement written in Rust
          # expect # automatic shell responses
          fd # find replacement written in Rust
          # FirefoxDevApp
          fish
          fzf # Fuzzy finder
          gh # github cli
          git # git maybe?
          git-branchless # git undo and more
          git-extras # useful git extra stuff
          git-lfs
          gitAndTools.delta
          gitui
          gmp
          # google-cloud-sdk # Google Cloud Platform CLI
          # gping
          # graphviz # dot
          heroku
          # htop # Resource monitoring
          # httpie # Like curl but more user friendlyq
          # Iterm2App
          jq # JSON parsing for the CLI
          # k9s # k8s tui
          # KeybaseApp
          # KeyttyApp
          # kubectl # Kubernetes CLI tool
          # kubectx # kubectl context switching
          # kubernetes-helm # Kubernetes package manager
          # kustomize
          lazygit # nice tui for git
          # libnotify # for those sweet sweet notifications
          libxml2
          # lua5 # My second-favorite language from Brazil
          lzma
          # m-cli # handy macos cli for managing macos stuff
          # mdcat # Markdown converter/reader for the CLI
          # ncdu # a great large file and folder finder with a tui to help cleanup stuffs
          neovim # you can move, but there is no escape
          niv # Nix dependency management
          # pass
          pinentry_mac # Necessary for GPG
          podman # Docker alternative
          qemu # emulator
          re2c # regex compiler
          ripgrep # grep replacement written in Rust
          ripgrep-all
          rnix-lsp # nix language server
          rustc # rust language
          rustfmt # rust language
          # safe # a vault cli
          sd # Fancy sed replacement
          skim # High-powered fuzzy finder written in Rust
          tealdeer # tldr for various shell tools
          # tig
          tmux # cli window manager
          # TunnelblickApp
          viddy # a modern watch
          VimMotionApp
          wget
          # xh
          # xsv
          # yq # yaml processor like jq
          zoxide
        ]
        ++ podmans;
      # bash = [ shfmt shellcheck ];
      nix = [niv nixfmt alejandra];
    in {inherit jamievandyke nix;};
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
