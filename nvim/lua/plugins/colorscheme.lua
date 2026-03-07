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
