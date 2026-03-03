return {
  -- catppuccin mocha — customized to match tmux warp dark theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      term_colors = true,
      color_overrides = {
        mocha = {
          base = "#000000",        -- pure black bg (matches tmux)
          mantle = "#000000",      -- sidebars/floats bg
          crust = "#000000",       -- deepest bg layer
          surface0 = "#1a1a2e",    -- subtle surfaces (matches tmux current window)
          surface1 = "#2a2a3e",    -- lighter surfaces
          surface2 = "#333333",    -- borders (matches tmux pane borders)
          overlay0 = "#616161",    -- muted text (matches tmux inactive window)
          overlay1 = "#7a7a7a",
          overlay2 = "#9a9a9a",
          text = "#ffffff",        -- white text (matches tmux fg)
          subtext0 = "#e4e4e4",    -- slightly muted white
          subtext1 = "#cccccc",
          blue = "#a5d5fe",        -- sky blue accent (matches tmux status/floax)
          sapphire = "#a5d5fe",
          sky = "#a5d5fe",
          lavender = "#a5d5fe",    -- unify blue accents
          yellow = "#fefdc2",      -- pale gold (matches tmux prefix active)
          green = "#a6e3a1",       -- keep catppuccin green
          red = "#f38ba8",         -- keep catppuccin red
          peach = "#fab387",       -- keep catppuccin peach
          mauve = "#cba6f7",       -- keep catppuccin purple
          teal = "#94e2d5",        -- keep catppuccin teal
          maroon = "#eba0ac",
          pink = "#f5c2e7",
          flamingo = "#f2cdcd",
          rosewater = "#f5e0dc",
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
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
    },
  },

  -- tell LazyVim to use it
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
