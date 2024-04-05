-- set tab width to 2 instead of 4
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set leader to space
vim.g.mapleader = " "

-- enable 24-bit color
vim.opt.termguicolors = true

-- set up lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- add plugins here for lazy to load
local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        setup = function()
            require("nvim-tree").setup({
                sort = { sorter = "case_sensitive" },
                view = { width = 30 },
                renderer = { group_empty = true },
                filters = { dotfiles = true },
            })
        end,
    },
}

local opts = {}

require("lazy").setup(plugins, opts)
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

local config = require("nvim-treesitter.configs")
config.setup({
    ensure_installed = { "lua", "javascript", "typescript", "rust" },
    highlight = { enable = true },
    indent = { enable = true },
})

require("nvim-tree").setup()
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

