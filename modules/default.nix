{ inputs, config, lib, pkgs, ... }: {
  imports = [ ./dotfiles.nix ];

  fonts.fonts = with pkgs; [ jetbrains-mono nerdfonts ];
}
