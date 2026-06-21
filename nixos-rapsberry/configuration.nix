{ config, pkgs, ... }:
{
  boot.loader.raspberry-pi.bootloader = "kernel";
  networking.hostName = "nixos-rpi5";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "en_US.UTF-8";

  # SSH for remote management
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users.georgii = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = pkgs.bash;
    openssh.authorizedKeys.keyFiles = [ ./pi.pub ];
  };

  # Wayland / Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Place hyprland config system-wide so greetd can reference it
  environment.etc."hypr/hyprland.conf".source = ./hyprland.conf;

  # Autologin into Hyprland — no keyboard needed at boot
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.hyprland}/bin/Hyprland --config /etc/hypr/hyprland.conf";
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

  # GPU + hardware video decoding (VideoCore VII via V4L2)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva
      libva-utils
    ];
  };

  # VA-API via V4L2 for Firefox hardware video decode
  environment.sessionVariables = {
    MOZ_VA_API_USE_FFMPEG = "1";
    LIBVA_DRIVER_NAME = "v4l2_request";
  };

  # Firefox with hardware decode preferences
  programs.firefox = {
    enable = true;
    preferences = {
      "media.ffmpeg.vaapi.enabled" = true;
      "media.hardware-video-decoding.force-enabled" = true;
    };
  };

  # KDEConnect — remote control from phone (opens firewall ports automatically)
  programs.kdeconnect.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    mpv           # local video playback, MPRIS media controls via KDEConnect
    xfce.thunar   # file manager for browsing local drives
    waybar        # status bar with KDEConnect tray indicator
    git
  ];

  system.stateVersion = "25.11";
}
