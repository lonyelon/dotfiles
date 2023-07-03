{ inputs, lib, pkgs, ... }: {
  flake.nixosModules.autofirma = { config, lib, pkgs, ... }: {
    home-manager.users.sergio = {
      imports = [
        inputs.autofirma-nix.homeManagerModules.default
      ];
      programs = {
        firefox = {
          enable = false;
          package = pkgs.firefox;
          profiles.default.id = 0;
          policies.SecurityDevices = {
            "OpenSC PKCS11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
            "DNIeRemote" = "${config.programs.dnieremote.finalPackage}/lib/libdnieremotepkcs11.so";
          };
        };
        dnieremote.enable = true;
        autofirma = {
          enable = true;
          firefoxIntegration.profiles.default.enable = true;
        };
        configuradorfnmt = {
          enable = true;
          firefoxIntegration.profiles.default.enable = true;
        };
      };
    };
  };
}
