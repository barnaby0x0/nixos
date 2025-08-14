{ config, pkgs, ... }:

{
  users.groups.victor = {
      name = "victor";
      members = [ "victor" ];
    };
  
  users.users.victor = {
      createHome = true;
      description = "Victor B. User";
      extraGroups     = [ "users" "wheel" ];
      group = "victor";
      home = "/home/victor";
      useDefaultShell = true;
      hashedPasswordFile = "/etc/nixos/secrets/passwords/victor/hashed_password";
      isNormalUser = true;
      shell = pkgs.zsh;
    };
}

