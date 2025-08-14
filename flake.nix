{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;
      systems = [ "x86_64-linux" ];  # Extensible à d'autres systèmes
      sharedArgs = {
        inherit lib;
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };

      paths = {
        k8 = {
          host = "${self}/hosts/k8";
          #config = "${self}/hosts/k8/configuration.nix";
          #user = "${self}/hosts/k8/users/user.nix";
          #vimConfig = "${self}/hosts/k8/users/user.vim.conf";
        };
        vagrant = {
          common = "${self}/hosts/common";
          config = "${self}/hosts/vagrant";
        };
      };
      
      homeManagerModule = home-manager.nixosModules.home-manager;
      homeManagerSettings = {
        users.mutableUsers = false;
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      };


    in {
      nixosConfigurations = {
        k8 = lib.nixosSystem {
          system = "x86_64-linux";
	  #modules = [paths.k8.host];
	  modules = ["${self}/hosts/k8"];
          #modules = [ 
          #  paths.k8.config
          #  paths.k8.user
          #  homeManagerModule
          #  {
          #    home-manager.extraSpecialArgs = { 
          #      userVimConfig = paths.k8.vimConfig; 
          #    };
          #  }
          #  homeManagerSettings
          #];
        };

        vagrant = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${paths.vagrant.common}/configuration.nix"
            "${paths.vagrant.common}/bootloader.nix"
            "${paths.vagrant.common}/hardware-configuration.nix"
            "${paths.vagrant.config}/vagrant-hostname.nix"
            homeManagerModule
            {
              home-manager.extraSpecialArgs = { 
                victorVimConfig = "${paths.vagrant.common}/users/victor_vim_configuration";
              };
              home-manager.users.victor = import ./home_victor.nix;
            }
            homeManagerSettings
          ];
        };

      #nixosConfigurations.vagrant = lib.nixosSystem {
      #  system = "x86_64-linux";
      #  modules = [ 
      #    "${self}/hosts/common/configuration.nix" 
      #    "${self}/hosts/common/bootloader.nix" 
      #    "${self}/hosts/common/hardware-builder.nix" 
      #    "${self}/hosts/common/custom-configuration.nix" 
      #    "${self}/hosts/common/hardware-configuration.nix" 
      #    "${self}/hosts/vagrant/vagrant-hostname.nix" 
      #    "${self}/hosts/vagrant/vagrant-network.nix" 
      #    "${self}/hosts/common/users/victor.nix" 
      #    "${self}/hosts/common/users/security.nix" 
      #    "${self}/hosts/vagrant/users/vagrant.nix" 
      #    home-manager.nixosModules.home-manager
      #    {
      #      users.mutableUsers = false;
      #      home-manager.useGlobalPkgs = true;
      #      home-manager.useUserPackages = true;
      #      home-manager.users.vagrant = ./home.nix;
      #      #home-manager.extraSpecialArgs = { self = self; };
      #      home-manager.extraSpecialArgs = { victorVimConfig = victorVimConfig; };
      #      home-manager.users.victor = ./home_victor.nix;
      #    }
      #  ];
      #};
    };
  };
}
