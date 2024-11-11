return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  options = {
    ignore_focus = { 'neo-tree' },
    disabled_filetypes = { statusline = { 'neo-tree' } },
  },
  config = function(opts)
    require('lualine').setup(opts)
  end,
}
