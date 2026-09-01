{
  libnotify,
  pulseaudio,
  writeShellScriptBin,
}:
writeShellScriptBin "volume-notify" ''
  case "$1" in
    up)   ${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    down) ${pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
    mute) ${pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    *)    echo "Usage: volume-notify up|down|mute" >&2; exit 1 ;;
  esac

  percent=$(${pulseaudio}/bin/pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -n1 | tr -d '%')
  if ${pulseaudio}/bin/pactl get-sink-mute @DEFAULT_SINK@ | grep -q yes; then
    icon=audio-volume-muted
    body="Muted ($percent%)"
    value=0
  elif [ "$percent" -ge 70 ]; then
    icon=audio-volume-high
    body="$percent%"
    value=$percent
  elif [ "$percent" -ge 30 ]; then
    icon=audio-volume-medium
    body="$percent%"
    value=$percent
  else
    icon=audio-volume-low
    body="$percent%"
    value=$percent
  fi

  ${libnotify}/bin/notify-send -u low -t 600 \
    -c volume \
    -i "$icon" \
    -h string:x-dunst-stack-tag:volume \
    -h int:value:"$value" \
    "Volume" "$body"
''
