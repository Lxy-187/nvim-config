local parser_install_dir = vim.fn.stdpath("data") .. "/site"
local warned_languages = {}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = function()
      require("nvim-treesitter").install({
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "python",
        "javascript",
        "html",
        "css",
        "c",
        "cpp",
      }):wait(300000)
      vim.cmd("TSUpdate")
    end,
    config = function()
      vim.opt.runtimepath:append(parser_install_dir)

      require("nvim-treesitter").setup({
        parser_install_dir = parser_install_dir,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "lua",
          "vim",
          "markdown",
          "python",
          "javascript",
          "html",
          "css",
          "c",
          "cpp",
        },
        callback = function(args)
          local ok, err = pcall(vim.treesitter.start, args.buf)
          if not ok then
            local language = vim.bo[args.buf].filetype
            if not warned_languages[language] then
              warned_languages[language] = true
              vim.notify(
                string.format("Treesitter parser for '%s' is not available yet. Install it with :TSInstall %s", language, language),
                vim.log.levels.WARN
              )
            end
          end
        end,
      })
    end,
  },
}
