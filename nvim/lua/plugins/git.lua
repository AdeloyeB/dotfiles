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
          -- Set up a timer to periodically refresh the diff view
          local timer = vim.uv.new_timer()
          timer:start(
            2000,
            3000,
            vim.schedule_wrap(function()
              -- Only refresh if diffview is still open
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
