{ pkgs, home-manager, ... }:
let
  file = pkgs.fetchurl {
    url = "https://dl.emu-land.net/roms/bios_images/psx2/Sony%20PlayStation%202%20BIOS%20%28U%29%28v1.6%29%282002-03-19%29%5BSCPH39004%5D.zip";
    sha256 = "0e24d1a1003883ef3400b89579c40a7a06406325639379659bafaa7a0906738e";
  };
in
{
  home-manager.users.tornado711 = {
    home.packages = with pkgs; [
      discord
      android-tools
      calibre
      dolphin-emu
      freetube
      libreoffice
      pcsx2
      spotify
      r2modman
      snes9x-gtk
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
}
