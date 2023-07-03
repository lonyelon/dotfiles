{ self, inputs, ... }: {
  flake.nixosModules.common-pc = { lib, modulesPath, pkgs, ... }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      self.nixosModules.autofirma
      self.nixosModules.bean
      self.nixosModules.common
      self.nixosModules.emacs
      self.nixosModules.email
      self.nixosModules.xorg
      self.nixosModules.ktl
      self.nixosModules.rdiary
      self.nixosModules.sergio
      self.nixosModules.stevenblack-hosts
      self.nixosModules.wayland
    ];

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    hardware = {
      keyboard.qmk.enable = true;
      rtl-sdr.enable = true;
      hackrf.enable = true;
    };

    time.timeZone = "Europe/Madrid";

    networking.firewall.enable = false;

    nixpkgs = {
      hostPlatform = lib.mkDefault "x86_64-linux";
      config.allowUnfree = false;
    };

    programs = {
      zsh.enable = true;
      dconf.enable = true;
    };

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      liberation_ttf
      source-code-pro
    ];

    security.rtkit.enable = true; # Required by Pipewire.

    environment.systemPackages = with pkgs; [
      btop         # Task manager.
      curl         # Web browsers.
        wget       #  .
      gcc          # Development.
        cargo      #  .
        git        #  .
        gnumake    #  .
        cmake      #  .
        platformio #  .
      jq           # Parsers.
        yq         #  .
      neovim       # Coolest text editor.
        rsync      #  .
      usbutils     # USB management tools.
        usb-modeswitch
      xorg.xbacklight
    ];

    services = {
      udisks2.enable = true;
      pulseaudio.enable = false;
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };
    };

    system.stateVersion = "23.05";
  };
}
