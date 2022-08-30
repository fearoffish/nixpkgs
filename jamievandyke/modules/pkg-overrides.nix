{
  config,
  pkgs,
  lib,
  jamievandyke,
  ...
}: {
  nixpkgs.overlays = [
    (self: super: {
      leader = jamievandyke.lib.nivGoAutoMod "leader";
      xbarApp = jamievandyke.lib.nivApp "xbar";
      VimMotionApp = jamievandyke.lib.nivApp "VimMotion";
      KeyttyApp = jamievandyke.lib.nivApp "Keytty";
      KeybaseApp = jamievandyke.lib.nivApp "Keybase";
      FirefoxDevApp = jamievandyke.lib.nivApp "FirefoxDev";
      TunnelblickApp = jamievandyke.lib.nivApp "Tunnelblick";
      Iterm2App =
        pkgs.stdenvNoCC.mkDerivation
        (let
          src = jamievandyke.lib.nivSources."Iterm2App";
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
      alejandra = jamievandyke.inputs.alejandra.defaultPackage.${config.nixpkgs.system};
      # kdash = pkgs.stdenvNoCC.mkDerivation (let
      #   src = jamievandyke.lib.nivSources.kdash;
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
