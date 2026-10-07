# Everything system-side that is not the desktop.
{ pkgs, ... }:
{
  # ── Nix ──
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    trusted-users = [ "@wheel" ];
  };
  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    flake = "/home/demiurge/nix-conf"; # where the repo lives on the machine
    clean = {
      enable = true; # replaces nix.gc
      extraArgs = "--keep-since 14d --keep 10";
    };
  };

  # ── Boot ──
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20; # keeps the 1G ESP from filling
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.tmp.useTmpfs = true;
  zramSwap.enable = true;

  # ── Locale ──
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us"; # graphical layouts are Hyprland's and fcitx5's

  # ── Network ──
  networking.networkmanager.enable = true;
  networking.nftables.enable = true;
  networking.firewall.enable = true; # ports are opened by the modules that need them

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false; 
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  # services.tailscale.enable = true;

  # ── User ──
  users.users.demiurge = {
    isNormalUser = true;
    description = "demiurge";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZj9Srr6tUVqTMZedPICFq7jU7mRoTeznjzVNUDngYM"
    ];
  };

  # ── Shell ── (rc files are chezmoi's; bash is always there)
  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false; # ~/.zshrc runs compinit itself
  };
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
  };
  programs.nano.enable = false;
  documentation.man.cache.enable = true;

  # ── Hardware ──
  security.rtkit.enable = true; # real-time scheduling for PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true; # TODO:check the board has it: rfkill list
    powerOnBoot = true;
  };

  # ── Services ──
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
  services.fwupd.enable = true;
}
