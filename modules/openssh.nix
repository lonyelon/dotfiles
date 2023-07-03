{ self, lib, ... }: {
    flake.nixosModules.openssh = { config, ... }: let
      keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC87gLutTPq1rwqMbFwN16qebtk9Ki600EKMJloDUgwF6q6MCGz8DSsEC2vVsXOSvVGEkZlrMMzGogSXQ2DAcfYo8d23FamRNiswojTZ3XTsBGrEwF2R77V1zsPyrNMcb2oHyD5c/mogk8sGFJgp1v6EB+gtQzFoTdSL69NZjUOS5KZu1G7gyAMMMLdraGVFIMvqHgxuWN1Fm94yBcwl/2H27eST4JpDlwTuTrnYV4WbMLoPHrjrvwuQmH7DIHvra87eM/3+H98Wv9Y9p7GYSecqbnUqhgxWKRxPLQqmVlaNNsSJuRbqmwAsLZef6Fs3fFyV8zV31/ir47L2jKNMxSuIteDuPOkDaP7yTAepLYJAuOWhcuFaa0r65Vr9+udOp9dMrFYHtGTJnNzG8fioGPh4eN2uHOpMacd0A1B4yMMkLG1Jn4GONOrD22mY7CvUmC45uEzIjpsUr++nrys9WBfcha8MLIiGDVQKRGjPsEb3u2RU+Eip/O6zFjIlO/THNE= sergio@icebear"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGgmfpwopah9yYYgus5MruZlVUWONLutQAp7jtBHT8o4 sergio@rpi-nix"
      ];
      hasSergio = lib.hasAttr "sergio" config.users.users;
    in {
      services.openssh.settings = {
        PermitRootLogin = if hasSergio then "no" else "yes";
        PasswordAuthentication = !hasSergio;
      };
      users.users.root.openssh.authorizedKeys.keys = keys;
    };
}
