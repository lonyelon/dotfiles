{ self, inputs, ... }: {
  flake.nixosModules.sergio = { config, pkgs, ... }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.aerc
      self.nixosModules.btop
      self.nixosModules.env
      self.nixosModules.git
      self.nixosModules.neovim
      self.nixosModules.syncthing
      self.nixosModules.xdg
      self.nixosModules.zsh
    ];
    age.identityPaths = [ "/home/sergio/.ssh/id_ed25519" ];
    users.users.sergio = {
      isNormalUser = true;
      home = "/home/sergio";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "libvirtd" "plugdev" "usb" "dialout" ];
      openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
    };
    home-manager.users.sergio = {
      home = {
        packages = with pkgs; [
          isync          # Mail utils.
          ffmpeg         # Image/video editors.
            imagemagick  #
          fastfetch      # Like neofetch but in C.
          gnupg          # GPG key manager.
          lf             # Terminal file explorer (like ranger).
          bc             # Terminal calculator.
          ripgrep        # Recursive search.
          pandoc         # Convert documents
          zip unzip      # Just zip.
          yt-dlp         # YT downloader
          pkg-config     # I don't know why this is here.
          podman-compose # Podman tool.
          fontconfig     # I think this is for my fonts but IDK.
            freetype     #
          esptool        # Required for esp32 dev.

          sxiv           # Image viewers.
            feh          #
          mpv vlc        # Image/video players
          cmus           # Music player.
          openscad       # CAD as code.
          rssguard       # RSS feed reader.
          keepassxc      # Password manager.
          logseq         # Note taking app.
          calibre        # Ebook manager.
          virt-manager   # VM manager.
          sdrpp          # SDR tool.
          zotero         # Bibliography manager.
          orca-slicer    # 3D printer slicer.
          freecad        # CAD design tool.
          #kicad         # PCB design tool.
          krita          # Image editor.
          pavucontrol    # Volume control
          dragon-drop    # Drag and drop from the console.
          #stellarium    # Real time planetarium.
          qbittorrent    # Torrent manager.
          libreoffice    # Office tools.
          signal-desktop # Instant messaging app.
          rnote          # Note taking app for touchscreens.
          librewolf      # Web browsers
            tor-browser  #
        ];

        # Disable version missmatch warnings when using both unstable branches.
        enableNixpkgsReleaseCheck = false;

        stateVersion = "23.05";
      };

      programs = {
        home-manager.enable = true;
        ripgrep.enable = true;
        sioyek.enable = true;
        zathura.enable = true;
        zathura.options = {
          default-bg = "#fbf1c7";
          recolor = "true";
          recolor-darkcolor = "#212121";
          recolor-lightcolor = "#fbf1c7";
          statusbar-bg = "#ebdbb2";
          statusbar-fg = "rgb(0,0,0)";
          window-title-basename = true;
        };
        mpv.enable = true;
        borgmatic = {
          enable = true;
          backups.personal = {
            location = {
              repositories = [ "ssh://192.168.1.200/opt/backup/borg" ];
              patterns = [
                "R /home/sergio"
                "- home/sergio/dw"
                "- home/sergio/.*"
                "+ home/sergio/.local"
              ];
            };
          };
        };
        ssh = {
          enable = true;
          enableDefaultConfig = false;
          matchBlocks = {
            "icebear" = {
              user = "sergio";
              port = 22;
              hostname = "192.168.1.100";
            };
            "icebear.vpn" = {
              user = "sergio";
              port = 22;
              hostname = "10.0.0.2";
            };
            "homeserver" = {
              user = "root";
              port = 22;
              hostname = "192.168.1.200";
            };
            "homeserver.vpn" = {
              user = "root";
              port = 22;
              hostname = "10.0.0.4";
            };
            "nixremberg" = {
              user = "root";
              port = 22;
              hostname = "195.201.231.120";
            };
          };
        };
      };

      services.mpd.enable = true;

      nixpkgs.config.allowUnfree = false;     
    };
    nix.settings.trusted-users = [ "sergio" "@wheel" ];
    security.doas.extraRules = [{
      users = [ "sergio" ];
      keepEnv = true;
      persist = true;  
    }];
    services.getty.autologinUser = "sergio";
  };
}
