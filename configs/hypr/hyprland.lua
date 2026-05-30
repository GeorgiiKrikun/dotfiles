--###############
--## MONITORS ###
--###############

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "1",
})

--##################
--## AUTOSTART    ###
--##################

--############################
--## ENVIRONMENT VARIABLES ###
--############################

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

--####################
--## LOOK AND FEEL ###
--####################

hl.curve("easeOut", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 5,
    bezier = "easeOut",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 5,
    bezier = "default",
    style = "popin 80%",
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 8,
    bezier = "default",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 5,
    bezier = "default",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 4,
    bezier = "default",
})

local mainMod = "SUPER"
local terminal = "kitty"
local menu = "wofi --show run"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

hl.bind(mainMod .. " + I", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + U", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind(mainMod .. " + SHIFT + I", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "e-1" }))

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

hl.bind("Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim - | wl-copy"))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pamixer --default-source -t"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { locked = true, repeating = true })

hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 8,
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(88c0d0ff)", "rgba(81a1c1ff)" }, angle = 45 },
            inactive_border = "rgba(3b4252aa)",
        },
        layout = "dwindle",
        allow_tearing = false,
    },
    decoration = {
        rounding = 8,
        blur = {
            enabled = true,
            size = 4,
            passes = 2,
            vibrancy = 0.1696,
        },
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        enable_swallow = true,
        swallow_regex = "^(kitty)$",
    },
    --############
    --## INPUT ###
    --############
    input = {
        kb_layout = "us,ru",
        kb_options = "grp:win_space_toggle",
        follow_mouse = 1,
        sensitivity = 0,
        accel_profile = "flat",
        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.window_rule{
    name = "Zoom",
    match = {
        class = "[Zz]oom"
    },
    float = true,
    border_size = 10,
}

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("swww-daemon")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("bash -c \"sleep 10 && /home/georgii/software/dotfiles/configs/hypr/connect-headphones.sh\"")
end)


