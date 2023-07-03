{ ... }: {
  flake.nixosModules.zsh = { config, ... }: {
    home-manager.users.sergio.programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        defaultKeymap = "viins";
        dotDir = "${config.home-manager.users.sergio.home.homeDirectory}/.config/zsh";
        history.path = "${config.home-manager.users.sergio.xdg.dataHome}/zsh/zsh_history";
        shellAliases =  {
          ls = "ls --color";
          ytdl = "yt-dlp";
          bc = "bc -l";
          nix-rebuild = "doas nixos-rebuild -I $HOME/proj/dotfiles/$(hostname)";
        };
        loginExtra = ''
          [ -z $DISPLAY ] && [ "$(tty)" = '/dev/tty1' ] && Hyprland
        '';
        initContent = ''
          autoload -Uz compinit vcs_info
          git_branch() {
            git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
          }
          setopt PROMPT_SUBST
          export PROMPT='%F{green}[%F{magenta}%l%f:%F{cyan}%!%F{green}][%F{red}%n%f@%F{yellow}%m%f:%F{blue}%~%F{green}]%F{magenta}$(git_branch)%F{green}$%f '
        '';
      };
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
