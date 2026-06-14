# hyprland-rice

Personal Hyprland dotfiles, managed with **GNU Stow**. Dual-monitor setup with
unified Base16 theme switching across every app via [flavours](https://github.com/Misterio77/flavours).

## Layout

Each top-level dir is a Stow package whose tree mirrors `$HOME`. `stow <pkg>`
symlinks it into place (e.g. `mako/.config/mako/config` → `~/.config/mako/config`).

## Install

```bash
sudo pacman -S --needed stow
cd hyprland-rice
stow */          # link everything, or pick: stow hypr mako ironbar kitty ...
```

Then run a theme once to generate the flavours-managed color files:

```bash
~/.config/hypr/scripts/theme-switch.sh --set catppuccin-mocha
```

## Components

| Area | Tool | Package |
|------|------|---------|
| Compositor | Hyprland (dwindle, dual monitor) | `hypr/` |
| Status bar | **ironbar** (GTK4), themed via flavours | `ironbar/` |
| Notifications | mako | `mako/` |
| Launcher / menus | rofi | `rofi/` |
| Terminal | kitty | `kitty/` |
| File manager | **yazi** | (config in `~/.config/yazi`) |
| Lock screen | hyprlock | `hyprlock/` |
| Prompt | starship | `starship/` |
| System monitor | btop | `btop/` |
| Editor | neovim | `nvim/` |
| Shell | zsh | `zsh/` |
| Theming engine | flavours (Base16) | `flavours/` |

Monitors: **DP-2** (2560×1440, workspaces 1–5), **HDMI-A-1** (1920×1080, workspaces 6–10).

## Theme switching

```bash
~/.config/hypr/scripts/theme-switch.sh            # cycle to next
~/.config/hypr/scripts/theme-switch.sh --select   # rofi picker
~/.config/hypr/scripts/theme-switch.sh --set nord # specific theme
```

Bound to **Super+Shift+T**. Themes: `catppuccin-mocha`, `nord`, `tokyo-night-dark`,
`dracula`, `gruvbox-dark-medium`, `rose-pine`. A switch applies colors across ironbar,
mako, rofi, kitty, hyprlock, starship, btop, and neovim, and rotates the wallpaper.

## Wallpapers

Managed externally with [`awww`](https://github.com/) (an swww fork) and **not tracked
in git** (~350 MB). Stored at `~/.config/wallpapers/<theme>/`; the theme switcher picks
a random one per theme.

## Key packages

Wayland/Hyprland core: `hyprland`, `hyprlock`, `hyprpicker`, `mako`, `rofi`, `grim`,
`slurp`, `wl-clipboard`, `cliphist`, `xdg-desktop-portal-hyprland`,
`hyprland-preview-share-picker-git` (AUR).
Rice/theming: `flavours` (AUR), `ironbar`, `yazi`, `awww`, `kitty`, `starship`, `btop`,
`sddm` + `sddm-silent-theme` (AUR).

## Keybindings

See `hypr/.config/hypr/conf.d/keybindings.conf`, or press **Super+/** for the cheat sheet.
