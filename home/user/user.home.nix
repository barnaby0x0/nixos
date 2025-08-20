{ config, pkgs, userVimConfig, ... }:

{
  home.stateVersion = "25.05";
  # Définition de base du profil utilisateur
  home.username = "user";
  home.homeDirectory = "/home/user";

  # Paquets utilisateur à installer
  home.packages = with pkgs; [
    vim
    zsh
    glances
    nmap
    tmux
    vscode
    terminator
    brave
    deskflow
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
      theme = "crunch";                  # example theme
    };
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake github:barnaby0x0/nixos#k8";
    };
  };

  # Configuration des dotfiles (exemple simple)
  home.file.".vimrc".source = ./user.vim;
  home.file.".config/terminator/config".source = ./config.terminator;
  home.file.".tmux.conf".source = ./tmux.conf;
  home = {
    file = {
        ".config/autostart/steam.desktop".text = ''
          [Desktop Entry]
          Name=Steam
          Exec=steam -nochatui -nofriendsui -silent
          Icon=steam
          Terminal=false
          Type=Application
          Categories=Network;FileTransfer;Game;
          MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
          Actions=Store;Community;Library;Servers;Screenshots;News;Settings;BigPicture;Friends;
          PrefersNonDefaultGPU=true
          X-KDE-RunOnDiscreteGpu=true
        '';
    };
  };
}

