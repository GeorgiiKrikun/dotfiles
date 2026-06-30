{ config, lib, pkgs, pkgs-neovim11, rustToolchain, ... }:
let
    dotfiles = "${config.home.homeDirectory}/software/dotfiles";
    pythonWithDebugpy = pkgs.python3.withPackages (ps: with ps; [
        ps.pip
        ps.debugpy
        ps.ipython
    ]);
in
    {
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

    programs.ssh = {
        enable = true;
        addKeysToAgent = "yes";
        matchBlocks."github.com" = {
            identityFile = "~/.ssh/gh";
        };
        matchBlocks."hetzner" = {
            hostname = "2a01:4f8:1c1f:afbf::1";
            user = "root";
            identityFile = "~/.ssh/hetzner";
        };
    };

      programs.git = {
          enable = true;
          userName = "Georgii Krikun";
          userEmail = "georgii.krikun@gmail.com";
          extraConfig.credential.helper = "cache --timeout=86400";
      };

    home.sessionPath = [ "$HOME/.npm-global/bin" ];

    home.activation.installClaudeCode = lib.hm.dag.entryAfter ["writeBoundary"] ''
        export PATH="${pkgs.nodejs}/bin:$PATH"
        ${pkgs.nodejs}/bin/npm install -g --prefix "$HOME/.npm-global" @anthropic-ai/claude-code
    '';

    home.packages = (with pkgs; [
        # --- The Unix Core ---
        coreutils
        findutils
        gnugrep
        gnused
        gawk
        bashInteractive
        # --- The Rust coreutils ---
        ripgrep
        bottom
        fd
        wget
        curl
        git
        unzip
        lazygit
        nodejs
        gnumake
        just
        rbw
        nixd
        pythonWithDebugpy
        uv
        jq
        awscli2
    ]) ++ (with pkgs-neovim11; [ neovim ]);
}
