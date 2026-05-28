# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
    imports =
        [
            /etc/nixos/hardware-configuration.nix
        ];

    # Bootloader.
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";
    boot.loader.grub.useOSProber = true;

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "nixos"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.++

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Vienna";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "de_AT.UTF-8";
        LC_IDENTIFICATION = "de_AT.UTF-8";
        LC_MEASUREMENT = "de_AT.UTF-8";
        LC_MONETARY = "de_AT.UTF-8";
        LC_NAME = "de_AT.UTF-8";
        LC_NUMERIC = "de_AT.UTF-8";
        LC_PAPER = "de_AT.UTF-8";
        LC_TELEPHONE = "de_AT.UTF-8";
        LC_TIME = "de_AT.UTF-8";
    };

    # Keyboard layout (used by XWayland and virtual console)
    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    # Hyprland Wayland compositor
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
    };

    # greetd display manager with tuigreet
    services.greetd = {
        enable = true;
        settings = {
            default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${pkgs.hyprland}/bin/Hyprland";
                user = "greeter";
            };
        };
    };

    security.polkit.enable = true;

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;

    # XDG portals (needed for screen sharing, file pickers, etc.)
    xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

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

    users.users.georgii = {
        isNormalUser = true;
        description = "georgii";
        extraGroups = [
            "networkmanager" 
            "wheel"
            "docker"
        ];
        packages = with pkgs; [
            gparted
        ];
        shell = pkgs.zsh;
    };

    virtualisation.docker = {
        enable = true;
    };

    # Install firefox.
    programs.firefox.enable = true;
    programs.zsh.enable = true;
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
        stdenv.cc.cc
    ];

    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        kitty
        git
        just
        gcc
        # Wayland / Hyprland ecosystem
        waybar
        wofi
        mako
        swww
        grim
        slurp
        wl-clipboard
        brightnessctl
        pamixer
        pavucontrol
        networkmanagerapplet
        polkit_gnome
        libreoffice
    ];

    system.stateVersion = "25.11";

    services.blueman.enable = true;
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
    };

    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        open = true;
    };
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;  # powers up on boot
}
