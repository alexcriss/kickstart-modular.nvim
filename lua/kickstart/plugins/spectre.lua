return {
  'nvim-pack/nvim-spectre',
  config = function(opts)
    vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
      desc = 'Toggle [S]pectre',
    })
  end,
}
