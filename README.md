# Nixnado NixOS configuration

Flake-based NixOS and Home Manager configuration for the desktop and laptop
systems owned by `tornado711`.

## Hosts

| Flake output | Role | Hardware |
| --- | --- | --- |
| `nixnado_desktop` | NVIDIA desktop and Jellyfin server | `hosts/nixnado_desktop` |
| `nixnado_laptop` | Intel laptop with battery-aware Polybar | `hosts/nixnado_laptop` |

Both outputs intentionally retain the runtime hostname `nixnado`.

## Layout

- `hosts/`: host facts and generated hardware configuration.
- `modules/nixos/`: system modules grouped by service or responsibility.
- `modules/nixos/packages/`: system packages grouped by category.
- `modules/home/`: the single Home Manager entry point and user configuration.
- `modules/home/packages/`: user packages grouped by category.
- `modules/home/programs/`: Home Manager program configuration.
- `pkgs/`: local scripts and wrappers packaged as Nix derivations.
- `config/`: application configuration consumed by Home Manager.
- `overlays/`: the FreeTube and Python i3ipc package overrides.
- `media/`: immutable media assets referenced from the Nix store.

Package lists are alphabetized by effective package name. Add a package to the
narrowest existing category and keep system packages at system scope only when
they must be available outside the user profile.

## Validate

```sh
nix fmt
nix flake check --no-build
nix flake check
```

Enter the pinned tool environment for standalone checks:

```sh
nix develop
deadnix --fail .
statix check .
```

## Rebuild

```sh
sudo nixos-rebuild switch --flake .#nixnado_desktop
sudo nixos-rebuild switch --flake .#nixnado_laptop
```

Use `nixos-rebuild test` in place of `switch` to activate a generation without
making it the boot default.

## Add a host

1. Create `hosts/<name>/default.nix` and `hosts/<name>/hardware.nix`.
2. Set all typed `nixnado` host facts in the host's `default.nix`.
3. Add the output through `mkHost` in `flake.nix`.
4. Run the complete validation suite.

## Update inputs

The lockfile is committed. Update one input at a time where possible:

```sh
nix flake update <input>
```

Review `flake.lock`, evaluate both hosts, and build both system closures before
committing an input update. Signal Desktop intentionally comes from the
separate `nixpkgs-unstable` input.
