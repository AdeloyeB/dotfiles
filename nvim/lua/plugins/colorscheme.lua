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
      vim.cmd.colorscheme("vesper")

      -- Neo-tree sidebar: match editor bg, light blue accent (Warp-style)
      local blue = "#58A6FF"
      vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "#101010" })
      vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "#101010" })
      vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "#101010", fg = "#101010" })
      vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { bg = "#101010", fg = "#282828" })
      vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "#1A1A1A" })
      vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = blue })
      vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = blue })
      vim.api.nvim_set_hl(0, "NeoTreeRootName", { fg = blue, bold = true })
      vim.api.nvim_set_hl(0, "NeoTreeTabActive", { fg = blue, bold = true })
      vim.api.nvim_set_hl(0, "NeoTreeTabInactive", { fg = "#5C5C5C" })
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
