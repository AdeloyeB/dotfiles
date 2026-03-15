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
brew install neovim tmux fzf ripgrep fd lazygit node python pngpaste zoxide eza imagemagick entr opencode
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
# Ghostty Configuration - Vesper Theme (nexxeln/dots)
# ===================================================

theme = Vesper
font-family = Hack Nerd Font Mono
font-size = 14
window-padding-x = 8
window-padding-y = 8
macos-titlebar-style = hidden
cursor-style = block
cursor-style-blink = false
shell-integration-features = no-cursor
mouse-hide-while-typing = true
keybind = shift+enter=text:\n
macos-option-as-alt = true

# Window size
window-width = 199
window-height = 56

# Remap Cmd+D / Cmd+Shift+D to tmux splits
keybind = super+d=text:\x1b[77;0u
keybind = super+shift+d=text:\x1b[77;1u
```

**Important:** The `theme = Vesper` line uses Ghostty's built-in Vesper theme. All ANSI colors, background, foreground, cursor, and selection colors are provided by the theme — no manual palette overrides needed.

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

Copy the exact contents of `zsh/zshrc` from this repository. Key sections:

- **oh-my-zsh** with `robbyrussell` theme and 18 plugins (git, docker, fzf, command-not-found, colored-man-pages, z, copypath, aliases, web-search, npm, bun, tmux, ssh-agent, sudo, zsh-syntax-highlighting, zsh-autosuggestions, zsh-completions, zsh-history-substring-search)
- **Environment:** `BUN_INSTALL`, `JAVA_HOME`, PATH additions for windsurf, bun, local bin, java
- **Autosuggestions:** ghost text `#666666`, strategy `(history completion)`, buffer max 20
- **FZF Vesper colors:** `--color=bg:#101010,bg+:#232323,fg:#A0A0A0,fg+:#FFFFFF,hl:#FFC799,hl+:#FFC799,pointer:#FFC799,prompt:#FFC799,info:#5C5C5C`
- **dev-mode():** Shell function (not a script) that creates a tmux `sandbox` session with 4 windows:
  - Window 1 "claude": 3-pane layout (60/40 split, right split vertically), all panes run `claude --dangerously-skip-permissions`
  - Window 2 "opencode": single pane, auto-runs `opencode`
  - Window 3 "code": empty shell
  - Window 4 "github": single pane, auto-runs `gh dash` (GitHub dashboard TUI)
  - After creating windows, sources `~/.tmux.conf` to ensure TPM plugins are loaded
  - `dev-mode reload` kills and recreates the session
- **clip():** Paste clipboard image to `/tmp/clip-<timestamp>.png`
- **_clip_inline():** ZLE widget bound to `Ctrl+X Ctrl+V`, pastes image path at cursor
- **lg alias:** Opens lazygit in tmux window or inline
- **tmux-git-autofetch():** chpwd hook for auto git fetch

---

## 4. tmux Configuration

### 4.1 `~/.tmux.conf`

Copy the exact contents of `tmux/tmux.conf` from this repository. Key settings:

- **Prefix:** `Ctrl+A` (unbinds `Ctrl+B`)
- **General:** base-index 1, renumber-windows on, allow-rename off, automatic-rename off, escape-time 0
- **Plugins (TPM):** tpm, tmux-sensible, tmux-yank, tmux-resurrect, tmux-continuum, tmux-open, tmux-fingers, tmux-floax, tmux-which-key, tmux-autoreload, tmux-git-autofetch
- **Mouse & Clipboard:** `set -g mouse on` BEFORE TPM, `@yank_selection_mouse 'clipboard'`, `@yank_action 'copy-pipe-and-cancel'`
- **Floax:** 80% x 80%, bind `C-f` (with prefix, manual binding bypasses plugin's broken path), menu `P` (with prefix), border `#282828`, text `#A0A0A0`
- **Popup:** bg `#101010`, border `#282828`
- **Continuum:** auto-restore on, save interval 10m, resurrect nvim session strategy
- **Terminal:** `tmux-256color`, RGB overrides for xterm-256color and xterm-ghostty, allow-passthrough on

**Vesper Theme:**

| Element | Value |
|---|---|
| Status position | Top |
| Status lines | 2 (content + empty spacer for visual padding) |
| Status bg | `#101010` |
| Status fg | `#A0A0A0` |
| Status left | `#[fg=#FFC799,bold] #S #[fg=#5C5C5C]│ ` |
| Status right | `#[fg=#A0A0A0]%-I:%M %p ` |
| Current window | `#[fg=#FFFFFF,bold] #I #W ` |
| Inactive window | `#[fg=#5C5C5C] #I #W ` |
| Pane borders | Simple lines, `#282828` both active and inactive (no accent) |
| Messages | White on `#232323` |
| Copy mode | White on `#232323` |
| Clock | `#FFC799` |

**Keybindings:**

| Binding | Prefix | Action |
|---|---|---|
| `c` | Yes | New window |
| `Shift+Left/Right` | No | Previous/next window |
| `\|` | Yes | Split horizontal (keeps path) |
| `-` | Yes | Split vertical (keeps path) |
| `Alt+Arrows` | No | Navigate panes |
| `H/J/K/L` | Yes (repeat) | Resize panes 5px |
| `Escape Escape` | No | Detach |
| `g` | Yes | Lazygit window |
| `f` | Yes | FZF pane search |
| `Z` | Yes | Zoxide directory picker |
| `Ctrl+F` | Yes | Toggle floax |
| `P` | Yes | Floax menu |

### 4.2 tmux Helper Scripts

Create the directory `~/.local/bin/` if it does not exist:

```bash
mkdir -p ~/.local/bin
```

All scripts below go in `~/.local/bin/` and must be made executable with `chmod +x`.

#### `dev-mode` (shell function in `.zshrc`)

**Note:** `dev-mode` is now a shell function defined directly in `.zshrc`, not a separate script in `~/.local/bin/`. The `~/.local/bin/dev-mode` script is no longer used.

The function creates a tmux `sandbox` session with 4 windows:

| Window | Name | Layout | Auto-run |
|---|---|---|---|
| 1 | claude | 3 panes (60/40 split, right split vertically) | `claude --dangerously-skip-permissions` in all 3 panes |
| 2 | opencode | Single pane | `opencode` |
| 3 | code | Single pane | (none) |
| 4 | github | Single pane | `gh dash` (GitHub dashboard TUI) |

`dev-mode reload` kills the session and recreates it fresh.

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
      salesforce.lua
      ui.lua
      image.lua
```

### 5.2 `~/.config/nvim/init.lua`

```lua
require("config.lazy")
```

### 5.3 `~/.config/nvim/lua/config/lazy.lua`

Copy the exact contents of `nvim/lua/config/lazy.lua` from this repository. Key differences from default LazyVim:

- `rocks = { enabled = false }` — disables luarocks support
- `install = { colorscheme = { "vesper", "habamax" } }` — uses vesper as install fallback
- `checker = { enabled = true, notify = false }` — silent update checks
- Disabled runtime plugins: gzip, tarPlugin, tohtml, tutor, zipPlugin

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
        "apex",
        "soql",
        "sosl",
        "sflog",
      },
    },
  },

  -- vim-obsession: auto-maintains Session.vim for tmux-resurrect
  { "tpope/vim-obsession" },

  {
    "mason-org/mason.nvim",
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
  -- vesper — nexxeln's dark minimal colorscheme
  {
    "nexxeln/vesper.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vesper").setup({
        transparent = false,
      })

      local accent = "#7DC4E4"
      local bg = "#101010"
      local bg_elevated = "#1A1A1A"
      local bg_hover = "#282828"
      local bg_selected = "#232323"
      local border = "#282828"

      local function apply_overrides()
        local hl = vim.api.nvim_set_hl

        -- dashed window separators (match tmux pane borders)
        vim.opt.fillchars:append({ horiz = "─", horizup = "─", horizdown = "─", vert = "│", vertleft = "│", vertright = "│", verthoriz = "│" })
        hl(0, "WinSeparator", { fg = "#282828", bg = bg })

        -- editor
        hl(0, "Cursor", { fg = bg, bg = accent })
        hl(0, "FloatTitle", { fg = accent, bg = bg_elevated })
        hl(0, "IncSearch", { fg = bg, bg = accent })
        hl(0, "CurSearch", { fg = bg, bg = accent })
        hl(0, "MatchParen", { fg = accent, bg = bg_hover })
        hl(0, "Directory", { fg = accent })
        hl(0, "Question", { fg = accent })
        hl(0, "MoreMsg", { fg = accent })
        hl(0, "Title", { fg = accent })

        -- diagnostics (prevent orange leaking via linked groups)
        hl(0, "DiagnosticWarn", { fg = "#E0AF68" })
        hl(0, "DiagnosticInfo", { fg = accent })

        -- syntax
        hl(0, "Constant", { fg = accent })
        hl(0, "Number", { fg = accent })
        hl(0, "Boolean", { fg = accent })
        hl(0, "Float", { fg = accent })
        hl(0, "Function", { fg = accent })
        hl(0, "Label", { fg = accent })
        hl(0, "Macro", { fg = accent })
        hl(0, "Type", { fg = accent })
        hl(0, "Structure", { fg = accent })
        hl(0, "Typedef", { fg = accent })
        hl(0, "Special", { fg = accent })
        hl(0, "SpecialChar", { fg = accent })
        hl(0, "Tag", { fg = accent })
        hl(0, "Underlined", { fg = accent, underline = true })
        hl(0, "Todo", { fg = accent, bg = bg_elevated })

        -- treesitter
        hl(0, "@constant", { fg = accent })
        hl(0, "@constant.builtin", { fg = accent })
        hl(0, "@constant.macro", { fg = accent })
        hl(0, "@label", { fg = accent })
        hl(0, "@string.escape", { fg = accent })
        hl(0, "@character.special", { fg = accent })
        hl(0, "@boolean", { fg = accent })
        hl(0, "@number", { fg = accent })
        hl(0, "@number.float", { fg = accent })
        hl(0, "@type", { fg = accent })
        hl(0, "@type.builtin", { fg = accent })
        hl(0, "@type.definition", { fg = accent })
        hl(0, "@function", { fg = accent })
        hl(0, "@function.builtin", { fg = accent })
        hl(0, "@function.macro", { fg = accent })
        hl(0, "@function.method", { fg = accent })
        hl(0, "@constructor", { fg = accent })
        hl(0, "@tag", { fg = accent })
        hl(0, "@comment.todo", { fg = accent })
        hl(0, "@markup.heading", { fg = accent })
        hl(0, "@markup.math", { fg = accent })
        hl(0, "@markup.link", { fg = accent })
        hl(0, "@markup.link.label", { fg = accent })

        -- lsp
        hl(0, "LspSignatureActiveParameter", { fg = accent })

        -- telescope
        hl(0, "TelescopeTitle", { fg = accent, bg = bg })
        hl(0, "TelescopePromptTitle", { fg = accent, bg = bg })
        hl(0, "TelescopePromptPrefix", { fg = accent, bg = bg })
        hl(0, "TelescopeResultsTitle", { fg = accent, bg = bg })
        hl(0, "TelescopePreviewTitle", { fg = accent, bg = bg })
        hl(0, "TelescopeSelectionCaret", { fg = accent, bg = bg_selected })
        hl(0, "TelescopeMatching", { fg = accent })

        -- blink.cmp
        hl(0, "BlinkCmpLabelMatch", { fg = accent })
        hl(0, "BlinkCmpKind", { fg = accent })

        -- oil
        hl(0, "OilDir", { fg = accent })

        -- flash.nvim
        hl(0, "FlashLabel", { fg = bg, bg = accent, bold = true })
        hl(0, "FlashMatch", { fg = accent })

        -- mini.statusline
        hl(0, "MiniStatuslineModeCommand", { fg = bg, bg = accent })
        hl(0, "MiniStatuslineModeInsert", { fg = bg, bg = accent })
        hl(0, "MiniStatuslineModeVisual", { fg = bg, bg = accent })

        -- mini.icons — override directly so linked groups don't pull in orange
        hl(0, "MiniIconsAzure", { fg = accent })
        hl(0, "MiniIconsCyan", { fg = accent })
        hl(0, "MiniIconsBlue", { fg = accent })
        hl(0, "MiniIconsOrange", { fg = accent })
        hl(0, "MiniIconsYellow", { fg = accent })
        hl(0, "MiniIconsPurple", { fg = accent })
        hl(0, "MiniIconsGreen", { fg = "#99FFE4" })
        hl(0, "MiniIconsRed", { fg = "#FF8080" })
        hl(0, "MiniIconsGrey", { fg = "#7E7E7E" })

        -- snacks dashboard
        hl(0, "SnacksDashboardHeader", { fg = accent })
        hl(0, "SnacksDashboardIcon", { fg = accent })
        hl(0, "SnacksDashboardKey", { fg = accent })
        hl(0, "SnacksDashboardSpecial", { fg = accent })
        hl(0, "SnacksDashboardFooter", { fg = accent })

        -- snacks explorer/picker sidebar — match editor bg, #282828 borders
        hl(0, "NormalFloat", { fg = "#FFFFFF", bg = bg })
        hl(0, "FloatBorder", { fg = border, bg = bg })
        hl(0, "SnacksPickerListNormalFloat", { bg = bg })
        hl(0, "SnacksPickerInputNormalFloat", { bg = bg })
        hl(0, "SnacksPickerBoxNormalFloat", { bg = bg })
        hl(0, "SnacksPickerNormalFloat", { bg = bg })
        hl(0, "SnacksPickerListBorder", { fg = border, bg = bg })
        hl(0, "SnacksPickerInputBorder", { fg = border, bg = bg })
        hl(0, "SnacksPickerBorder", { fg = border, bg = bg })
        hl(0, "SnacksPickerBoxBorder", { fg = border, bg = bg })
        hl(0, "SnacksPickerTitle", { fg = accent, bg = bg })
        hl(0, "SnacksPickerInputTitle", { fg = accent, bg = bg })
      end

      -- Apply on ColorScheme event AND after all plugins finish loading
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "vesper",
        callback = apply_overrides,
      })
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.schedule(apply_overrides)
        end,
      })
      vim.cmd.colorscheme("vesper")
    end,
  },

  -- tell LazyVim to use it
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vesper",
    },
  },
}
```

### 5.9 `~/.config/nvim/lua/plugins/ui.lua`

Copy the exact contents of `nvim/lua/plugins/ui.lua` from this repository. It contains a fully custom lualine theme using the Vesper palette:

**Vesper Lualine Palette:**
- `bg: #101010`, `bg_elevated: #1A1A1A`, `bg_selected: #232323`
- `fg: #FFFFFF`, `fg_muted: #A0A0A0`, `fg_dim: #7E7E7E`
- `comment: #5C5C5C`, `accent: #7DC4E4`, `mint: #99FFE4`, `error: #FF8080`, `border: #282828`

**Mode colors:** Normal/Command = accent (`#7DC4E4`), Insert = mint (`#99FFE4`), Visual = `#aca1cf`, Replace = error (`#FF8080`)

**Key features:**
- Uses `LazyVim.config.icons` for diagnostics and `LazyVim.lualine.pretty_path()` for file path
- Git branch with  icon in accent color
- Snacks profiler, noice command/mode, lazy updates in section x
- Diff with gitsigns source (mint=added, accent=modified, error=removed)
- No section z (tmux shows clock)
- Global statusline, no separators, disabled on dashboard filetypes

### 5.9b `~/.config/nvim/lua/plugins/salesforce.lua`

```lua
-- Salesforce development: Apex, SOQL, SOSL, LWC, Aura, Visualforce
-- Provides LSP, treesitter, filetype detection, sf.nvim, formatting, and which-key groups

-- Apex Language Server JAR (auto-detect latest VS Code Salesforce extension)
local function find_apex_jar()
  local extensions_dir = vim.fn.expand("~/.vscode/extensions")
  local handle = vim.uv.fs_scandir(extensions_dir)
  if not handle then
    return nil
  end
  local latest_dir
  while true do
    local name, typ = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end
    if typ == "directory" and name:match("^salesforce%.salesforcedx%-vscode%-apex%-") then
      if not latest_dir or name > latest_dir then
        latest_dir = name
      end
    end
  end
  if latest_dir then
    return extensions_dir .. "/" .. latest_dir .. "/dist/apex-jorje-lsp.jar"
  end
  return nil
end

local apex_jar = find_apex_jar()

-- Register Salesforce filetypes early (before plugins load)
vim.filetype.add({
  extension = {
    cls = "apex",
    trigger = "apex",
    apex = "apex",
    soql = "soql",
    sosl = "sosl",
    sflog = "sflog",
    cmp = "html", -- Lightning Aura components
    auradoc = "xml",
    design = "xml",
    evt = "xml",
    intf = "xml",
    tokens = "xml",
    page = "html", -- Visualforce pages
    component = "html", -- Visualforce components
    resource = "xml", -- Static resources metadata
    object = "xml", -- Custom objects
    layout = "xml", -- Page layouts
    permissionset = "xml",
    profile = "xml",
    workflow = "xml",
    email = "html",
  },
  pattern = {
    [".*force%-app/.*/lwc/.*%.html"] = "html",
    [".*force%-app/.*/lwc/.*%.js"] = "javascript",
  },
})

return {
  -- Custom Salesforce file icons (blue cloud for Apex, variants for SOQL/SOSL)
  {
    "echasnovski/mini.icons",
    opts = {
      filetype = {
        apex = { glyph = "󰅩", hl = "MiniIconsBlue" },
        soql = { glyph = "󰆼", hl = "MiniIconsCyan" },
        sosl = { glyph = "󰍉", hl = "MiniIconsCyan" },
        sflog = { glyph = "󰌱", hl = "MiniIconsGrey" },
      },
      extension = {
        cls = { glyph = "󰅩", hl = "MiniIconsBlue" },
        trigger = { glyph = "󱐋", hl = "MiniIconsOrange" },
        soql = { glyph = "󰆼", hl = "MiniIconsCyan" },
        sosl = { glyph = "󰍉", hl = "MiniIconsCyan" },
        sflog = { glyph = "󰌱", hl = "MiniIconsGrey" },
      },
    },
  },

  -- Apex Language Server (only if JAR is found)
  {
    "neovim/nvim-lspconfig",
    opts = apex_jar and {
      servers = {
        apex_ls = {
          filetypes = { "apex" },
          apex_jar_path = apex_jar,
          apex_enable_semantic_errors = true,
          apex_enable_completion_statistics = false,
        },
      },
    } or {},
  },

  -- Apex formatting via prettier + prettier-plugin-apex
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        apex = { "prettier" },
      },
      formatters = {
        prettier = {
          prepend_args = function(_, ctx)
            if ctx.filename and (ctx.filename:match("%.cls$") or ctx.filename:match("%.trigger$") or ctx.filename:match("%.apex$")) then
              return { "--plugin", "prettier-plugin-apex", "--parser", "apex" }
            end
            return {}
          end,
        },
      },
    },
  },

  -- which-key: register Salesforce group so it shows a proper label
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>sf", group = "Salesforce", icon = "☁️" },
      },
    },
  },

  -- sf.nvim: Salesforce CLI integration (push, retrieve, test, org management)
  {
    "xixiaofinland/sf.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "apex", "soql", "sosl", "javascript", "html" },
    keys = {
      -- Metadata operations
      { "<leader>sff", "<cmd>SF md push<cr>", desc = "Push Current File" },
      { "<leader>sfF", "<cmd>SF md pull<cr>", desc = "Pull Metadata List" },
      { "<leader>sfl", "<cmd>SF md list<cr>", desc = "List Metadata" },
      -- Test operations
      { "<leader>sft", "<cmd>SF test currentTest<cr>", desc = "Run Current Test" },
      { "<leader>sfT", "<cmd>SF test allTestsInThisFile<cr>", desc = "Run All Tests in File" },
      { "<leader>sfs", "<cmd>SF test selectTests<cr>", desc = "Select Tests to Run" },
      -- Org operations
      { "<leader>sfo", "<cmd>SF org fetchList<cr>", desc = "Fetch Org List" },
      { "<leader>sfO", "<cmd>SF org set<cr>", desc = "Set Target Org" },
      -- Metadata type operations
      { "<leader>sfm", "<cmd>SF mdtype list<cr>", desc = "List Metadata Types" },
      { "<leader>sfM", "<cmd>SF mdtype pull<cr>", desc = "Pull Metadata Types" },
    },
    opts = {},
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

## 6. Open Code Configuration

Install Open Code via Homebrew:

```bash
brew install opencode
```

### Config Architecture (IMPORTANT)

Open Code uses **two separate config files**. Getting this wrong will silently break keybindings:

- **`opencode.json`** — Models, providers, agents, MCP servers, plugins
- **`tui.json`** — Theme, keybindings (anything TUI-related)

**DO NOT put `keybinds` or `theme` in `opencode.json`.** Open Code v1.2+ migrated these to `tui.json`. If they appear in `opencode.json`, the app silently deletes them from memory at startup (the file on disk looks correct, but the values are never applied). You will see defaults instead of your custom settings with no visible error — only a deprecation warning in debug logs.

### Step-by-step Setup

#### 1. Create the config directory and symlinks

```bash
mkdir -p ~/.config/opencode
ln -sf ~/dotfiles/opencode/opencode.json ~/.config/opencode/opencode.json
ln -sf ~/dotfiles/opencode/tui.json ~/.config/opencode/tui.json
ln -sf ~/dotfiles/opencode/oh-my-opencode.json ~/.config/opencode/oh-my-opencode.json
```

#### 2. Install the oh-my-opencode plugin

```bash
cd ~/.config/opencode && bun install oh-my-opencode opencode-wakatime
```

This creates `node_modules/` and `bun.lock` inside `~/.config/opencode/`. These are local dependencies and should NOT be committed to the dotfiles repo.

**Note:** The `opencode-wakatime` plugin requires a WakaTime configuration file at `~/.wakatime.cfg` with a valid API key. See <https://wakatime.com/> for setup instructions.

#### 3. Verify the config loads correctly

```bash
opencode debug config
```

Check that your models, keybindings, and MCP servers appear in the output.

### `opencode/opencode.json`

Copy the exact contents of `opencode/opencode.json` from this repository. Key settings:

- **`$schema`:** `https://opencode.ai/config.json`
- **`enabled_providers`:** `["opencode"]` — uses OpenCode Zen as the model provider
- **`model`:** `opencode/minimax-m2.5` — default model for conversations
- **`small_model`:** `opencode/minimax-m2.5-free` — used for lightweight tasks
- **`plugin`:** `["oh-my-opencode", "opencode-wakatime"]` — loads community plugins
- **Agent models:**
  - `build`: `opencode/kimi-k2.5` (autonomous deep work)
  - `plan`: `opencode/kimi-k2.5` (architecture and planning)
  - `general`: `opencode/glm-4.7` (default agent)
  - `explore`: `opencode/minimax-m2.5-free` (codebase exploration)
  - `oracle`: `opencode/kimi-k2.5` (deep knowledge queries)
  - `librarian`: `opencode/minimax-m2.5-free` (documentation lookup)
  - `multimodal-looker`: `opencode/minimax-m2.5` (image/visual analysis)
  - `Metis`: `opencode/kimi-k2.5` (strategic reasoning)
  - `Momus`: `opencode/glm-4.7` (critical review)
- **MCP servers:**
  - `apigcp` (Nia): enabled, remote server at `https://apigcp.trynia.ai/mcp`
  - `linear`: local server via `bunx mcp-remote https://mcp.linear.app/mcp --header "Authorization:Bearer <API_KEY>"`
  - `context7`: disabled
  - `grep_app`: disabled

**DO NOT add `keybinds`, `theme`, or `tui` keys to this file.** They belong in `tui.json`.

### `opencode/tui.json`

Create this file with the following exact contents:

```json
{
  "$schema": "https://opencode.ai/tui.json",
  "theme": "vesper",
  "keybinds": {
    "session_interrupt": "ctrl+c",
    "input_clear": "ctrl+u",
    "app_exit": "ctrl+d,<leader>q",
    "session_delete": "ctrl+x",
    "stash_delete": "ctrl+x"
  }
}
```

**Why these keybindings:**

| Key | Value | Open Code Default | Reason |
|---|---|---|---|
| `session_interrupt` | `ctrl+c` | `escape` | Matches Claude Code behavior. `Escape` is often bound to other actions (e.g., tmux detach via double-escape). `Ctrl+C` is the universal "stop" signal. |
| `input_clear` | `ctrl+u` | `ctrl+c` | Since `Ctrl+C` now interrupts the AI, input clearing moves to `Ctrl+U` — the standard Unix "kill line" shortcut used in bash/zsh. Consistent muscle memory. |
| `app_exit` | `ctrl+d,<leader>q` | `ctrl+c,ctrl+d,<leader>q` | Removed `Ctrl+C` from exit to avoid conflicts with the new interrupt binding. `Ctrl+D` (EOF signal) is sufficient for exiting. |
| `session_delete` | `ctrl+x` | (default) | Delete the current session from the session list. |
| `stash_delete` | `ctrl+x` | (default) | Delete the selected stash entry. |

**Full list of configurable keybind keys:**

| Key | Default | Description |
|---|---|---|
| `leader` | `ctrl+x` | Leader key for keybind combinations |
| `app_exit` | `ctrl+c,ctrl+d,<leader>q` | Exit the application |
| `session_interrupt` | `escape` | Interrupt current AI session |
| `input_clear` | `ctrl+c` | Clear input field |
| `input_submit` | `return` | Submit input |
| `editor_open` | `<leader>e` | Open external editor |
| `display_thinking` | `none` | Toggle thinking blocks visibility |

Multiple bindings for the same action are comma-separated (e.g., `ctrl+c,ctrl+d`).

### `opencode/oh-my-opencode.json`

```json
{
  "disabled_mcps": ["context7", "grep_app"]
}
```

Disables `context7` and `grep_app` MCP servers that come bundled with oh-my-opencode. These are not needed because Nia (`apigcp`) handles knowledge indexing and search.

### Update Safety

Open Code updates (`brew upgrade opencode`) only replace the binary in `/opt/homebrew/Cellar/opencode/`. User config in `~/.config/opencode/` is never touched — keybindings, theme, models, and MCP servers persist across all updates.

---

## 7. Git Configuration

Create `~/.gitconfig` with the following template. Replace `{{NAME}}` and `{{EMAIL}}` with the user's actual name and email address:

```gitconfig
[user]
  name = {{NAME}}
  email = {{EMAIL}}
[init]
  defaultBranch = main
```

---

## 8. Unified Color Palette Reference (Vesper)

This is the single source of truth for the color theme used across Ghostty, tmux, Neovim, FZF, and lualine. The theme is **Vesper** by nexxeln.

| Name / Role            | Hex Code  | Where Used                                      |
|------------------------|-----------|------------------------------------------------|
| Background             | `#101010` | Ghostty (Vesper theme), tmux status bg, nvim bg, lualine bg, FZF bg, popup bg |
| Background elevated    | `#1A1A1A` | lualine section b                               |
| Background selected    | `#232323` | FZF bg+, tmux copy/message bg, lualine bg_selected |
| Foreground / Text      | `#FFFFFF` | Ghostty fg, tmux current window, nvim text, lualine fg, FZF fg+ |
| Muted text             | `#A0A0A0` | tmux status fg, floax text, lualine section c, FZF fg |
| Dim text               | `#7E7E7E` | lualine dim                                      |
| Comment / inactive     | `#5C5C5C` | tmux inactive windows, tmux separator, lualine inactive, FZF info |
| Primary accent (peach) | `#FFC799` | tmux session name, tmux active border, tmux clock, lualine normal/command mode, lualine branch icon, FZF highlight/pointer/prompt |
| Mint                   | `#99FFE4` | lualine insert mode, diff added                  |
| Visual / lavender      | `#aca1cf` | lualine visual mode                              |
| Error / red            | `#FF8080` | lualine replace mode, diff removed               |
| Border                 | `#282828` | tmux pane borders, floax border, popup border    |
| ANSI palette           | (various) | Provided by Ghostty's built-in Vesper theme      |

---

## 9. Post-Installation Steps

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

8. **Install Open Code plugin dependencies:**
   ```bash
   cd ~/.config/opencode && bun install oh-my-opencode opencode-wakatime
   ```

9. **Verify Open Code keybindings work:**
   - Launch `opencode` in a terminal
   - Start a conversation and press `Ctrl+C` — it should interrupt the AI session
   - If `Ctrl+C` doesn't interrupt (and `Escape` does instead), your keybinds are in the wrong file. They must be in `tui.json`, not `opencode.json`. See section 6 for details.

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
| `~/.config/nvim/lua/plugins/colorscheme.lua` | Vesper colorscheme (nexxeln/vesper.nvim) |
| `~/.config/nvim/lua/plugins/ui.lua` | Lualine status line |
| `~/.config/nvim/lua/plugins/image.lua` | image.nvim (disabled) |
| `~/.config/nvim/stylua.toml` | Lua formatter config |
| `~/.config/nvim/.neoconf.json` | Neodev/LSP settings |
| `~/.config/nvim/lazyvim.json` | LazyVim version metadata |
| `~/.config/nvim/.gitignore` | Neovim gitignore |
| `~/.config/opencode/opencode.json` | Open Code main config (symlink) |
| `~/.config/opencode/tui.json` | Open Code TUI config — theme, keybindings (symlink) |
| `~/.config/opencode/oh-my-opencode.json` | oh-my-opencode plugin config (symlink) |
| `~/.gitconfig` | Git user config (template) |
