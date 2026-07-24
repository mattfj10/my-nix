{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clamav
    ghidra-bin
    proton-vpn
    tcpdump
    traceroute
    wireshark
  ];
}
