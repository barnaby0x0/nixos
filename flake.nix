{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   disko ={
     url = "github:nix-community/disko";
     inputs.nixpkgs.follows = "nixpkgs";
   };
  };

  outputs = { self, nixpkgs, home-manager, disko, ... } @ inputs:
    let
      lib = nixpkgs.lib;
      systems = [ "x86_64-linux" ];
      sharedArgs = {
        inherit lib;
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };

      paths = {
        k8test = {
          host = "${self}/hosts/k8test";
        };
        k8 = {
          host = "${self}/hosts/k8";
        };
        vagrant = {
          host = "${self}/hosts/vagrant";
        };
        pve = {
          host = "${self}/hosts/pve";
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

        k8test = lib.nixosSystem {
          system = "x86_64-linux";
	        modules = [
            paths.k8test.host
            disko.nixosModules.disko
            homeManagerModule
            {
              home-manager.extraSpecialArgs = {};
            }
            homeManagerSettings
          ];
        };

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
            {
              #nixpkgs.config.allowUnfree = true;
              nixpkgs.config.allowUnfreePredicate = pkg: 
                builtins.elem (lib.getName pkg) ["vscode"];
            }
            homeManagerModule
            {
              home-manager.extraSpecialArgs = {};
            }
            homeManagerSettings
          ];
        };
        
        pve = lib.nixosSystem {
          system = "x86_64-linux";
	        modules = [
            paths.pve.host
          ];
        };
    };
  };
}
