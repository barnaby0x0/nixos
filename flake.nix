{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      lib = nixpkgs.lib;
      systems = [ "x86_64-linux" ];
      sharedArgs = {
        inherit lib;
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };

      paths = {
        k8 = {
          host = "${self}/hosts/k8";
        };
        vagrant = {
          host = "${self}/hosts/vagrant";
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
	        modules = [
            paths.k8.host
            homeManagerModule
            {
              home-manager.extraSpecialArgs = {};
            }
            homeManagerSettings
          ];
        };

        vagrant = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            paths.vagrant.host
            #nixpkgs.config.allowUnfree = true;
            
            nixpkgs.config.allowUnfreePredicate = pkg: 
              builtins.elem (lib.getName pkg) ["vscode"];
            homeManagerModule
            {
              home-manager.extraSpecialArgs = {};
            }
            homeManagerSettings
          ];
        };
    };
  };
}
