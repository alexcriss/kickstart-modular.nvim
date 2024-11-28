return {
  'coffebar/neovim-project',
  opts = {
    projects = {
      '~/Repos/*',
      '~/Personal/money/*',
      '~/Personal/ireny/*',
      '~/.config/*',
      -- on the sandbox
      '~/roles/*',
      '~/svn/tags/*',
      '~/svn/migrations/*',
    },
    picker = {
      type = 'telescope',
    },
    last_session_on_startup = false,
    dashboard = false,
  },
  init = function()
    -- enable saving the state of plugins in the session
    vim.opt.sessionoptions:append 'globals' -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  end,
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope.nvim' },
    { 'Shatur/neovim-session-manager' },
  },
  keys = {
    { '<Leader>op', '<Cmd>NeovimProjectDiscover<CR>', mode = { 'n', 'x' }, desc = '[O]pen [P]rojects picker' },
  },
  lazy = false,
  priority = 100,
}
