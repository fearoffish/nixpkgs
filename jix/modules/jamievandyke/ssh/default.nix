{
  config,
  lib,
  pkgs,
  USER,
  DOTS,
  ...
}: {
  home-manager.users.${USER} = {
    programs.ssh = {
      enable = true;
      controlMaster = "auto";
      controlPersist = "10m";
      forwardAgent = true;
    };
    # home.file = {
    #   ".ssh/id_rsa".source = "${DOTS}/ssh/id_rsa";
    #   ".ssh/id_rsa.pub".source = ./id_rsa.pub;
    # };
  };
}
