# Terminal Config

A dotfiles repository for a macOS development environment. Every tool shares a unified **Vesper** color theme — a warm, minimal dark palette built around a `#101010` background, peach/amber accent `#FFC799`, and muted greys. Tmux acts as the session-management layer; Neovim (via LazyVim) provides the editor; Ghostty is the terminal emulator; Zsh is the shell.

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
│           ├── salesforce.lua
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
| **Unified color theme** | Vesper is applied consistently across Ghostty (built-in theme), tmux (custom status bar), Neovim (vesper.nvim), and lualine. |
| **Key palette** | Dark background `#101010`, peach accent `#FFC799`, mint `#99FFE4`, muted text `#A0A0A0`, dim `#5C5C5C`, border `#282828`. |
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

### Color Theme (Vesper)

Uses Ghostty's built-in `Vesper` theme (`theme = Vesper`). All colors are provided by the theme — no manual palette overrides needed.

### Font

- **Family:** Hack Nerd Font Mono
- **Size:** 14pt

### Window

| Setting | Value |
|---|---|
| Dimensions | 199 columns x 56 rows |
| Padding | 8px (all sides) |
| Titlebar | Hidden (`macos-titlebar-style = hidden`) |
| Cursor | Block, no blink |
| Mouse | Hide while typing |
| Option key | Alt mode (`macos-option-as-alt = true`) |

### Keybindings

| Shortcut | Action |
|---|---|
| `Cmd+D` | tmux horizontal split (via escape sequence) |
| `Cmd+Shift+D` | tmux vertical split (via escape sequence) |
| `Shift+Enter` | Send literal newline |

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
| Automatic rename | Off |
| Escape time | 0 (no delay) |
| Mouse | On (set before TPM for tmux-yank integration) |
| Default terminal | `tmux-256color` |
| Allow passthrough | On (for image protocols like Kitty graphics) |

### Terminal Overrides

- **RGB** overrides applied for `xterm-256color` and `xterm-ghostty`.
- **Terminal features for Ghostty:** clipboard, ccolour, cstyle, focus, title, mouse.

### Plugins (via TPM)

| Plugin | Purpose | Key Config |
|---|---|---|
| `tmux-sensible` | Sensible default settings | -- |
| `tmux-yank` | Clipboard copy integration | `@yank_selection_mouse = clipboard`, `@yank_action = copy-pipe-and-cancel` |
| `tmux-continuum` | Automatic session save and restore | Save interval: 10 minutes; auto-restore on start |
| `tmux-resurrect` | Persist sessions across tmux server restarts | `@resurrect-strategy-nvim 'session'` (restores vim-obsession sessions) |
| `tmux-open` | Open files and URLs from tmux copy mode | -- |
| `tmux-fingers` | Quick text selection and copy (like vimium hints) | -- |
| `tmux-floax` | Floating pane support | Size: 80% x 80%; border color: `#282828`; text color: `#A0A0A0`; bind: Prefix + `Ctrl+F`; popup bg: `#101010` |
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
| `Ctrl+F` | Yes | Toggle floating pane (floax) |

#### Other

| Binding | Prefix Required | Action |
|---|---|---|
| `Escape Escape` (double) | No | Detach from session |
| `g` | Yes | Open lazygit in a new window |
| `f` | Yes | Fuzzy pane search via fzf |
| `Z` | Yes | Zoxide directory picker with eza tree preview |

### Theme (Vesper)

The tmux status bar is styled to match the Vesper palette used in Ghostty and Neovim.

#### Status Bar

| Element | Style |
|---|---|
| Position | Top |
| Status bar background | `#101010` |
| Status bar foreground | `#A0A0A0` |
| Status left | Peach accent (`#FFC799`), bold, shows session name |
| Status right | 12-hour time (`%-I:%M %p`) |

#### Windows

| Element | Style |
|---|---|
| Window status format | ` #I #W ` |
| Current window | Bold white (`#FFFFFF`) |
| Inactive window | Dim grey (`#5C5C5C`) |
| Separator | None |

#### Other Elements

| Element | Color |
|---|---|
| Pane borders (inactive) | `#282828` |
| Pane borders (active) | Peach accent (`#FFC799`) |
| Pane border lines | Simple |
| Messages | White on `#232323` |
| Copy mode | White on `#232323` |
| Clock | Peach accent (`#FFC799`) |
| Popup background | `#101010` |
| Popup border | `#282828` |

---

## Tmux Scripts

**Directory:** `tmux/scripts/`

All scripts live in `tmux/scripts/` and are symlinked or referenced from the tmux configuration.

### dev-mode

**Primary session launcher.** Creates a tmux session named `sandbox` with a specific multi-pane layout. Defined as a shell function in `.zshrc`.

| Window | Name | Layout |
|---|---|---|
| 1 | claude | 3 panes (60/40 split, right side split vertically). All 3 panes auto-launch `claude --dangerously-skip-permissions`. |
| 2 | opencode | Single pane, auto-launches `opencode` |
| 3 | code | Single pane, empty shell |

**Reload mode:**

```bash
dev-mode reload
```

Kills the existing session and recreates it with a fresh layout.

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
| Install colorscheme fallback | `vesper`, then `habamax` |
| Rocks | Disabled |

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
python, rust, svelte, toml, tsx, typescript, yaml, c_sharp, java, kotlin, xml,
apex, soql, sosl, sflog
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
| `apex_ls` | Apex (Salesforce) | Configured in `salesforce.lua`, auto-detects JAR from VS Code extension |

### Colorscheme

**File:** `lua/plugins/colorscheme.lua`

**Theme:** [Vesper](https://github.com/nexxeln/vesper.nvim) — a warm, minimal dark colorscheme by nexxeln.

| Setting | Value |
|---|---|
| Plugin | `nexxeln/vesper.nvim` |
| Transparent | `false` |
| Priority | 1000 (loads first) |

LazyVim is also configured to use `vesper` as its colorscheme.

### Statusline

**File:** `lua/plugins/ui.lua`

Custom **lualine.nvim** theme, styled to match the Vesper palette.

#### Lualine Color Palette

| Name | Hex | Usage |
|---|---|---|
| `bg` | `#101010` | Status bar background |
| `bg_elevated` | `#1A1A1A` | Section b backgrounds |
| `bg_selected` | `#232323` | Selected items |
| `fg` | `#FFFFFF` | Primary text |
| `fg_muted` | `#A0A0A0` | Section c text |
| `fg_dim` | `#7E7E7E` | Dimmed text |
| `comment` | `#5C5C5C` | Inactive elements |
| `accent` | `#FFC799` | Normal/command mode, branch icon, noice, lazy updates |
| `mint` | `#99FFE4` | Insert mode, diff added |
| `error` | `#FF8080` | Replace mode, diff removed |
| `border` | `#282828` | Borders |

#### Mode Colors

| Mode | Color | Hex |
|---|---|---|
| Normal | Peach accent | `#FFC799` |
| Insert | Mint | `#99FFE4` |
| Visual | Lavender | `#aca1cf` |
| Replace | Error red | `#FF8080` |
| Command | Peach accent | `#FFC799` |

#### Section Layout

```
┌──────┬────────────┬─────────────────────┬─────────────────────────────┬──────────────────┐
│ mode │ git branch │ diagnostics │ type │ │ profiler │ noice cmd │ noice │ diff │ progress:location│
│      │            │             │ path │ │         │ mode      │ lazy  │      │                  │
└──────┴────────────┴─────────────────────┴─────────────────────────────┴──────────────────┘
```

**Sections:**
- **Left (a):** mode (3-char truncated)
- **Left (b):** git branch (with  icon, accent colored)
- **Left (c):** diagnostics, filetype icon, pretty path
- **Right (x):** snacks profiler, noice command/mode, lazy updates, diff (with gitsigns source)
- **Right (y):** progress, location (on elevated bg)
- **Right (z):** empty (tmux shows clock)

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

### Salesforce Support

**File:** `lua/plugins/salesforce.lua`

Full Salesforce development environment with LSP, treesitter, formatting, filetype detection, and CLI integration.

#### Filetype Detection

| Extension | Detected As |
|---|---|
| `.cls`, `.trigger`, `.apex` | `apex` |
| `.soql` | `soql` |
| `.sosl` | `sosl` |
| `.sflog` | `sflog` |
| `.cmp`, `.page`, `.component`, `.email` | `html` (Aura/Visualforce) |
| `.auradoc`, `.design`, `.evt`, `.intf`, `.tokens`, `.object`, `.layout`, `.permissionset`, `.profile`, `.workflow` | `xml` |
| LWC files in `force-app/**/lwc/` | `html`/`javascript` (pattern-matched) |

#### File Icons (mini.icons)

| Extension | Icon | Color | Highlight Group |
|---|---|---|---|
| `.cls` | 󰅩 (code braces) | Sky blue | `MiniIconsBlue` |
| `.trigger` | 󱐋 (lightning bolt) | Orange | `MiniIconsOrange` |
| `.soql` | 󰆼 (database) | Cyan | `MiniIconsCyan` |
| `.sosl` | 󰍉 (search) | Cyan | `MiniIconsCyan` |
| `.sflog` | 󰌱 (log) | Grey | `MiniIconsGrey` |

#### Apex Language Server

Auto-detects the `apex-jorje-lsp.jar` from the latest installed Salesforce VS Code extension. Requires Java (`JAVA_HOME` or `java` in PATH).

| Setting | Value |
|---|---|
| Semantic errors | Enabled |
| Filetypes | `apex` |
| JAR source | Auto-detected from `~/.vscode/extensions/salesforce.salesforcedx-vscode-apex-*/dist/` |

#### Apex Formatting

Uses `prettier` with `prettier-plugin-apex` (installed globally via npm). Configured through `conform.nvim` for `.cls`, `.trigger`, and `.apex` files.

#### sf.nvim Keybindings (`<leader>sf` — "Salesforce" in which-key)

| Keybinding | Action |
|---|---|
| `<leader>sff` | Push current file to org |
| `<leader>sfF` | Pull metadata list |
| `<leader>sfl` | List metadata |
| `<leader>sft` | Run current test |
| `<leader>sfT` | Run all tests in file |
| `<leader>sfs` | Select tests to run |
| `<leader>sfo` | Fetch org list |
| `<leader>sfO` | Set target org |
| `<leader>sfm` | List metadata types |
| `<leader>sfM` | Pull metadata types |

#### Salesforce Dependencies

| Dependency | Purpose |
|---|---|
| Salesforce CLI (`sf`) | Metadata operations, org management |
| Java 21+ | Apex Language Server runtime |
| `prettier-plugin-apex` (npm global) | Apex code formatting |
| Salesforce VS Code extension | Provides `apex-jorje-lsp.jar` |

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

### Full Plugin List (41)

| Category | Plugins |
|---|---|
| **Core** | LazyVim, lazy.nvim, plenary.nvim |
| **Completion** | blink.cmp, friendly-snippets |
| **LSP** | nvim-lspconfig, mason.nvim, mason-lspconfig.nvim, lazydev.nvim |
| **Linting/Formatting** | nvim-lint, conform.nvim |
| **Treesitter** | nvim-treesitter, nvim-treesitter-textobjects, nvim-ts-autotag, ts-comments.nvim |
| **Colorschemes** | vesper.nvim, catppuccin, tokyonight.nvim |
| **UI** | lualine.nvim, bufferline.nvim, noice.nvim, nui.nvim |
| **Git** | gitsigns.nvim, diffview.nvim |
| **Search/Navigation** | grug-far.nvim, flash.nvim, todo-comments.nvim |
| **Help** | which-key.nvim |
| **Rust** | rustaceanvim, crates.nvim |
| **Python** | venv-selector.nvim |
| **Salesforce** | sf.nvim |
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

#### FZF Theme (Vesper)

```
--color=bg:#101010,bg+:#232323,fg:#A0A0A0,fg+:#FFFFFF,hl:#FFC799,hl+:#FFC799,pointer:#FFC799,prompt:#FFC799,info:#5C5C5C
```

#### Functions

| Function | Purpose |
|---|---|
| `dev-mode()` | Launch the dev-mode tmux session "sandbox" (3 windows: claude, opencode, code) |
| `_dev_mode_create()` | Helper for dev-mode session creation |
| `clip()` | Paste clipboard image to file and print path |
| `_clip_inline()` | Paste clipboard image path inline at cursor |
| `tmux-git-autofetch()` | Auto-fetch git on directory change (chpwd hook) |

#### Aliases

| Alias | Action |
|---|---|
| `lg` | Launch lazygit in a tmux window (or inline if not in tmux) |

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
