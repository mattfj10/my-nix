{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home-manager.useUserPackages = true;
  home-manager.users.tornado711.home.packages = with pkgs; [
    # List your tools here
    clamav
    ghidra-bin
    protonvpn-gui
    wireshark
    tcpdump
    unzip
    xdotool
    traceroute
    # scheme-small + extras for résumés / LaTeX Workshop (pdflatex + latexmk)
    (texlive.combine {
      inherit (texlive)
        scheme-small
        latexmk
        preprint # fullpage.sty
        titlesec
        marvosym
        enumitem
        fancyhdr
        babel
        ;
    })
    maim
    vagrant
    (pkgs.writers.writeDashBin "vboxmanage" '' ${pkgs.virtualbox}/bin/VBoxManage "$@"'')
  ];

  # ProtonVPN GUI (and Signal/Slack/Discord) talk to the Secret Service API to
  # persist login tokens. gnome-keyring provides that. Without it the Proton
  # app errors out with "please make sure a system keyring is available".
  services.gnome.gnome-keyring.enable = true;
}
