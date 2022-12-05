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
      EmacsApp = (jamievandyke.lib.nivApp "Emacs").overrideAttrs (old: let
        bin_dir =
          {
            "aarch64-darwin" = "bin-arm64-*/";
          }
          .${config.nixpkgs.system}
          or "bin-x86_64-*/";
      in {
        installPhase = ''
          ${old.installPhase}
          mkdir -p $out/bin
          ln -s $out/Applications/Emacs.app/Contents/Resources/{etc,man,info} $out/
          ln -s $out/Applications/Emacs.app/Contents/MacOS/${bin_dir} $out/bin
          ln -s $out/Applications/Emacs.app/Contents/MacOS/Emacs $out/bin/emacs
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
