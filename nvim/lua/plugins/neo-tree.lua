-- File explorer sidebar
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<leader>E", "<cmd>Neotree toggle<cr>", desc = "Neo-tree: Toggle" },
	},
	opts = {
		filesystem = {
			filtered_items = {
				hide_dotfiles = false,
				hide_gitignored = true,
			},
			follow_current_file = {
				enabled = true,
			},
		},
		window = {
			width = 35,
		},
	},
}
