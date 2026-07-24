{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (texlive.combine {
      inherit (texlive)
        babel
        enumitem
        fancyhdr
        latexmk
        marvosym
        preprint
        scheme-small
        titlesec
        ;
    })
    unzip
  ];
}
