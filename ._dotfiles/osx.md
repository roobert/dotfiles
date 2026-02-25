# Workstation Setup

Automated macOS setup. Run `._dotfiles/osx_bootstrap/setup.sh` to configure a new machine.

## Usage

```bash
./._dotfiles/osx_bootstrap/setup.sh
```

## Pre-setup (manual)

The script will prompt you to do these first:

1. Open Mission Control (three-finger swipe up) and create desktops using the `+` button
2. Enable Input Monitoring for iTerm: System Settings > Privacy & Security > Input Monitoring, then restart iTerm

## What it does

Scripts run in order by `setup.sh`:

| Script | What it does |
|---|---|
| `pre-setup.sh` | Prompts for manual pre-setup steps |
| `hostname-timezone.sh` | Sets hostname (default: `mbp0`) and timezone (default: `Europe/London`) |
| `xcode-homebrew.sh` | Installs Xcode CLI tools and Homebrew |
| `brew-bundle.sh` | Installs all packages, apps, and fonts from `Brewfile` |
| `macos-defaults.sh` | System preferences (see below) |
| `keyboard-swap.sh` | Swaps §/` and Caps Lock/Escape via `hidutil` + LaunchAgent |
| `iterm2.sh` | iTerm2 theme, font, colours, keybindings, dynamic profile |
| `mission-control.sh` | Binds Ctrl+1..9 to switch desktops |
| `mise-setup.sh` | Installs Python, Node, Go via mise; sets `PIP_REQUIRE_VIRTUALENV` |
| `maintenance-launchd.sh` | Weekly launchd job that checks for outdated brew/mise packages |
| `fzf-setup.sh` | Installs fzf key bindings and completion |

## macOS defaults applied

- Reduce motion (no desktop switch animation)
- Disable smart quotes, smart dashes, double-space period
- Disable "natural" scrolling (traditional scroll direction)
- Menu bar clock: 24h with seconds (`EEE d MMM HH:mm:ss`)
- Chrome: disable swipe-to-navigate
- AltTab: show on current screen, hide minimised/hidden/fullscreen windows

## Packages installed (Brewfile)

**CLI tools:** coreutils, findutils, gnu-tar, gnu-sed, gawk, gnutls, gnu-indent, gnu-getopt, grep, wget, jq, fzf, ripgrep, graphviz, qemu, neovim, gh, gnupg, mise, uv, util-linux, libgit2

**Apps:** iTerm2, OrbStack, Slack, WhatsApp, iStat Menus, AltTab, gcloud CLI, Zoom

**Fonts:** Hack Nerd Font, JetBrains Mono Nerd Font

## Tool version management

- **mise** manages runtime versions (Python, Node, Go, etc.)
- **uv** manages Python packages and virtual environments
- `PIP_REQUIRE_VIRTUALENV=true` prevents accidental global pip installs
- Editor tooling (LSPs, linters, formatters) is managed by the editor, not brew

## Maintenance

A weekly launchd job checks for outdated brew and mise packages. If updates are found, it writes `~/.zsh_maintenance_required`. On next terminal open, `maintenance.zsh` prompts:

```
── updates available ──
mise:
python  3.14.3 -> 3.14.4

Run upgrades now? (N/y)
```

## Still manual

- Set up Aggregate Sound Device in Audio MIDI Setup
- Switch to Australian keyboard layout in System Settings
- `gh auth login`
