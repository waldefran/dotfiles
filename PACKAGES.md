# Dotfiles Package Relationship Documentation

## Overview

This document describes how the packages in this dotfiles repository relate to each other, what they depend on, and how they form an integrated terminal/development environment.

**Platform:** Linux primary, Windows secondary
**Terminal Emulator:** Wezterm
**Package Manager:** GNU Stow

---

## Architecture Summary

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER INTERFACE                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────┐     ┌───────────┐     ┌─────────────────────┐    │
│  │ Wezterm  │────▶│   Shell   │────▶│ Prompt (Starship)   │    │
│  │(Terminal)│     │(zsh/nu)   │     │ + Prompt (nushell)  │    │
│  └──────────┘     └───────────┘     └─────────────────────┘    │
│                          │                                       │
│         ┌────────────────┼────────────────┐                    │
│         ▼                ▼                ▼                     │
│  ┌───────────┐    ┌───────────┐    ┌───────────┐                │
│  │   tmux    │    │  zellij  │    │   nvim    │                │
│  │(multiplexer)   │(workspace)│    │   (editor)                │
│  └───────────┘    └───────────┘    └───────────┘                │
│                                                  │               │
│                          ┌────────────────────────┘               │
│                          ▼                                       │
│                   ┌───────────┐                                  │
│                   │  Atuin    │                                  │
│                   │ (history) │                                  │
│                   └───────────┘                                  │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                      SHELL INTEGRATIONS                         │
│                                                                 │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐             │
│  │  eza    │  │   fzf   │  │ zoxide  │  │ direnv  │             │
│  │  (ls)   │  │ (fuzzy) │  │  (cd)   │  │ (env)   │             │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Package Inventory

### Core Terminal Layer

#### 1. Wezterm (`wezterm/`)
**Purpose:** Terminal emulator - the application that provides terminal functionality

**Type:** Terminal emulator (cross-platform: Linux, Windows, macOS)

| Setting | Value | Notes |
|---------|-------|-------|
| Font | JetBrains Mono 16pt | Monospace programming font |
| Color Scheme | Catppuccin Mocha | Dark purple-tinted theme |
| Window Decorations | RESIZE | Native look with resize handles |
| Tab Bar | Disabled | Uses multiplexer tab management instead |

**Keybindings:**
| Key | Action |
|-----|--------|
| `Ctrl+q` | Toggle fullscreen |
| `Ctrl+'` | Clear scrollback |
| `Ctrl+click` | Open link at cursor |

**What it depends on:**
- JetBrains Mono font installed on the system
- No external tools required

**What it integrates with:**
- Any shell (zsh, bash, nushell, fish)
- Can run multiplexers (tmux, zellij) inside panes

**Replaces:** xterm, gnome-terminal, kitty, alacritty, terminal.app

---

### Shell Layer

#### 2. zsh (`zshrc/`)
**Purpose:** Primary shell configuration for zsh

**Files:**
- `.zshrc` - Main zsh configuration

**Integrations:**
| Tool | Purpose |
|------|---------|
| Starship | Prompt formatter |
| Zoxide | Directory jumping (cd replacement) |
| Atuin | Global shell history sync |
| Direnv | Environment variable management |
| FZF | Fuzzy finder for file/directory search |

**Environment Variables:**
```bash
export LANG=en_US.UTF-8
export EDITOR=nvim
export KUBECONFIG=~/.kube/config
export PATH=${HOME}/.opencode/bin:${HOME}/.local/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${GOPATH}/bin
export XDG_CONFIG_HOME="$HOME/.config"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
```

**Aliases (High-Value):**
| Alias | Command | Description |
|-------|---------|-------------|
| `l` | `eza -l --icons --git -a` | Modern ls replacement |
| `lt` | `eza --tree --level=2...` | Tree view |
| `v` | `nvim` | Editor shortcut |
| `cat` | `bat` | Cat with syntax highlighting |
| `gc` | `git commit -m` | Git commit |
| `gst` | `git status` | Git status |
| `ka` | `kubectl apply -f` | K8s apply |
| `kg` | `kubectl get` | K8s get |

**Tool Dependencies:**
- `eza` - Modern ls replacement
- `bat` - Cat replacement
- `fzf` - Fuzzy finder
- `fd` - Fast file finder (FZF backend)
- `sesh` - Tmux session manager (required by `t()`)
- `kubectl` - Kubernetes CLI
- `ngrok` - Tunneling

**Keybindings:**
| Binding | Action |
|---------|--------|
| `jj` | Enter vi-cmd-mode (escape) |
| `^L` | vi-forward-word |
| `^k` | up-line-or-search |
| `^j` | down-line-or-search |

**Custom Functions:**
```bash
cx() { cd "$@" && l; }               # Change dir + list
fcd() { cd "$(find ... | fzf)" && l; }  # Fuzzy cd
f() { echo "$(find ... | fzf)" | xclip; }  # Copy path
fv() { nvim "$(find ... | fzf)"; }   # Open in vim
t() { sesh list | fzf | sesh connect }  # Fuzzy tmux session picker (sesh)
```

---

#### 3. Nushell (`nushell/`)
**Purpose:** Alternative shell with structured data handling — default shell inside tmux

**Version:** 0.112.2 (installed at `~/.local/bin/nu`)

**Files:**
- `env.nu` - Environment variables, prompts, PATH
- `config.nu` - Main config, keybindings, aliases
- `vendor/autoload/wt.nu` - WezTerm integration (sets `TERM_PROGRAM`, exposes `wezterm-set-user-var`)

**Prompt Definition:**
- **Left Prompt:** Directory path (green, with `~` abbreviation)
- **Right Prompt:** Timestamp (magenta) + exit code (red if non-zero)

**PATH Additions:**
```nu
path add "/usr/local/bin"
path add ($env.HOME | path join ".turso")
path add ($env.HOME | path join ".local/share/mise/shims")
path add ($env.HOME | path join ".local/bin")
path add ($env.HOME | path join ".opencode/bin")
```

**Integrations:**
| Tool | Setup | Cache File | Required |
|------|-------|------------|---------|
| Starship | `starship init nu` | `~/.cache/starship/init.nu` | Yes |
| Zoxide | `zoxide init nushell` | `~/.zoxide.nu` | Yes |
| Atuin | Source init | `~/.local/share/atuin/init.nu` | Yes |
| Direnv | pre_prompt hook | N/A | Yes |
| Mise | `mise activate nu` | `~/.cache/mise/init.nu` | No — stub created if absent |
| Carapace | `carapace _carapace nushell` | `~/.cache/carapace/init.nu` | No — stub created if absent |

> `env.nu` automatically generates empty stubs for Mise and Carapace when the tools are not installed, so `config.nu` sources always succeed.

**Aliases (similar to zsh):**
- Git aliases: `gc`, `gca`, `gp`, `gst`, `glog`, etc.
- K8s aliases: `k`, `ka`, `kg`, `kd`, etc.
- General: `l`, `c`, `ll`, `lt`, `v`, `oc` (opencode), `asr` (atuin scripts run)

**vs zsh:** Nushell provides structured data pipelines, type-safe environment variables, and native completions via Carapace bridge. Set as `default-shell` in tmux.

---

### Prompt Layer

#### 4. Starship (`starship/`)
**Purpose:** Cross-shell prompt formatter

**File:** `starship.toml`

**Configuration:**
| Setting | Value |
|---------|-------|
| Format | `$directory$character` (left), `$all` (right) |
| Palette | catppuccin_mocha |
| Command Timeout | 1000ms |

**Active Modules:**
| Module | Format | Style | Symbol |
|--------|--------|-------|--------|
| directory | default | default | default |
| character | custom | bold green | `➜` |
| git_branch | custom | default | default |
| aws | custom | bold blue | `` |
| golang | custom | bold cyan | `` |
| kubernetes | disabled | varies | varies |

**Used by:**
- zsh (`eval "$(starship init zsh)"`)
- nushell (`starship init nu`)

**Catppuccin Mocha Palette Colors:**
```toml
rosewater = "#f5e0dc"
flamingo = "#f2cdcd"
pink = "#f5c2e7"
mauve = "#cba6f7"
red = "#f38ba8"
maroon = "#eba0ac"
peach = "#fab387"
yellow = "#f9e2af"
green = "#a6e3a1"
teal = "#94e2d5"
sky = "#89dceb"
sapphire = "#74c7ec"
blue = "#89b4fa"
lavender = "#b4befe"
text = "#cdd6f4"
subtext1 = "#bac2de"
subtext0 = "#a6adc8"
overlay2 = "#9399b2"
overlay1 = "#7f849c"
overlay0 = "#6c7086"
surface2 = "#585b70"
surface1 = "#45475a"
surface0 = "#313244"
base = "#1e1e2e"
mantle = "#181825"
crust = "#11111b"
```

**Replaces:** powerlevel10k, starship (default config), pure

---

### Workspace/Multiplexer Layer

#### 5. tmux (`tmux/`)
**Purpose:** Terminal multiplexer - multiple sessions, windows, panes

**Files:**
- `tmux.conf` - Main configuration
- `tmux.reset.conf` - First-stage keybindings (sourced first)
- `scripts/cal.sh` - Calendar/meeting integration (icalBuddy)
- `README.md` - Install instructions

**Plugins (via TPM):**
| Plugin | Purpose |
|--------|---------|
| `tmux-plugins/tpm` | Plugin manager |
| `tmux-plugins/tmux-sensible` | Sensible defaults |
| `tmux-plugins/tmux-yank` | Clipboard integration |
| `tmux-plugins/tmux-resurrect` | Save/restore sessions |
| `tmux-plugins/tmux-continuum` | Auto-restore on start |
| `fcsonline/tmux-thumbs` | Quick copy via thumbs |
| `sainnhe/tmux-fzf` | FZF integration |
| `wfxr/tmux-fzf-url` | URL picker with fzf |
| `omerxx/catppuccin-tmux` | Catppuccin theme |
| `omerxx/tmux-sessionx` | Fuzzy session picker |
| `omerxx/tmux-floax` | Floating panes |

**Prefix Key:** `Ctrl+a`

**Settings:**
| Option | Value | Notes |
|--------|-------|-------|
| `default-shell` | `~/.local/bin/nu` | Nushell in all new panes/windows |
| `default-terminal` | `tmux-256color` | Correct for WezTerm true color |
| `base-index` | `1` | Windows start at 1 |
| `status-position` | `top` | Status bar at top |

**Keybindings:**
| Binding | Action |
|---------|--------|
| `^C` | New window (home dir) |
| `s` | Split pane vertically (current path) |
| `v` | Split pane horizontally (current path) |
| `\|` | Split pane horizontally (current path) |
| `h/j/k/l` | Navigate panes |
| `H/L` | Previous/next window |
| `z` | Zoom/unzoom pane |
| `c` | Kill pane |
| `x` | Swap pane down |
| `*` | Toggle synchronize panes |
| `o` | tmux-sessionx (fuzzy session picker) |
| `p` | tmux-floax (floating pane) |
| `R` | Reload config |
| `K` | Clear pane |
| `^L` | Refresh client |
| `v` (copy-mode-vi) | Begin selection |
| `y` (copy-mode-vi) | Yank to clipboard (tmux-yank) |

**Features:**
- Nushell as default shell in all panes
- Vi-style copy mode
- 1M line scrollback
- Session persistence via resurrect + continuum auto-restore
- Catppuccin Mocha theme (omerxx fork) with powerline separators
- sessionx: zoxide-aware fuzzy session picker, custom path `~/.dotfiles`
- floax: floating panes with magenta border

**External Dependencies:**
- `fzf` (for sessionx, fzf-url, floax)
- `icalBuddy` (optional, for `scripts/cal.sh` calendar integration)

**Replaces:** screen, byobu

---

#### 6. Zellij (`zellij/`)
**Purpose:** Workspace manager / terminal multiplexer (alternative to tmux)

**Files:**
- `config.kdl` - Main configuration (320 lines)
- `themes/catppuccin.yaml` - Catppuccin themes (YAML)
- `themes/catppuccin.kdl` - Catppuccin themes (KDL)

**Keybindings Mode Overview:**
| Mode | Prefix | Purpose |
|------|--------|---------|
| Normal | default | General navigation |
| Pane | `Ctrl+a` | Pane management |
| Tab | `Ctrl+t` | Tab management |
| Resize | `Ctrl+n` | Resize panes |
| Scroll | `Ctrl+s` | Scroll/search |
| Tmux | `Ctrl+b` | tmux-compatible bindings |

**Key Pane Bindings:**
| Binding | Action |
|---------|--------|
| `h/j/k/l` | Move focus (returns to Normal) |
| `n` | New pane |
| `d` | New pane Down |
| `x` | Close pane |
| `z` | Toggle fullscreen |
| `w` | Toggle floating panes |

**Plugins (built-in):**
| Plugin | Purpose |
|--------|---------|
| `tab-bar` | Tab display |
| `status-bar` | Status display |
| `strider` | Strider plugin |
| `compact-bar` | Compact status |

**Themes:** Catppuccin family (latte, frappe, macchiato, mocha)
**Active Theme:** `catppuccin-mocha`

**Features:**
- Built-in floating panes
- Swap layouts (`Alt+[/]`)
- Session manager plugin (`Ctrl+x w`)
- tmux compatibility mode
- Simplified UI mode (no arrow fonts)

**vs tmux:**
| Aspect | Zellij | tmux |
|--------|--------|------|
| Config format | KDL (structured) | TMUX.conf (scripted) |
| Defaults | Sane defaults included | Very minimal |
| Plugins | Built-in plugin system | External TPM |
| Floating panes | Native support | Via tmux-floax plugin |
| Mouse support | Enabled by default | Disabled by default |
| Layouts | Built-in layout engine | Manual |

**Replaces:** tmux (alternative), screen, byobu

---

### Editor Layer

#### 7. Neovim (`nvim/`)
**Purpose:** Text editor / IDE

**File Structure:**
```
nvim/
├── init.lua              # Entrypoint
├── lua/config/
│   ├── lazy.lua          # lazy.nvim bootstrap
│   ├── options.lua       # Neovim options
│   ├── keymaps.lua       # Keybindings
│   └── autocmds.lua      # Autocommands
├── lua/plugins/
│   ├── conform.lua       # Conform.nvim formatter
│   ├── opencode.lua      # OpenCode AI plugin
│   ├── surround.lua      # Mini.surround
│   └── go.lua           # Go LSP config
├── lazyvim.json         # LazyVim extras
├── lazy-lock.json       # Plugin versions (50 plugins)
├── stylua.toml          # Lua formatter config
└── .neoconf.json        # Neoconf/LSP config
```

**Plugin Manager:** lazy.nvim with LazyVim base

**Key Plugins (50 total):**
| Plugin | Purpose |
|--------|---------|
| `blink.cmp` | Completion menu |
| `bufferline.nvim` | Buffer tabs |
| `catppuccin` | Theme |
| `conform.nvim` | Formatter (yamlfmt) |
| `flash.nvim` | Motion/search |
| `fzf-lua` | Fuzzy finder |
| `gitsigns.nvim` | Git status |
| `grug-far.nvim` | Git search/replace |
| `harpoon` | Quick file access |
| `lazyvim` | Base plugin collection |
| `lualine.nvim` | Status line |
| `mini.ai` | Text objects |
| `mini.files` | File explorer |
| `mini.surround` | Surround motions |
| `neo-tree.nvim` | File tree |
| `noice.nvim` | UI messages |
| `nvim-dap*` | Debugger (Go) |
| `nvim-lspconfig` | LSP config |
| `nvim-treesitter` | Syntax parsing |
| `opencode.nvim` | AI coding assistant |
| `persistence.nvim` | Session management |
| `todo-comments.nvim` | TODO highlighting |
| `tokyonight.nvim` | Theme |
| `trouble.nvim` | Diagnostics |
| `which-key.nvim` | Keybinding helper |

**Keybindings:**
| Binding | Action |
|---------|--------|
| `jj` / `jk` | Escape (insert mode) |
| `sa` | Add surround |
| `sd` | Delete surround |
| `gsf` | Find surround |
| `<leader>ot` | Toggle OpenCode embedded |
| `<leader>oa` | Ask about cursor |
| `<leader>oe` | Explain code |
| `<leader>on` | New session |

**LSP Servers (auto-installed via Mason):**
- `gopls` (Go)
- TypeScript
- YAML
- JSON
- Docker/Helm/Terraform

**External Dependencies:**
- `yamlfmt` - YAML formatter
- `stylua` - Lua formatter (via Mason)
- `shellcheck`, `shfmt` - Shell formatter

**Replaces:** vim, VSCode, IDE

---

### History Layer

#### 8. Atuin (`atuin/`)
**Purpose:** Global shell history sync and search

**File:** `config.toml`

**Features:**
| Setting | Value | Description |
|---------|-------|-------------|
| `style` | `"compact"` | UI style |
| `enter_accept` | `true` | Enter executes command |
| `sync.records` | `true` | Enable sync v2 records |
| `secrets_filter` | `true` | Auto-filter API keys |

**What it does:**
- Replaces default shell history with SQLite-backed searchable history
- Syncs history across machines (optional)
- Encrypts history (optional)
- Filters secrets automatically

**Used by:**
- zsh (`eval "$(atuin init zsh)"`)
- nushell (sourced from `~/.local/share/atuin/init.nu`)

**Replaces:** shell built-in history, fc, history

---

### Utility Packages

#### 9. Television (`television/`)
**Purpose:** Terminal UI picker/selector (fzf alternative)

**Files:**
- `config.toml` - Main configuration
- `cable/` - 49 channel definition files

**Configuration:**
| Setting | Value |
|---------|-------|
| Theme | `catppuccin` |
| Default Channel | `files` |
| Preview Panel Size | 65% |
| Orientation | `landscape` |

**Shell Integration Keybindings:**
| Binding | Channel |
|---------|---------|
| `ctrl-t` | Smart autocomplete |
| `ctrl-r` | Command history |

**Channels by Trigger:**
| Trigger Commands | Channel |
|-----------------|---------|
| `alias`, `unalias` | alias |
| `export`, `unset` | env |
| `cd`, `ls`, `rmdir`, `z` | dirs |
| `cat`, `less`, `head`, `tail`, `vim`, `cp`, `mv`, `rm` | files |
| `git add`, `git restore` | git-diff |
| `git checkout`, `git branch`, `git merge` | git-branch |
| `git log`, `git show` | git-log |
| `docker run` | docker-images |
| `nvim`, `code`, `hx`, `git clone` | git-repos |

**Notable Cable Channels:**
| Cable | Dependencies | Purpose |
|-------|--------------|---------|
| `git-repos.toml` | `fd`, `git` | Find local git repos |
| `k8s-contexts.toml` | `kubectl` | Switch K8s contexts |
| `gh-prs.toml` | `gh`, `jq` | View GitHub PRs |
| `docker-containers.toml` | `docker`, `jq` | Manage containers |
| `aws-profiles.toml` | `aws` | Switch AWS profiles |
| `files.toml` | `fd`, `bat` | File picker with preview |

**Replaces:** fzf (partially), rofi (partially)

---

#### 10. gh-dash (`gh-dash/`)
**Purpose:** GitHub CLI dashboard for PRs, issues, notifications

**File:** `config.yml`

**Sections:**
| Section | Items |
|---------|-------|
| PRs | My PRs, Needs Review, Involved |
| Issues | My Issues, Assigned, Involved |
| Notifications | All, Created, Participating, Mentioned, etc. |

**Keybindings:**
| Key | Action |
|-----|--------|
| `C` | Code review (opens opencode) |

**Dependencies:**
- `gh` - GitHub CLI
- `tmux` - For window spawning
- `lazygit` - Optional (for `g` keybinding)

**Replaces:** GitHub web UI (partially), `gh pr list`

---

#### 11. SSH (`ssh/`)
**Purpose:** SSH client configuration

**File:** `ssh-config`

**Global Defaults:**
```ssh-config
Host *
    SendEnv LANG LC_*
    MACs hmac-md5,hmac-sha1
    ForwardX11 no
    ForwardAgent yes
    AddressFamily inet
    ServerAliveInterval 15
    ConnectTimeout 20
```

**Bastion Host:**
```ssh-config
Host bastion
    User ec2-user
    Hostname bastion.domain.com
    IdentityFile ~/.ssh/id_rsa
```

**Replaces:** None (standard SSH config)

---

#### 12. OpenCode (`opencode/`)
**Purpose:** AI coding assistant configuration

**Files:**
- `opencode.json` - Core config
- `tui.json` - TUI keybindings
- `skills/ship/SKILL.md` - CI/CD skill
- `command/scan.md` - Scan command
- `command/build.md` - Build command
- `agent/*.md` - 6 agent definitions

**Core Config:**
```json
{
  "model": "opencode/kimi-k2.5",
  "autoupdate": true
}
```

**Agents:**
| Agent | Purpose |
|-------|---------|
| `tech-lead` | Orchestrates workflows, delegates |
| `architect-designer` | Architecture and design |
| `requirements-clarifier` | Transform vague requirements |
| `implementation-specialist` | Execute coding tasks |
| `test-automation-engineer` | Write/execute tests |
| `big-pickle-simple-tasks` | Decompose complex problems |

**Keybindings:**
| Leader | Binding | Action |
|--------|---------|--------|
| `ctrl+o` | Leader key | |
| | `<leader>e` | Open editor |
| | `<leader>t` | Theme list |
| | `<leader>s` | Status view |
| | `<leader>a` | Agent list |
| | `<leader>m` | Model list |

**Skills:**
- `ship` - Full CI/CD: commit, push, PR creation, review trigger

**Replaces:** GitHub Copilot (partial), Cursor (partial)

---

## Package Relationships

### Dependency Graph

```
wezterm
    │
    ├── zsh ────────┬──► starship
    │               ├──► zoxide
    │               ├──► atuin
    │               ├──► direnv
    │               ├──► fzf ───► fd
    │               ├──► eza
    │               ├──► bat
    │               └──► sesh ──► t() session picker
    │
    ├── nushell ────┬──► starship
    │  (tmux shell) ├──► zoxide
    │               ├──► atuin
    │               ├──► direnv (pre_prompt hook)
    │               ├──► carapace (optional, stub if absent)
    │               ├──► mise (optional, stub if absent)
    │               └──► wt.nu (WezTerm TERM_PROGRAM integration)
    │
    └── (tmux OR zellij) ───► nushell (default-shell)
              │
              ├──► tmux plugins: fzf, tmux-sessionx, tmux-floax
              └──► zellij plugins: tab-bar, status-bar

nvim ───► opencode.nvim (AI assistant)
    ├──► conform.nvim (formatter)
    ├──► nvim-dap (debugging)
    └──► Mason (LSP installers)

gh-dash ───► gh (GitHub CLI)
    └──► tmux (window spawning)

television ──┬──► fd
              ├──► git
              ├──► kubectl
              ├──► gh
              ├──► docker
              └──► aws
```

---

## What Replaces What

| Tool/Category | This Config Uses | Replaces |
|--------------|------------------|----------|
| Terminal Emulator | Wezterm | xterm, gnome-terminal, kitty, alacritty |
| Shell (tmux) | nushell 0.112.2 | bash, zsh inside tmux |
| Shell (terminal) | zsh | bash, dash |
| Prompt | Starship | powerlevel10k, pure, starship-default |
| Multiplexer | tmux + zellij (choose one) | screen, byobu |
| Session Picker | sesh + `t()` | tmux choose-session, tmux-sessionx |
| Editor | Neovim | vim, VSCode |
| File Picker | FZF + Television | fzf (standalone), rofi |
| History | Atuin | shell built-in history |
| Git UI | Neovim + gh-dash | git CLI, GitHub web |
| AI Assistant | opencode (`~/.opencode/bin`) | Copilot, Cursor |
| Kubernetes | kubectl + aliases | kubeconfig manual editing |
| Directory Jump | Zoxide | cd chains, autojump |

---

## Tool Dependencies Summary

### Required Tools (must be installed)

| Tool | Package | Purpose |
|------|---------|---------|
| Nushell | `~/.local/bin/nu` v0.112.2 | Default shell in tmux |
| Neovim | nvim | Editor |
| Starship | starship | Prompt |
| FZF | fzf | Fuzzy finder |
| eza | eza | Modern ls |
| bat | bat | Cat replacement |
| fd | fd | Fast file finder |
| zoxide | zoxide | Directory jump |
| atuin | atuin | Shell history |
| direnv | direnv | Env hooks |
| sesh | `~/.local/bin/sesh` v2.25.0 | Tmux session picker (zsh `t()`) |
| gh | github-cli | GitHub CLI |

### Optional Tools

| Tool | Used By | Purpose |
|------|---------|---------|
| kubectl | zsh + nushell aliases | Kubernetes CLI |
| icalBuddy | tmux/cal.sh | Calendar integration |
| lazygit | gh-dash | Git TUI |
| mise | nushell env.nu | Version manager (stub if absent) |
| carapace | nushell env.nu | Completions bridge (stub if absent) |
| ngrok | zsh aliases | Tunneling |
| nmap | zsh aliases | Network scanning |
| gobuster | zsh aliases | Web busting |
| ffuf | zsh aliases | Fuzzing |

### Language Servers (auto-installed via Mason)

- `gopls` (Go)
- TypeScript
- YAML
- JSON
- Docker/Helm/Terraform

### Formatters (auto-installed via Mason)

- `stylua` (Lua)
- `yamlfmt` (YAML)
- `shellcheck` + `shfmt` (Shell)

---

## Platform Notes

### Linux Primary
- All packages work on Linux
- Standard XDG paths (`~/.config`)
- Wayland/X11 clipboard integration

### Windows Secondary
- Wezterm works on Windows
- Television supports Windows paths (`%LocalAppData%`)
- SSH config is cross-platform
- Some nushell integrations may need adjustment

### Removed (macOS-only)
- aerospace (window manager)
- hammerspoon (automation)
- karabiner (keyboard)
- sketchybar (menu bar)
- skhd (hotkey daemon)
- nix-darwin (Nix macOS)
- kindavim (Vim macOS)
- ghostty (terminal)
- nix (Nix Linux)

---

## Installation

```bash
# Apply symlinks
stow .

# Install tmux plugins (inside tmux)
Ctrl+I

# Fonts (install JetBrains Mono)
# Linux: fc-cache -fv or font-manager
# Or: mkdir -p ~/.local/share/fonts && cp JetBrainsMono.ttf ~/.local/share/fonts/
```

---

## Quick Reference: Key Aliases

```bash
# Navigation
l          # eza -l --icons --git -a (ls)
lt         # eza --tree (tree view)
cx <dir>   # cd + l
fcd        # fuzzy cd
fv         # fuzzy open in nvim

# Tmux sessions
t          # fuzzy session picker via sesh (fzf popup)
t <name>   # attach or create session by name

# Git
gc "msg"   # git commit -m
gst        # git status
glog       # colored log graph
gdiff      # git diff
gp         # git push origin HEAD

# Kubernetes
ka <file>  # kubectl apply -f
kg         # kubectl get
kd         # kubectl describe
kl         # kubectl logs -f
ke         # kubectl exec -it

# General
v          # nvim
cat        # bat
oc         # opencode
http       # xh (HTTP client)
nm         # nmap scan
```
