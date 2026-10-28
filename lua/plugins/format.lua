local formatters_by_ft = {
  javascript = { 'prettier', 'eslint_d', stop_after_first = true },
  typescript = { 'prettier', 'eslint_d', stop_after_first = true },
  go = { 'goimports' },
}
if not vim.env.SSH_TTY then
  formatters_by_ft.lua = { 'stylua' }
end

local never_lsp_format = { sh = true, json = true, jsonc = true, yaml = true }
if vim.env.SSH_TTY then
  never_lsp_format = { c = true, cpp = true, sh = true, json = true, jsonc = true, lua = true, php = true }
end

require('conform').setup {
  notify_on_error = false,
  formatters_by_ft = formatters_by_ft,
  format_on_save = function(bufnr)
    if vim.g.autoformat == false or vim.b[bufnr].autoformat == false then
      return
    end
    return {
      timeout_ms = 20000,
      lsp_format = never_lsp_format[vim.bo[bufnr].filetype] and 'never' or 'fallback',
    }
  end,
}

vim.keymap.set('', '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = 'Format buffer' })

local lint = require 'lint'
lint.linters_by_ft = {
  markdown = { 'markdownlint' },
  javascript = { 'eslint_d' },
  typescript = { 'eslint_d' },
}
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('lint', { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
