{ self, inputs, lib, ... }: {
  flake.nixosModules.nixremberg = { config, modulesPath, ... }: {
    age.secrets.email-server.file = ../../secrets/email-server.age;
    mailserver = {
      enable = true;
      fqdn = "mail.sergio.sh";
      domains = [ "sergio.sh" ];
      certificateScheme = "acme";
      loginAccounts = let
          a = "y";
          b = "@se";
          c = "io.s";
        in {
          "${a}o${b}rg${c}h" = {
            hashedPasswordFile = "${config.age.secrets.email-server.path}";
            aliases = [ ];
          };
        };
      mailboxes = {
        Archive.auto = "subscribe";
        Drafts = {
          auto = "subscribe";
          specialUse = "Drafts";
        };
        Junk = {
          auto = "subscribe";
          specialUse = "Junk";
        };
        Sent = {
          auto = "subscribe";
          specialUse = "Sent";
        };
        Trash = {
          auto = "no";
          specialUse = "Trash";
        };
      };
    };
  };
}
