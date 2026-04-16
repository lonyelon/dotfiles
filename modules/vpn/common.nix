{ config, lib, self, ... }: {
  flake.nixosModules = {
    common-vpn = {
      config.lib.vpn = rec {
        private = {
          name = "wg-private";
          host = "195.201.231.120";
          port = 51820;
          network = "10.0.0.1/24";
          dns = [ "8.8.8.8" "8.0.0.8" ];
          publicKey = "rehxjeDL+mEou+mdN3aweVIqQJTbxtugl34so29t+ho=";
          peers = {
            icebear = {
              publicKey = "VTGB/32zMWLXa7Yw23m8+saHCyLg4K/75teuRvsaAC0=";
              ip = "10.0.0.2";
            };
            pixel8a = {
              publicKey = "BH0y6vScdQQGyN65kJIGmpUioilpFueZGhO3eyTRVVA=";
              ip = "10.0.0.3";
            };
            homeserver = {
              publicKey = "PtHvWiCB1LetxHa+/CSd44cUt+xlk40te04wNq+hrT8=";
              ip = "10.0.0.4";
            };
            nixremberg = {
              publicKey = "JCZKgxGGmg19TeZL5pfsdWxiMSC+PDHuKNKvNa6U20c=";
              ip = "10.0.0.5";
            };
            rpi = {
              publicKey = "n1DhzVyfjCTnie17sAmfhaOB4MhK+/j2i0uw4tJy41c=";
              ip = "10.0.0.6";
            };
            nixtab = { # FIXME: make this have its own values.
              publicKey = "ATD2Drcv6UTGHKYAmn469ncwXUHLTrxTN8Ak9utiSFA=";
              ip = "10.0.0.7";
            };
            nixpad = {
              publicKey = "ATD2Drcv6UTGHKYAmn469ncwXUHLTrxTN8Ak9utiSFA=";
              ip = "10.0.0.8";
            };
            archremote = {
              publicKey = "ahEm15zmaL6j99AIHjyb9e3gdV3JCcpX4JVswMKPeFk=";
              ip = "10.0.0.9";
            };
          };
        };
        public = {
          name = "wg-public";
          host = private.host;
          port = 51830;
          network = "10.0.1.1/24";
          dns = private.dns;
          publicKey = "q2+htWSw7q+Va5rKG0kcVs9pYP6ITpp/5YR6J02jTHQ="; # FIXME This is wrong.
          peers = {
            homeserver = {
              publicKey = "6sBEBeUNbdHCHA/3MtiPG5enhzUAZnHsYdsFLDPo5Qk=";
              ip = "10.0.1.2";
            };
            emma-iphone = {
              publicKey = "M2mtkh4KLMPLCu9EcuT+KTLZnTMVLmgZ2smD3Dy00WY=";
              ip = "10.0.1.3";
            };
            emma-pc = {
              publicKey = "XHIH6NhlvpLai0T5GYQee5WwUlYIch1CqKKKLCJpM1s=";
              ip = "10.0.1.4";
            };
            emma-ipad = {
              publicKey = "vkbFz75wVitIZMDxMOkcI11yiDnehxG9+CcBeuGFAB8=";
              ip = "10.0.1.5";
            };
          };
        };
      };
    };
  };
}
