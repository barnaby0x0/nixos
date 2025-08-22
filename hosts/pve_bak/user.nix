{ config, pkgs, ... }:

{
  users.groups.user = {
      name = "user";
      members = [ "user" ];
    };
  
  users.users.user = {
      createHome = true;
      description = "Main User";
      extraGroups     = [ "networkmanager" "user" "wheel" "docker" ];
      group = "user";
      home = "/home/user";
      hashedPassword = "$6$8J7uSW3tvJF5MQ9g$RLio5MYDfkWRyGW2FUBJcC6dklX.0BVNlp1pdLi0uGayp0o.0pnxKtSaYWZvDe1rr4bGbgjVerUy5LvK2vkaZ0";
      isNormalUser = true;
      shell = pkgs.zsh;
      packages = with pkgs; [
        glances
        home-manager
      ];
    };

}