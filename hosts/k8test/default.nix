{ modulesPath, config, pkgs, ... }:

{
  imports = [
    ../commons/users/user
    ../../modules/steam-config.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disk-config.nix
    # Ajouts spécifiques pour GMKtec K8 Plus
    # (modulesPath + "/profiles/hardware/cpu/amd.nix")
    # (modulesPath + "/profiles/hardware/gpu/amd.nix")
    # (modulesPath + "/profiles/all-hardware.nix")
  ];

  # Bootloader.

   boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  };  

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "virtiofs" ];

  networking.hostName = "k8"; # Define your hostname.
  networking.hosts = {
    "10.10.0.93" = [ "ull" ];
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  fileSystems."/home/user/Workspace" = {
    device = "10.10.0.72:/Workspace";
    fsType = "nfs";
    options = [
      "defaults"
      "nofail"
      "x-systemd.device-timeout=9"
      "proto=tcp"
      "port=2049"
    ];
  };


  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  hardware.bluetooth.enable = true;


  ## HARDWARE CONFIGURATION FOR GMKtec K8 Plus ##
  
  # # Pour le processeur AMD Ryzen
  # hardware.cpu.amd.updateMicrocode = true;
  
  # # Pour le GPU Radeon intégré
  # hardware.opengl = {
  #   enable = true;
  #   driSupport = true;
  #   extraPackages = with pkgs; [
  #     amdvlk
  #     rocm-opencl-icd
  #     rocm-opencl-runtime
  #   ];
  # };
  
  # # Optimisations pour SSD NVMe
  # boot.kernelParams = [ "nvme_core.default_ps_max_latency_us=0" ];
  
  # # Gestion de l'énergie
  # powerManagement.cpuFreqGovernor = "ondemand";
  
  # # Support WiFi/BT (si présent)
  # hardware.enableRedistributableFirmware = true;
  # hardware.firmware = [ pkgs.linux-firmware ];
  
  # # Pilotes pour les chipsets courants
  # boot.initrd.availableKernelModules = [
  #   "nvme"
  #   "xhci_pci"
  #   "ahci"
  #   "usbhid"
  #   "usb_storage"
  #   "sd_mod"
  #   "rtsx_pci_sdmmc"  # Pour lecteur carte SD si présent
  # ];

  #hardware.bluetooth.powerOnBoot = true;
  
  # services.power-profiles-daemon.enable = true;
  # security.polkit.extraConfig = ''
  #   polkit.addRule(function(action, subject) {
  #     if (action.id == "org.freedesktop.UPower.PowerProfiles.switch-profile") {
  #       return polkit.Result.YES;
  #     }
  #   });
  # '';

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
   # settings = {
   #   General = {
   #     LoginTimeoutSec = 15;
   #     MinimumUid = 1000;
   #     MaximumUid = 65000;
   #   };
   # };
  };

  users.users.user.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDpfkycNGYPLEXjSzQLpkRKIIHOfReD71oazZhESkBC8 user@vagrant"];
  users.users.root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDpfkycNGYPLEXjSzQLpkRKIIHOfReD71oazZhESkBC8 user@vagrant"];

  services.desktopManager.plasma6.enable = true;

  # Exclude kwallet
  security.pam.services.sddm.kwallet.enable = false;
  security.pam.services.login.kwallet.enable = pkgs.lib.mkForce false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    qt6.qtwayland
    findutils
    git
    gnumake
    htop
    iputils
    jq
    netcat
    nettools
    nfs-utils
    rsync
    tmux
    vim
    zsh
    lm_sensors
  ];

  programs.vim.defaultEditor = true;

  environment.variables = {
    QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

  xdg.portal.enable = true;
  programs.zsh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    #enableSSHSupport = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };

  programs.virt-manager.enable = true;
  virtualisation.docker.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 
    24800 #deskflow
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  environment.etc."current-system-packages".text =
  let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

