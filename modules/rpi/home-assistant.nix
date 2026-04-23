{ self, inputs, ... }: {
  flake.nixosModules.rpi = { pkgs, ... }: {
    services = {
      home-assistant = {
        enable = true;
        openFirewall = true;
        config = {
          default_config = {};
          automation = "!include automations.yaml";
          script = "!include scripts.yaml";
          input_boolean.vacation_mode = {
            name = "Whether to enable the vacation mode.";
            initial = false;
            icon = "mdi:car";
          };
          homeassistant.allowlist_external_dirs = [
            "/var/lib/hass/snapshots"
          ];
        };
        extraComponents = [
          "esphome"
          "mqtt"
          "met"
          "radio_browser"
          "zwave_js"
          "wake_on_lan"
          "samsungtv"
          "ipp"
          "holiday"
          "minecraft_server"
          "reolink"
          "isal"
        ];
        customComponents = [
          pkgs.home-assistant-custom-components.frigate
          (pkgs.buildHomeAssistantComponent rec {
            owner = "greghesp";
            domain = "bambu_lab";
            version = "2.2.20";
            src = pkgs.fetchFromGitHub {
              owner = "greghesp";
              repo = "ha-bambulab";
              rev = "v${version}";
              hash = "sha256-lKKfPWWcri2OUM9nkdY2iltvIaoFhnUP4HGBGDUnEww=";
            };
            dependencies = with pkgs.home-assistant.python.pkgs; [ beautifulsoup4 ];
            doCheck = false;
          })
        ];
      };
      zwave-js = {
        enable = true;
        serialPort = "/dev/ttyACM0";
        secretsConfigFile = "/etc/zwave.json";
      };
    };
  };
}
