{ config, pkgs, userVimConfig, ... }:

{
  home.stateVersion = "25.05";
  # Définition de base du profil utilisateur
  home.username = "user";
  home.homeDirectory = "/home/user";

  # Paquets utilisateur à installer
  home.packages = with pkgs; [
    brave
    deskflow
    glances
    nmap
    terminator
    tmux
    vim
    zsh
  ];

  #environment.systemPackages = with pkgs; [ glances ];

  home.file.".vim/autoload/plug.vim".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim";
    sha256 = "sha256-LuxOfosU4RpHmTz5euO9rGi186fel8CBQXzOPxZDK7E=";
  };

  # Gestionnaire de shell et configuration de l’environnement
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" ];
      theme = "af-magic";
    };
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake github:barnaby0x0/nixos#k8";
    };
  };
  #environment.sessionVariables.XDG_CONFIG_HOME = "${config.home.configDir}";
#  programs.matugen = {
#    enable = true;
#    configFile = "${config.xdg.configDir}/matugen/config.toml";
#  };

#  programs.ax-shell = {
#    enable = true;
#    settings = {
#      # --- General ---
#      terminalCommand = "alacritty -e";
##      wallpapersDir = "/path/to/your/wallpapers";
#
#      # --- Cursor ---
#      cursor = {
#        package = pkgs.oreo-cursors-plus;
#        name = "oreo_black_cursors";
#        size = 24;
#      };
#
#      # --- Bar & Dock ---
#      bar = {
#        position = "Top"; # "Top", "Bottom", "Left", "Right"
#        theme = "Pills";  # "Pills", "Dense", "Edge"
#      };
#      dock.enable = false; # Disable the dock
#      panel.theme = "Notch"; # "Notch", "Panel"
#
#      # --- Keybindings ---
#      keybindings.launcher = { prefix = "SUPER"; suffix = "SPACE"; };
#    };
#  };


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

