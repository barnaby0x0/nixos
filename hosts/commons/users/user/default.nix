{ config, pkgs, ... }:

{
  users.groups.user = {
      name = "user";
      members = [ "user" ];
    };
  
  users.users.user = {
      createHome = true;
      description = "Main User";
      extraGroups     = [ "networkmanager" "users" "wheel" "libvirtd" "kvm" "docker" ];
      group = "user";
      home = "/home/user";
      hashedPassword = "$6$FdYq/J2XbivlPLEG$Jx7ppF65H0vj/.6/118K/d1LUFa4dyucTSk9KTSxlDhIHGH/puUDIIGNx5fcn5H7XgTHPPa.TyyaIugiLw6GF/";
      isNormalUser = true;
      shell = pkgs.zsh;
      packages = with pkgs; [
        home-manager
      ];
    };

    home-manager.users.user = import ../../../../home/user/user.home.nix;

}

