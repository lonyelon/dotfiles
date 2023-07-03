{ self, inputs, lib, ... }: {
  flake.nixosModules.nixremberg = { config, modulesPath, ... }: {
    services.nginx = {
      enable = true;
      user = "nginx";
      group = "www-data";
      virtualHosts = {
        "sergio.sh" = {
          enableACME = true;
          forceSSL = true;
          root = "/srv/sergio.sh";
        };
        "blog.sergio.sh" = {
          enableACME = true;
          forceSSL = true;
          root = "/srv/blog.sergio.sh";
        };
        "blog.lony.xyz" = {
          enableACME = true;
          forceSSL = true;
          root = "/srv/blog.sergio.sh";
        };
        "mail.sergio.sh" = {
          enableACME = true;
          forceSSL = true;
          root = "/srv/blog.sergio.sh";
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "lonyelon@gmail.com";
      certs = {
        "sergio.sh" = {
          reloadServices = [ "nginx" ];
          group = "www-data";
          keyType = "rsa4096";
        };
        "blog.sergio.sh" = {
          reloadServices = [ "nginx" ];
          group = "www-data";
          keyType = "rsa4096";
        };
        "blog.lony.xyz" = {
          reloadServices = [ "nginx" ];
          group = "www-data";
          keyType = "rsa4096";
        };
      };
    };

    users = {
      users.nginx = {};
      groups.www-data = {};
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
