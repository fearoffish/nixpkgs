{
  config,
  pkgs,
  lib,
  vix,
  ...
}: {
  nixpkgs.overlays = [
    (self: super: {
      # See https://github.com/NixOS/nixpkgs/pull/129543/files
      neovim = super.neovim-unwrapped;
      leader = vix.lib.nivGoAutoMod "leader";
      xbarApp = vix.lib.nivApp "xbar";
      VimMotionApp = vix.lib.nivApp "VimMotion";
      KeyttyApp = vix.lib.nivApp "Keytty";
      IdeaApp = vix.lib.nivApp "Idea";
      KeybaseApp = vix.lib.nivApp "Keybase";
      FirefoxDevApp = vix.lib.nivApp "FirefoxDev";
      TunnelblickApp = vix.lib.nivApp "Tunnelblick";
      Postgres12App = vix.lib.nivApp "Postgres12";
      PosticoApp = with pkgs;
        stdenvNoCC.mkDerivation {
          buildInputs = [unzip];
          name = "Postico";
          version = vix.lib.nivSources.PosticoApp.version;
          src = vix.lib.nivSources.PosticoApp;
          phases = ["install"];
          install = ''
            mkdir -p $out/Applications/
            unzip $src -d $out/Applications/
          '';
        };
      Iterm2App =
        pkgs.stdenvNoCC.mkDerivation
        (let
          src = vix.lib.nivSources."Iterm2App";
        in {
          name = "Iterm2";
          version = src.version;
          inherit src;
          phases = ["install"];
          install = ''
            mkdir -p $out
            ${pkgs.unzip}/bin/unzip $src -d $out/Applications
          '';
        });
      alejandra = vix.inputs.alejandra.defaultPackage.${config.nixpkgs.system};
      
      # kdash = pkgs.stdenvNoCC.mkDerivation (let
      #   src = vix.lib.nivSources.kdash;
      # in {
      #   name = "kdash";
      #   inherit (src) version;
      #   inherit src;
      #   phases = ["install"];
      #   install = ''
      #     mkdir -p $out/bin
      #     cp $src $out/bin/kdash
      #   '';
      # });
    })
  ];
}
