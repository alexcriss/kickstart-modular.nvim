local function gh(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add({
  gh 'Mofiqul/dracula.nvim',
  gh 'nvim-lua/plenary.nvim',
  gh 'folke/snacks.nvim',
  gh 'nvim-mini/mini.nvim',
  { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' },
  gh 'nvim-treesitter/nvim-treesitter-context',
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'stevearc/conform.nvim',
  gh 'mfussenegger/nvim-lint',
  gh 'folke/which-key.nvim',
  gh 'lewis6991/gitsigns.nvim',
  gh 'MagicDuck/grug-far.nvim',
  gh 'stevearc/quicker.nvim',
  gh 'stevearc/oil.nvim',
  gh 'nmac427/guess-indent.nvim',
  { src = gh 'jake-stewart/multicursor.nvim', version = '1.0' },
  gh 'Shatur/neovim-session-manager',
  gh 'coffebar/neovim-project',
  gh 'mfussenegger/nvim-dap',
  { src = gh 'igorlfs/nvim-dap-view', version = vim.version.range '1.*' },
  gh 'leoluz/nvim-dap-go',
}, { confirm = false })

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack-hooks', { clear = true }),
  callback = function(ev)
    if ev.data.kind == 'update' and ev.data.spec.name == 'nvim-treesitter' then
      vim.cmd 'TSUpdate'
    end
  end,
})

vim.cmd.packadd 'nvim.undotree'
vim.cmd.packadd 'nvim.difftool'
vim.cmd.packadd 'cfilter'

vim.cmd.colorscheme 'dracula'

require 'plugins.snacks'
require 'plugins.treesitter'
require 'plugins.editing'
require 'plugins.git'
require 'plugins.format'
require 'plugins.projects'
