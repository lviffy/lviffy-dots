-- Custom configuration overrides
-- Modern, clean, minimal animations & UX improvements

hl.config({
    animations = {
        enabled = true,
    },
    decoration = {
        dim_inactive = true,
        dim_strength = 0.08,
    },
    dwindle = {
        smart_split = true,
    },
    misc = {
        enable_swallow = true,
        swallow_regex = "^(foot|kitty|alacritty|Alacritty)$",
    },
})

-- Modern, minimal bezier curves (no cartoon bounce/overshoot)
hl.curve("cleanDecel", {
    type = "bezier",
    points = {{0.05, 0.9}, {0.1, 1.0}}
})
hl.curve("cleanExit", {
    type = "bezier",
    points = {{0.2, 0.0}, {0.0, 1.0}}
})

-- Window open (subtle popin + smooth fade)
hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 2.5,
    bezier = "cleanDecel",
    style = "popin 88%"
})
hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = 2.0,
    bezier = "cleanDecel"
})

-- Window close (brisk, clean exit)
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 1.8,
    bezier = "cleanDecel",
    style = "popin 92%"
})
hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 1.6,
    bezier = "cleanDecel"
})

-- Tiling & window move / resize (smooth fluid transition between tile layouts)
hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = 2.4,
    bezier = "cleanDecel"
})

-- Workspaces (subtle 20% slide + crossfade, snappy and modern)
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 2.2,
    bezier = "cleanDecel",
    style = "slidefade 20%"
})
hl.animation({
    leaf = "specialWorkspaceIn",
    enabled = true,
    speed = 2.0,
    bezier = "cleanDecel",
    style = "slidefadevert 20%"
})
hl.animation({
    leaf = "specialWorkspaceOut",
    enabled = true,
    speed = 1.5,
    bezier = "cleanDecel",
    style = "slidefadevert 20%"
})

-- Layers & Popups (app launchers, quickshell, OSD, notifications)
hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 2.0,
    bezier = "cleanDecel",
    style = "popin 94%"
})
hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 1.5,
    bezier = "cleanDecel",
    style = "popin 94%"
})
hl.animation({
    leaf = "fadeLayersIn",
    enabled = true,
    speed = 1.8,
    bezier = "cleanDecel"
})
hl.animation({
    leaf = "fadeLayersOut",
    enabled = true,
    speed = 1.5,
    bezier = "cleanDecel"
})
