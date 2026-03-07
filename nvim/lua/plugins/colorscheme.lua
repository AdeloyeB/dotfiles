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
