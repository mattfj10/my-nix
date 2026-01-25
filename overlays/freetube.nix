final: prev: {
  freetube = prev.appimageTools.wrapType2 rec {
    pname = "freetube";
    version = "0.23.13-beta";
    
    src = prev.fetchurl {
      url = "https://github.com/FreeTubeApp/FreeTube/releases/download/v${version}/freetube-${version}-amd64.AppImage";
      sha256 = "0g3vb8bgmbhzxanqch8lqgfnxiq1f00pw3vrd6apmd08lvib0wih";
    };

    extraPkgs = pkgs: with pkgs; [
      # Common dependencies for Electron apps
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libdrm
      libxkbcommon
      mesa
      nspr
      nss
      pango
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxcb
    ];

    extraInstallCommands = let
      appimageContents = prev.appimageTools.extract { inherit pname version src; };
    in ''
      # Create desktop entry manually since the AppImage might not have one or it might be in a different location
      mkdir -p $out/share/applications
      cat > $out/share/applications/freetube.desktop << EOF
      [Desktop Entry]
      Name=FreeTube
      Comment=An Open Source YouTube app for privacy
      Exec=$out/bin/freetube %U
      Terminal=false
      Type=Application
      Icon=freetube
      StartupWMClass=FreeTube
      MimeType=x-scheme-handler/freetube;
      Categories=Network;AudioVideo;
      Keywords=youtube;video;player;
      EOF
      
      # Try to install icon from various possible locations, create fallback if none found
      mkdir -p $out/share/pixmaps
      mkdir -p $out/share/icons/hicolor/512x512/apps
      
      if [ -f ${appimageContents}/freetube.png ]; then
        install -Dm644 ${appimageContents}/freetube.png $out/share/pixmaps/freetube.png
        install -Dm644 ${appimageContents}/freetube.png $out/share/icons/hicolor/512x512/apps/freetube.png
      elif [ -f ${appimageContents}/usr/share/pixmaps/freetube.png ]; then
        install -Dm644 ${appimageContents}/usr/share/pixmaps/freetube.png $out/share/pixmaps/freetube.png
        install -Dm644 ${appimageContents}/usr/share/pixmaps/freetube.png $out/share/icons/hicolor/512x512/apps/freetube.png
      elif [ -f ${appimageContents}/.DirIcon ]; then
        install -Dm644 ${appimageContents}/.DirIcon $out/share/pixmaps/freetube.png
        install -Dm644 ${appimageContents}/.DirIcon $out/share/icons/hicolor/512x512/apps/freetube.png
      else
        # Create a simple fallback icon if no icon is found
        echo "No icon found in AppImage, using fallback"
      fi
    '';
    
    meta = with prev.lib; {
      description = "FreeTube 0.23.13-beta - An Open Source YouTube app for privacy";
      longDescription = ''
        FreeTube is an open source desktop YouTube player built with privacy in mind.
        This is a custom build of version 0.23.13-beta which includes bug fixes not yet
        available in the official nixpkgs repository.
      '';
      homepage = "https://freetubeapp.io/";
      license = licenses.agpl3Only;
      platforms = platforms.linux;
      maintainers = with maintainers; [ ];
    };
  };
}
