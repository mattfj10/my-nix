{
  description = "Nixnado NixOS configurations";

  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # Rolling package set used only for Signal Desktop.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgsSignal = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      baseModules = [
        home-manager.nixosModules.default
        ./modules/nixos
        ./modules/home
        {
          nixpkgs = {
            config.allowUnfree = true;
            overlays = [
              (import ./overlays/freetube.nix)
              (import ./overlays/i3ipc.nix)
            ];
          };
        }
      ];

      mkHost =
        hostModule:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit pkgsSignal; };
          modules = baseModules ++ [ hostModule ];
        };

      tooling =
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          formatter.${system} = pkgs.nixfmt;

          devShells.${system}.default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              deadnix
              nix-diff
              nixfmt
              statix
            ];
          };
        };
    in
    {
      nixosConfigurations = {
        nixnado_desktop = mkHost ./hosts/nixnado_desktop;
        nixnado_laptop = mkHost ./hosts/nixnado_laptop;
      };
    }
    // tooling
    // {
      checks.${system} = {
        deadnix =
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          pkgs.runCommand "deadnix-check"
            {
              nativeBuildInputs = [ pkgs.deadnix ];
              src = self;
            }
            ''
              deadnix --fail "$src"
              touch "$out"
            '';
        formatting =
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          pkgs.runCommand "formatting-check"
            {
              nativeBuildInputs = [ pkgs.nixfmt ];
              src = self;
            }
            ''
              nixfmt --check $(find "$src" -name '*.nix' -type f)
              touch "$out"
            '';
        nixnado-desktop = self.nixosConfigurations.nixnado_desktop.config.system.build.toplevel;
        nixnado-laptop = self.nixosConfigurations.nixnado_laptop.config.system.build.toplevel;
        statix =
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          pkgs.runCommand "statix-check"
            {
              nativeBuildInputs = [ pkgs.statix ];
              src = self;
            }
            ''
              statix check "$src"
              touch "$out"
            '';
      };
    };
}
