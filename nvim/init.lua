-- ===============================================
-- Neovim configuration (Neovim 0.10.x)
-- ===============================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Theme
  { "folke/tokyonight.nvim" },

  -- Status line
  { "nvim-lualine/lualine.nvim" },

  -- Git integration
  { "lewis6991/gitsigns.nvim" },

  -- Mini utilities (pairs, surround, etc.)
  { "echasnovski/mini.nvim", version = "*" },

  -- Treesitter (syntax highlighting)
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Fuzzy finder (uses builtin fzf-java for now)
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function() return vim.fn.executable("fzf") == 1 end,
  },
}, {
  defaults = { lazy = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "netrwPlugin",
        "rplugin", "spellfilePlugin", "tutor", "quotesPermutations",
      },
    },
  },
})

-- ===============================================
-- Options
-- ===============================================

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.colorcolumn = "100"

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.termguicolors = true
opt.hidden = true
opt.ignorecase = true
opt.smartcase = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.updatetime = 200
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.iskeyword:append("-")

-- Better netrw
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- ===============================================
-- Keymaps
-- ===============================================

vim.g.mapleader = " "
local map = vim.keymap.set

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Resize
map("n", "<M-h>", "<C-w>5<", { desc = "Resize left" })
map("n", "<M-l>", "<C-w>5>", { desc = "Resize right" })

-- Files / buffers
map("n", "<leader>ee", ":Lexplore<CR>", { desc = "Toggle netrw" })
map("n", "<leader>ff", ":FzfLua files<CR>", { desc = "Find files (if fzflua installed)" })
map("n", "<leader>fb", ":buffers<CR>", { desc = "List buffers" })

-- Git
map("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
map("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })

-- Move lines
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- ===============================================
-- Theme
-- ===============================================

vim.cmd([[colorscheme tokyonight]])
vim.opt.background = "dark"
