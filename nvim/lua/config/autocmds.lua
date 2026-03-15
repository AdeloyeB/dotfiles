-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

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

-- Auto-refresh neo-tree when switching back from another tmux pane (e.g. Claude Code)
vim.api.nvim_create_autocmd("FocusGained", {
  group = vim.api.nvim_create_augroup("neotree_auto_refresh", { clear = true }),
  callback = function()
    if package.loaded["neo-tree.sources.manager"] then
      require("neo-tree.sources.manager").refresh("filesystem")
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
