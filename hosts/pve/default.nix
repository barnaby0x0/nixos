{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./hardware-builder.nix
      ./bootloader.nix
      ./custom-configuration.nix
      ./users.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # remove the fsck that runs at startup. It will always fail to run, stopping
  # your boot until you press *.
  boot.initrd.checkJournalingFS = false;

  networking.hostName = "nixos";
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
  
  ## Minimal setup to make it works with Vagrant next to this build
  # Minimal configuration for NFS support with Vagrant.
  #services.nfs.server.enable = true;
  
  ## Add firewall exception for VirtualBox provider 
  #networking.firewall.extraCommands = ''
  #  ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
  #'';

  ## Add firewall exception for libvirt provider when using NFSv4 
  #networking.firewall.interfaces."virbr1" = {                                   
  #  allowedTCPPorts = [ 2049 ];                                               
  #  allowedUDPPorts = [ 2049 ];                                               
  #};  
  services.qemuGuestAgent.enable = true;
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
  users.mutableUsers = false;
  users.users.root = { 
    hashedPassword = "$6$D7M0zSnb5nDkhkRU$492h3gwtIHjhwj863MGVhFzPolG1Q7VtOuKbyGaoXKv7EO2M5wv4LJuJh3VpICXIegAKI/uiHQXiepYqKuivn.";
  };
  #users.users.vagrant.shell = pkgs.zsh;

  # security.sudo.extraConfig =
  #   ''
  #     Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
  #     Defaults:root,%wheel env_keep+=NIX_PATH
  #     Defaults:root,%wheel env_keep+=TERMINFO_DIRS
  #     Defaults env_keep+=SSH_AUTH_SOCK
  #     Defaults lecture = never
  #     root   ALL=(ALL) SETENV: ALL
  #     %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
  #   '';

}

