vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

local python3_host = "/home/chuxin/miniforge3/envs/nvim-py/bin/python"
if vim.fn.executable(python3_host) == 1 then
  vim.g.python3_host_prog = python3_host
end

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "ucs-bom", "cp936", "gb18030", "gbk", "latin1" }

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number,line"
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.confirm = true
vim.opt.winborder = "rounded"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.autoread = true
vim.opt.timeoutlen = 300
vim.opt.updatetime = 250
vim.opt.pumheight = 12

local undo_dir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undo_dir, "p")
vim.opt.undofile = true
vim.opt.undodir = undo_dir

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true
local has_clipboard_tool = vim.fn.executable("xclip") == 1
  or vim.fn.executable("xsel") == 1
  or vim.fn.executable("wl-copy") == 1
  or vim.fn.executable("pbcopy") == 1
  or vim.fn.executable("win32yank.exe") == 1
  or vim.fn.executable("clip.exe") == 1

if not has_clipboard_tool then
  -- Over SSH/VPS, fall back to the built-in OSC52 clipboard provider.
  vim.g.clipboard = "osc52"
end

vim.opt.clipboard = "unnamedplus"
vim.opt.tags:append({ "./tags;", "tags;" })

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  command = "checktime",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "json", "jsonc" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})
