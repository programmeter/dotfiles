-- IMPORTS
import XMonad
import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.SpawnOnce
import XMonad.Layout.Spacing
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders
import XMonad.Util.Loggers
import XMonad.ManageHook
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Renamed
import XMonad.Util.Cursor

-- SETTINGS
display_connection      = "DP-2"
display_resolution      = "2560x1440"
display_refresh_rate    = "164.83"

mouse_name              = "SteelSeries SteelSeries Rival 3"
mouse_speed             = "-0.5"

backup_location         = "/media/martin/'Debian Backup'/home-backup/"

-- DEFAULT PROGRAMS
session                 = "xfce4-session"
settings_daemon         = "xfsettingsd"
compositor              = "picom --config ~/.config/picom/picom.conf"
notification_manager    = "dunst"
terminal                = "alacritty"
web_browser             = "firefox"
file_manager            = "thunar"
run_launcher            = "rofi -show drun"
password_manager        = "/opt/enpass/Enpass"
wallpaper_program       = "feh --bg-fill ~/.local/share/wallpapers/wallpaper.jpg"
lock_program            = "~/.scripts/lock.sh"
autolock_program        = "~/.scripts/start_xautolock.sh"

-- MAIN COMPONENTS
altMask = mod1Mask

main :: IO()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar ~/.config/xmobarrc" (pure xmobarOut)) toggleStrutsKey 
     $ customConfig
  where
    toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
    toggleStrutsKey XConfig{ modMask = m } = (m .|. altMask, xK_b)

-- HOOKS
customConfig = def
    { modMask               = mod4Mask,
      startupHook           = startupPrograms,
      layoutHook            = smartBorders $ layouts,
      manageHook            = windowRules,
      borderWidth           = 2,
      normalBorderColor     = "#191816",
      focusedBorderColor    = "#5b7b85"
    }
  -- KEYBINDINGS
  `additionalKeysP`
    [ ("M-S-<Return>",  spawn $ Main.terminal)
    , ("M-b",           spawn $ Main.web_browser)
    , ("M-f",           spawn $ Main.file_manager) 
    , ("M-x",           spawn $ Main.run_launcher)
    , ("M-p",           spawn $ Main.password_manager)
    , ("M-s",           spawn "steam")
    , ("M-C-p",         spawn "~/.scripts/power_menu.sh")
    , ("M-C-v",         spawn "pkexec ~/.scripts/vpn_toggle.sh")
    , ("<Print>",       spawn "~/.scripts/screenshot_menu.sh")
    , ("M-C-l",         spawn "~/.scripts/autolock_toggle.sh")
    ]

-- STARTUP APPLICATIONS
startupPrograms :: X ()
startupPrograms = do
  -- Locking programs
  spawnOnce $ Main.lock_program
  spawnOnce $ ("xss-lock --transfer-sleep-lock -- " ++ Main.lock_program)
  spawnOnce $ Main.autolock_program 
  spawnOnce $ "xset s 0 0 dpms 0 0 0"
  -- Settings & desktop programs
  spawnOnce $ Main.session
  spawnOnce $ Main.settings_daemon
  spawnOnce $ "pipewire"
  -- Picom is started in lock script, because of bug with i3lock
  --spawnOnce $ Main.compositor
  spawnOnce $ Main.notification_manager
  spawnOnce $ ("xinput set-prop '" ++ Main.mouse_name ++ "' 'libinput Accel Profile Enabled'  0, 1")
  spawnOnce $ ("xinput set-prop '" ++ Main.mouse_name ++ "' 'libinput Accel Speed' " ++ Main.mouse_speed)
  spawnOnce $ ("xrandr --output " ++ Main.display_connection ++ " --primary --mode " ++ Main.display_resolution ++ " rate " ++ display_refresh_rate)
  spawnOnce $ Main.wallpaper_program
  spawnOnce $ "xsetroot -cursor_name left_ptr"
  spawnOnce $ "setxkbmap -layout 'us,rs,rs' -variant ',latinyz,' -option 'grp:alt_shift_toggle'"
  spawnOnce $ ("rsync -r -t -v --progress --delete -s --update --exclude .steam/ --exclude Downloads --exclude .local/share/Trash ~ " ++ Main.backup_location)
  -- User programs
  spawnOnce $ "steam -silent"
  spawnOnce $ (Main.password_manager ++ " -minimize")

-- LAYOUTS
layouts = (renamed [Replace "master/stack"] $ spacingWithEdge 5 $ tiled) ||| (renamed [Replace "broad"] $ spacingWithEdge 5 $ Mirror tiled) ||| (renamed [Replace "fullscreen"] $ Full)
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1
    ratio   = 1/2
    delta   = 3/100

-- WINDOW RULES
windowRules :: ManageHook
windowRules = composeAll
    [ className =? "Gimp"       --> doCenterFloat
    , isDialog		            --> doCenterFloat
    , className =? "Galculator" --> doCenterFloat
    , isFullscreen              --> doFullFloat
    ]

-- XMOBAR OUTPUT
xmobarOut :: PP
xmobarOut = def
    { ppSep             = " "
    , ppTitleSanitize   = xmobarStrip
    , ppWsSep		    = "|"
    , ppCurrent         = xmobarBorder "Bottom" "#5b7b85" 2 . wrap "  " "  " . xmobarColor "#5b7b85" "" 
    , ppHidden          = xmobarColor "#e2d7cc" "" . wrap "  " "  "
    , ppTitle		    = wrap "[ " " ]" . xmobarColor "#e2d7cc" "" . shorten 50
    , ppLayout		    = wrap "[ " " ]" . xmobarColor "#c27b62" ""
    , ppOrder           = \[ws, l, t] -> [ws, l, t]
    }
  where
    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "Untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""
