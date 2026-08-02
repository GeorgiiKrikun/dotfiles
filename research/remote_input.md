# Remote Input & Wayland Compositor Research

Research on getting remote input (specifically **KDE Connect**, for controlling a
Raspberry Pi) working under Wayland, and whether it's worth switching compositors
away from Hyprland. Date: 2026-08-02.

## TL;DR / Decision

- KDE Connect remote input does **not** work out of the box on **either Hyprland
  or Sway** — same root cause on both.
- It's fixable on **both** via a portal bridge shim (no compositor switch needed).
- Therefore this alone is **not a reason to leave Hyprland**. Decided to defer the
  fix for now; revisit later if remote input becomes needed.

## The core problem

KDE Connect's remote-input feature uses the `org.freedesktop.portal.RemoteDesktop`
portal on Wayland. But the wlroots-style portal backends —
`xdg-desktop-portal-wlr` (Sway) and `xdg-desktop-portal-hyprland` — expose
screenshot / screencast / global-shortcuts but **do not implement the
RemoteDesktop input interface**. So remote input is broken by default on both.

Tracked upstream:
- https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/344
- https://github.com/hyprwm/Hyprland/issues/1775
- https://forum.endeavouros.com/t/no-remote-input-with-kdeconnect/43167

## The fix (when we get to it)

A portal bridge shim fills the missing RemoteDesktop backend and injects events via
`zwlr_virtual_pointer_v1` + `zwp_virtual_keyboard_v1`. Works on wlroots-compatible
compositors (sway, river, wayfire, labwc, phosh, niri) **and Hyprland**.

- https://github.com/iamnarayana/wayland-kdeconnect-fix  (Hyprland, niri, others)
- https://github.com/gfhdhytghd/hypr-kdeconnect-fix       (Hyprland)

Setup involves `portals.conf` routing to forward RemoteDesktop calls to the bridge,
which then starts virtual input devices.

**Future-proofing note:** KDE Connect 26.04+ prefers `ConnectToEIS` (libei) on
Wayland. libei is the direction the whole ecosystem is migrating to, so the bridge
may become unnecessary once portal backends adopt libei natively.

## wayvnc — the one genuine Sway-only win

Full remote *desktop* (not just KDE Connect input) via `wayvnc` runs only on
wlroots-based compositors (Sway, River). It does **not** support Hyprland, because
Hyprland forked off wlroots in 2024 for its own Aquamarine backend. This is a real
architectural difference — but it's about wayvnc specifically, NOT KDE Connect.

## Compositor comparison (context for the decision)

Current versions: Hyprland 0.55 (2026-05-09), Sway 1.10.

| Feature                       | Hyprland 0.55            | Sway 1.10                 |
|-------------------------------|--------------------------|---------------------------|
| Base                          | Own compositor/Aquamarine (forked wlroots 2024) | wlroots reference |
| Config format                 | `hyprland.conf`; Lua new on 0.55 | i3 text syntax    |
| KDE Connect remote input      | Broken by default; bridge fix exists | Broken by default; bridge fix exists |
| wayvnc remote desktop         | ❌ Not supported         | ✅ Supported              |
| Portal backend                | xdg-desktop-portal-hyprland | xdg-desktop-portal-wlr |
| HDR                           | ✅ Auto-switch (0.55)    | ✅ (Vulkan renderer)      |
| VRR                           | ✅ Best-in-class, per-monitor | ✅ adaptive_sync on   |
| Tearing (game latency)        | ✅                       | ✅                        |
| Animations / blur / shadows   | ✅ Rich                  | ❌ None                   |
| Plugin system                 | ✅ C++ plugin API        | ❌ External tools only    |
| Stability                     | ⚠️ Occasional regressions | ✅ Longest track record  |
| Scrolling tiling              | ✅ Unique feature        | ❌                        |
| Memory                        | 80–120 MB               | 40–60 MB                  |

### Notes for a Raspberry Pi
Sway is independently the better fit on a Pi: ~40–60 MB vs Hyprland's ~80–120 MB
and much lighter on the GPU. If a compositor switch happens for the Pi anyway, KDE
Connect will still need the bridge there too.

## Why Hyprland is more popular than Sway (context)
Visual polish out of the box (blur/animations), ricing/screenshot culture momentum,
batteries-included ecosystem (hypridle/hyprlock/hyprpaper), fast charismatic dev.
The same feature-first culture is *why* its protocol coverage lags — which is the
root of the remote-input gap.

## Sources
- https://github.com/iamnarayana/wayland-kdeconnect-fix
- https://github.com/gfhdhytghd/hypr-kdeconnect-fix
- https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/344
- https://github.com/hyprwm/Hyprland/issues/1775
- https://forum.endeavouros.com/t/no-remote-input-with-kdeconnect/43167
- https://botmonster.com/self-hosting/hyprland-vs-sway-vs-cosmic-wayland-compositors/
- https://stackademic.com/blog/remote-desktop-on-wayland-in-2025-what-changed-for-linux-support-engineers
- https://www.fosslinux.com/158237/linux-remote-desktop-rdp-vnc-wayland.htm
- https://linuxiac.com/hyprland-0-47-lands-with-hdr-support-and-squircles/
- https://www.phoronix.com/news/Hyprland-HDR-Color-Management
