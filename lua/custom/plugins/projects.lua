return {
  'coffebar/neovim-project',
  opts = {
    projects = {
      '~/Repos/*',
      '~/.config/*',
      -- on the sandbox
      '~/roles/*',
      '/home/vipvdev/svn/*',
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
  lazy = false,
  priority = 100,
}
