# Terminal Configuration Setup Prompt

This document is a self-contained prompt for an AI assistant. It contains every detail needed to recreate a complete macOS terminal environment from scratch. When given to an AI, it should produce an identical configuration with no ambiguity. All colors are specified as hex codes, all keybindings are explicit, and all file paths are absolute.

---

Set up the following configuration on a fresh macOS machine (Apple Silicon / arm64). Follow every step in order. Do not skip any detail. Every hex color, every keybinding, every setting must match exactly.

---

## 1. Install Dependencies

### 1.1 Homebrew

Install Homebrew (it will install to `/opt/homebrew` on Apple Silicon):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installation, ensure the shell environment is configured. Create or append to `~/.zprofile`:

```bash
eval $(/opt/homebrew/bin/brew shellenv)
```

Source it immediately:

```bash
eval $(/opt/homebrew/bin/brew shellenv)
```

### 1.2 Homebrew Packages

```bash
brew install neovim tmux fzf ripgrep fd lazygit node python pngpaste zoxide eza imagemagick entr
```

### 1.3 Rust Toolchain

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Accept defaults. Then add the rust-analyzer component:

```bash
rustup component add rust-analyzer
```

Create or ensure `~/.zshenv` contains:

```zsh
. "$HOME/.cargo/env"
export PATH="$PATH:/Users/bode/.foundry/bin"
```

### 1.4 Bun

```bash
curl -fsSL https://bun.sh/install | bash
```

### 1.5 Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 1.6 Custom ZSH Plugins

Install these into `$ZSH_CUSTOM/plugins/` (which is `~/.oh-my-zsh/custom/plugins/`):

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
```

### 1.7 TMux Plugin Manager (TPM)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### 1.8 Python and Node Neovim Support

```bash
pip3 install --break-system-packages pynvim
npm install -g neovim
```

### 1.9 Font

Download and install **Hack Nerd Font Mono** from <https://www.nerdfonts.com/>. Install all variants (Regular, Bold, Italic, Bold Italic) into the system font directory or `~/Library/Fonts/`.

### 1.10 Java (Optional, for PATH)

```bash
brew install openjdk@21
```

This installs to `/opt/homebrew/opt/openjdk@21`.

---

## 2. Ghostty Terminal Configuration

Create the file at `~/Library/Application Support/com.mitchellh.ghostty/config` with the following exact contents:

```
background=000000
foreground=ffffff

cursor-color=00c2ff
cursor-style=block

selection-background=1a3a4a
selection-foreground=ffffff

palette=0=#616161
palette=1=#ff8272
palette=2=#b4fa72
palette=3=#fefdc2
palette=4=#82aaff
palette=5=#ff8ffd
palette=6=#d0d1fe
palette=7=#f1f1f1
palette=8=#8e8e8e
palette=9=#ffc4bd
palette=10=#d6fcb9
palette=11=#fefdd5
palette=12=#82aaff
palette=13=#ffb1fe
palette=14=#e5e6fe
palette=15=#feffff

window-padding-x=8
window-padding-y=8
window-decoration=true

font-family=Hack Nerd Font Mono
font-size=12

window-width=199
window-height=56

keybind=super+d=text:\x1b[77;0u
keybind=super+shift+d=text:\x1b[77;1u
```

### Ghostty Color Reference

| Role              | Hex Code  |
|-------------------|-----------|
| Background        | `#000000` |
| Foreground        | `#ffffff` |
| Cursor            | `#00c2ff` |
| Selection BG      | `#1a3a4a` |
| Selection FG      | `#ffffff` |
| ANSI Black (0)    | `#616161` |
| ANSI Red (1)      | `#ff8272` |
| ANSI Green (2)    | `#b4fa72` |
| ANSI Yellow (3)   | `#fefdc2` |
| ANSI Blue (4)     | `#82aaff` |
| ANSI Magenta (5)  | `#ff8ffd` |
| ANSI Cyan (6)     | `#d0d1fe` |
| ANSI White (7)    | `#f1f1f1` |
| Bright Black (8)  | `#8e8e8e` |
| Bright Red (9)    | `#ffc4bd` |
| Bright Green (10) | `#d6fcb9` |
| Bright Yellow (11)| `#fefdd5` |
| Bright Blue (12)  | `#82aaff` |
| Bright Magenta(13)| `#ffb1fe` |
| Bright Cyan (14)  | `#e5e6fe` |
| Bright White (15) | `#feffff` |

---

## 3. ZSH Configuration

### 3.1 `~/.zprofile`

```zsh
eval $(/opt/homebrew/bin/brew shellenv)
```

### 3.2 `~/.zshenv`

```zsh
. "$HOME/.cargo/env"
export PATH="$PATH:/Users/bode/.foundry/bin"
```

### 3.3 `~/.zshrc`

```zsh
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

plugins=(git docker fzf command-not-found colored-man-pages z copypath aliases web-search npm bun tmux ssh-agent sudo zsh-syntax-highlighting zsh-autosuggestions zsh-completions zsh-history-substring-search)

source $ZSH/oh-my-zsh.sh

# Environment variables
export BUN_INSTALL=$HOME/.bun
export JAVA_HOME=/opt/homebrew/opt/openjdk@21
export PATH="$HOME/.codeium/windsurf/bin:$BUN_INSTALL/bin:$HOME/.local/bin:$JAVA_HOME/bin:$PATH"

# Autosuggestions configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Keybindings for autosuggestions
bindkey '→' autosuggest-accept
bindkey '^]' autosuggest-accept-word

# FZF shell integration
source <(fzf --zsh)

# Accept line binding
bindkey '^M' accept-line

# dev-mode function: launches or attaches to the tmux dev session
dev-mode() {
  if [[ "$1" == "reload" ]]; then
    ~/.local/bin/dev-mode reload
    return
  fi
  ~/.local/bin/dev-mode
}

# _dev_mode_create function
_dev_mode_create() {
  ~/.local/bin/dev-mode
}

# clip function: copies an image from clipboard
clip() {
  local filename="${1:-clipboard_image.png}"
  pngpaste "$filename" && echo "Saved clipboard image to $filename"
}

# _clip_inline widget bound to Ctrl+X Ctrl+V
_clip_inline() {
  local tmpfile=$(mktemp /tmp/clip_XXXXXX.png)
  pngpaste "$tmpfile" 2>/dev/null && LBUFFER+="$tmpfile"
}
zle -N _clip_inline
bindkey '^X^V' _clip_inline

# Lazygit in tmux alias
alias lg='~/.local/bin/lgt'
```

---

## 4. tmux Configuration

### 4.1 `~/.tmux.conf`

```tmux
# --- Prefix ---
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# --- General settings ---
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
setw -g allow-rename off
set -s escape-time 0
set -g allow-passthrough on
set -g default-terminal "tmux-256color"
set -sa terminal-overrides ",xterm-256color:RGB"
set -sa terminal-overrides ",xterm-ghostty:RGB"
set -sa terminal-features ",xterm-ghostty:clipboard:ccolour:cstyle:focus:title:mouse"

# --- Plugins ---
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-open'
set -g @plugin 'Morantron/tmux-fingers'
set -g @plugin 'omerxx/tmux-floax'
set -g @plugin 'alexwforsythe/tmux-which-key'
set -g @plugin 'b0o/tmux-autoreload'
set -g @plugin 'thepante/tmux-git-autofetch'

# --- Plugin settings ---
set -g @yank_selection_mouse 'clipboard'
set -g @floax-width '80%'
set -g @floax-height '80%'
set -g @floax-bind '-n C-f'
set -g @floax-border-color '#a5d5fe'
set -g @floax-text-color '#e4e4e4'
set -g @continuum-restore 'on'
set -g @continuum-save-interval '10'
set -g @resurrect-strategy-nvim 'session'

# --- Popup style (subtle dark background for floating panes) ---
set -g popup-style 'bg=#0a0a0a'
set -g popup-border-style 'fg=#a5d5fe'

# --- Window keybindings ---
bind c new-window
bind -n S-Left previous-window
bind -n S-Right next-window

# --- Pane splitting ---
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# --- Pane navigation ---
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# --- Pane resizing ---
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# --- Escape to detach (double-tap) ---
bind -n Escape switch-client -T escape_pressed
bind -T escape_pressed Escape detach-client

# --- Utility keybindings ---
bind g new-window -n "lazygit" "lazygit"
bind f run-shell "tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_current_command} #{pane_current_path}' | fzf-tmux -p 80%,60% --reverse | cut -d' ' -f1 | xargs tmux switch-client -t"
bind Z run-shell "zoxide query -l | fzf-tmux -p 80%,60% --reverse --preview 'eza -la --color=always --icons {}' | xargs -I{} tmux new-window -c '{}'"

# --- Theme / Status Bar ---
set -g status-style "bg=#000000,fg=#ffffff"
set -g status-left-style "bg=#000000,bold"
set -g status-right-style "bg=#000000,fg=#ffffff"
set -g status-left "#{?client_prefix,#[fg=#fefdc2],#[fg=#a5d5fe]} #S "
set -g status-right "%H:%M  %d-%b"
set -g status-left-length 20
set -g status-right-length 40

setw -g window-status-style "bg=#000000,fg=#616161"
setw -g window-status-current-style "bg=#1a1a2e,fg=#ffffff,bold"
setw -g window-status-format " #I:#W "
setw -g window-status-current-format " #I:#W "

set -g pane-border-style "fg=#333333"
set -g pane-active-border-style "fg=#333333"
set -g message-style "bg=#000000,fg=#a5d5fe"
set -g clock-mode-colour "#a5d5fe"

# --- Initialize TPM (MUST be the last plugin line) ---
run '~/.tmux/plugins/tpm/tpm'

# --- Post-TPM overrides (these MUST come after TPM init) ---
set -g mouse on
```

### 4.2 tmux Helper Scripts

Create the directory `~/.local/bin/` if it does not exist:

```bash
mkdir -p ~/.local/bin
```

All scripts below go in `~/.local/bin/` and must be made executable with `chmod +x`.

#### `~/.local/bin/dev-mode`

```bash
#!/usr/bin/env bash

SESSION="dev"
TMUX_BIN="/opt/homebrew/bin/tmux"

# Handle reload argument
if [[ "$1" == "reload" ]]; then
  $TMUX_BIN source-file ~/.tmux.conf
  echo "tmux config reloaded."
  exit 0
fi

# If session already exists, attach to it
if $TMUX_BIN has-session -t "$SESSION" 2>/dev/null; then
  $TMUX_BIN attach-session -t "$SESSION"
  exit 0
fi

# Create new session with Window 1: AI Orchestrator
$TMUX_BIN new-session -d -s "$SESSION" -n "AI Orchestrator" -x 199 -y 56
$TMUX_BIN split-window -h -l 68 -t "$SESSION"
$TMUX_BIN split-window -v -l 26 -t "$SESSION"
$TMUX_BIN send-keys -t "${SESSION}:1.1" 'claude' Enter
$TMUX_BIN select-pane -t "${SESSION}:1.1"

# Create Window 2: Deep Code
$TMUX_BIN new-window -t "$SESSION" -n "Deep Code"

# Select Window 1 and attach
$TMUX_BIN select-window -t "${SESSION}:1"
$TMUX_BIN attach-session -t "$SESSION"
```

#### `~/.local/bin/tmux-command-palette`

This is an FZF-based command launcher for tmux. It presents roughly 20 actions (new window, split panes, kill pane, rename window, list sessions, etc.) along with their keybindings via FZF, then executes the selected tmux command. FZF is styled with these colors:

- `bg:#1a3a4a`
- `fg:#ffffff`
- `hl:#00c2ff`
- `border:#616161`

The script should use `fzf-tmux -p 80%,60%` with `--reverse` and the color flags above, piping the selection to the appropriate `tmux` command.

#### `~/.local/bin/tmux-session-list`

Produces a formatted session list for the status bar. The active session is rendered with white background (`#ffffff`), black text (`#000000`), and bold. Inactive sessions are rendered in `#616161`.

#### `~/.local/bin/tmux-sessionizer`

A ThePrimeagen-style sessionizer script. It searches directories under `~/dev-mode/`, creates tmux sessions per project directory (replacing dots with underscores in session names), and attaches or switches to the selected session.

#### `~/.local/bin/tmux-switch-session`

Switches to a tmux session by 1-based index number. Takes a single numeric argument and switches to the session at that position in the list.

#### `~/.local/bin/tmux-learning-cloud`

Creates a "Learning Cloud" tmux window in the current session with a 50/50 horizontal split. Left pane runs `claude --dangerously-skip-permissions`, right pane runs `nvim`, both in `~/dev-mode/learning-cloud`. If the window already exists, switches to it instead of creating a duplicate.

```bash
#!/usr/bin/env bash
DIR="$HOME/dev-mode/learning-cloud"
WIN_NAME="Learning Cloud"
SESSION=$(tmux display-message -p '#S')
if tmux list-windows -t "$SESSION" -F '#W' | grep -qx "$WIN_NAME"; then
  tmux select-window -t "$SESSION:$WIN_NAME"
  exit 0
fi
tmux new-window -n "$WIN_NAME" -c "$DIR" "claude --dangerously-skip-permissions"
tmux split-window -h -t "$SESSION:$WIN_NAME" -c "$DIR" "nvim"
tmux select-layout -t "$SESSION:$WIN_NAME" even-horizontal
tmux select-pane -t "$SESSION:$WIN_NAME.0"
```

#### `~/.local/bin/lgt`

Opens lazygit in a tmux window named `"<current-directory-name> Git"`. The window auto-closes when lazygit exits.

```bash
#!/usr/bin/env bash
dirname=$(basename "$(pwd)")
tmux new-window -n "${dirname} Git" "lazygit"
```

Make all scripts executable:

```bash
chmod +x ~/.local/bin/dev-mode
chmod +x ~/.local/bin/tmux-command-palette
chmod +x ~/.local/bin/tmux-session-list
chmod +x ~/.local/bin/tmux-sessionizer
chmod +x ~/.local/bin/tmux-switch-session
chmod +x ~/.local/bin/tmux-learning-cloud
chmod +x ~/.local/bin/lgt
```

---

## 5. Neovim Configuration

All Neovim config files live under `~/.config/nvim/`.

### 5.1 Directory Structure

```
~/.config/nvim/
  init.lua
  stylua.toml
  .neoconf.json
  lazyvim.json
  .gitignore
  lua/
    config/
      lazy.lua
      options.lua
      keymaps.lua
      autocmds.lua
    plugins/
      editor.lua
      colorscheme.lua
      git.lua
      ui.lua
      image.lua
```

### 5.2 `~/.config/nvim/init.lua`

```lua
require("config.lazy")
```

### 5.3 `~/.config/nvim/lua/config/lazy.lua`

```lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
```

### 5.4 `~/.config/nvim/lua/config/options.lua`

```lua
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.termguicolors = true

-- Faster file-change detection for AI tool edits
vim.opt.updatetime = 1000 -- CursorHold triggers after 1s (default 4s)
vim.opt.autoread = true -- Auto-read files changed outside Neovim
```

### 5.5 `~/.config/nvim/lua/config/keymaps.lua`

```lua
-- LazyVim defaults are used. Leader key is Space.
```

### 5.6 `~/.config/nvim/lua/config/autocmds.lua`

```lua
-- Aggressive file-change detection for AI tool edits (Claude Code, Cursor, Copilot)
-- LazyVim checks on FocusGained; this adds a timer-based check for background changes
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = vim.api.nvim_create_augroup("auto_checktime", { clear = true }),
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- Auto-start vim-obsession if no session is already being tracked
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("auto_obsession", { clear = true }),
  callback = function()
    -- Only auto-track if: not already in a session, not opened with specific files,
    -- and obsession plugin is loaded
    if vim.fn.argc() == 0 and vim.fn.exists(":Obsess") == 2 and vim.v.this_session == "" then
      vim.cmd("Obsess")
    end
  end,
})
```

### 5.7 `~/.config/nvim/lua/plugins/editor.lua`

```lua
return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.lang.java" },
  { import = "lazyvim.plugins.extras.lang.dotnet" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "yaml",
        "c_sharp",
        "java",
        "kotlin",
        "xml",
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "prettierd",
        "svelte-language-server",
      },
    },
  },

  -- vim-obsession: auto-maintains Session.vim for tmux-resurrect
  { "tpope/vim-obsession" },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        svelte = {},
      },
    },
  },
}
```

### 5.7b `~/.config/nvim/lua/plugins/git.lua`

```lua
return {
  -- diffview.nvim: side-by-side diff viewer for reviewing AI-generated changes
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff View (working changes)" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diff View Close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (current)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "File History (all)" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_vertical" },
        merge_tool = { layout = "diff3_mixed" },
      },
      file_panel = {
        listing_style = "tree",
        win_config = { position = "left", width = 35 },
      },
      hooks = {
        -- Auto-refresh when files change on disk (for AI tool edits)
        view_opened = function()
          local timer = vim.uv.new_timer()
          timer:start(
            2000,
            3000,
            vim.schedule_wrap(function()
              local ok, lib = pcall(require, "diffview.lib")
              if ok and lib.get_current_view() then
                vim.cmd("checktime")
              else
                timer:stop()
                timer:close()
              end
            end)
          )
        end,
      },
    },
  },
}
```

### 5.8 `~/.config/nvim/lua/plugins/colorscheme.lua`

```lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#000000",
          crust = "#000000",
          surface0 = "#1a1a2e",
          surface1 = "#2a2a3e",
          surface2 = "#333333",
          overlay0 = "#616161",
          text = "#ffffff",
          blue = "#a5d5fe",
          sky = "#a5d5fe",
          sapphire = "#a5d5fe",
          lavender = "#a5d5fe",
          yellow = "#fefdc2",
          green = "#a6e3a1",
          red = "#f38ba8",
          peach = "#fab387",
          mauve = "#cba6f7",
          teal = "#94e2d5",
        },
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        mason = true,
        mini = true,
        native_lsp = { enabled = true },
        notify = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
  },
}
```

### 5.9 `~/.config/nvim/lua/plugins/ui.lua`

```lua
return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local colors = {
        bg = "#000000",
        fg = "#ffffff",
        blue = "#a5d5fe",
        gold = "#fefdc2",
        grey = "#616161",
        surface = "#1a1a2e",
        green = "#a6e3a1",
        red = "#f38ba8",
        peach = "#fab387",
        mauve = "#cba6f7",
      }

      local custom_theme = {
        normal = {
          a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
          b = { bg = colors.surface, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
        },
        insert = {
          a = { bg = colors.green, fg = colors.bg, gui = "bold" },
          b = { bg = colors.surface, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
        },
        visual = {
          a = { bg = colors.mauve, fg = colors.bg, gui = "bold" },
          b = { bg = colors.surface, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
        },
        replace = {
          a = { bg = colors.red, fg = colors.bg, gui = "bold" },
          b = { bg = colors.surface, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
        },
        command = {
          a = { bg = colors.gold, fg = colors.bg, gui = "bold" },
          b = { bg = colors.surface, fg = colors.fg },
          c = { bg = colors.bg, fg = colors.fg },
        },
        inactive = {
          a = { bg = colors.bg, fg = colors.grey },
          b = { bg = colors.bg, fg = colors.grey },
          c = { bg = colors.bg, fg = colors.grey },
        },
      }

      return {
        options = {
          theme = custom_theme,
          component_separators = "",
          section_separators = "",
        },
        sections = {
          lualine_a = { { "mode", fmt = function(str) return str:sub(1, 3) end } },
          lualine_b = { "branch" },
          lualine_c = { "diagnostics", "filetype", "filename" },
          lualine_x = { "diff", "profiler", "noice" },
          lualine_y = { "progress", "location" },
          lualine_z = {},
        },
        extensions = { "neo-tree", "lazy", "fzf" },
      }
    end,
  },
}
```

### 5.10 `~/.config/nvim/lua/plugins/image.lua`

```lua
-- image.nvim is DISABLED.
-- Ghostty + tmux does not reliably support the Kitty graphics protocol.
return {
  {
    "3rd/image.nvim",
    enabled = false,
    opts = {
      backend = "kitty",
    },
  },
}
```

### 5.11 `~/.config/nvim/stylua.toml`

```toml
indent_type = "Spaces"
indent_width = 2
column_width = 120
```

### 5.12 `~/.config/nvim/.neoconf.json`

```json
{
  "neodev": {
    "library": {
      "enabled": true,
      "plugins": true
    }
  },
  "lspconfig": {
    "lua_ls": {
      "Lua.workspace.checkThirdParty": false
    }
  }
}
```

### 5.13 `~/.config/nvim/lazyvim.json`

```json
{
  "version": 8,
  "extras": []
}
```

### 5.14 `~/.config/nvim/.gitignore`

```
tt.*
.tests
doc/tags
debug
.repro
foo.*
*.log
data
```

---

## 6. Git Configuration

Create `~/.gitconfig` with the following template. Replace `{{NAME}}` and `{{EMAIL}}` with the user's actual name and email address:

```gitconfig
[user]
  name = {{NAME}}
  email = {{EMAIL}}
[init]
  defaultBranch = main
```

---

## 7. Unified Color Palette Reference

This is the single source of truth for the color theme used across Ghostty, tmux, Neovim, and FZF. The theme is derived from **Warp Dark**.

| Name / Role            | Hex Code  | Where Used                                      |
|------------------------|-----------|------------------------------------------------|
| Background             | `#000000` | Ghostty bg, tmux status bg, nvim base/mantle/crust, lualine bg |
| Foreground / Text      | `#ffffff` | Ghostty fg, tmux fg, nvim text, lualine fg      |
| Primary accent (sky)   | `#a5d5fe` | tmux active prefix, floax border, nvim blue/sky/sapphire/lavender, lualine normal mode, message fg, clock |
| Secondary accent (gold)| `#fefdc2` | tmux prefix indicator, nvim yellow, lualine command mode, ANSI yellow |
| Muted / inactive       | `#616161` | tmux inactive windows, nvim overlay0, lualine inactive, ANSI black, FZF border |
| Surface (subtle bg)    | `#1a1a2e` | tmux current window bg, nvim surface0, lualine section b, FZF bg |
| Lighter surface        | `#2a2a3e` | nvim surface1                                   |
| Borders                | `#333333` | tmux pane borders, nvim surface2                 |
| Cursor                 | `#00c2ff` | Ghostty cursor, FZF highlight                   |
| Selection bg           | `#1a3a4a` | Ghostty selection, FZF bg                        |
| Error / red            | `#f38ba8` | nvim red, lualine replace mode                   |
| Success / green        | `#a6e3a1` | nvim green, lualine insert mode                  |
| Warning / peach        | `#fab387` | nvim peach                                       |
| Purple / mauve         | `#cba6f7` | nvim mauve, lualine visual mode                  |
| Teal                   | `#94e2d5` | nvim teal                                        |
| ANSI Blue              | `#82aaff` | Ghostty palette 4 and 12                         |
| ANSI Magenta           | `#ff8ffd` | Ghostty palette 5                                |
| ANSI Red               | `#ff8272` | Ghostty palette 1                                |
| ANSI Green             | `#b4fa72` | Ghostty palette 2                                |
| ANSI Cyan              | `#d0d1fe` | Ghostty palette 6                                |

---

## 8. Post-Installation Steps

Run these steps in order after all files are in place:

1. **Source the ZSH config:**
   ```bash
   source ~/.zshrc
   ```

2. **Launch the tmux dev session:**
   ```bash
   dev-mode
   ```

3. **Install TPM plugins** (inside tmux): Press `Ctrl+A` then `I` (capital I). Wait for all plugins to install.

4. **Open Neovim:**
   ```bash
   nvim
   ```
   lazy.nvim will automatically detect and install all plugins on first launch. Wait for the installation to complete.

5. **Verify LSP servers in Neovim:**
   ```vim
   :Mason
   ```
   Confirm that `stylua`, `shellcheck`, `shfmt`, `prettierd`, and `svelte-language-server` are installed.

6. **Update Treesitter parsers in Neovim:**
   ```vim
   :TSUpdate
   ```

7. **Verify Hack Nerd Font Mono** is installed and selected in Ghostty (font-family setting in the Ghostty config).

---

## Summary of All Files Created

| File Path | Purpose |
|-----------|---------|
| `~/Library/Application Support/com.mitchellh.ghostty/config` | Ghostty terminal config |
| `~/.zprofile` | Homebrew shell environment |
| `~/.zshenv` | Cargo and Foundry PATH |
| `~/.zshrc` | Main ZSH configuration |
| `~/.tmux.conf` | tmux configuration |
| `~/.local/bin/dev-mode` | tmux dev session launcher |
| `~/.local/bin/tmux-command-palette` | FZF command palette for tmux |
| `~/.local/bin/tmux-session-list` | Status bar session list |
| `~/.local/bin/tmux-sessionizer` | Project session creator |
| `~/.local/bin/tmux-switch-session` | Switch session by index |
| `~/.local/bin/lgt` | Lazygit tmux wrapper |
| `~/.config/nvim/init.lua` | Neovim entry point |
| `~/.config/nvim/lua/config/lazy.lua` | lazy.nvim bootstrap |
| `~/.config/nvim/lua/config/options.lua` | Neovim options |
| `~/.config/nvim/lua/config/keymaps.lua` | Neovim keymaps (LazyVim defaults) |
| `~/.config/nvim/lua/config/autocmds.lua` | Neovim autocommands (LazyVim defaults) |
| `~/.config/nvim/lua/plugins/editor.lua` | Language extras, Treesitter, Mason, LSP |
| `~/.config/nvim/lua/plugins/colorscheme.lua` | Catppuccin Mocha with custom overrides |
| `~/.config/nvim/lua/plugins/ui.lua` | Lualine status line |
| `~/.config/nvim/lua/plugins/image.lua` | image.nvim (disabled) |
| `~/.config/nvim/stylua.toml` | Lua formatter config |
| `~/.config/nvim/.neoconf.json` | Neodev/LSP settings |
| `~/.config/nvim/lazyvim.json` | LazyVim version metadata |
| `~/.config/nvim/.gitignore` | Neovim gitignore |
| `~/.gitconfig` | Git user config (template) |
