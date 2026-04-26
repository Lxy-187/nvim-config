local function open_term_current(argv, cwd)
  vim.cmd("enew")
  vim.fn.termopen(argv, { cwd = cwd or vim.fn.getcwd() })
  vim.cmd("startinsert")
end

local function open_term_right(argv, cwd)
  vim.cmd("rightbelow vnew")
  vim.fn.termopen(argv, { cwd = cwd or vim.fn.getcwd() })
  vim.cmd("startinsert")
end

local function shell_argv_for_command(command)
  local shell = vim.o.shell ~= "" and vim.o.shell or vim.env.SHELL

  if shell ~= nil and shell ~= "" and vim.fn.executable(shell) == 1 then
    return { shell, "-lc", command }
  end

  if vim.fn.executable("bash") == 1 then
    return { "bash", "-lc", command }
  end

  return { "sh", "-c", command }
end

local function open_term_command(command, cwd)
  open_term_current(shell_argv_for_command(command), cwd)
end

local function default_shell_argv()
  local shell = vim.o.shell ~= "" and vim.o.shell or vim.env.SHELL

  if shell ~= nil and shell ~= "" and vim.fn.executable(shell) == 1 then
    return { shell, "-l" }
  end

  if vim.fn.executable("bash") == 1 then
    return { "bash", "-l" }
  end

  return { "sh" }
end

local function current_file()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("No file is associated with the current buffer", vim.log.levels.WARN)
    return nil
  end
  return file
end

local function compiler_for_current_file()
  local filetype = vim.bo.filetype

  if filetype == "c" then
    if vim.fn.executable("gcc") == 1 then
      return "gcc"
    end
    if vim.fn.executable("clang") == 1 then
      return "clang"
    end
  end

  if filetype == "cpp" then
    if vim.fn.executable("g++") == 1 then
      return "g++"
    end
    if vim.fn.executable("clang++") == 1 then
      return "clang++"
    end
  end
end

local function compile_current_file_command()
  local file = current_file()
  if not file then
    return nil
  end

  local compiler = compiler_for_current_file()
  if not compiler then
    vim.notify("No compiler found for the current filetype", vim.log.levels.WARN)
    return nil
  end

  local output = vim.fn.expand("%:p:r")
  local quoted_file = vim.fn.shellescape(file)
  local quoted_output = vim.fn.shellescape(output)

  if vim.bo.filetype == "c" then
    return string.format("%s -std=c17 -Wall -Wextra -g %s -o %s", compiler, quoted_file, quoted_output)
  end

  return string.format("%s -std=c++20 -Wall -Wextra -g %s -o %s", compiler, quoted_file, quoted_output)
end

local function run_current_binary_command()
  local file = current_file()
  if not file then
    return nil
  end

  local output = vim.fn.expand("%:p:r")
  if vim.fn.executable(output) ~= 1 then
    vim.notify("Current file has not been compiled yet", vim.log.levels.WARN)
    return nil
  end

  return vim.fn.shellescape(output)
end

local function project_build_command()
  local cwd = vim.fn.getcwd()
  local has_make = vim.fn.filereadable(cwd .. "/Makefile") == 1 or vim.fn.filereadable(cwd .. "/makefile") == 1
  local has_build_ninja = vim.fn.filereadable(cwd .. "/build.ninja") == 1
  local has_cmake = vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1
  local has_build_dir = vim.fn.isdirectory(cwd .. "/build") == 1

  if has_make and vim.fn.executable("make") == 1 then
    return "make"
  end

  if has_build_ninja and vim.fn.executable("ninja") == 1 then
    return "ninja"
  end

  if has_cmake and vim.fn.executable("cmake") == 1 then
    if has_build_dir then
      return "cmake --build build"
    end
    return "cmake -S . -B build && cmake --build build"
  end

  vim.notify("No supported project build workflow found in the current directory", vim.log.levels.WARN)
end

vim.keymap.set("n", "<leader>tt", function()
  local cwd = vim.fn.getcwd()
  open_term_current(default_shell_argv(), cwd)
end, {
  silent = true,
  desc = "Open shell terminal",
})

vim.keymap.set("n", "<leader>tz", function()
  if vim.fn.executable("zsh") == 0 then
    vim.notify("zsh not found in PATH", vim.log.levels.WARN)
    return
  end

  local cwd = vim.fn.getcwd()
  open_term_right({ "zsh", "-l" }, cwd)
end, {
  silent = true,
  desc = "Open zsh terminal in right split",
})

vim.keymap.set("n", "<leader>cb", function()
  local command = compile_current_file_command()
  if command then
    open_term_command(command, vim.fn.getcwd())
  end
end, {
  silent = true,
  desc = "Compile current file",
})

vim.keymap.set("n", "<leader>cr", function()
  local command = run_current_binary_command()
  if command then
    open_term_command(command, vim.fn.getcwd())
  end
end, {
  silent = true,
  desc = "Run current binary",
})

vim.keymap.set("n", "<leader>ct", function()
  local compile_command = compile_current_file_command()
  local run_command = run_current_binary_command()
  if compile_command and run_command then
    open_term_command(compile_command .. " && " .. run_command, vim.fn.getcwd())
  elseif compile_command then
    local output = vim.fn.shellescape(vim.fn.expand("%:p:r"))
    open_term_command(compile_command .. " && " .. output, vim.fn.getcwd())
  end
end, {
  silent = true,
  desc = "Compile and run current file",
})

vim.keymap.set("n", "<leader>cm", function()
  local command = project_build_command()
  if command then
    open_term_command(command, vim.fn.getcwd())
  end
end, {
  silent = true,
  desc = "Build current project",
})

vim.keymap.set("n", "<leader>tq", "<cmd>bd!<CR>", { silent = true, desc = "Close terminal buffer" })

vim.keymap.set("t", "<Esc>", function()
  vim.api.nvim_feedkeys(vim.keycode("<C-\\><C-n>"), "n", false)
end, { silent = true, desc = "Exit terminal mode" })
vim.keymap.set("i", "jj", "<Esc>", { silent = true, desc = "Exit insert mode" })

vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", { silent = true, desc = "Write file" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<CR>", { silent = true, desc = "Quit window" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { silent = true, desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { silent = true, desc = "Previous buffer" })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { silent = true, desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { silent = true, desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { silent = true, desc = "Show diagnostic" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true, desc = "Focus left window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true, desc = "Focus right window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true, desc = "Focus lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true, desc = "Focus upper window" })
