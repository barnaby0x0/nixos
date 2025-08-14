# steam-config.nix
{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    # STABILITY
    # gamescopeSession.enable = true;
  };

  # STABILITY
  # programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    protonup-qt
  ];


  hardware.graphics = {
    enable = true;               # Remplace hardware.opengl.enable
    enable32Bit = true;          # Remplace driSupport32Bit
    extraPackages = with pkgs; [ # Remplace hardware.opengl.extraPackages
      amdvlk
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      amdvlk
    ];
  };

  # STABILITY
  # environment.variables = {
  #   AMD_VULKAN_ICD = "RADV";  # Préfère le pilote open-source RADV

  # Optimisations gaming
  #  RADV_PERFTEST = "gpl,rt";  # Active Geometry Pipeline + Ray Tracing
    #VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  # };
  #services.xserver.desktopManager.runXdgAutostartIfNone = false;
}
