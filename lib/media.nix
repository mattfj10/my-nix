{ pkgs, lib, home-manager, host, ... }:
let
  file = pkgs.fetchurl {
    url = "https://dl.emu-land.net/roms/bios_images/psx2/Sony%20PlayStation%202%20BIOS%20%28U%29%28v1.6%29%282002-03-19%29%5BSCPH39004%5D.zip";
    sha256 = "0e24d1a1003883ef3400b89579c40a7a06406325639379659bafaa7a0906738e";
  };
  mediaDir = "/home/tornado711/Media";
  isDesktop = !host.isLaptop;
in
{
  home-manager.users.tornado711 = {
    home.packages = with pkgs; [
      discord
      android-tools
      audacity
      biglybt
      calibre
      dolphin-emu
      freetube
      libreoffice
      pcsx2
      slack
      spotify
      r2modman
      unityhub
      #snes9x-gtk
      (pkgs.writeShellScriptBin "view-file" ''
        cp ${file} $HOME/Downloads/filename
      '')
    ];
  };

  programs.steam = {
    enable = true;
    protontricks.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Jellyfin media server (desktop only). Runs as tornado711 so it can read
  # media under $HOME without extra ACLs. openFirewall handles the LAN-facing
  # ports (8096/8920, plus 1900/7359 UDP for auto-discovery). NVENC transcoding
  # works out of the box on this host since jellyfin-ffmpeg ships with NVENC
  # built in and the driver+userland come from the existing hardware.nvidia
  # config — turn it on in the web UI under Dashboard -> Playback -> Hardware
  # acceleration.
  services.jellyfin = lib.mkIf isDesktop {
    enable = true;
    openFirewall = true;
    user = "tornado711";
    group = "users";
  };

  systemd.tmpfiles.rules = lib.mkIf isDesktop [
    "d ${mediaDir} 0755 tornado711 users - -"
  ];
}
