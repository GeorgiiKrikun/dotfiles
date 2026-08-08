{ config, lib, pkgs, ... }:
let
    dotfiles = "${config.home.homeDirectory}/software/dotfiles";
    pythonWithDebugpy = pkgs.python3.withPackages (ps: [ ps.debugpy ]);
in
    {
    # Identity fallbacks for container use, where the build-time user is unknown.
    # Overridden explicitly by home.nix on workstations.
    # NOTE: Why?
    home.username = lib.mkDefault (let u = builtins.getEnv "HM_USERNAME"; in if u != "" then u else "appuser");
    home.homeDirectory = lib.mkDefault (let h = builtins.getEnv "HM_HOME"; in if h != "" then h else "/home/appuser");
    home.stateVersion = lib.mkDefault "24.11";

    programs.home-manager.enable = true;

    home.file = {
        ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink
            "${dotfiles}/configs/nvim/nvim-conf";
        ".local/bin/python-debugpy".source = "${pythonWithDebugpy}/bin/python3";
    };

    programs.zsh = {
        enable = true;
        oh-my-zsh = {
            enable = true;
            theme = "robbyrussell";
            plugins = [ "git" "aws" "docker" "docker-compose" "extract" "pip" "rust" "z" ];
        };
        initContent = lib.mkMerge [
            (lib.mkBefore ''
                ZSH_DISABLE_COMPFIX=true
            '')
            ''
                export USER_ID=$(id -u)
                export GROUP_ID=$(id -g)
            ''
        ];
        sessionVariables = {
            EDITOR = "nvim";
        };
    };

    programs.git = {
        enable = true;
        settings = {
            user.name = "Georgii Krikun";
            user.email = "georgii.krikun@gmail.com";
            credential.helper = "cache --timeout=86400";
        };
    };

    home.packages = (with pkgs; [
        # --- Rust coreutils (leaf tools you want everywhere) ---
        ripgrep
        bottom
        fd
        # --- Dev leaf tools ---
        git
        unzip
        lazygit
        nodejs
        just
        rbw
        nixd
        uv
        jq
        claude-code
        cursor-cli
        tree-sitter
    ]) ++ (with pkgs; [ neovim ]);
}
