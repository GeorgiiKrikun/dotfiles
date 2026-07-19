{ config, pkgs, pkgs-unstable,... }:
{
  boot.loader.raspberry-pi.bootloader = "kernel";
  networking.hostName = "nixos-rpi5";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "en_US.UTF-8";

  # SSH for remote management
  services.openssh = {
    enable = true;
  };

  users.users.georgii = {
    isNormalUser = true;
    # "uinput" lets KDEConnect inject remote mouse/keyboard input under Wayland
    extraGroups = [ "networkmanager" "wheel" "video" "uinput" ];
    shell = pkgs.bash;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = false;
    package = pkgs-unstable.hyprland;
    portalPackage = pkgs-unstable.xdg-desktop-portal-hyprland;
  };

  # Autologin into Hyprland — no keyboard needed at boot
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs-unstable.hyprland}/bin/Hyprland";
      user = "georgii";
    };
  };
  systemd.services.greetd.serviceConfig = {
    StandardOutput = "null";
    StandardError = "journal";
  };

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # GPU acceleration for the Wayland compositor.
  hardware.graphics.enable = true;

  # Run Firefox natively on Wayland (no XWayland).
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Firefox. The Pi 5 has no hardware H.264/VP9/AV1 decoder (only HEVC), so
  # forcing VA-API hardware decode is unreliable and can black out video —
  # 1080p is decoded on the CPU just fine, so we leave decoding at defaults.
  programs.firefox.enable = true;

  # KDEConnect — remote control from phone (opens firewall ports automatically).
  programs.kdeconnect.enable = true;
  # uinput backend so the phone's remote-input plugin can move the cursor / type.
  hardware.uinput.enable = true;

  # mpv config for local playback: zero-copy tear-free output on Wayland and
  # the HEVC hardware decoder for H.265 files (software for H.264, fine at 1080p).
  environment.etc."xdg/mpv/mpv.conf".text = ''
    vo=dmabuf-wayland
    hwdec=auto-safe
    fullscreen=yes
  '';

  # Trim docs to keep the system lean.
  documentation.nixos.enable = false;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
        kitty
        git
        just
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
  ];

  system.stateVersion = "25.11";
}
