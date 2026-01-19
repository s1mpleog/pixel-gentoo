#!/usr/bin/env python3

import gi
gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl, GLib
import subprocess

def send_notification(summary, body, urgency='normal', icon='spotify-client'):
    # Optional: clear old mako notifications
    subprocess.run(['makoctl', 'dismiss', '-a'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    # Use YOUR custom blue heart image here!
    custom_icon = '/home/s1mple/.config/mako/heart.png'
    
    subprocess.Popen([
        'notify-send',
        '-u', urgency,
        '-a', 'Spotify',
        '-i', custom_icon,
        summary,
        body
    ])

def on_metadata(player, metadata):
    if not metadata:
        return

    keys = metadata.keys()

    artist = 'Unknown'
    if 'xesam:artist' in keys and metadata['xesam:artist']:
        artist = metadata['xesam:artist'][0]  # take first artist

    title = 'Unknown'
    if 'xesam:title' in keys:
        title = metadata['xesam:title']

    album = ''
    if 'xesam:album' in keys:
        album = metadata['xesam:album']

    msg = f"{artist} — {title}"
    if album:
        msg += f"\n<i>{album}</i>"

    send_notification("Now Playing", msg, urgency='normal')

def on_playback_status(player, status):
    # status is string: "Playing", "Paused", "Stopped"
    if status == "Playing":
        send_notification("Spotify", "▶ Playing", urgency='low')
        # Metadata signal usually follows soon → full info comes
    elif status == "Paused":
        send_notification("Spotify", "⏸ Paused", urgency='low')
    elif status == "Stopped":
        send_notification("Spotify", "⏹ Stopped", urgency='low')

# Create player targeting spotify
player = Playerctl.Player(player_name='spotify')

# Connect the signals
player.connect('metadata', on_metadata)
player.connect('playback-status', on_playback_status)

# Optional initial status check (using property)
initial_status = player.props.playback_status
if initial_status == "Playing":
    send_notification("Spotify", "▶ Playing (already active)", urgency='low')
elif initial_status == "Paused":
    send_notification("Spotify", "⏸ Paused (already active)", urgency='low')

print("Spotify notification listener started...")
GLib.MainLoop().run()
