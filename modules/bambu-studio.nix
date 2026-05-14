{ self, ... }: {
  flake.nixosModules.sergio = { pkgs, ... }: {
    home-manager.users.sergio.home.packages = with pkgs; [
      (pkgs.symlinkJoin {
        name = "bambu-studio";
        paths = [ pkgs.bambu-studio ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/bambu-studio \
            --set __GLX_VENDOR_LIBRARY_NAME mesa \
            --set __EGL_VENDOR_LIBRARY_FILENAMES ${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json \
            --set MESA_LOADER_DRIVER_OVERRIDE zink \
            --set GALLIUM_DRIVER zink \
            --set WEBKIT_DISABLE_DMABUF_RENDERER 1
        '';
      })
    ];
  };
}
