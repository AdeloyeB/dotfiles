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
