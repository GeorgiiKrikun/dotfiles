{ config, lib, pkgs, ... }:
let
    dotfiles = "${config.home.homeDirectory}/software/dotfiles";
in
{
    imports = [ ./home-container.nix ];

    home.username = "georgii";
    home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/georgii" else "/home/georgii";

    home.file = {
        ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink
            "${dotfiles}/configs/kitty";
    } // lib.optionalAttrs (!pkgs.stdenv.isDarwin) {
        ".vscode/extensions/ms-vscode.cpptools/extension".source =
            "${pkgs.vscode-extensions.ms-vscode.cpptools}/share/vscode/extensions/ms-vscode.cpptools";
        ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink
            "${dotfiles}/configs/hypr";
        ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink
            "${dotfiles}/configs/waybar";
        ".config/mako".source = config.lib.file.mkOutOfStoreSymlink
            "${dotfiles}/configs/mako";
    };

    systemd.user.services.gnome-keyring-secrets = {
        Unit = {
            Description = "GNOME Keyring secrets component";
            WantedBy = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
        };
        Service = {
            Type = "simple";
            ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --foreground --components=secrets";
            Restart = "on-failure";
        };
    };

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
        Unit = {
            Description = "polkit-gnome-authentication-agent-1";
            WantedBy = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
        };
        Service = {
            Type = "simple";
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
        };
    };

    services.ssh-agent.enable = true;

    programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks."github.com" = {
            identityFile = "~/.ssh/gh";
        };
        matchBlocks."*" = {
            addKeysToAgent = "yes";
            forwardAgent = true;
            compression = false;
            serverAliveInterval = 0;
            serverAliveCountMax = 3;
            hashKnownHosts = false;
            userKnownHostsFile = "~/.ssh/known_hosts";
            controlMaster = "no";
            controlPath = "~/.ssh/master-%r@%n:%p";
            controlPersist = "no";
        };
        extraConfig = ''
            Include ~/.ssh/config.local
        '';
    };

    programs.zsh.oh-my-zsh.plugins = [ "kitty" ];

    programs.zsh.initContent = ''
        if (( $+commands[xhost] )); then
            xhost +local:docker
        fi
    '';

    home.packages = with pkgs; [
        nerd-fonts.commit-mono
        telegram-desktop
        zoom-us
        spotify
    ];
}
