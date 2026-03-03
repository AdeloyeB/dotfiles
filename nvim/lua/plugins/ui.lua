return {
  -- lualine: styled to merge visually with tmux status bar
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = LazyVim.config.icons

      -- palette matching tmux warp dark theme
      local c = {
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

      -- flat theme — black bg everywhere, blue accents for active sections
      local theme = {
        normal = {
          a = { bg = c.blue, fg = c.bg, gui = "bold" },
          b = { bg = c.surface, fg = c.fg },
          c = { bg = c.bg, fg = c.grey },
        },
        insert = {
          a = { bg = c.green, fg = c.bg, gui = "bold" },
        },
        visual = {
          a = { bg = c.mauve, fg = c.bg, gui = "bold" },
        },
        replace = {
          a = { bg = c.red, fg = c.bg, gui = "bold" },
        },
        command = {
          a = { bg = c.gold, fg = c.bg, gui = "bold" },
        },
        inactive = {
          a = { bg = c.bg, fg = c.grey },
          b = { bg = c.bg, fg = c.grey },
          c = { bg = c.bg, fg = c.grey },
        },
      }

      return {
        options = {
          theme = theme,
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        },
        sections = {
          lualine_a = {
            { "mode", fmt = function(s) return s:sub(1, 3) end },
          },
          lualine_b = {
            { "branch", icon = "", color = { fg = c.blue, bg = c.surface } },
          },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { LazyVim.lualine.pretty_path(), color = { fg = c.fg } },
          },
          lualine_x = {
            Snacks.profiler.status(),
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = { fg = c.blue },
            },
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = { fg = c.gold },
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = c.peach },
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              diff_color = {
                added = { fg = c.green },
                modified = { fg = c.blue },
                removed = { fg = c.red },
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 }, color = { fg = c.fg, bg = c.surface } },
            { "location", padding = { left = 0, right = 1 }, color = { fg = c.fg, bg = c.surface } },
          },
          -- no clock — tmux already shows one
          lualine_z = {},
        },
        extensions = { "neo-tree", "lazy", "fzf" },
      }
    end,
  },
}
