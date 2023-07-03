{ ... }: {
  flake.nixosModules.xdg = { config, ... }: {
    home-manager.users.sergio.xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "${config.home-manager.users.sergio.home.homeDirectory}";
        documents = "${config.home-manager.users.sergio.home.homeDirectory}/doc";
        download = "${config.home-manager.users.sergio.home.homeDirectory}/dw";
        music = "${config.home-manager.users.sergio.home.homeDirectory}/doc/mus";
        pictures = "${config.home-manager.users.sergio.home.homeDirectory}/doc/img";
        publicShare = "${config.home-manager.users.sergio.home.homeDirectory}/doc/pub";
        templates = "${config.home-manager.users.sergio.home.homeDirectory}/doc/templates";
        videos = "${config.home-manager.users.sergio.home.homeDirectory}/doc/vid";
        extraConfig = {
          PROJECTS_DIR = "${config.home-manager.users.sergio.home.homeDirectory}/proj";
          VMS_DIR = "${config.home-manager.users.sergio.home.homeDirectory}/doc/vm";
        };
      };
      mimeApps = {
        enable = true;
        defaultApplications = {
          "image/png"     = ["sxiv.desktop"];
          "image/bmp"     = ["sxiv.desktop"];
          "image/jpg"     = ["sxiv.desktop"];
          "image/jpeg"    = ["sxiv.desktop"];
          "image/gif"     = ["sxiv.desktop"];
          "image/webp"    = ["sxiv.desktop"];
          "image/svg+xml" = ["sxiv.desktop"];
          "image/x-icon"  = ["sxiv.desktop"];

          "audio/mpeg" = ["mpv.desktop"];
          "audio/ogg"  = ["mpv.desktop"];
          "audio/wav"  = ["mpv.desktop"];
          "audio/mp3"  = ["mpv.desktop"];
          "audio/flac" = ["mpv.desktop"];

          "video/mp4"  = ["mpv.desktop"];
          "video/mpeg" = ["mpv.desktop"];
          "video/webm" = ["mpv.desktop"];
          "video/avi"  = ["mpv.desktop"];
          "video/ogg"  = ["mpv.desktop"];

          "text/html"       = ["librewolf.desktop"];
          "text/htm"        = ["librewolf.desktop"];
          "text/css"        = ["librewolf.desktop"];
          "text/php"        = ["librewolf.desktop"];
          "text/javascript" = ["librewolf.desktop"];
          "text/plain"      = ["librewolf.desktop"];
          "text/xml"        = ["librewolf.desktop"];

          "application/atom+xml"   = ["librewolf.desktop"];
          "application/javascript" = ["librewolf.desktop"];
          "application/json"       = ["librewolf.desktop"];
          "application/rss+xml"    = ["librewolf.desktop"];
          "application/xhtml+xml"  = ["librewolf.desktop"];
          "application/xml"        = ["librewolf.desktop"];
          "application/pdf"        = ["sioyek.desktop"];
          "application/epub+zip"   = ["sioyek.desktop"];

          "x-scheme-handler/https" = ["librewolf.desktop"];
          "x-scheme-handler/http"  = ["librewolf.desktop"];
        };
      };
    };
  };
}
