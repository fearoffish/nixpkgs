# ####
## > env NIX_CONF_DIR="$PWD" nix run
{
  description = "Jamie's Nix Environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/ce6aa13369b667ac2542593170993504932eb836";
    # change tag or commit of nixpkgs for your system
    mk-darwin-system.url = "github:vic/mk-darwin-system/main"; # change main to a tag o git revision
    # mk-darwin-system.url = "path:/hk/mkDarwinSystem";

    # development mode
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
      flakePath = "/a/git/jix";
      modules = [
        ({
          pkgs,
          lib,
          ...
        }: {
          config._module.args = {
            jix =
              self
              // {
                lib = import ./jix/lib {
                  jix = self;
                  inherit pkgs lib;
                };
              };
          };
        })
        ./jix/modules
      ];
    };
  in
    darwinFlakeOutput
    // {
      darwinConfigurations."jamie-mbp" =
        darwinFlakeOutput.darwinConfiguration.aarch64-darwin;
    };
}
