vim.g.mapleader = ' '
vim.cmd([[syntax enable]])

vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.conceallevel = 0
vim.opt.tabstop = 8
vim.opt.shiftwidth = 8
vim.opt.hidden = true
vim.opt.ruler = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.wrap = true
vim.opt.autochdir = true
vim.opt.colorcolumn = '80'
vim.opt.background = 'dark'

-- General configuration

vim.keymap.set('n', '-', '$')
vim.keymap.set('n', '_', '^')

local function set_local(opts)
  for key, value in pairs(opts) do
    vim.opt_local[key] = value
  end
end

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.ledger",
  callback = function()
    set_local({ tabstop = 30, shiftwidth = 30 })
  end,
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.tex",
  callback = function()
    set_local({ tabstop = 4, shiftwidth = 4 })
  end,
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.wiki",
  callback = function()
    set_local({ textwidth = 80 })
  end,
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.rs",
  callback = function()
    set_local({ tabstop = 4, shiftwidth = 4 })
  end,
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.nix",
  callback = function()
    set_local({ expandtab = true, tabstop = 2, shiftwidth = 2 })
  end,
})

vim.cmd([[highlight ColorColumn ctermbg=235]])

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<C-Up>',    ':resize +5<CR>', opts)
vim.keymap.set('n', '<C-Down>',  ':resize -5<CR>', opts)
vim.keymap.set('n', '<C-Left>',  ':vertical resize -5<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +5<CR>', opts)
vim.keymap.set('n', '<C-j>',     ':resize +5<CR>', opts)
vim.keymap.set('n', '<C-k>',     ':resize -5<CR>', opts)
vim.keymap.set('n', '<C-l>',     ':vertical resize -5<CR>', opts)
vim.keymap.set('n', '<C-h>',     ':vertical resize +5<CR>', opts)

--vim.cmd([[colorscheme gruvbox]])

local goyo_lualine_group = vim.api.nvim_create_augroup("GoyoLualine", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = "GoyoEnter",
  group = goyo_lualine_group,
  callback = function()
    require('lualine').hide()
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "GoyoLeave",
  group = goyo_lualine_group,
  callback = function()
    require('lualine').hide({ unhide = true })
  end,
})
local goyo_wrap_group = vim.api.nvim_create_augroup("GoyoWrap", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = "GoyoEnter",
  group = goyo_wrap_group,
  command = "setlocal wrap linebreak"
})
vim.api.nvim_create_autocmd("User", {
  pattern = "GoyoLeave",
  group = goyo_wrap_group,
  command = "setlocal nowrap nolinebreak"
})

----------------------------------------------------------------- Plugin configs

require('lualine').setup()

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}
pcall(require('telescope').load_extension, 'fzf')
vim.keymap.set('n', '<space>fr', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<space>bb', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<space>fB', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<space>fg', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<space>ff', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<space>fh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<space>fw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<space>ft', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })

vim.api.nvim_set_keymap('n', '<space>G', ':Goyo<CR>', {noremap = true, silent = true})

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
