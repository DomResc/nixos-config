{ config, pkgs, ... }:

{
  imports =
    [
      <nixos-hardware/common/pc>
      <nixos-hardware/common/pc/ssd>
      <nixos-hardware/common/pc/laptop>      
      <nixos-hardware/common/cpu/amd>
      <nixos-hardware/common/cpu/amd/pstate.nix>
      <nixos-hardware/common/gpu/amd>
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot/efi";
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_zen;
  };

  powerManagement.cpuFreqGovernor = "schedutil";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
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

  # Enable the Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "it";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "it2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Allow insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.6"
  ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # core
    btop
    vim
    firefox
    enpass
    p7zip
    onlyoffice-bin
    plex-media-player
    nextcloud-client
    # programming
    obsidian
    vscode
    godot_4
    aseprite-unfree
    # gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];

  environment.shells = with pkgs; [
    fish
  ];

  # Initial installed version
  system.stateVersion = "23.05";

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
      upgrade = "sudo nix-collect-garbage --delete-older-than 7d && sudo nixos-rebuild switch -I nixos-config=.dotfile/nixos-config/configuration.nix --upgrade-all";
    };
  };

  programs.pantheon-tweaks.enable = true;
}
