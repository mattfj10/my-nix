{ pkgs, home-manager, ... }:
{
  home-manager.users.tornado711 = {
    home.packages = with pkgs; [
      rofi  # Required for rofi scripts
      (pkgs.writeScriptBin "i3-rofi-window-switcher" ''
        #!${pkgs.python3.withPackages (ps: with ps; [ i3ipc ])}/bin/python3
        """
        i3-rofi-window-switcher (icons, no workspace grouping)

        Lists all open i3 windows in rofi with icons.
        When one is selected, focuses that window.

        Deps:
          - i3ipc  (PyPI)
          - rofi   (must support icons)
        """

        import subprocess
        import sys
        import argparse
        from typing import List, Tuple

        try:
            import i3ipc
        except ImportError:
            print("Error: The 'i3ipc' Python package is not installed. Try: pip install i3ipc", file=sys.stderr)
            sys.exit(1)


        def best_icon_name(app_id: str, wm_class: str, wm_instance: str) -> str:
            """Guess the correct icon name for rofi."""
            for candidate in (app_id, wm_class, wm_instance):
                if candidate:
                    return candidate.lower()
            return "application-x-executable"


        def format_rofi_line(label: str, icon_name: str, info: str = "") -> str:
            """Format a rofi line with icon and metadata."""
            line = f"{label}\x00icon\x1f{icon_name}"
            if info:
                line += f"\x00info\x1f{info}"
            return line


        def collect_windows(ipc: i3ipc.Connection, include_scratchpad: bool) -> List[Tuple[str, int]]:
            """Collect all window entries as (line, con_id)."""
            items: List[Tuple[str, int]] = []
            tree = ipc.get_tree()

            for con in tree.leaves():
                if con.type not in ("con", "floating_con"):
                    continue
                if not include_scratchpad and con.workspace() and con.workspace().name == "__i3_scratch":
                    continue

                app_id = con.app_id or ""
                wm_class = con.window_class or ""
                wm_instance = getattr(con, "window_instance", "") or ""
                title = con.name or ""
                icon = best_icon_name(app_id, wm_class, wm_instance)

                # Show something like "Firefox — ChatGPT"
                label_parts = []
                if wm_class or app_id:
                    label_parts.append(wm_class or app_id)
                if title:
                    if label_parts:
                        label_parts.append("—")
                    label_parts.append(title)
                label = " ".join(label_parts) or "<untitled window>"

                items.append((format_rofi_line(label, icon, str(con.id)), con.id))

            return items


        def rofi_choose(lines: List[str], prompt: str = "Windows") -> int:
            """Run rofi and return the selected index."""
            cmd = [
                "rofi", "-dmenu", "-i",
                "-matching", "fuzzy",
                "-p", prompt,
                "-format", "i",
                "-show-icons",
            ]

            try:
                proc = subprocess.run(
                    cmd,
                    input="\n".join(lines),
                    text=True,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    check=False,
                )
            except FileNotFoundError:
                print("Error: rofi not installed or not in PATH.", file=sys.stderr)
                return -1

            if proc.returncode != 0:
                return -1

            s = proc.stdout.strip()
            return int(s) if s.isdigit() else -1


        def focus_window(ipc: i3ipc.Connection, con_id: int) -> None:
            ipc.command(f'[con_id="{con_id}"] focus')


        def main():
            parser = argparse.ArgumentParser(description="Choose and focus an i3 window via rofi (with icons).")
            parser.add_argument("--include-scratchpad", action="store_true", help="Include scratchpad windows.")
            parser.add_argument("--prompt", default="Windows", help="Custom rofi prompt.")
            args = parser.parse_args()

            ipc = i3ipc.Connection()
            items = collect_windows(ipc, include_scratchpad=args.include_scratchpad)
            if not items:
                print("No windows found.")
                sys.exit(0)

            idx = rofi_choose([line for line, _ in items], prompt=args.prompt)
            if idx < 0 or idx >= len(items):
                sys.exit(0)

            _, con_id = items[idx]
            focus_window(ipc, con_id)


        if __name__ == "__main__":
            main()
      '')

      # i3 workspace switcher with rofi
      (pkgs.writeScriptBin "i3-rofi-workspace-switcher" ''
        #!${pkgs.python3.withPackages (ps: with ps; [ i3ipc ])}/bin/python3
        """
        i3-rofi-workspace-switcher

        Lists all i3 workspaces in rofi for quick switching.
        If you type a workspace name that doesn't exist and press enter,
        it creates the workspace and switches to it.

        Deps:
          - i3ipc  (PyPI)
          - rofi
        """

        import subprocess
        import sys
        import argparse
        import re
        from typing import List, Tuple, Optional

        try:
            import i3ipc
        except ImportError:
            print("Error: The 'i3ipc' Python package is not installed.", file=sys.stderr)
            sys.exit(1)


        def get_workspaces(ipc: i3ipc.Connection) -> List[Tuple[str, str, bool]]:
            """Get all workspaces as (name, display_name, is_focused) tuples."""
            workspaces = []
            for ws in ipc.get_workspaces():
                # Format: "1: term" or just "1" 
                name = ws.name
                # Create a nice display name with focus indicator
                display_name = f"{'● ' if ws.focused else '  '}{name}"
                if ws.urgent:
                    display_name = f"⚠ {name}"
                
                workspaces.append((name, display_name, ws.focused))
            
            # Sort by workspace number if possible, otherwise alphabetically
            def sort_key(item):
                name = item[0]
                # Try to extract number from workspace name
                match = re.match(r'^(\d+)', name)
                if match:
                    return (0, int(match.group(1)), name)  # Number first
                else:
                    return (1, 0, name)  # Named workspaces after
            
            workspaces.sort(key=sort_key)
            return workspaces


        def rofi_choose_workspace(workspaces: List[Tuple[str, str, bool]], prompt: str = "Workspace") -> Optional[str]:
            """Run rofi and return the selected/typed workspace name."""
            lines = [display_name for _, display_name, _ in workspaces]
            
            cmd = [
                "rofi", "-dmenu", "-i",
                "-matching", "fuzzy",
                "-p", prompt,
                "-format", "s",  # Return the actual string, not index
            ]

            try:
                proc = subprocess.run(
                    cmd,
                    input="\n".join(lines),
                    text=True,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    check=False,
                )
            except FileNotFoundError:
                print("Error: rofi not installed or not in PATH.", file=sys.stderr)
                return None

            if proc.returncode != 0:
                return None

            selection = proc.stdout.strip()
            if not selection:
                return None

            # Check if selection matches an existing workspace display name
            for name, display_name, _ in workspaces:
                if selection == display_name:
                    return name
            
            # If no match, treat it as a new workspace name
            # Clean up the input (remove focus indicators if user typed them)
            clean_name = selection.replace("● ", "").replace("  ", "").replace("⚠ ", "").strip()
            return clean_name


        def switch_to_workspace(ipc: i3ipc.Connection, workspace_name: str) -> None:
            """Switch to the specified workspace, creating it if necessary."""
            try:
                # This command will create the workspace if it doesn't exist
                ipc.command(f'workspace "{workspace_name}"')
                print(f"Switched to workspace: {workspace_name}")
            except Exception as e:
                print(f"Error switching to workspace {workspace_name}: {e}", file=sys.stderr)


        def main():
            parser = argparse.ArgumentParser(description="Choose and switch to an i3 workspace via rofi.")
            parser.add_argument("--prompt", default="Workspace", help="Custom rofi prompt.")
            args = parser.parse_args()

            try:
                ipc = i3ipc.Connection()
            except Exception as e:
                print(f"Error connecting to i3: {e}", file=sys.stderr)
                sys.exit(1)

            workspaces = get_workspaces(ipc)
            if not workspaces:
                print("No workspaces found.")
                sys.exit(0)

            selected_workspace = rofi_choose_workspace(workspaces, prompt=args.prompt)
            if not selected_workspace:
                sys.exit(0)

            switch_to_workspace(ipc, selected_workspace)


        if __name__ == "__main__":
            main()
      '')
    ];
  };
}
