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
}
