{ config, lib, ... }:
let
  isDesktop = !config.nixnado.isLaptop;
  mediaDir = "/home/tornado711/Media";
in
{
  programs.steam = {
    dedicatedServer.openFirewall = true;
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
    remotePlay.openFirewall = true;
  };

  services.jellyfin = lib.mkIf isDesktop {
    enable = true;
    group = "users";
    openFirewall = true;
    user = "tornado711";
  };

  systemd.tmpfiles.rules = lib.mkIf isDesktop [
    "d ${mediaDir} 0755 tornado711 users - -"
  ];
}
