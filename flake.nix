{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;
      #pkgs = import nixpkgs { system = "x86_64-linux"; };
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      victorVimConfig = builtins.toString (self + "/hosts/common/users/victor_vim_configuration");
    in {
      imports =
      [
        (import "${home-manager}/nixos")
      ];
      nixosConfigurations.vagrant = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          "${self}/hosts/common/configuration.nix" 
          "${self}/hosts/common/bootloader.nix" 
          "${self}/hosts/common/hardware-builder.nix" 
          "${self}/hosts/common/custom-configuration.nix" 
          "${self}/hosts/common/hardware-configuration.nix" 
          "${self}/hosts/vagrant/vagrant-hostname.nix" 
          "${self}/hosts/vagrant/vagrant-network.nix" 
          "${self}/hosts/common/users/victor.nix" 
          "${self}/hosts/common/users/security.nix" 
          "${self}/hosts/vagrant/users/vagrant.nix" 
          home-manager.nixosModules.home-manager
          {
            users.mutableUsers = false;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vagrant = ./home.nix;
            #home-manager.extraSpecialArgs = { self = self; };
            home-manager.extraSpecialArgs = { victorVimConfig = victorVimConfig; };
            home-manager.users.victor = ./home_victor.nix;
          }
        ];
      };
    };
}
