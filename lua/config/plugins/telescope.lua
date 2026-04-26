return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup()

      vim.keymap.set("n", "<leader>ff", builtin.find_files, { silent = true, desc = "Find file" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { silent = true, desc = "Live grep" })
      vim.keymap.set("n", "<leader>/", builtin.live_grep, { silent = true, desc = "Search workspace" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { silent = true, desc = "Find buffer" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { silent = true, desc = "Help tags" })
      vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { silent = true, desc = "LSP references" })
      vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { silent = true, desc = "Document symbols" })
      vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, { silent = true, desc = "Workspace symbols" })
      vim.keymap.set("n", "<leader>o", builtin.lsp_document_symbols, { silent = true, desc = "Outline symbols" })
    end,
  },
}
