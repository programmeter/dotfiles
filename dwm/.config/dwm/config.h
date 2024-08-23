/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int gappx     = 5;        /* gaps between windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int user_bh            = 25;        /* 0 means that dwm will calculate bar height, >= 1 means dwm will user_bh as bar height */
static const char *fonts[]          = { "JetBrains Mono Nerd Font:size=10" };
static const char dmenufont[]       = "JetBrains Mono Nerd Font:size=10";
static const char col_gray1[]       = "#232933";
static const char col_gray2[]       = "#2d3543";
static const char col_gray3[]       = "#d8dee9";
static const char col_gray4[]       = "#d8dee9";
static const char col_cyan[]        = "#4d6a8e";

static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan },
	[SchemeStatus]  = { col_gray3, col_gray1,  col_gray2 }, // Statusbar right {text,background,not used but cannot be empty}
	[SchemeTagsSel]  = { col_gray4, col_cyan,  col_cyan }, // Tagbar left selected {text,background,not used but cannot be empty}
	[SchemeTagsNorm]  = { col_gray3, col_gray1,  col_gray2 }, // Tagbar left unselected {text,background,not used but cannot be empty}
	[SchemeInfoSel]  = { col_gray3, col_gray2,  col_cyan }, // infobar middle  selected {text,background,not used but cannot be empty}
	[SchemeInfoNorm]  = { col_gray3, col_gray1, col_gray2 }, // infobar middle  unselected {text,background,not used but cannot be empty}
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

// LAYOUTS
static const float mfact     = 0.50; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "master/stack",     tile },    /* first entry is default */
	{ "floating", 	      NULL },
	{ "monocle",          monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|Mod1Mask,              KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

// AUTOSTART APPLICATIONS
static const char *const autostart[] = {
	"/bin/bash", "-c", "/home/defaultuser/.scripts/lock.sh", NULL,
	"xfce4-session", NULL,
	"xfsettingsd", NULL,
	// Uncomment if you want to lock on start
	//"/bin/bash", "-c", "/home/defaultuser/.scripts/lock.sh", NULL,
	"/bin/bash", "-c", "/home/defaultuser/.scripts/autolock-start.sh", NULL,
	// Disables screensaver, since that's handled by xautolock
	"xset", "s", "0", "0", "dpms", "0", "0", "0", NULL,
	// Set sleep lock
	"xss-lock", "--transfer-sleep-lock", "--", "/home/defaultuser/.scripts/lock.sh", NULL,
	// Set wallpaper
	"feh", "--bg-fill", "/home/defaultuser/.local/share/wallpapers/wallpaper.png", NULL,
	"picom", NULL,
	"dunst", NULL,
	"/bin/bash", "-c", "~/.scripts/kblayout.sh", NULL,
	"slstatus", NULL,
	"steam", "-silent", NULL,
	NULL
};


// COMMAND DEFINITIONS
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]	    = { "rofi", "-show", "drun" };
static const char *termcmd[]  	    = { "alacritty", NULL };
static const char *browsercmd[]     = { "firefox-esr" };
static const char *filemanagercmd[] = { "thunar", NULL };
static const char *gamecmd[] 	    = { "steam" };
static const char *quitcmd[]	    = { "/bin/bash", "-c", "/home/defaultuser/.scripts/power-menu.sh" };
static const char *scrshotcmd[]     = { "/bin/bash", "-c", "/home/defaultuser/.scripts/screenshot-menu.sh" };
static const char *vpntogglecmd[]   = { "pkexec", "/bin/bash", "-c", "/home/defaultuser/.scripts/vpn-toggle.sh" };
static const char *locktogglecmd[]  = { "/bin/bash", "-c", "/home/defaultuser/.scripts/autolock-toggle.sh" };

// KEYBINDINGS
static const Key keys[] = {
	// modifier                     key        function        argument
	{ MODKEY,                       XK_x,      spawn,          {.v = dmenucmd } },
	{ MODKEY|Mod1Mask,              XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,			XK_b,	   spawn,	   {.v = browsercmd } },
	{ MODKEY,			XK_f,	   spawn,	   {.v = filemanagercmd } },
	{ MODKEY,			XK_g,	   spawn,	   {.v = gamecmd } },
	{ MODKEY,                       XK_s,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_w,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_comma,  incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_period, incnmaster,     {.i = -1 } },
	{ MODKEY,			XK_q,	   focusmaster,	   {0} },
	{ MODKEY,                       XK_a,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_d,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_r,      view,           {0} },
	{ MODKEY|Mod1Mask,              XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_space,  cyclelayout,    {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY|Mod1Mask,              XK_f,      togglefullscr,  {0} },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|Mod1Mask,              XK_a,  	   tagmon,         {.i = -1 } },
	{ MODKEY|Mod1Mask,              XK_d,      tagmon,         {.i = +1 } },
	{ 0,				XK_Print,  spawn,	   {.v = scrshotcmd } },
	{ MODKEY|Mod1Mask,		XK_l,	   spawn, 	   {.v = locktogglecmd } },
	{ MODKEY|Mod1Mask,		XK_v,	   spawn, 	   {.v = vpntogglecmd } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|Mod1Mask,              XK_q,      spawn,          {.v = quitcmd} },
};

// WINDOW RULES
static Rule rules[] = {
	/* class      instance    title       tags mask     isfloating   monitor */
	{ NULL,       NULL,       NULL,       0,            False,       -1 },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

