{
  python3,
  rofi,
  symlinkJoin,
  writeScriptBin,
}:
let
  python = python3.withPackages (ps: [ ps.i3ipc ]);

  windowSwitcher = writeScriptBin "i3-rofi-window-switcher" ''
    #!${python}/bin/python3
    """Select and focus an i3 window with rofi."""

    import argparse
    import subprocess
    import sys

    import i3ipc


    def icon_name(app_id, window_class, window_instance):
        for candidate in (app_id, window_class, window_instance):
            if candidate:
                return candidate.lower()
        return "application-x-executable"


    def rofi_line(label, icon, info):
        return f"{label}\0icon\x1f{icon}\0info\x1f{info}"


    def collect_windows(ipc, include_scratchpad):
        items = []
        for con in ipc.get_tree().leaves():
            if con.type not in ("con", "floating_con"):
                continue
            workspace = con.workspace()
            if not include_scratchpad and workspace and workspace.name == "__i3_scratch":
                continue

            app_id = con.app_id or ""
            window_class = con.window_class or ""
            window_instance = getattr(con, "window_instance", "") or ""
            title = con.name or ""
            label_parts = []
            if window_class or app_id:
                label_parts.append(window_class or app_id)
            if title:
                if label_parts:
                    label_parts.append("—")
                label_parts.append(title)
            label = " ".join(label_parts) or "<untitled window>"
            icon = icon_name(app_id, window_class, window_instance)
            items.append((rofi_line(label, icon, str(con.id)), con.id))
        return items


    def choose(lines, prompt):
        command = [
            "${rofi}/bin/rofi",
            "-dmenu",
            "-i",
            "-matching",
            "fuzzy",
            "-p",
            prompt,
            "-format",
            "i",
            "-show-icons",
        ]
        result = subprocess.run(
            command,
            input="\n".join(lines),
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=False,
        )
        selection = result.stdout.strip()
        return int(selection) if result.returncode == 0 and selection.isdigit() else -1


    def main():
        parser = argparse.ArgumentParser(
            description="Choose and focus an i3 window via rofi."
        )
        parser.add_argument("--include-scratchpad", action="store_true")
        parser.add_argument("--prompt", default="Windows")
        args = parser.parse_args()

        ipc = i3ipc.Connection()
        items = collect_windows(ipc, args.include_scratchpad)
        if not items:
            print("No windows found.")
            return

        index = choose([line for line, _ in items], args.prompt)
        if 0 <= index < len(items):
            ipc.command(f'[con_id="{items[index][1]}"] focus')


    if __name__ == "__main__":
        main()
  '';

  workspaceSwitcher = writeScriptBin "i3-rofi-workspace-switcher" ''
    #!${python}/bin/python3
    """Select, create, and switch to an i3 workspace with rofi."""

    import argparse
    import re
    import subprocess
    import sys

    import i3ipc


    def workspaces(ipc):
        result = []
        for workspace in ipc.get_workspaces():
            prefix = "⚠ " if workspace.urgent else ("● " if workspace.focused else "  ")
            result.append((workspace.name, f"{prefix}{workspace.name}"))

        def sort_key(item):
            match = re.match(r"^(\d+)", item[0])
            return (0, int(match.group(1)), item[0]) if match else (1, 0, item[0])

        result.sort(key=sort_key)
        return result


    def choose(items, prompt):
        command = [
            "${rofi}/bin/rofi",
            "-dmenu",
            "-i",
            "-matching",
            "fuzzy",
            "-p",
            prompt,
            "-format",
            "s",
        ]
        result = subprocess.run(
            command,
            input="\n".join(display for _, display in items),
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=False,
        )
        if result.returncode != 0:
            return None
        selection = result.stdout.strip()
        if not selection:
            return None
        for name, display in items:
            if selection == display:
                return name
        return selection.replace("● ", "").replace("⚠ ", "").lstrip()


    def main():
        parser = argparse.ArgumentParser(
            description="Choose and switch to an i3 workspace via rofi."
        )
        parser.add_argument("--prompt", default="Workspace")
        args = parser.parse_args()

        try:
            ipc = i3ipc.Connection()
        except Exception as error:
            print(f"Error connecting to i3: {error}", file=sys.stderr)
            sys.exit(1)

        items = workspaces(ipc)
        if not items:
            print("No workspaces found.")
            return
        selection = choose(items, args.prompt)
        if selection:
            ipc.command(f'workspace "{selection}"')
            print(f"Switched to workspace: {selection}")


    if __name__ == "__main__":
        main()
  '';
in
symlinkJoin {
  name = "i3-rofi-switchers";
  paths = [
    windowSwitcher
    workspaceSwitcher
  ];
}
