# AGENTS

## What this repo is
- This is a GNU Stow-managed dotfiles repo; top-level folders are config packages (`nvim`, `tmux`, `wezterm`, `zellij`, `nushell`, `zshrc`, `opencode`, etc.).
- `opencode/` is part of the repo deliverable (custom OpenCode config, commands, agents, and skills), not generated output.

## Source-of-truth commands
- Apply symlinks from repo root with `stow .` (same as `./setup.sh`).
- `.stowrc` enforces `--target=~/.config` and ignores `.stowrc`, `DS_Store`, and `atuin/*`.
- tmux plugin manager is manual: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`, then in tmux run `Ctrl+I` to install plugins.

## Important wiring (easy to break)
- tmux loads in two stages: `tmux/tmux.conf` sources `tmux/tmux.reset.conf` first.
- Neovim entrypoint is `nvim/init.lua` -> `nvim/lua/config/lazy.lua`; local behavior changes live in `nvim/lua/plugins/*.lua`.

## Host-specific assumptions
- This repo is configured for Linux primary (wezterm terminal, tmux/zellij multiplexers).
- Windows support is secondary (wezterm, television picker).

## Edit conventions in this repo
- Lua style is controlled by `nvim/stylua.toml` (spaces, indent width 2, column width 120).
- Keep front matter blocks intact in OpenCode metadata files under `opencode/agent/*.md`, `opencode/command/*.md`, and `opencode/skills/*/SKILL.md`.
- There is no repo-wide CI/lint/test runner defined here; validate changes by reloading the affected tool directly.
