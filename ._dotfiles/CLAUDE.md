# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles and machine provisioning scripts. Not a software project — there are no builds, tests, or linters. The repo contains:

- `osx_bootstrap/` — automated macOS setup (the primary, actively maintained part)
- Markdown runbooks for other environments (Raspberry Pi, VMware, GL.iNET routers) — these are rough notes, not polished docs

## macOS bootstrap

Run `./osx_bootstrap/setup.sh` to provision a new Mac. It sources each script in `osx_bootstrap/scripts/` sequentially via `run_step()`. Scripts are idempotent — they check current state before making changes.

Key conventions:
- Scripts use `set -uo pipefail` (setup.sh) or `set -e` (individual scripts). Failures are warnings, not fatal — the runner continues and reports a count at the end.
- Interactive prompts (`read -p`) are used for hostname, timezone, and pre-setup confirmation. Don't add `set -e` to scripts that use `read`.
- Packages go in `osx_bootstrap/Brewfile`. The bootstrap installs everything via `brew bundle`.
- Runtime versions (Python, Node, Go) are managed by **mise**, not brew. Python packages are managed by **uv**.
- LaunchAgents are installed to `~/Library/LaunchAgents/` for persistent config (keyboard remapping, maintenance checks).
- iTerm2 profile settings use direct plist manipulation via python3/plistlib because PlistBuddy can't handle keys containing colons. App-level settings use `defaults write`.

## `mbp` command

`~/bin/mbp` is the day-to-day CLI for managing this setup. Zsh completions are in `~/.zsh/robs/mbp.zsh`.

- `mbp brew list` — print all packages from the Brewfile
- `mbp brew install [--cask] <pkg>...` — add to Brewfile (under `# CLI tools` or `# Cask apps` header) and `brew bundle`. Auto-detects casks if `--cask` is omitted.
- `mbp brew remove <pkg>...` — remove from Brewfile and `brew uninstall`
- `mbp dfs <git-cmd>` — run git against the bare dotfiles repo (`~/.dotfiles`, work tree `$HOME`)
- `mbp dfs up` — stage tracked changes, commit "updated", push
- `mbp status` — dotfiles repo status + Brewfile summary
- `mbp claude` — open Claude Code in `._dotfiles/`

When adding Brewfile entries programmatically, match the existing pattern: insert after the section header comment using `sed`, not append to end of file.

## Zsh config

Zsh modules live in `~/.zsh/robs/*.zsh` — one file per tool/topic, all sourced automatically by `~/.zsh/zshrc`. When asked to add shell config, create or edit a file in `~/.zsh/robs/`. Guard commands behind availability checks (e.g. `if (( $+commands[tool] ))`) so shells don't break when a tool isn't installed.

After making dotfile changes, offer to commit via `mbp dfs up` and let the user review or comment first. Always use `mbp dfs up` — the commit message is always "updated". New files must be added first with `mbp dfs add <file>...` since `mbp dfs up` only stages tracked files.

## Repo structure

This directory (`._dotfiles`) is part of a bare git repo at `~/.dotfiles` with `$HOME` as the work tree. The bare repo tracks dotfile configs (`.zshrc`, `.gitconfig`, etc.) scattered across `$HOME` as well as this `._dotfiles/` directory containing bootstrap scripts and runbooks. Use `install.sh` to checkout the bare repo on a fresh machine.
