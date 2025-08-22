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
    hashedPassword = "$6$D7M0zSnb5nDkhkRU$492h3gwtIHjhwj863MGVhFzPolG1Q7VtOuKbyGaoXKv7EO2M5wv4LJuJh3VpICXIegAKI/uiHQXiepYqKuivn.";
    home            = "/home/user";
    createHome      = true;
    shell = pkgs.bash;
    isNormalUser = true;
  };
  users.users.root = { 
    hashedPassword = "$6$D7M0zSnb5nDkhkRU$492h3gwtIHjhwj863MGVhFzPolG1Q7VtOuKbyGaoXKv7EO2M5wv4LJuJh3VpICXIegAKI/uiHQXiepYqKuivn.";
  };

  # home-manager.users.vagrant = import ../../home/user/vagrant.home.nix;
}
