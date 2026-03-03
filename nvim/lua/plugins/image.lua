return {
  {
    "3rd/image.nvim",
    enabled = false, -- disabled: Ghostty + tmux doesn't reliably support kitty graphics protocol
    ft = { "markdown", "norg", "oil" },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = { enabled = true },
      },
      max_width = 100,
      max_height = 30,
      tmux_show_only_in_active_window = true,
    },
  },
}
