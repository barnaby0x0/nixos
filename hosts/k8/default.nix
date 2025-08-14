{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../commons/users/user
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.initrd.checkJournalingFS = false;

  networking.hostName = "k8";
  # Services to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.extraConfig =
    ''
      PubkeyAcceptedKeyTypes +ssh-rsa
    '';

  # Enable DBus
  services.dbus.enable    = true;

  # Replace ntpd by timesyncd
  services.timesyncd.enable = true;
  
  environment.systemPackages = with pkgs; [
    findutils
    git
    gnumake
    htop
    iputils
    jq
    netcat
    nettools
    nfs-utils
    rsync
    tmux
    vim
    zsh
  ];

  programs.zsh.enable = true;

  security.sudo.extraConfig =
    ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
      Defaults env_keep+=SSH_AUTH_SOCK
      Defaults lecture = never
      root   ALL=(ALL) SETENV: ALL
      %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
    '';

}

