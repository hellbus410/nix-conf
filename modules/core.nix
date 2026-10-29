# What every host needs, servers included; the rest are features a host lists.
{ inputs, ... }:
{
  flake.modules.nixos.core =
    { lib, pkgs, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.impermanence.nixosModules.impermanence
      ];

      # Features list the paths they keep; nothing is bind-mounted unless the impermanence feature turns this on.
      environment.persistence."/persist".enable = lib.mkDefault false;

      # ── Nix ──
      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
        trusted-users = [ "@wheel" ];
        use-xdg-base-directories = true; # ~/.nix-profile and ~/.nix-defexpr live under ~/.local/state/nix instead
      };
      nixpkgs.config.allowUnfree = true;

      # ── Nix Helper ──
      programs.nh = {
        enable = true;
        flake = "/home/demiurge/projects/nix-conf"; # where the repo lives on the machine
        clean = {
          enable = true; # replaces nix.gc
          extraArgs = "--keep-since 14d --keep 10";
        };
      };

      # ── Boot ──
      boot.loader.systemd-boot.enable = true;
      boot.loader.systemd-boot.configurationLimit = 20; # keeps the 1G ESP from filling
      boot.loader.systemd-boot.memtest86.enable = true; # Memtest86+ entry in the boot menu
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.tmp.useTmpfs = true;
      zramSwap.enable = true;

      # ── Locale ──
      time.timeZone = "Europe/Moscow";
      i18n.defaultLocale = "en_US.UTF-8";
      console.keyMap = "us"; # graphical layouts are Hyprland's and fcitx5's

      # ── Network ──
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

      # ── User ──
      users.users.demiurge = {
        isNormalUser = true;
        description = "demiurge";
        extraGroups = [
          "wheel"
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
      # The "usual lecture" prints once per user, but its record in /var/db/sudo is wiped every boot
      security.sudo.extraConfig = "Defaults lecture = never";
      programs.nano.enable = false;
      documentation.man.cache.enable = true;

      # ── Network tools ── (a module, not a package: mtr needs a capability wrapper for raw sockets)
      programs.mtr.enable = true;

      # ── Services ──
      services.fwupd.enable = true;

      # ── Packages ──
      environment.systemPackages = with pkgs; [
        git
        neovim
        tmux
        curl
        wget
        lsof
        pciutils # lspci, pcilmr, setpci
        usbutils # lsusb, lsusb.py, usb-devices, usbhid-dump, usbreset
        psmisc # killall, pstree, fuser
        openssl
        dnsutils # dig, nslookup
        nmap
        whois

      # ── Nice to have ──
        lazygit
        eza
        bat
        tree
        ripgrep
        fd
        sd
        file
        dysk
        unzip
        zip
        _7zz
      ];

      # ── Home Manager ── (user demiurge, the same on every machine; features add to it;
      # home.stateVersion is per host, like system.stateVersion)
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
}
