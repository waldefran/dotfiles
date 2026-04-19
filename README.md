# dotfiles

Terminal environment for Linux — WezTerm · tmux · zsh/nushell · Neovim · Starship · Catppuccin Mocha.

```
WezTerm → (tmux | zellij) → (zsh | nushell) → Neovim
                └─→ Starship prompt
                └─→ Atuin (history)
                └─→ FZF + Television (pickers)
```

---

## Dependencies

### Required

| Tool | Install | Purpose |
|------|---------|---------|
| [WezTerm](https://wezfurlong.org/wezterm/) | see below | Terminal emulator |
| [tmux](https://github.com/tmux/tmux) | `apt install tmux` | Multiplexer |
| [Neovim](https://neovim.io/) ≥ 0.10 | `apt install neovim` | Editor |
| [Starship](https://starship.rs/) | `curl -sS https://starship.rs/install.sh \| sh` | Prompt |
| [Zsh](https://www.zsh.org/) | `apt install zsh` | Primary shell |
| [eza](https://github.com/eza-community/eza) | `apt install eza` | Modern `ls` |
| [bat](https://github.com/sharkdp/bat) | `apt install bat` | Modern `cat` |
| [fd](https://github.com/sharkdp/fd) | `apt install fd-find` | Fast file find |
| [fzf](https://github.com/junegunn/fzf) | `apt install fzf` | Fuzzy finder |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh \| sh` | Smart `cd` |
| [atuin](https://github.com/atuinsh/atuin) | `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh \| sh` | Shell history |
| [direnv](https://direnv.net/) | `apt install direnv` | Env hooks |
| [GNU Stow](https://www.gnu.org/software/stow/) | `apt install stow` | Symlink manager |
| [JetBrains Mono Nerd Font](https://www.nerdfonts.com/) | see below | Icons in terminal |
| [gh](https://cli.github.com/) | `apt install gh` | GitHub CLI |

### Optional

| Tool | Purpose |
|------|---------|
| [Nushell](https://www.nushell.sh/) | Structured data shell (dual-shell setup) |
| [Zellij](https://zellij.dev/) | Alternative multiplexer |
| [Television](https://github.com/alexpasmantier/television) | Advanced fuzzy picker |
| [mise](https://mise.jdx.dev/) | Runtime version manager |
| [carapace](https://carapace.sh/) | Shell completions bridge |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI |
| [xh](https://github.com/ducaale/xh) | HTTP client (`http` alias) |
| [kubectl](https://kubernetes.io/docs/tasks/tools/) | Kubernetes CLI |

---

## Install

### 1. Clone the repo

```bash
git clone https://github.com/waldefran/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Install JetBrains Mono Nerd Font

```bash
mkdir -p ~/.local/share/fonts
cd /tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
tar -xf JetBrainsMono.tar.xz -C ~/.local/share/fonts/
fc-cache -fv
```

### 3. Install WezTerm

```bash
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update && sudo apt install wezterm
```

### 4. Apply symlinks with Stow

```bash
cd ~/.dotfiles
stow .
```

This links all packages into `~/.config/`. The `.stowrc` file sets the target automatically.

> **Note:** `~/.zshrc` needs a direct link (stow puts the zshrc package at `~/.config/zshrc`):
> ```bash
> ln -sf ~/.dotfiles/zshrc/.zshrc ~/.zshrc
> ```

### 5. Set Zsh as default shell

```bash
chsh -s $(which zsh)
```

Log out and back in, then open a new terminal.

### 6. Install tmux plugins

```bash
# Clone TPM (if not already present)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install all plugins headlessly
~/.tmux/plugins/tpm/bin/install_plugins
```

Or inside a running tmux session: `Prefix + I` (`Ctrl+a I`).

### 7. Install Neovim plugins

Open Neovim — lazy.nvim bootstraps automatically and installs all plugins on first launch:

```bash
nvim
```

### 8. (Optional) Set Nushell as secondary shell

```bash
# Install Nushell
sudo apt install nushell   # or: cargo install nu

# Nushell config is already linked via stow at ~/.config/nushell/
# Start nushell manually or add it to WezTerm as an alternate shell
nu
```

---

## Packages

| Package | Stow Target | Purpose |
|---------|-------------|---------|
| `wezterm/` | `~/.config/wezterm/` | Terminal emulator — Catppuccin Mocha, JetBrains Mono |
| `tmux/` | `~/.config/tmux/` | Multiplexer — sessionx, resurrect, floax, catppuccin |
| `zellij/` | `~/.config/zellij/` | Alternative multiplexer |
| `nvim/` | `~/.config/nvim/` | Editor — LazyVim, 50+ plugins, AI via opencode.nvim |
| `zshrc/` | `~/.config/zshrc/` | Zsh aliases, functions, completions |
| `nushell/` | `~/.config/nushell/` | Structured data shell |
| `starship/` | `~/.config/starship/` | Cross-shell prompt |
| `atuin/` | `~/.config/atuin/` | Searchable encrypted shell history |
| `television/` | `~/.config/television/` | Fuzzy picker with 49 channels |
| `gh-dash/` | `~/.config/gh-dash/` | GitHub PR/issue dashboard |
| `ssh/` | `~/.config/ssh/` | SSH client config |
| `opencode/` | `~/.config/opencode/` | AI coding assistant config + agents + skills |

---

## Highlights

- **Catppuccin Mocha** — consistent theme across WezTerm, tmux, Neovim, Starship, Zellij
- **tmux** — sessionx (fuzzy session picker), resurrect + continuum (auto-restore), floax (floating panes)
- **Neovim** — LazyVim base, blink.cmp, flash.nvim, harpoon, opencode.nvim AI assistant
- **Dual shell** — zsh for everyday use, nushell for data pipelines and structured output
- **Television** — context-aware fuzzy picker: switches channels based on the command being typed (git, docker, k8s, etc.)

---

## tmux Key Bindings

Prefix: `Ctrl+a`

| Binding | Action |
|---------|--------|
| `Prefix + s` | Split pane vertically |
| `Prefix + v` | Split pane horizontally |
| `Prefix + h/j/k/l` | Navigate panes |
| `Prefix + H/L` | Previous/next window |
| `Prefix + o` | tmux-sessionx (fuzzy session picker) |
| `Prefix + p` | tmux-floax (floating pane) |
| `Prefix + z` | Zoom/unzoom pane |
| `Prefix + R` | Reload config |
| `Prefix + K` | Clear pane |

---

## Key Aliases

```bash
# Navigation
l            # eza -l --icons --git -a
lt           # eza --tree --level=2
cx <dir>     # cd into dir + list
fcd          # fuzzy cd
fv           # fuzzy open in nvim

# Editor
v            # nvim
cat          # bat (syntax highlighted)

# Git
gc "msg"     # git commit -m
gca "msg"    # git commit -a -m
gst          # git status
glog         # colored graph log
gdiff        # git diff
gp           # git push origin HEAD

# Docker
dco          # docker compose
dps          # docker ps
dx           # docker exec -it

# Kubernetes
k            # kubectl
ka           # kubectl apply -f
kg           # kubectl get
kd           # kubectl describe
kl           # kubectl logs -f
ke           # kubectl exec -it

# Misc
http         # xh (HTTP client)
cl           # clear
```

---

## Directory Structure

```
~/.dotfiles/
├── wezterm/        # WezTerm config + Catppuccin theme
├── tmux/           # tmux.conf + tmux.reset.conf + scripts/
├── zellij/         # config.kdl + Catppuccin themes
├── nvim/           # init.lua + lua/ plugins
├── zshrc/          # .zshrc
├── nushell/        # config.nu + env.nu + vendor/autoload/
├── starship/       # starship.toml
├── atuin/          # config.toml
├── television/     # config.toml + cable/ channels
├── gh-dash/        # config.yml
├── ssh/            # ssh-config
├── opencode/       # opencode.json + agents/ + skills/ + command/
├── .stowrc         # stow target: ~/.config
├── setup.sh        # alias for: stow .
├── PACKAGES.md     # detailed per-package docs
└── README.md       # this file
```

---

See [PACKAGES.md](PACKAGES.md) for detailed per-package documentation, dependency graphs, and keybinding references.
