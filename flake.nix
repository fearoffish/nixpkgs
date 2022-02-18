{
  description = "Minimal mkDarwinSystem example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    
    mk-darwin-system.url = "github:fearoffish/mk-darwin-system/main";
    mk-darwin-system.inputs.nixpkgs.follows = "nixpkgs";

    # nix formatter
    # alejandra.url = "github:kamadorueda/alejandra";
    # alejandra.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, mk-darwin-system, ... } @inputs:
    let
      inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

      nixpkgsConfig = {
        config = { allowUnfree = true; };
        overlays = attrValues self.overlays ++ singleton (
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            inherit (final.pkgs-x86)
              cachix # Nix build cache
              packer # HashiCorp tool for building machine images
              ;
          })
        );
      };

      imports = [
          ./modules
        ];

      darwinFlakeOutput = mk-darwin-system.mkDarwinSystem.m1 {

        modules = [
          ({ config, pkgs, ... }: {
            environment.systemPackages = with pkgs; [ nixfmt ];
          })

          {
            home-manager = {
              # sharedModules = []; # per-user modules.
              # extraSpecialArgs = {}; # pass aditional arguments to all modules.
            };
          }

          ({ pkgs, lib, ... }: {
            home-manager.users."jamievandyke" = {

              home.packages = with pkgs; [ 
                asdf-vm # version manager for all the things
                autoconf # Broadly used tool, no clue what it does
                awscli # Amazon Web Services CLI
                bash # /bin/bash
                bat # cat replacement written in Rust
                bottom # istat menus on the cli
                buildpack # Cloud Native buildpacks
                curl # An old classic
                direnv # Per-directory environment variables
                exa # ls replacement written in Rust
                fd # find replacement written in Rust
                fzf # Fuzzy finder
                gh # github cli
                git # git maybe?
                gnupg # gpg
                google-cloud-sdk # Google Cloud Platform CLI
                graphviz # dot
                htop # Resource monitoring
                httpie # Like curl but more user friendlyq
                jq # JSON parsing for the CLI
                k9s # k8s tui
                kubectl # Kubernetes CLI tool
                kubectx # kubectl context switching
                kubernetes-helm # Kubernetes package manager
                kustomize
                lorri # Easy Nix shell
                lua5 # My second-favorite language from Brazil
                m-cli # handy macos cli for managing macos stuff
                mdcat # Markdown converter/reader for the CLI
                neovim # faster vim with sane defaults
                niv # Nix dependency management
                pinentry_mac # Necessary for GPG
                podman # Docker alternative
                qemu # emulator
                ripgrep # grep replacement written in Rust
                sd # Fancy sed replacement
                skim # High-powered fuzzy finder written in Rust
                starship # Fancy shell that works with zsh
                tealdeer # tldr for various shell tools
                terraform # Declarative infrastructure management
                tig # git tui
                tmux # cli window manager
                tokei # Handy tool to see lines of code by language
                tree # Should be included in macOS but it's not
                wget
                youtube-dl # Download videos
                zoxide # directory switcher with memory
              ];

              programs.fish = {
                enable = true;
              };
              
              programs.direnv.enable = true;

              programs.git = {
                enable = true;
                userEmail = "me@fearof.fish";
                userName = "Jamie van Dyke";
                signing = {
                  key = "me@fearof.fish";
                  signByDefault = true;
                };
              };

              # create some custom dot-files on your user's home.
              # home.file.".config/foo".text = "bar";
            };
          })

          # for configurable nixos modules see (note that many of them might be linux-only):
          # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/module-list.nix
          ({ config, lib, ... }: {

            # You can provide an overlay for packages not available or that fail to compile on arm.
            # nixpkgs.overlays =
            #  [ (self: super: { 
            #   inherit (lib.mds.intelPkgs) cachix; }) ];

            # You can enable supported services (if they work on arm and are not linux only)
            # services.lorri.enable = true;
          })

        ];
      };
    in darwinFlakeOutput // { darwinConfigurations."jamie-mbp" = darwinFlakeOutput.darwinConfiguration.aarch64-darwin; };
}
