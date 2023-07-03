{ ... }: {
  flake.nixosModules.email = { config, ... }: {
    lib.mail.accounts = let
        commonOptions = {
          msmtp.enable = true;
          aerc.enable = true;
          mbsync = {
            enable = true;
            create = "both";
            expunge = "both";
            remove = "both";
          };
        };
        personalMailAddress = let # Done like this to prevent spam bots.
            name = "y";
            domain = "h";
            dot = "@ser";
          in "${name}o${dot}gio.s${domain}";
        gmailAddress = let # Done like this to prevent spam bots.
            name = "lony";
            domain = "om";
            extra = "elon";
            dot = "@gma";
          in "${name}${extra}${dot}il.c${domain}";
      in {
        ${personalMailAddress} = rec {
          primary = true;
          address = "${personalMailAddress}";
          userName = "${address}";
          realName = "Sergio M. Iglesias";
          passwordCommand = "grep '${address}' ${config.age.secrets.email.path} | cut -d' ' -f2";
          imap = {
            host = "mail.sergio.sh";
            port = 993;
            tls.enable = true;
          };
          smtp = {
            host = "mail.sergio.sh";
            port = 465;
            tls.enable = true;
          };
        } // commonOptions ;

        ${gmailAddress} = rec {
          address = "${gmailAddress}";
          userName = "${address}";
          realName = "Lonyelon";
          flavor = "gmail.com";
          passwordCommand = "grep '${address}' ${config.age.secrets.email.path} | cut -d' ' -f2";
          imap = {
            host = "imap.gmail.com";
            port = 993;
            tls.enable = true;
          };
          smtp = {
            host = "smtp.gmail.com";
            port = 465;
            tls.enable = true;
          };
        } // commonOptions;
    };
    age.secrets.email = {
      file = ../secrets/email.age;
      owner = "sergio";
    };
    home-manager.users.sergio = {
      accounts.email = {
        maildirBasePath = ".local/share/mail";
        accounts = config.lib.mail.accounts;
      };
      programs = {
        mbsync.enable = true;
        msmtp.enable = true;
      };
      services.mbsync.enable = true;
    };
  };
}
