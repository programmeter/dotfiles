# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
import psutil
from pathlib import Path

from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# ** SETTINGS **
# Mod keys
mod = "mod4"
mod1 = "mod1"
# Colors
color_bg = "#191816"
color_fg = "#e2d7cc"
color_inactive = "#262320"
color_accent = "#5b7b85"
color_alert = "#c27b62"
# Default programs
session = "xfce4-session"
settingsd = "xfsettingsd"
notification_manager = "dunst"
terminal = "alacritty"
web_browser = "firefox"
file_manager = "thunar"
run_launcher = "rofi -show drun"
pwd_manager = "/opt/Enpass/enpass"
game_launcher = "steam"

@hook.subscribe.startup_once
def autostart():
    script = Path("~/.config/qtile/autostart.sh").expanduser()
    subprocess.run([script])

def_layout_theme = {
                    "border_width":2,
                    "border_focus":color_accent,
                    "border_normal":color_bg,
                    "margin":7
                   }

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "a", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "d", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "s", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "w", lazy.layout.up(), desc="Move focus up"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, mod1], "a", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, mod1], "d", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, mod1], "s", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, mod1], "w", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "shift"], "a", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "shift"], "d", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "shift"], "s", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "shift"], "w", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, mod1], "c", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod, mod1],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, mod1], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, mod1], "q", lazy.spawn(os.path.expanduser("~/.scripts/power_menu.sh")), desc="Display power menu"),
    Key([mod], "x", lazy.spawn(run_launcher), desc="Spawn run launcher"),
    Key([mod], "b", lazy.spawn(web_browser), desc="Spawn web browser"),
    Key([mod], "f", lazy.spawn(file_manager), desc="Spawn file manager"),
    Key([mod], "p", lazy.spawn(pwd_manager), desc="Spawn password manager"),
    Key([mod], "g", lazy.spawn(game_launcher), desc="Spawn game launcher"),
    Key([], "print", lazy.spawn(os.path.expanduser("~/.scripts/screenshot_menu.sh")), desc="Show screenshot menu"),
    Key([mod, mod1], "l", lazy.spawn(os.path.expanduser("~/.scripts/autolock_toggle.sh")), desc="Toggle autolocker program")
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.MonadTall(**def_layout_theme),
    # layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadWide(**def_layout_theme),
    # layout.RatioTile(),
    layout.Tile(**def_layout_theme),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="JetBrains Mono Nerd Font",
    foreground=color_fg,
    fontsize=14,
    padding=7
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.TextBox(fmt=" [", foreground=color_inactive, padding=0),
                widget.GroupBox(
                    active=color_fg,
                    inactive=color_fg,
                    margin_x=0,
                    hide_unused=True,
                    highlight_method="text",
                    highlight_color=color_bg,
                    this_current_screen_border=color_accent,
                    urgent_alert_method="text",
                    urgent_text=color_alert
                ),
                widget.TextBox(fmt="] [", foreground=color_inactive, padding=0),
                widget.CurrentLayout(
                    fmt=" {}",
                    foreground=color_alert
                ),
                widget.TextBox(fmt="] [", foreground=color_inactive, padding=0),
                widget.WindowName(
                    fmt="<span color='#5b7b85'></span> {}",
                    max_chars=39,
                    width=bar.CALCULATED,
                    empty_group_string="No window selected"
                ),
                widget.TextBox(fmt="]", foreground=color_inactive, padding=0),
                widget.Spacer(length=bar.STRETCH),
                widget.TextBox(fmt="[", foreground=color_inactive, padding=0),
                widget.Clock(
                    fmt="<span color='#5b7b85'></span> {}",
                    format="%H:%M %a %b %d, %Y"
                ), 
                widget.TextBox(fmt="]", foreground=color_inactive, padding=0),
                widget.Spacer(length=bar.STRETCH),
                widget.TextBox(fmt="[", foreground=color_inactive, padding=0),
                widget.KeyboardLayout(
                    fmt="<span color='#5b7b85'> </span> {}",
                    configured_keyboards=["us", "rs latinyz", "rs"],
                    option="caps:super",
                    display_map={
                        "rs latinyz":"RS (Latin)"
                    }
                ),
                widget.TextBox(foreground=color_inactive, fmt="/", padding=0),
                widget.Volume(
                    fmt="<span color='#5b7b85'>󰕾</span> {}",
                    step=5
                ),
                widget.TextBox(foreground=color_inactive, fmt="/", padding=0),
                widget.CPU(
                    fmt="<span color='#5b7b85'></span> {}",
                    format="{load_percent}%",
                ),
                widget.TextBox(foreground=color_inactive, fmt="/", padding=0),
                widget.Memory(
                    fmt="<span color='#5b7b85'></span> {}",
                    format="{MemUsed:.1f}{mm}",
                    measure_mem="G"
                ),
                widget.TextBox(foreground=color_inactive, fmt="/", padding=0),
                widget.DF(
                    fmt="<span color='#5b7b85'></span> {}",
                    format="{f}{m}",
                    partition="/home",
                    measure="G",
                    visible_on_warn=False
                ),
                widget.TextBox(foreground=color_inactive, fmt="/", padding=0),
                widget.CheckUpdates(
                    distro='Fedora',
                    colour_no_updates=color_fg,
                    colour_have_updates=color_alert,
                    display_format=" {updates}",
                    no_update_string="<span color='#5b7b75'></span> 0"
                ),
                widget.TextBox(fmt="] [", foreground=color_inactive, padding=0),
                widget.GenPollCommand(
                    cmd=os.path.expanduser("~/.scripts/autolock_status.sh"),
                    update_interval=1
                ),
                widget.GenPollCommand(
                    cmd=os.path.expanduser("~/.scripts/vpn_indicator.sh"),
                    update_interval=5
                ),
                widget.GenPollCommand(
                    cmd=os.path.expanduser("~/.scripts/check_connection.sh"),
                    update_interval=5
                ),
                widget.TextBox(fmt="] [", foreground=color_inactive, padding=0),
                widget.TextBox(
                    fmt="",
                    foreground="#5b7b85",
                    padding=15,
                    mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(os.path.expanduser("~/.scripts/power_menu.sh"))}
                ),
                widget.Spacer(length=2),
                widget.TextBox(fmt="] ", foreground=color_inactive, padding=0)
            ],
            26,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
            background="#191816",
            #margin=[5, 7, 0, 7]
        ),
        wallpaper="~/.local/share/wallpapers/wallpaper.jpg",
        wallpaper_mode="stretch"
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        #x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    **def_layout_theme
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
