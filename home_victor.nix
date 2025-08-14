{ config, pkgs, victorVimConfig, ... }:

{
  home.stateVersion = "25.05";
  # Définition de base du profil utilisateur
  home.username = "victor";
  home.homeDirectory = "/home/victor";

  # Paquets utilisateur à installer
  home.packages = with pkgs; [
    vim
    zsh
    glances
    nmap
  ];

  home.file.".vim/autoload/plug.vim".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim";
    sha256 = "sha256-wtiZhGmgSaUSJacRKKEpF7N5gi0WtjlJPinqAth4cwY=";
  };


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
  home.file.".vimrc".source = victorVimConfig;
  #home.file = {
  #  ".vimrc".text = ''
  #    set number
  #    syntax on
  #  '';
  #};
}

