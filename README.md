# dotfiles

My terminal environment - configured for Linux with Wezterm, tmux/zellij, Neovim, and Nushell.

## Stack

```
Wezterm → (tmux | zellij) → (zsh | nushell) → Neovim
         └─→ Starship prompt
         └─→ Atuin (history)
         └─→ FZF + Television (pickers)
```

## Packages

| Package | Purpose |
|---------|---------|
| `wezterm/` | Terminal emulator |
| `tmux/` | Multiplexer (sessions, panes, windows) |
| `zellij/` | Alternative multiplexer with floating panes |
| `nvim/` | Editor + LSP + AI (opencode.nvim) |
| `zshrc/` | Zsh config with aliases, functions, completions |
| `nushell/` | Structured data shell |
| `starship/` | Cross-shell prompt |
| `atuin/` | Global searchable history |
| `television/` | Terminal picker (fzf alternative) |
| `gh-dash/` | GitHub PR/issue dashboard |
| `ssh/` | SSH client config |
| `opencode/` | AI coding assistant config |

## Highlights

- **Catppuccin Mocha** theme throughout
- **tmux** with sessionx, resurrect, and auto-restore
- **Neovim** with 50+ plugins: LSP, treesitter, flash.nvim, conform, AI
- **Dual shell**: zsh for speed, nushell for data pipelines
- **TV** picker with k8s contexts, AWS profiles, git repos channels

## Install

```bash
stow .
```

## Key Aliases

```bash
l        # eza -l --icons (modern ls)
v        # nvim
cx <dir> # cd + list
gc "msg" # git commit
ka       # kubectl apply -f
kg       # kubectl get
```

See [PACKAGES.md](PACKAGES.md) for full documentation.
