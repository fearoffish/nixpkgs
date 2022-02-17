{
  description = "Minimal mkDarwinSystem example";

  inputs = {
    # change tag or commit of nixpkgs for your system
    nixpkgs.url = "github:nixos/nixpkgs/21.11";

    # change main to a tag o git revision
    mk-darwin-system.url = "github:fearoffish/mk-darwin-system/main";
    mk-darwin-system.inputs.nixpkgs.follows = "nixpkgs";

    # nix formatter
    alejandra.url = "github:kamadorueda/alejandra";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, mk-darwin-system, ... }:
    let
      darwinFlakeOutput = mk-darwin-system.mkDarwinSystem.m1 {

        # Provide your nix modules to enable configurations on your system.
        #
        modules = [
          ({ config, pkgs, ... }: {
            environment.systemPackages = with pkgs; [ nixfmt ];
          })

          # for configurable home-manager modules see:
          # https://github.com/nix-community/home-manager/blob/master/modules/modules.nix
          {
            home-manager = {
              # sharedModules = []; # per-user modules.
              # extraSpecialArgs = {}; # pass aditional arguments to all modules.
            };
          }

          # An example of user environment. Change your username.
          ({ pkgs, lib, ... }: {
            home-manager.users."jamievandyke" = {

              home.packages = with pkgs; [ 
                bottom
                exa 
                bat
                fzf
                ripgrep
                tig
                git
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
            #nixpkgs.overlays =
            #  [ (self: super: { inherit (lib.mds.intelPkgs) pandoc; }) ];

            # You can enable supported services (if they work on arm and are not linux only)
            #services.lorri.enable = true;
          })

        ];
      };
    in darwinFlakeOutput // {
      # Your custom flake output here.
      darwinConfigurations."jamie-mbp" =
        darwinFlakeOutput.darwinConfiguration.aarch64-darwin;
    };
}
