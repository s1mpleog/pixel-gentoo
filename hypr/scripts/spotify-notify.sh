#!/usr/bin/dash

# Your config
ICON="$HOME/.config/mako/heart.png" # or full path
PLAYER="spotify"
LAST_TITLE=""
CHECK_INTERVAL=3 # seconds - lower = more responsive, but slightly more CPU

while true; do
  # Get current status and metadata (quick & safe)
  status=$(playerctl --player="$PLAYER" playback-status 2>/dev/null || echo "Stopped")
  title=$(playerctl --player="$PLAYER" metadata title 2>/dev/null || echo "")

  # New track? Send full "Now Playing"
  # POSIX equivalent of [[ "$title" != "$LAST_TITLE" && -n "$title" ]]
  if [ "$title" != "$LAST_TITLE" ] && [ -n "$title" ]; then
    artist=$(playerctl --player="$PLAYER" metadata artist 2>/dev/null || echo "Unknown")
    album=$(playerctl --player="$PLAYER" metadata album 2>/dev/null || echo "")

    msg="$artist — $title"
    if [ -n "$album" ]; then
      msg="$msg
<i>$album</i>"
    fi

    makoctl dismiss -a >/dev/null 2>&1
    notify-send -u normal -a "Spotify" -i "$ICON" "Now Playing" "$msg"
    LAST_TITLE="$title"
  fi

  # Handle playback status changes (simple icons)
  case "$status" in
  Playing)
    notify-send -u low -a "Spotify" -i "$ICON" "Spotify" "▶ Playing"
    ;;
  Paused)
    notify-send -u low -a "Spotify" -i "$ICON" "Spotify" "⏸ Paused"
    ;;
  Stopped)
    # Optional:
    # notify-send -u low -a "Spotify" -i "$ICON" "Spotify" "⏹ Stopped"
    ;;
  esac

  sleep "$CHECK_INTERVAL"
done
