# Terminal Config

A dotfiles repository for a macOS development environment. Every tool shares a unified **Warp Dark** color theme built around a pure-black background, sky-blue accents, and gold highlights. Tmux acts as the session-management layer; Neovim (via LazyVim) provides the editor; Ghostty is the terminal emulator; Zsh is the shell.

This document covers every configuration file, keybinding, plugin, color value, and script in the repository. It is detailed enough to recreate the entire setup from scratch.

---

## Table of Contents

1. [Repository Structure](#repository-structure)
2. [Design Philosophy](#design-philosophy)
3. [Dependencies](#dependencies)
4. [Install Script](#install-script)
5. [Ghostty Terminal](#ghostty-terminal)
6. [Tmux](#tmux)
7. [Tmux Scripts](#tmux-scripts)
8. [Neovim](#neovim)
9. [Zsh Shell](#zsh-shell)
10. [Git](#git)

---

## Repository Structure

```
terminal-config/
├── README.md
├── prompt.md
├── install.sh
├── ghostty/config
├── tmux/tmux.conf
├── tmux/scripts/
│   ├── dev-mode
│   ├── tmux-command-palette
│   ├── tmux-session-list
│   ├── tmux-sessionizer
│   ├── tmux-switch-session
│   ├── tmux-learning-cloud
│   └── lgt
├── nvim/                        # Full LazyVim configuration
│   ├── init.lua
│   ├── stylua.toml
│   ├── .neoconf.json
│   ├── lazyvim.json
│   ├── lazy-lock.json
│   └── lua/
│       ├── config/
│       │   ├── autocmds.lua
│       │   ├── keymaps.lua
│       │   ├── lazy.lua
│       │   └── options.lua
│       └── plugins/
│           ├── colorscheme.lua
│           ├── editor.lua
│           ├── git.lua
│           ├── image.lua
│           └── ui.lua
├── zsh/
│   ├── zshrc
│   ├── zprofile
│   └── zshenv
└── git/gitconfig.template
```

---

## Design Philosophy

| Principle | Detail |
|---|---|
| **Unified color theme** | Warp Dark is applied consistently across Ghostty, tmux, Neovim (Catppuccin mocha override), and lualine. |
| **Key palette** | Black background `#000000`, sky-blue accents `#a5d5fe`, gold highlights `#fefdc2`, muted grey `#616161`. |
| **Minimal aesthetic** | No unnecessary chrome, decorations, or visual noise. |
| **Keyboard-driven** | Every action is reachable via a keybinding. Mouse support is enabled but not required. |
| **Tmux as session layer** | All terminal multiplexing, session persistence, and project switching flow through tmux. |
| **LazyVim for maintainability** | The community Neovim distribution provides a well-maintained base; customizations layer on top. |

---

## Dependencies

### Homebrew Packages

| Package | Purpose |
|---|---|
| `neovim` | Editor |
| `tmux` | Terminal multiplexer |
| `fzf` | Fuzzy finder |
| `ripgrep` | Fast grep (`rg`) |
| `fd` | Fast find |
| `lazygit` | Terminal Git UI |
| `node` | Node.js runtime (LSP servers, Neovim provider) |
| `python` | Python 3 runtime (LSP servers, Neovim provider) |
| `pngpaste` | Paste images from clipboard |
| `zoxide` | Smarter `cd` |
| `eza` | Modern `ls` replacement |
| `imagemagick` | Image processing |

### Other Dependencies

| Dependency | Source / Notes |
|---|---|
| Rust toolchain | Installed via [rustup](https://rustup.rs/) (`rustc`, `cargo`, `rust-analyzer`) |
| Bun | JavaScript runtime and package manager |
| oh-my-zsh | Zsh framework |
| TPM | Tmux Plugin Manager (`~/.tmux/plugins/tpm`) |
| Hack Nerd Font Mono | Terminal font (install via `brew install --cask font-hack-nerd-font`) |

### Custom oh-my-zsh Plugins

Installed to `$ZSH_CUSTOM/plugins/`:

- `zsh-syntax-highlighting`
- `zsh-autosuggestions`
- `zsh-completions`
- `zsh-history-substring-search`

### Provider Packages

| Manager | Package | Purpose |
|---|---|---|
| pip | `pynvim` | Neovim Python provider |
| npm (global) | `neovim` | Neovim Node.js provider |

---

## Install Script

**File:** `install.sh`

The install script creates symlinks from the repository into the home directory.

### Behavior

- **Backup:** Existing files at the target locations are renamed with a `.bak` suffix before symlinking.
- **Interactive mode (default):** Prompts before each action.
- **Force mode:** Pass `--force` to skip all prompts.

### Dependency Check

The script verifies the following are installed before proceeding:

```
brew, nvim, tmux, fzf, rg, fd, lazygit, node, python3,
rustc, cargo, rust-analyzer, bun, pngpaste, zoxide, eza
```

### Post-Install Steps

After running the script, it prints remaining manual steps (font installation, TPM plugin install, etc.).

### Usage

```bash
# Interactive (recommended for first run)
./install.sh

# Non-interactive
./install.sh --force
```

---

## Ghostty Terminal

**File:** `ghostty/config`

### Color Theme (Warp Dark)

| Element | Value |
|---|---|
| Background | `#000000` (pure black) |
| Foreground | `#ffffff` (white) |
| Cursor color | `#00c2ff` (cyan) |
| Cursor style | Block |
| Selection background | `#1a3a4a` |
| Selection foreground | `#ffffff` |

### ANSI Color Palette

| Index | Normal | Bright |
|---|---|---|
| 0 (black/grey) | `#616161` | `#8e8e8e` |
| 1 (red) | `#ff8272` | `#ffc4bd` |
| 2 (green) | `#b4fa72` | `#d6fcb9` |
| 3 (yellow) | `#fefdc2` | `#fefdd5` |
| 4 (blue) | `#82aaff` | `#82aaff` |
| 5 (magenta) | `#ff8ffd` | `#ffb1fe` |
| 6 (cyan) | `#d0d1fe` | `#e5e6fe` |
| 7 (white) | `#f1f1f1` | `#feffff` |

### Font

- **Family:** Hack Nerd Font Mono
- **Size:** 12pt

### Window

| Setting | Value |
|---|---|
| Dimensions | 199 columns x 56 rows |
| Padding | 8px (all sides) |
| Window decoration | On |

### Keybindings

| Shortcut | Escape Sequence | Tmux Action |
|---|---|---|
| `Cmd+D` | `\x1b[77;0u` | Horizontal split |
| `Cmd+Shift+D` | `\x1b[77;1u` | Vertical split |

These escape sequences are captured in `tmux.conf` and mapped to the corresponding split-pane commands.

---

## Tmux

**File:** `tmux/tmux.conf`

### Core Settings

| Setting | Value |
|---|---|
| Prefix key | `Ctrl+A` (default `Ctrl+B` is unbound) |
| Base index (windows) | 1 |
| Base index (panes) | 1 |
| Renumber windows | On |
| Allow rename | Off |
| Escape time | 0 (no delay) |
| Mouse | On (set after TPM to override plugin defaults) |
| Default terminal | `tmux-256color` |
| Allow passthrough | On (for image protocols like Kitty graphics) |

### Terminal Overrides

- **RGB** overrides applied for `xterm-256color` and `xterm-ghostty`.
- **Terminal features for Ghostty:** clipboard, ccolour, cstyle, focus, title, mouse.

### Plugins (via TPM)

| Plugin | Purpose | Key Config |
|---|---|---|
| `tmux-sensible` | Sensible default settings | -- |
| `tmux-yank` | Clipboard copy integration | `@yank_selection_mouse = clipboard` |
| `tmux-continuum` | Automatic session save and restore | Save interval: 10 minutes; auto-restore on start |
| `tmux-resurrect` | Persist sessions across tmux server restarts | `@resurrect-strategy-nvim 'session'` (restores vim-obsession sessions) |
| `tmux-open` | Open files and URLs from tmux copy mode | -- |
| `tmux-fingers` | Quick text selection and copy (like vimium hints) | -- |
| `tmux-floax` | Floating pane support | Size: 80% x 80%; border color: `#a5d5fe`; text color: `#e4e4e4`; bind: `Ctrl+F`; popup bg: `#0a0a0a` |
| `tmux-which-key` | Keybinding help overlay | -- |
| `tmux-autoreload` | Automatically reloads tmux config on file change | Requires `entr` (`brew install entr`) |
| `tmux-git-autofetch` | Automatically fetches git changes in background | -- |

### Keybindings

#### Window Management

| Binding | Prefix Required | Action |
|---|---|---|
| `c` | Yes | Create new window |
| `Shift+Left` | No | Previous window |
| `Shift+Right` | No | Next window |

#### Pane Management

| Binding | Prefix Required | Action |
|---|---|---|
| `\|` | Yes | Split horizontally (keeps current path) |
| `-` | Yes | Split vertically (keeps current path) |
| `Alt+Left` | No | Navigate to left pane |
| `Alt+Right` | No | Navigate to right pane |
| `Alt+Up` | No | Navigate to pane above |
| `Alt+Down` | No | Navigate to pane below |
| `H` | Yes (repeatable) | Resize pane left 5px |
| `J` | Yes (repeatable) | Resize pane down 5px |
| `K` | Yes (repeatable) | Resize pane up 5px |
| `L` | Yes (repeatable) | Resize pane right 5px |
| `Ctrl+F` | No | Toggle floating pane (floax) |

#### Other

| Binding | Prefix Required | Action |
|---|---|---|
| `Escape Escape` (double) | No | Detach from session |
| `g` | Yes | Open lazygit in a new window |
| `f` | Yes | Fuzzy pane search via fzf |
| `Z` | Yes | Zoxide directory picker with eza tree preview |

### Theme (Warp Dark)

The tmux status bar is styled to match the Ghostty and Neovim themes exactly.

#### Status Bar

| Element | Style |
|---|---|
| Status bar background | `#000000` |
| Status bar foreground | `#ffffff` |
| Status left (normal) | Sky blue (`#a5d5fe`), shows session name |
| Status left (prefix active) | Gold (`#fefdc2`), shows session name |
| Status right | Time (`%H:%M`) and date (`%d-%b`) |

#### Windows

| Element | Style |
|---|---|
| Window status format | ` #I:#W ` (both active and inactive) |
| Current window | Bold white text on `#1a1a2e` background |
| Inactive window | Grey (`#616161`) text on black background |

#### Other Elements

| Element | Color |
|---|---|
| Pane borders | `#333333` |
| Messages | Sky blue (`#a5d5fe`) |
| Clock | Sky blue (`#a5d5fe`) |

---

## Tmux Scripts

**Directory:** `tmux/scripts/`

All scripts live in `tmux/scripts/` and are symlinked or referenced from the tmux configuration.

### dev-mode

**Primary session launcher.** Creates a tmux session named `dev` with a specific multi-pane layout.

| Window | Name | Layout |
|---|---|---|
| 1 | AI Orchestrator | 3 panes: left pane occupies 60% width; right side is split vertically into two panes (68 cols, 26 rows). The left pane auto-launches `claude`. |
| 2 | Deep Code | Single pane |

**Reload mode:**

```bash
dev-mode reload
```

Runs `tmux source-file ~/.tmux.conf` to reload configuration without destroying the session.

**Notes:**
- Uses `/opt/homebrew/bin/tmux` explicitly (Apple Silicon Homebrew path).
- Window dimensions: 199 columns x 56 rows.

### tmux-command-palette

Fuzzy command launcher powered by `fzf-tmux`. Presents approximately 20 common tmux actions plus all current keybindings in a searchable list.

**FZF Theme:**

| Element | Color |
|---|---|
| Background | `#1a3a4a` |
| Foreground | `#ffffff` |
| Highlight | `#00c2ff` |
| Border | `#616161` |

### tmux-session-list

Renders a session list for the tmux status bar with color coding.

| Session State | Style |
|---|---|
| Active | White background, black text, bold |
| Inactive | Dimmed grey (`#616161`) |

### tmux-sessionizer

A [ThePrimeagen](https://github.com/ThePrimeagen)-style project session creator. Searches `~/dev-mode/` for project directories and creates a dedicated tmux session for each project. Directory names with dots (`.`) are converted to underscores (`_`) in the session name.

### tmux-switch-session

Switches to a tmux session by its 1-based index number.

```bash
tmux-switch-session 3   # switches to the 3rd session
```

### tmux-learning-cloud

Creates a "Learning Cloud" tmux window with a 50/50 horizontal split:

| Pane | Content | Directory |
|------|---------|-----------|
| Left | Claude Code (`--dangerously-skip-permissions`) | `~/dev-mode/learning-cloud` |
| Right | LazyVim (`nvim`) | `~/dev-mode/learning-cloud` |

If a "Learning Cloud" window already exists in the current session, it switches to it instead of creating a duplicate.

### lgt

Opens `lazygit` inside a tmux window named `<dirname> Git`. The window auto-closes when lazygit exits.

---

## Neovim

**Directory:** `nvim/`

### Framework

**LazyVim** -- a community Neovim distribution built on top of `lazy.nvim`.

**Plugin manager:** `lazy.nvim` (auto-bootstraps on first launch if not present).

### Editor Options

**File:** `lua/config/options.lua`

| Option | Value |
|---|---|
| `relativenumber` | `true` |
| `scrolloff` | `8` |
| `termguicolors` | `true` |
| `updatetime` | `1000` (faster CursorHold for AI tool edit detection) |
| `autoread` | `true` (auto-reload files changed externally) |

### Keymaps

**File:** `lua/config/keymaps.lua`

LazyVim defaults. `Space` is the leader key.

### Autocmds

**File:** `lua/config/autocmds.lua`

| Autocmd | Event | Purpose |
|---|---|---|
| `auto_checktime` | `FocusGained`, `BufEnter`, `CursorHold` | Runs `checktime` to detect files changed by AI tools (Claude Code, Cursor, Copilot) |
| `auto_obsession` | `VimEnter` | Auto-starts vim-obsession session tracking for tmux-resurrect integration |

### Plugin Manager Configuration

**File:** `lua/config/lazy.lua`

| Setting | Value |
|---|---|
| Imports | LazyVim core + all files from `lua/plugins/` |
| Custom plugin lazy loading | Disabled (`lazy = false`) |
| Versioning | Disabled (`version = false`); always runs latest commits |
| Install colorscheme fallback | `catppuccin`, then `habamax` |

**Disabled runtime plugins** (for startup performance):

- `gzip`
- `tarPlugin`
- `tohtml`
- `tutor`
- `zipPlugin`

### Language Support

**File:** `lua/plugins/editor.lua`

#### LazyVim Extras

| Extra | Language/Feature |
|---|---|
| `lazyvim.plugins.extras.lang.typescript` | TypeScript / JavaScript |
| `lazyvim.plugins.extras.lang.json` | JSON |
| `lazyvim.plugins.extras.lang.rust` | Rust |
| `lazyvim.plugins.extras.lang.python` | Python |
| `lazyvim.plugins.extras.lang.tailwind` | Tailwind CSS |
| `lazyvim.plugins.extras.lang.java` | Java (via nvim-jdtls) |
| `lazyvim.plugins.extras.lang.dotnet` | C# / F# (via omnisharp) |

#### Treesitter Parsers

All of the following parsers are set to auto-install:

```
bash, css, html, javascript, json, lua, markdown, markdown_inline,
python, rust, svelte, toml, tsx, typescript, yaml, c_sharp, java, kotlin, xml
```

#### Mason Tools (Auto-Installed)

| Tool | Purpose |
|---|---|
| `stylua` | Lua formatter |
| `shellcheck` | Shell script linter |
| `shfmt` | Shell script formatter |
| `prettierd` | Fast Prettier daemon (JS/TS/CSS/HTML formatting) |
| `svelte-language-server` | Svelte LSP |

#### LSP Servers

| Server | Language | Source |
|---|---|---|
| `svelte` | Svelte (Tauri + SvelteKit) | Configured in `editor.lua` |
| `vtsls` | TypeScript | LazyVim TypeScript extra |
| `jsonls` | JSON | LazyVim JSON extra |
| `rust-analyzer` | Rust (via `rustaceanvim`) | LazyVim Rust extra |
| `pyright` | Python | LazyVim Python extra |
| `ruff` | Python (linting/formatting) | LazyVim Python extra |
| `tailwindcss-language-server` | Tailwind CSS | LazyVim Tailwind extra |
| `lua_ls` | Lua | LazyVim built-in |

### Colorscheme

**File:** `lua/plugins/colorscheme.lua`

**Base:** Catppuccin Mocha, extensively overridden to match the Warp Dark theme.

#### Color Overrides

| Catppuccin Token | Hex Value | Description |
|---|---|---|
| `base` | `#000000` | Background |
| `mantle` | `#000000` | Slightly darker background |
| `crust` | `#000000` | Darkest background |
| `surface0` | `#1a1a2e` | UI element backgrounds |
| `surface1` | `#2a2a3e` | Lighter UI surfaces |
| `surface2` | `#333333` | Borders, separators |
| `overlay0` | `#616161` | Muted/disabled text |
| `text` | `#ffffff` | Primary text |
| `blue` | `#a5d5fe` | Sky blue (unified) |
| `sky` | `#a5d5fe` | Sky blue (unified) |
| `sapphire` | `#a5d5fe` | Sky blue (unified) |
| `lavender` | `#a5d5fe` | Sky blue (unified) |
| `yellow` | `#fefdc2` | Pale gold |
| `green` | `#a6e3a1` | Green |
| `red` | `#f38ba8` | Red |
| `peach` | `#fab387` | Peach/orange |
| `mauve` | `#cba6f7` | Purple |
| `teal` | `#94e2d5` | Teal |

#### Catppuccin Integrations

The following integrations are enabled in the Catppuccin setup:

- `cmp` (completion)
- `gitsigns`
- `mason`
- `mini`
- `lsp` (native LSP)
- `notify`
- `nvimtree` (Neo-tree)
- `telescope`
- `treesitter`
- `which-key`

### Statusline

**File:** `lua/plugins/ui.lua`

Custom **lualine.nvim** theme, styled to match the tmux status bar.

#### Lualine Color Palette

| Name | Hex | Usage |
|---|---|---|
| `bg` | `#000000` | Status bar background |
| `fg` | `#ffffff` | Status bar text |
| `blue` | `#a5d5fe` | Normal mode, accents |
| `gold` | `#fefdc2` | Command mode |
| `grey` | `#616161` | Inactive elements |
| `surface` | `#1a1a2e` | Section backgrounds |

#### Mode Colors

| Mode | Color | Hex |
|---|---|---|
| Normal | Sky blue | `#a5d5fe` |
| Insert | Green | `#a6e3a1` |
| Visual | Mauve | `#cba6f7` |
| Replace | Red | `#f38ba8` |
| Command | Gold | `#fefdc2` |

#### Section Layout

```
┌──────┬────────────┬─────────────┬──────┬──────┬──────────────────┐
│ mode │ git branch │ diagnostics │      │ diff │ progress:location│
│      │            │             │  ... │      │                  │
└──────┴────────────┴─────────────┴──────┴──────┴──────────────────┘
              ↑ filetype and filepath shown in center
```

**Sections:**
- **Left:** mode | git branch | diagnostics
- **Center:** filetype, filepath
- **Right:** diff | progress:location

**Extensions:** neo-tree, lazy, fzf

### Git Plugins

**File:** `lua/plugins/git.lua`

#### diffview.nvim

Side-by-side diff viewer for reviewing AI-generated changes. Auto-refreshes every 3 seconds when the diff view is open, detecting files modified by Claude Code, Cursor, or Copilot.

| Keybinding | Action |
|---|---|
| `<leader>gd` | Open diff view (all working changes) |
| `<leader>gD` | Close diff view |
| `<leader>gh` | File history (current file) |
| `<leader>gH` | File history (all files) |

| Setting | Value |
|---|---|
| Layout | `diff2_vertical` (side-by-side) |
| File panel | Tree style, left side, 35 cols wide |
| Auto-refresh | Timer polls every 3s while view is open |
| Enhanced diff HL | Enabled |

#### vim-obsession

**Configured in:** `lua/plugins/editor.lua`

Auto-maintains `Session.vim` for tmux-resurrect. The `auto_obsession` autocmd starts tracking automatically on `VimEnter`.

### Image Support

**File:** `lua/plugins/image.lua`

**Plugin:** `image.nvim`

**Status:** DISABLED. The Ghostty + tmux combination does not reliably support the Kitty graphics protocol required for inline image rendering.

### Supporting Config Files

| File | Purpose |
|---|---|
| `stylua.toml` | Lua formatting: 2-space indent, 120 column width |
| `.neoconf.json` | neodev library enabled, `lua_ls` enabled |
| `lazyvim.json` | Install version 8, empty extras array |
| `lazy-lock.json` | 38 plugins with locked commit hashes for reproducible builds |

### Full Plugin List (40)

| Category | Plugins |
|---|---|
| **Core** | LazyVim, lazy.nvim, plenary.nvim |
| **Completion** | blink.cmp, friendly-snippets |
| **LSP** | nvim-lspconfig, mason.nvim, mason-lspconfig.nvim, lazydev.nvim |
| **Linting/Formatting** | nvim-lint, conform.nvim |
| **Treesitter** | nvim-treesitter, nvim-treesitter-textobjects, nvim-ts-autotag, ts-comments.nvim |
| **Colorschemes** | catppuccin, tokyonight.nvim |
| **UI** | lualine.nvim, bufferline.nvim, noice.nvim, nui.nvim |
| **Git** | gitsigns.nvim, diffview.nvim |
| **Search/Navigation** | grug-far.nvim, flash.nvim, todo-comments.nvim |
| **Help** | which-key.nvim |
| **Rust** | rustaceanvim, crates.nvim |
| **Python** | venv-selector.nvim |
| **Mini** | mini.ai, mini.icons, mini.pairs |
| **Utilities** | snacks.nvim, persistence.nvim, SchemaStore.nvim, vim-obsession |
| **Media** | image.nvim (disabled) |
| **Diagnostics** | trouble.nvim |

---

## Zsh Shell

**Directory:** `zsh/`

### zshrc

**File:** `zsh/zshrc`

#### Framework

oh-my-zsh with the **robbyrussell** theme.

#### Plugins (18)

```
git, docker, fzf, command-not-found, colored-man-pages, z,
copypath, aliases, web-search, npm, bun, tmux, ssh-agent,
sudo, zsh-syntax-highlighting, zsh-autosuggestions,
zsh-completions, zsh-history-substring-search
```

#### PATH Additions

| Path | Purpose |
|---|---|
| `~/.codeium/windsurf/bin` | Windsurf/Codeium CLI |
| `$BUN_INSTALL/bin` | Bun runtime |
| `~/.local/bin` | User-local binaries |
| `$JAVA_HOME/bin` | Java (OpenJDK 21) |

#### Environment Variables

| Variable | Value |
|---|---|
| `BUN_INSTALL` | `$HOME/.bun` |
| `JAVA_HOME` | `/opt/homebrew/opt/openjdk@21` |

#### Autosuggestions Configuration

| Setting | Value |
|---|---|
| Ghost text color | `#666666` |
| Strategy | `(history completion)` |
| Buffer max size | 20 |

#### Keybindings

| Binding | Action |
|---|---|
| `Right Arrow` | Accept full suggestion |
| `Ctrl+]` | Accept one word from suggestion |
| `Ctrl+M` | Accept line |
| `Ctrl+X Ctrl+V` | Paste image path |

#### Functions

| Function | Purpose |
|---|---|
| `dev-mode()` | Launch the dev-mode tmux session |
| `_dev_mode_create()` | Helper for dev-mode session creation |
| `clip()` | Clipboard utility |
| `_clip_inline()` | Helper for inline clipboard operations |

#### Aliases

| Alias | Action |
|---|---|
| `lg` | Launch lazygit with tmux integration |

#### Sourced Files

| Source | Purpose |
|---|---|
| `fzf --zsh` | fzf shell integration (keybindings and completion) |
| Bun completions | Bun shell completions |

### zprofile

**File:** `zsh/zprofile`

```bash
eval "$(brew shellenv)"
```

Sets up the Homebrew environment (`PATH`, `HOMEBREW_PREFIX`, etc.) for Apple Silicon (`/opt/homebrew`).

### zshenv

**File:** `zsh/zshenv`

- Sources `~/.cargo/env` to add the Rust toolchain (`rustc`, `cargo`, `rustup`) to `PATH`.
- Adds Foundry binary directory to `PATH` (Ethereum development toolkit).

---

## Git

**File:** `git/gitconfig.template`

A Git configuration template with placeholder variables:

| Placeholder | Purpose |
|---|---|
| `{{NAME}}` | Git author name |
| `{{EMAIL}}` | Git author email |

The install script (or manual setup) replaces these placeholders with actual values when symlinking or copying to `~/.gitconfig`.

---

## Recreating the Setup from Scratch

### 1. Install system dependencies

```bash
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Homebrew packages
brew install neovim tmux fzf ripgrep fd lazygit node python \
             pngpaste zoxide eza imagemagick

# Font
brew install --cask font-hack-nerd-font

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Bun
curl -fsSL https://bun.sh/install | bash

# Neovim providers
pip install pynvim
npm install -g neovim
```

### 2. Install oh-my-zsh and custom plugins

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-completions.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

git clone https://github.com/zsh-users/zsh-history-substring-search.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
```

### 3. Install TPM (Tmux Plugin Manager)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### 4. Run the install script

```bash
cd terminal-config
./install.sh
```

### 5. Post-install

1. Open tmux and press `Ctrl+A` then `I` (capital i) to install all tmux plugins via TPM.
2. Open Neovim. `lazy.nvim` will auto-bootstrap and install all plugins on first launch.
3. In Neovim, run `:Mason` to verify all language servers and tools are installed.
4. Restart the terminal to pick up all Zsh configuration changes.
5. Run `dev-mode` to launch the primary development session.
