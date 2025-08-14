{ config, pkgs, ... }:

{
  users.groups.security = {
      name = "security";
      members = [ "security" ];
    };
  
  users.users.security = {
      createHome = true;
      description = "Security user agent";
      group = "security";
      home = "/home/security";
      useDefaultShell = true;
      password = "toor";
      #hashedPasswordFile = "/etc/nixos/secrets/passwords/victor/hashed_password";
      isNormalUser = true;
      shell = pkgs.bash;
      packages = [
        pkgs.nmap
      ];
    };
}

