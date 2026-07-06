#!/usr/bin/env bash
# Waybar custom module: indicate the focused window's fullscreen/maximized state.
# Hyprland's activewindow `fullscreen` field: 0 = none, 1 = maximized, 2 = fullscreen.
# Polled on an interval (no socat dependency).

json=$(hyprctl activewindow -j 2>/dev/null)
state=$(printf '%s' "$json" | jq -r '.fullscreen // 0' 2>/dev/null)
[ -z "$state" ] && state=0

case "$state" in
    1) printf '{"text":"MAX","tooltip":"Window maximized","class":"maximized"}\n' ;;
    *) printf '{"text":"","tooltip":"","class":"none"}\n' ;;
esac
