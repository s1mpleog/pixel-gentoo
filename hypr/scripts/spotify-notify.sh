#!/usr/bin/env bash

# Config
ICON="/home/s1mple/.config/mako/heart.png" # your pixel purple heart
URGENCY_NORMAL="normal"
URGENCY_LOW="low"

function send_notif() {
  makoctl dismiss -a >/dev/null 2>&1
  notify-send \
    -u "$2" \
    -a "Spotify" \
    -i "$ICON" \
    "$1" \
    "$3"
}

# Main loop using --follow (playerctl 2.x+)
playerctl --player=spotify --follow metadata 2>/dev/null | while read -r line; do
  # Extract on new track (xesam:title changes most reliably)
  if [[ "$line" =~ xesam:title ]]; then
    artist=$(playerctl --player=spotify metadata artist 2>/dev/null || echo "Unknown")
    title=$(playerctl --player=spotify metadata title 2>/dev/null || echo "Unknown")
    album=$(playerctl --player=spotify metadata album 2>/dev/null || echo "")

    msg="$artist — $title"
    [[ -n "$album" ]] && msg="$msg\n<i>$album</i>"

    send_notif "Now Playing" "$URGENCY_NORMAL" "$msg"
  fi
done &

# Handle playback status changes separately (another follow)
playerctl --player=spotify --follow playback-status 2>/dev/null | while read -r status; do
  case "$status" in
  Playing) send_notif "Spotify" "$URGENCY_LOW" "▶ Playing" ;;
  Paused) send_notif "Spotify" "$URGENCY_LOW" "⏸ Paused" ;;
  Stopped) send_notif "Spotify" "$URGENCY_LOW" "⏹ Stopped" ;;
  esac
done &

wait # Keep script alive
