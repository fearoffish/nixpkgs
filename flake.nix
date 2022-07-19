# ####
## > env NIX_CONF_DIR="$PWD" nix run
{
  description = "Jamie's Nix Environment";
  inputs = {
    # change tag or commit of nixpkgs for your system
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # change main to a tag o git revision
    mk-darwin-system.url = "github:vic/mk-darwin-system/main";
    mk-darwin-system.inputs.nixpkgs.follows = "nixpkgs";

    alejandra.url = "github:kamadorueda/alejandra";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    mk-darwin-system,
    ...
  }: let
    darwinFlakeOutput = mk-darwin-system.mkDarwinSystem.m1 {
      flakePath = "/a/git/fearoffish/nixpkgs";
      modules = [
        ({
          pkgs,
          lib,
          ...
        }: {
          config._module.args = {
            jamievandyke =
              self
              // {
                lib = import ./jamievandyke/lib {
                  jamievandyke = self;
                  inherit pkgs lib;
                };
              };
          };
        })
        ./jamievandyke/modules
      ];
    };
  in
    darwinFlakeOutput
    // {
      darwinConfigurations."jamie-mbp" =
        darwinFlakeOutput.darwinConfiguration.aarch64-darwin;
    };
}
