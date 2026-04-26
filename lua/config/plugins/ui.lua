return {
  { "folke/tokyonight.nvim", priority = 1000 },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local api = require("nvim-tree.api")

      require("nvim-tree").setup({
        hijack_cursor = true,
        sync_root_with_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        view = {
          width = 36,
          preserve_window_proportions = true,
        },
        renderer = {
          group_empty = true,
          highlight_git = true,
          highlight_diagnostics = true,
        },
        filters = {
          dotfiles = false,
        },
        actions = {
          open_file = {
            resize_window = true,
          },
        },
      })

      vim.keymap.set("n", "<leader>n", api.tree.toggle, { silent = true, desc = "Toggle file tree" })
      vim.keymap.set("n", "<leader>no", api.tree.open, { silent = true, desc = "Open file tree" })
      vim.keymap.set("n", "<leader>nf", function()
        api.tree.find_file({
          open = true,
          focus = true,
        })
      end, { silent = true, desc = "Reveal current file in tree" })
      vim.keymap.set("n", "<leader>nc", api.tree.collapse_all, { silent = true, desc = "Collapse file tree" })
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local mode_names = {
        n = "NORMAL",
        no = "O-PENDING",
        nov = "O-PENDING",
        noV = "O-PENDING",
        ["no\22"] = "O-PENDING",
        niI = "NORMAL",
        niR = "NORMAL",
        niV = "NORMAL",
        nt = "NORMAL",
        v = "VISUAL",
        vs = "VISUAL",
        V = "V-LINE",
        Vs = "V-LINE",
        ["\22"] = "V-BLOCK",
        ["\22s"] = "V-BLOCK",
        s = "SELECT",
        S = "S-LINE",
        ["\19"] = "S-BLOCK",
        i = "INSERT",
        ic = "INSERT",
        ix = "INSERT",
        R = "REPLACE",
        Rc = "REPLACE",
        Rx = "REPLACE",
        Rv = "V-REPLACE",
        Rvc = "V-REPLACE",
        Rvx = "V-REPLACE",
        c = "COMMAND",
        cv = "EX",
        ce = "EX",
        r = "PROMPT",
        rm = "MORE",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        t = "TERMINAL",
      }

      local function file_encoding()
        local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
        return encoding:upper()
      end

      local function file_format()
        return vim.bo.fileformat:upper()
      end

      local function indent_style()
        local width = vim.bo.shiftwidth > 0 and vim.bo.shiftwidth or vim.bo.tabstop
        local style = vim.bo.expandtab and "SPACES" or "TABS"
        return string.format("%s:%d", style, width)
      end

      require("lualine").setup({
        options = {
          theme = "tokyonight",
          globalstatus = true,
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(mode)
                local current = vim.api.nvim_get_mode().mode
                return mode_names[current] or mode:upper()
              end,
            },
          },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            {
              "filename",
              path = 1,
            },
          },
          lualine_x = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
            },
            "filetype",
            file_encoding,
            file_format,
            indent_style,
          },
          lualine_y = { "filesize", "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
}
