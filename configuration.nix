{ config, pkgs, ... }:

{
  imports =
    [
      <nixos-hardware/common/pc/laptop>
      <nixos-hardware/common/pc/ssd>
      <nixos-hardware/common/cpu/amd>
      <nixos-hardware/common/gpu/amd>
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.configurationLimit = 3;
    kernelPackages = pkgs.linuxPackages_zen;
  };

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.autoUpgrade = {
      enable = true;
      dates = "daily";
      flags = [
        "-I"
        "nixos-config=/home/domresc/.dotfile/nixos-config/configuration.nix"
        "--upgrade-all"
      ];
   };

  # Enable networking
  networking.hostName = "domresc-notebook";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "it_IT.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "it";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "it2";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.ipp-usb.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define user account.
  users.users.domresc = {
    isNormalUser = true;
    description = "Domenico Rescigno";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # core
    btop
    brave
    vlc
    p7zip
    obsidian
    gearlever
    # cloud
    nextcloud-client
    filen-desktop
    # gnome
    gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.appindicator
    gnomeExtensions.system-monitor
    gnomeExtensions.clipboard-indicator
    # programming
    vscode
    # 3D
    bambu-studio
  ];

  environment.shells = with pkgs; [
    fish
  ];

  # Initial installed version
  system.stateVersion = "25.05";

  # Swap
  swapDevices = [{
    device = "/swapfile";
    size = 2048;
  }];

  # Programs
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    config = {
      user = {
        name = "Domenico Rescigno";
        email = "domenico.rescigno@gmail.com";
      };
    };
  };

  programs.steam = {
    enable = true;
  };

  programs.fish = {
    enable = true;
    shellAbbrs = {
      config = "code .dotfile/nixos-config";
      rebuild = "sudo nixos-rebuild switch -I nixos-config=.dotfile/nixos-config/configuration.nix";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.appimage = { 
    enable = true;
    binfmt = true;
  };
}