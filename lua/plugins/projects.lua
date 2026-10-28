require('neovim-project').setup {
  projects = {
    '~/Repos/*',
    '~/Personal/home/*',
    '~/Personal/money/*',
    '~/Personal/alerts/*',
    '~/Personal/*',
    '~/.config/*',
    '~/roles/*',
    '~/svn/tags/*',
    '~/svn/migrations/*',
  },
  picker = { type = 'snacks' },
  last_session_on_startup = false,
  dashboard_mode = false,
}

vim.keymap.set({ 'n', 'x' }, '<leader>op', '<cmd>NeovimProjectDiscover<CR>', { desc = 'Open project' })
vim.keymap.set('n', '<leader>oh', '<cmd>NeovimProjectHistory<CR>', { desc = 'Open recent project' })
