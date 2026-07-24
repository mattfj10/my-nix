{
  users.extraGroups.vboxusers.members = [ "tornado711" ];

  virtualisation = {
    libvirtd.enable = true;
    oci-containers = {
      backend = "podman";
      containers.calibre-web = {
        environment = {
          PGID = "100";
          PUID = "1000";
          TZ = "America/New_York";
        };
        image = "lscr.io/linuxserver/calibre-web:latest";
        ports = [ "8083:8083" ];
        volumes = [
          "/home/tornado711/Calibre Library:/books"
          "/home/tornado711/calibre-web-config:/config"
        ];
      };
    };
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
  };
}
