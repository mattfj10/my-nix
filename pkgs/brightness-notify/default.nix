{
  brightnessctl,
  libnotify,
  writeShellScriptBin,
}:
writeShellScriptBin "brightness-notify" ''
  case "$1" in
    up)   ${brightnessctl}/bin/brightnessctl -q set +5% ;;
    down) ${brightnessctl}/bin/brightnessctl -q set 5%- ;;
    *)    echo "Usage: brightness-notify up|down" >&2; exit 1 ;;
  esac

  current=$(${brightnessctl}/bin/brightnessctl get)
  max=$(${brightnessctl}/bin/brightnessctl max)
  percent=$((100 * current / max))
  ${libnotify}/bin/notify-send -t 600 \
    -h string:x-dunst-stack-tag:brightness \
    -h string:category:brightness \
    "Brightness" "$percent%"
''
