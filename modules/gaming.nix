# ./modules/gaming.nix
{ config, lib, pkgs, ... }:

with lib; {
  options.gaming = {
    enable = mkEnableOption "Enable gaming configuration";

    steam = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Steam and related features";
      };
      
      gamescopeSession = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Gamescope session for Steam Big Picture";
      };
    };

    gamemode.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Feral GameMode optimizations";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional gaming-related packages";
    };
  };

  config = let
    cfg = config.gaming;
  in mkIf cfg.enable {
    programs.steam = {
      enable = cfg.steam.enable;
      gamescopeSession.enable = cfg.steam.gamescopeSession;
    };

    programs.gamemode.enable = cfg.gamemode.enable;

    environment.systemPackages = with pkgs; [
      protonup-qt
    ] ++ cfg.extraPackages;
  };
}
