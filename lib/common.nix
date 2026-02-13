{ pkgs, home-manager, ... }:
{
  nixpkgs.config.allowUnfree = true;
  programs.noisetorch.enable = true;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.tornado711 = {
    home.packages = with pkgs; [
      code-cursor
      direnv
      file
      librewolf
      obsidian
      openssh
      (python3.withPackages (ps: with ps; [
        i3ipc  # Custom i3ipc package
        # Add other Python packages you need here
      ]))
      signal-desktop
      todoist-electron
    ];
    home.stateVersion = "24.11";
    home.enableNixpkgsReleaseCheck = true;

    xdg.desktopEntries.nemo = { 
    name = "Nemo";
    exec = "${pkgs.nemo-with-extensions}/bin/nemo";
};

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      profiles.default = {
        userSettings = {
          "terminal.integrated.defaultProfile.linux" = "zsh";
          "terminal.integrated.profiles.linux" = {
            "nix-shell" = {
              "path" = "nix-shell";
            };
            "zsh" = {
              "path" = "${pkgs.zsh}/bin/zsh";
            };
          };
          "terminal.integrated.inheritEnv" = true;
          "workbench.iconTheme" = "vscode-icons";
          "editor.minimap.enabled" = false;
        };
        extensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          dracula-theme.theme-dracula
          vscodevim.vim
          vscode-icons-team.vscode-icons
          continue.continue
        ];
      };
    };

    # Use programs.brave (not programs.chromium) so extension config is written to
    # ~/.config/BraveSoftware/Brave-Browser/External Extensions/ where Brave looks.
    programs.brave = {
      enable = true;
      extensions = [
        "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
        "nlgphodeccebbcnkgmokeegopgpnjfkc" # Super dark mode
        "eiaeiblijfjekdanodkjadfinkhbfgcd" # NordPass
        "ljflmlehinmoeknoonhibbjpldiijjmm" # Speechify
      ];
    };

  };
}
