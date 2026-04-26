local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

local plugins = {}
vim.list_extend(plugins, require("config.plugins.ui"))
vim.list_extend(plugins, require("config.plugins.treesitter"))
vim.list_extend(plugins, require("config.plugins.lsp"))
vim.list_extend(plugins, require("config.plugins.cmp"))
vim.list_extend(plugins, require("config.plugins.telescope"))
vim.list_extend(plugins, require("config.plugins.editing"))

require("lazy").setup(plugins, {
  checker = { enabled = false },
  concurrency = 1,
  git = { timeout = 300 },
  rocks = { enabled = false },
})

vim.cmd("colorscheme tokyonight-night")
