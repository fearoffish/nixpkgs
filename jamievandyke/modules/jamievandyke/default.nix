{
  config,
  pkgs,
  lib,
  jamievandyke,
  ...
} @ args: let
  inherit (jamievandyke.inputs) mk-darwin-system nixpkgs;
  inherit (mk-darwin-system.inputs) home-manager nix-darwin;
  DOTS = lib.mds.mkOutOfStoreSymlink "/a/dots";
  # USER = builtins.getEnv "USER";
  # HOME = "/Users/${USER}";
  USER = "C5343288";
  HOME = "/Users/C5343288";
in {
  _module.args = {inherit HOME USER DOTS;};
  imports = [./git ./direnv ./ssh ./fish ./gpg];
  users.users.${USER}.home = HOME;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) ["vscode"];
  home-manager.users.${USER} = {
    programs.nix-index.enableFishIntegration = true;
    home.packages = config.pkgSets.${USER};
    home.file.".nix-out/jamievandyke".source = jamievandyke;
    home.file.".nix-out/dots".source = DOTS;
    home.file.".nix-out/nixpkgs".source = nixpkgs;
    home.file.".nix-out/nix-darwin".source = nix-darwin;
    home.file.".nix-out/home-manager".source = home-manager;
    home.activation = {
      aliasApplications = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ln -sfn $genProfilePath/home-path/Applications/* "$HOME/Applications/"
      '';
    };
  };
}
