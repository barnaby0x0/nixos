{ config, pkgs, ... }:

{
	users.groups.user = {
    name = "user";
    members = [ "user" ];
  };

	users.users.user = {
    description     = "user User";
    name            = "user";
    group           = "user";
    extraGroups     = [ "users" "wheel" ];
    hashedPassword = "$6$w9lAKhDffJKvNdCv$1aXZQa0Ha29huB15mOp4.k1269gjh/G7aDqJNep7IJzJxz/5A.DzHOGIRFyRXNnbOqgtGwQYQEkdcA/zVaSUs.";
    home            = "/home/user";
    createHome      = true;
    shell = pkgs.bash;
    isNormalUser = true;
  };
  users.users.root = { 
    hashedPassword = "$6$w9lAKhDffJKvNdCv$1aXZQa0Ha29huB15mOp4.k1269gjh/G7aDqJNep7IJzJxz/5A.DzHOGIRFyRXNnbOqgtGwQYQEkdcA/zVaSUs.";
  };

  # home-manager.users.vagrant = import ../../home/user/vagrant.home.nix;
}
