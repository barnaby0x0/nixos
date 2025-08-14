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

    vulkan = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Vulkan optimizations";
      };
      
      useAMDVLK = mkOption {
        type = types.bool;
        default = false;
        description = "Use AMD official Vulkan driver instead of RADV";
      };

      enableRayTracing = mkOption {
        type = types.bool;
        default = false;
        description = "Enable experimental ray tracing support";
      };
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
    # Configuration Steam
    programs.steam = {
      enable = cfg.steam.enable;
      gamescopeSession.enable = cfg.steam.gamescopeSession;
    };

    # Configuration GameMode
    programs.gamemode.enable = cfg.gamemode.enable;

    # Configuration Vulkan/OpenGL
    hardware.opengl = mkIf cfg.vulkan.enable {
      enable = true;
      #driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        amdvlk  # Pilote Vulkan AMD officiel (optionnel)
        #rocm-opencl-icd  # Pour OpenCL/CUDA
      ];
    };

    # Variables d'environnement optimisées
    environment.variables = mkIf cfg.vulkan.enable {
      AMD_VULKAN_ICD = "RADV";
      # Force RADV comme implémentation Vulkan
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  
      # Paramètres RADV avancés
      RADV_PERFTEST = "gpl,rt";  # Active Geometry Pipeline + Ray Tracing
      DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1 = "1";  # Désactive le switching inutile
  
      # Optimisations générales
      VK_USE_PLATFORM_XCB_KHR = "1";
    };

    # Packages complémentaires
    environment.systemPackages = with pkgs; [
      protonup-qt
      vulkan-tools
      glxinfo
      clinfo
    ] ++ cfg.extraPackages;


    # Optimisations noyau pour AMD
    #boot.kernelParams = mkIf cfg.vulkan.enable [
    #  "amdgpu.ppfeaturemask=0xffffffff"
    #  "radeon.si_support=0"
    #  "amdgpu.cik_support=1"
    #];
  };
}
