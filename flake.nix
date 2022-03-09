{
  description = "Jamie's Laptop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    
    # mk-darwin-system.url = "github:fearoffish/mk-darwin-system/main";
    mk-darwin-system.url = "path:/Users/jamievandyke/a/git/fearoffish/mk-darwin-system";
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

      # TODO: Sort this
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

          ({ config, pkgs, lib, ... }: {

            home-manager.users."jamievandyke" = {
              home.username = "jamievandyke";
              # home.homeDirectory = "/Users/jamievandyke";
              # home.sessionPath = [];
              # home.sessionVariables = [];

              home.packages = with pkgs; [
                # work tool
                bosh-cli # cli for cloudfoundry bosh
                safe # a vault cli

                # general tools
                asdf-vm # version manager for all the things
                autoconf # Broadly used tool, no clue what it does
                awscli2 # Amazon Web Services CLI
                bash # /bin/bash
                bottom # istat menus on the cli
                buildpack # Cloud Native buildpacks
                bundix
                curl # An old classic
                direnv # Per-directory environment variables
                exa # ls replacement written in Rust
                fd # find replacement written in Rust
                fzf # Fuzzy finder
                gh # github cli
                git # git maybe?
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
                libnotify # for those sweet sweet notifications
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
                tealdeer # tldr for various shell tools
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
                plugins = [
                  # Need this when using Fish as a default macOS shell in order to pick
                  # up ~/.nix-profile/bin
                  {
                    name = "nix-env";
                    src = pkgs.fetchFromGitHub {
                      owner = "lilyball";
                      repo = "nix-env.fish";
                      rev = "00c6cc762427efe08ac0bd0d1b1d12048d3ca727";
                      sha256 = "1hrl22dd0aaszdanhvddvqz3aq40jp9zi2zn0v1hjnf7fx4bgpma";
                    };
                  }
                  {
                    name = "aws";
                    src = pkgs.fetchFromGitHub {
                      owner = "oh-my-fish";
                      repo = "plugin-aws";
                      rev = "a4cfb06627b20c9ffdc65620eb29abcedcc16340";
                      sha256 = "bTyp5j4VcFSntJ7mJBzERgOGGgu7ub15hy/FQcffgRE=";
                    };
                  }
                  {
                    name = "foreign-env";
                    src = pkgs.fetchFromGitHub {
                      owner = "oh-my-fish";
                      repo = "plugin-foreign-env";
                      rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
                      sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
                    };
                  }
                ];
                shellInit = ''
                  # Set syntax highlighting colours; var names defined here:
                  # http://fishshell.com/docs/current/index.html#variables-color
                  set fish_color_autosuggestion brblack
                  set -e GNUPGHOME
                  set -xg EDITOR /opt/homebrew/bin/subl
                '';
                shellAliases = {
                  rm = "rm -i";
                  cp = "cp -i";
                  mv = "mv -i";
                  mkdir = "mkdir -p";
                };
                shellAbbrs = {
                  o = "open";
                  s = "subl .";
                  n = "nix run";
                  bi = "bundle install";
                  be = "bundle exec";
                };
                functions = {
                  fish_greeting = {
                    description = "Greeting to show when starting a fish shell";
                    body = "";
                  };
                  flakify = {
                    description = "Add a flake.nix for devshell";
                    body = ''if [ ! -e flake.nix ]
                      nix flake new -t github:nix-community/nix-direnv .
                    else if [ ! -e .envrc ]
                      echo "use flake" > .envrc
                    end
                    $EDITOR flake.nix
                    direnv allow
                    '';
                  };
                  mkdcd = {
                    description = "Make a directory tree and enter it";
                    body = "mkdir -p $argv[1]; and cd $argv[1]";
                  };
                };
              };

              programs.starship = {
                enable = true;
                enableFishIntegration = true;
                enableZshIntegration = true;
              };
              
              programs.direnv.enable = true;

              programs.git = {
                enable = true;
                userEmail = "me@fearof.fish";
                userName = "Jamie van Dyke";
                signing = {
                  key = "6CBDC8C754ECEA0FDB57CE4EC89DD29350A9E797";
                  signByDefault = true;
                };
                delta = {
                  enable = true;
                  options = {
                    navigate = true;
                    line-numbers = true;
                    syntax-theme = "GitHub";
                  };
                };
                ignores = [ ".DS_Store" "*.swp" ];
                extraConfig = {
                  core = {
                    editor = "/opt/homebrew/bin/subl -w";
                  };
                  color = {
                    ui = true;
                  };
                  push = {
                    default = "simple";
                  };
                  pull = {
                    ff = "only";
                  };
                  init = {
                    defaultBranch = "main";
                  };
                  merge = {
                    log = true;
                    tool = "Kaleidoscope";
                  };
                  "difftool \"Kaleidoscope\"" = {
                    cmd = "ksdiff --partial-changeset --relative-path \"$MERGED\" -- \"$LOCAL\" \"$REMOTE\"";
                    prompt = false;
                  };
                  "mergetool \"Kaleidoscope\"" = {
                    cmd = "ksdiff --merge --output \"$MERGED\" --base \"$BASE\" -- \"$LOCAL\" --snapshot \"$REMOTE\" --snapshot";
                    trustExitCode = true;
                  };
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
                };
              };

              programs.gpg = {
                enable = true;
                settings = {
                  use-agent = true;
                };
                # publicKeys = [ { source = ./pubkeys.txt; } ];
              };

              programs.bat = {
                  enable = true;
                  config = {
                    theme = "GitHub";
                    italic-text = "always";
                  };
                };

              # create some custom dot-files on your user's home.
              # home.file.".config/foo".text = "bar";

              # Link apps installed by home-manager.
              home.activation = {
                aliasApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                  ln -sfn $genProfilePath/home-path/Applications "$HOME/Applications/HomeManagerApps"
                '';
              };
            };
          })

          # for configurable nixos modules see (note that many of them might be linux-only):
          # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/module-list.nix
          ({ config, lib, pkgs, ... }: {
            # You can enable supported services (if they work on arm and are not linux only)
            # services.lorri.enable = true;
          })

          # ({ pkgs, ...}: {
          #   # Install MacOS applications to the user environment if the targetPlatform is Darwin
          #     home.file."Applications/home-manager".source = let
          #     apps = pkgs.buildEnv {
          #       name = "home-manager-applications";
          #       paths = config.home.packages;
          #       pathsToLink = "/Applications";
          #     };
          #     in mkIf pkgs.stdenv.targetPlatform.isDarwin "${apps}/Applications";
          # })

        ];
      };
    in darwinFlakeOutput // { darwinConfigurations."jamie-mbp" = darwinFlakeOutput.darwinConfiguration.aarch64-darwin; };
}
