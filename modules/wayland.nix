{ inputs, lib, pkgs, ... }: {
  flake.nixosModules.wayland = { config, lib, pkgs, ... }: {
    options.wayland = {
      hyprlandMonitorList = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };
      isLaptop = lib.mkEnableOption "Wether the machine is a laptop";
      hasTouchScreen = lib.mkEnableOption "Wether the machine has touch screen";
      reducePowerUsage = lib.mkEnableOption "Reduce power usage";
    };

    config = {
      networking.wireless.iwd.enable = config.wayland.isLaptop;

      services = {
        displayManager = {
          enable = lib.mkForce false; # Due to https://github.com/NixOS/nixpkgs/pull/480050.
          autoLogin = {
            enable = true;
            user = "sergio";
          };
        };
        geoclue2.enable = config.wayland.isLaptop;
      };

      programs.niri.enable = true;

      home-manager.users.sergio = let
          wallpaperSource = pkgs.fetchurl {
            url = "https://upload.wikimedia.org/wikipedia/commons/e/ed/Semiradsky_Christ_Martha_Maria.jpg";
            sha256 = "sha256-mY2U1jWAB/0//lzihjJPcmnidENeMziplWGwxrnMq7w=";
          };
          wallpaper = pkgs.runCommand "process_cover" {
              nativeBuildInputs = [ pkgs.imagemagick ];
            } ''
              magick "${wallpaperSource}" \
                -resize 1200x720 \
                \( +clone -background black -shadow 40x12+0+0 \) \
                +swap -background "#fbf1c7" -layers merge \
                -gravity center -extent 2560x1440 \
                $out
            '';
        in {
          home = {
            file = {
              ".config/niri/config.kdl".source = pkgs.replaceVars ../files/niri/config.kdl {
                inherit wallpaper;
                DEFAULT_AUDIO_SINK = null;
                DEFAULT_AUDIO_SOURCE = null;
              };
              ".local/share/icons/breeze-cursor-light/".source = fetchTarball {
                url = "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/BreezeX-Light.tar.xz";
                sha256 = "sha256-uO1IMEXNe/EE6yneHw0UZ4erUtSGxrr7XKYDnQBd82Y=";
              };
            };
            packages = with pkgs; [
              fuzzel
              xwayland-satellite
              swaybg
              hyprshot
            ];
          };

          programs.alacritty = let
              alacrittyThemes = pkgs.fetchFromGitHub {
                owner = "alacritty";
                repo = "alacritty-theme";
                rev = "95a7d695605863ede5b7430eb80d9e80f5f504bc";
                hash = "sha256-D37MQtNS20ESny5UhW1u6ELo9czP4l+q0S8neH7Wdbc=";
              };
            in {
              enable = true;
              settings = {
                general.import = [
                  "${alacrittyThemes}/themes/gruvbox_light.toml"
                ];
                font = {
                  size = 9;
                  normal.family = "Source Code Pro";
                };
                window = {
                  opacity = 0.975;
                };
              };
            };

          services = {
            gammastep = {
              enable = true;
              temperature.night = 3500;
            } // lib.optionalAttrs (config.wayland.isLaptop) {
              provider = "geoclue2";
            } // lib.optionalAttrs (!config.wayland.isLaptop) {
              provider = "manual";
              latitude = 42.595058;
              longitude = -8.743065;
            };
          };

          wayland.windowManager.hyprland = let
              forcedOpacity = "0.975";
              programs = {
                terminal = "alacritty";
                menu = "fuzzel --show drun";
                browser = "librewolf";
              };
            in {
              enable = true;
              plugins = with pkgs; lib.mkIf config.wayland.hasTouchScreen [
                hyprlandPlugins.hyprgrass
              ];
              settings = {
                monitor = config.wayland.hyprlandMonitorList;

                "$terminal" = "alacritty";
                "$fileManager" = "lf";
                "$menu" = "fuzzel --show drun";

                env = [
                  "HYPRCURSOR_SIZE,24"
                  "HYPRCURSOR_THEME,breeze-cursor-light"
                  "XCURSOR_SIZE,24"
                  "XCURSOR_THEME,breeze-cursor-light"
                ];

                general = {
                  gaps_in = if config.wayland.isLaptop then "0" else "5";
                  gaps_out = if config.wayland.isLaptop then "0" else "15";
                  border_size = "2";
                  "col.active_border" = "rgba(fabd2fff) rgba(98971aff) 135deg";
                  "col.inactive_border" = "rgba(928374ff)";
                  resize_on_border = "false";
                  allow_tearing = "false";
                  layout = "master";
                };

                decoration = {
                  rounding = if config.wayland.isLaptop then "0" else "5";
                  active_opacity = "1.0";
                  shadow.enabled = "false";
                  blur = {
                    enabled = if config.wayland.reducePowerUsage then "false" else "true";
                    size = "2";
                    passes = "1";
                    vibrancy = "0.25";
                    vibrancy_darkness = "0.25";
                  };
                };

                animations.enabled = if (config.wayland.isLaptop && config.wayland.hasTouchScreen) then "true" else "false";

                master = {
                  new_status = "slave";
                  mfact = "0.6";
                };

                misc = {
                  force_default_wallpaper = "-1";
                  disable_hyprland_logo = "false";
                };

                input = {
                  kb_layout = "es";
                  follow_mouse = "1";
                  sensitivity = "0";
                  touchpad.natural_scroll = "false";
                };

                gesture = [
                  "3, horizontal, workspace"
                ];

                plugin.touch_gestures = {
                  sensitivity = 4.0;
                  workspace_swipe_fingers = 3;
                  #workspace_swipe_edge = d
                  long_press_delay = 400;
                  resize_on_border_long_press = true;
                  edge_margin = 20;
                  emulate_touchpad_swipe = false;
                  experimental.send_cancel = 0;
                };

                device = {
                  name = "epic-mouse-v1";
                  sensitivity = "-0.5";
                };

                "$mainMod" = "SUPER";

                bind = [
                  "$mainMod SHIFT,      Q, killactive,"
                  "$mainMod,            V, togglefloating,"
                  "$mainMod,            D, exec, ${programs.menu}"

                  "$mainMod,       RETURN, exec, ${programs.terminal}"
                  "$mainMod,            B, exec, ${programs.browser}"
                  "$mainMod,            M, exec, ${programs.terminal} -e aerc"
                  "$mainMod SHIFT,      M, exec, systemctl start --user sync-all-mail.service"
                  "$mainMod,            E, exec, emacsclient -c"
                  "$mainMod,            T, exec, logseq"
                  "$mainMod SHIFT,      S, exec, hyprshot -o ~/doc/img/screenshots/"
                  "$mainMod,            S, exec, hyprshot -m region -o ~/doc/img/screenshots/"

                  "$mainMod,            left,  layoutmsg, mfact -0.05"
                  "$mainMod,            right, layoutmsg, mfact +0.05"
                  "$mainMod,            up,    layoutmsg, cycleprev noloop"
                  "$mainMod,            down,  layoutmsg, cyclenext noloop"
                  "$mainMod CONTROL,    up,    layoutmsg, swapprev  noloop"
                  "$mainMod CONTROL,    down,  layoutmsg, swapnext  noloop"

                  "$mainMod,            COMMA,  workspace, 1"
                  "$mainMod,            PERIOD, workspace, 2"
                  "$mainMod,            NTILDE, workspace, 3"
                  "$mainMod,            P,      workspace, 4"
                  "$mainMod,            Y,      workspace, 5"
                  "$mainMod,            F,      workspace, 6"
                  "$mainMod,            G,      workspace, 7"
                  "$mainMod,            C,      workspace, 8"
                  "$mainMod,            H,      workspace, 9"
                  "$mainMod,            L,      workspace, 10"
                  "$mainMod,            1,      workspace, 1"
                  "$mainMod,            2,      workspace, 2"
                  "$mainMod,            3,      workspace, 3"
                  "$mainMod,            4,      workspace, 4"
                  "$mainMod,            5,      workspace, 5"
                  "$mainMod,            6,      workspace, 6"
                  "$mainMod,            7,      workspace, 7"
                  "$mainMod,            8,      workspace, 8"
                  "$mainMod,            9,      workspace, 9"
                  "$mainMod,            0,      workspace, 10"

                  "$mainMod SHIFT,      COMMA,  movetoworkspacesilent, 1"
                  "$mainMod SHIFT,      PERIOD, movetoworkspacesilent, 2"
                  "$mainMod SHIFT,      NTILDE, movetoworkspacesilent, 3"
                  "$mainMod SHIFT,      P,      movetoworkspacesilent, 4"
                  "$mainMod SHIFT,      Y,      movetoworkspacesilent, 5"
                  "$mainMod SHIFT,      F,      movetoworkspacesilent, 6"
                  "$mainMod SHIFT,      G,      movetoworkspacesilent, 7"
                  "$mainMod SHIFT,      C,      movetoworkspacesilent, 8"
                  "$mainMod SHIFT,      H,      movetoworkspacesilent, 9"
                  "$mainMod SHIFT,      L,      movetoworkspacesilent, 10"
                  "$mainMod SHIFT,      1,      movetoworkspacesilent, 1"
                  "$mainMod SHIFT,      2,      movetoworkspacesilent, 2"
                  "$mainMod SHIFT,      3,      movetoworkspacesilent, 3"
                  "$mainMod SHIFT,      4,      movetoworkspacesilent, 4"
                  "$mainMod SHIFT,      5,      movetoworkspacesilent, 5"
                  "$mainMod SHIFT,      6,      movetoworkspacesilent, 6"
                  "$mainMod SHIFT,      7,      movetoworkspacesilent, 7"
                  "$mainMod SHIFT,      8,      movetoworkspacesilent, 8"
                  "$mainMod SHIFT,      9,      movetoworkspacesilent, 9"
                  "$mainMod SHIFT,      0,      movetoworkspacesilent, 10"

                  # These are interesting. I leave them here for the future.
                  #"$mainMod, S, togglespecialworkspace, magic"
                  #"$mainMod SHIFT, S, movetoworkspace, special:magic"
                ];
                bindm = [
                  "$mainMod, mouse:272, movewindow"
                  "$mainMod, mouse:273, resizewindow"
                ];

                bindel = [
                  ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
                  ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                  ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                  ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
                  ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
                  ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
                ];

                bindl = [
                  ", XF86AudioNext,  exec, playerctl next"
                  ", XF86AudioPause, exec, playerctl play-pause"
                  ", XF86AudioPlay,  exec, playerctl play-pause"
                  ", XF86AudioPrev,  exec, playerctl previous"
                ];

                workspace = [
                  "w[t1],  gapsout:0, gapsin:0"
                  "w[tg1], gapsout:0, gapsin:0"
                  "f[1],   gapsout:0,  gapsin:0"
                  "s:1,    gapsout:0, gapsin:0"
                ];

                windowrule = [
                  {
                    name = "No rounding nor border on full screen windows 1";
                    border_size = 0;
                    rounding = 0;
                    "match:float" = 0;
                    "match:workspace" = "w[t1]";
                  }
                  {
                    name = "No rounding nor border on full screen windows 2";
                    border_size = 0;
                    rounding = 0;
                    "match:float" = 0;
                    "match:workspace" = "w[tg1]";
                  }
                  {
                    name = "No rounding nor border on full screen windows 3";
                    border_size = 0;
                    rounding = 0;
                    "match:float" = 0;
                    "match:workspace" = "f[1]";
                  }
                  {
                    name = "IDK";
                    suppress_event = "maximize";
                    "match:class" = ".*";
                  }
#                 {
#                   name = "Transparency for librewolf";
#                   opacity = "0.975 override";
#                   "match:class" = "librewolf";
#                 }
#                 {
#                   name = "Opacity for YouTube";
#                   opacity = "1.0 override";
#                   "match:class" = "librewolf";
#                   "match:title" = ".*YouTube.*";
#                 }
#                 {
#                   name = "Transparency for Logseq";
#                   opacity = "0.975 override";
#                   "match:class" = "Logseq";
#                 }
#                 {
#                   name = "Transparency for Emacs";
#                   opacity = "0.975 override";
#                   "match:class" = "Emacs";
#                 }
#                 {
#                   name = "Transparency for FreeCAD";
#                   opacity = "0.975 override";
#                   "match:class" = "org.freecad.FreeCAD";
#                 }
                ];

                exec-once = lib.mkMerge [
                  [ "swaybg --mode fill -i ${wallpaper}" ]
                  (lib.mkIf (config.wayland.hasTouchScreen && config.wayland.isLaptop) [
                    "iio-hyprland --left-master"
                  ])
                ];
              };
            };
        };
    };
  };
}
