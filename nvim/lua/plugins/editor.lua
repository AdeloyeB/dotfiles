return {
  -- language extras
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.lang.java" },
  { import = "lazyvim.plugins.extras.lang.dotnet" },
  { import = "lazyvim.plugins.extras.lang.docker" },
  { import = "lazyvim.plugins.extras.lang.terraform" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.lang.sql" },
  { import = "lazyvim.plugins.extras.lang.markdown" },

  -- treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "yaml",
        "c_sharp",
        "java",
        "kotlin",
        "xml",
        "dockerfile",
        "hcl",
        "terraform",
        "sql",
        "apex",
        "soql",
        "sosl",
        "sflog",
      })
    end,
  },

  -- mason tools
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "prettierd",
        "svelte-language-server",
      },
    },
  },

  -- vim-obsession: auto-maintains Session.vim for tmux-resurrect
  { "tpope/vim-obsession" },

  -- svelte LSP (for Tauri + SvelteKit)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        svelte = {},
      },
    },
  },
}
