{ config, pkgs, ... }:

{
	users.groups.vagrant = {
    name = "vagrant";
    members = [ "vagrant" ];
  };

	users.users.vagrant = {
    description     = "Vagrant User";
    name            = "vagrant";
    group           = "vagrant";
    extraGroups     = [ "users" "wheel" ];
    hashedPassword = "$6$w9lAKhDffJKvNdCv$1aXZQa0Ha29huB15mOp4.k1269gjh/G7aDqJNep7IJzJxz/5A.DzHOGIRFyRXNnbOqgtGwQYQEkdcA/zVaSUs.";
    home            = "/home/vagrant";
    createHome      = true;
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1YdxBpNlzxDqfJyw/QKow1F+wvG9hXGoqiysfJOn5Y vagrant insecure public key"
    ];
    isNormalUser = true;
  };
  users.users.root = { 
    hashedPassword = "$6$w9lAKhDffJKvNdCv$1aXZQa0Ha29huB15mOp4.k1269gjh/G7aDqJNep7IJzJxz/5A.DzHOGIRFyRXNnbOqgtGwQYQEkdcA/zVaSUs.";
  };

  home-manager.users.vagrant = import ../../home/user/vagrant.home.nix;
}
