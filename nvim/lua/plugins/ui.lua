return {
  -- lualine: styled to match Vesper theme
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = LazyVim.config.icons

      -- Vesper palette
      local c = {
        bg = "#101010",
        bg_elevated = "#1A1A1A",
        bg_selected = "#232323",
        fg = "#FFFFFF",
        fg_muted = "#A0A0A0",
        fg_dim = "#7E7E7E",
        comment = "#5C5C5C",
        accent = "#FFC799",
        mint = "#99FFE4",
        error = "#FF8080",
        border = "#282828",
      }

      local theme = {
        normal = {
          a = { bg = c.accent, fg = c.bg, gui = "bold" },
          b = { bg = c.bg_elevated, fg = c.fg },
          c = { bg = c.bg, fg = c.fg_muted },
        },
        insert = {
          a = { bg = c.mint, fg = c.bg, gui = "bold" },
        },
        visual = {
          a = { bg = "#aca1cf", fg = c.bg, gui = "bold" },
        },
        replace = {
          a = { bg = c.error, fg = c.bg, gui = "bold" },
        },
        command = {
          a = { bg = c.accent, fg = c.bg, gui = "bold" },
        },
        inactive = {
          a = { bg = c.bg, fg = c.comment },
          b = { bg = c.bg, fg = c.comment },
          c = { bg = c.bg, fg = c.comment },
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
            { "branch", icon = "", color = { fg = c.accent, bg = c.bg_elevated } },
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
              color = { fg = c.accent },
            },
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = { fg = c.accent },
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = c.accent },
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              diff_color = {
                added = { fg = c.mint },
                modified = { fg = c.accent },
                removed = { fg = c.error },
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
            { "progress", separator = " ", padding = { left = 1, right = 0 }, color = { fg = c.fg, bg = c.bg_elevated } },
            { "location", padding = { left = 0, right = 1 }, color = { fg = c.fg, bg = c.bg_elevated } },
          },
          -- no clock — tmux already shows one
          lualine_z = {},
        },
        extensions = { "neo-tree", "lazy", "fzf" },
      }
    end,
  },
}
