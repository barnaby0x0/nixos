{ config, pkgs, ... }:

{
  users.groups.user = {
      name = "user";
      members = [ "user" ];
    };
  
  users.users.user = {
      createHome = true;
      description = "Main User";
      extraGroups     = [ "users" "wheel" ];
      group = "user";
      home = "/home/user";
      useDefaultShell = true;
      hashedPasswordFile = "/etc/nixos/secrets/passwords/user/hashed_password";
      isNormalUser = true;
      shell = pkgs.zsh;
    };
}

