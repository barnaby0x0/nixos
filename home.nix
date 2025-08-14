{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";
  # Définition de base du profil utilisateur
  home.username = "vagrant";
  home.homeDirectory = "/home/vagrant";

  # Paquets utilisateur à installer
  home.packages = with pkgs; [
    vim
    zsh
    glances
  ];

  # Gestionnaire de shell et configuration de l’environnement
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" ]; # example plugins
      theme = "agnoster";                  # example theme
    };
  };
  # Exemple d’activation d’un service utilisateur
#  services.git.enable = true;

  # Configuration des dotfiles (exemple simple)
  home.file = {
    ".vimrc".text = ''
      set number
      syntax on
    '';
  };

  # Options supplémentaires selon besoins...
}

