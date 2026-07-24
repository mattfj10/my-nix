{ pkgs, ... }:
{
  programs = {
    gh = {
      enable = true;
      settings.git_protocol = "https";
    };

    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        alias = {
          ci = "commit";
          co = "checkout";
          s = "status";
        };
        pull.rebase = true;
        user = {
          email = "mattfjones@protonmail.com";
          name = "mattfj10";
        };
      };
    };

    vscode = {
      enable = true;
      package = pkgs.vscode;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          continue.continue
          dracula-theme.theme-dracula
          vscode-icons-team.vscode-icons
          vscodevim.vim
        ];
        userSettings = {
          "editor.minimap.enabled" = false;
          "terminal.integrated.defaultProfile.linux" = "zsh";
          "terminal.integrated.inheritEnv" = true;
          "terminal.integrated.profiles.linux" = {
            "nix-shell".path = "nix-shell";
            zsh.path = "${pkgs.zsh}/bin/zsh";
          };
          "workbench.iconTheme" = "vscode-icons";
        };
      };
    };
  };
}
