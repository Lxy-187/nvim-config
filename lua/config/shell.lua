local shell = nil

if vim.fn.executable("zsh") == 1 then
  shell = "zsh"
elseif vim.env.SHELL and vim.env.SHELL ~= "" and vim.fn.executable(vim.env.SHELL) == 1 then
  shell = vim.env.SHELL
elseif vim.fn.executable("bash") == 1 then
  shell = "bash"
end

if shell then
  vim.opt.shell = shell
end

if vim.o.shell ~= "" then
  vim.opt.shellcmdflag = "-lc"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end
