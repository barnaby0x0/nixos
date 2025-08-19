{ config, pkgs, userVimConfig, ... }:

{
  home.stateVersion = "25.05";
  # Définition de base du profil utilisateur
  home.username = "vagrant";
  home.homeDirectory = "/home/vagrant";

  # Paquets utilisateur à installer
  home.packages = with pkgs; [];

  # Aliases
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake github:barnaby0x0/nixos#vagrant";
    };
  };
}

