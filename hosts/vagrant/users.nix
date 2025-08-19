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
    hashedPasswordFile = "/etc/nixos/secrets/passwords/vagrant/hashed_password";
    home            = "/home/vagrant";
    createHome      = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1YdxBpNlzxDqfJyw/QKow1F+wvG9hXGoqiysfJOn5Y vagrant insecure public key"
    ];
    isNormalUser = true;
  };
  users.users.root = { password = "vagrant"; };
}
