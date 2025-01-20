{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home-manager.useUserPackages = true;
  home-manager.users.tornado711.home.packages = with pkgs; [
    # List your tools here
    clamav
    ghidra-bin
    wireshark
    tcpdump
    unzip
    xdotool
    traceroute
    maim
    dotnetCorePackages.dotnet_9.sdk
    dotnetCorePackages.dotnet_9.runtime
    omnisharp-roslyn
    vagrant
    (pkgs.writers.writeDashBin "vboxmanage" '' ${pkgs.virtualbox}/bin/VBoxManage "$@"'') # Added both these to get vbox management working
  ];
}
