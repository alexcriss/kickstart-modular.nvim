-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    close_if_last_window = true,
    sources = {
      'filesystem',
      -- 'buffers',
      -- 'git_status',
      -- "document_symbols",
    },
    source_selector = {
      winbar = false, -- toggle to show selector on winbar
      statusline = false, -- toggle to show selector on statusline
      show_scrolled_off_parent_node = false, -- this will replace the tabs with the parent path
      -- of the top visible node when scrolled down.
      sources = {
        { source = 'filesystem' },
        -- { source = 'buffers' },
        -- { source = 'git_status' },
      },
      content_layout = 'center', -- only with `tabs_layout` = "equal", "focus"
      --                start  : |/ 󰓩 bufname     \/...
      --                end    : |/     󰓩 bufname \/...
      --                center : |/   󰓩 bufname   \/...
      tabs_layout = 'equal', -- start, end, center, equal, focus
      --             start  : |/  a  \/  b  \/  c  \            |
      --             end    : |            /  a  \/  b  \/  c  \|
      --             center : |      /  a  \/  b  \/  c  \      |
      --             equal  : |/    a    \/    b    \/    c    \|
      --             active : |/  focused tab    \/  b  \/  c  \|
      truncation_character = '…', -- character to use when truncating the tab label
      tabs_min_width = nil, -- nil | int: if int padding is added based on `content_layout`
      tabs_max_width = nil, -- this will truncate text even if `text_trunc_to_fit = false`
      padding = 0, -- can be int or table
      -- padding = { left = 2, right = 0 },
      -- separator = "▕", -- can be string or table, see below
      separator = { left = '▏', right = '▕' },
      -- separator = { left = "/", right = "\\", override = nil },     -- |/  a  \/  b  \/  c  \...
      -- separator = { left = "/", right = "\\", override = "right" }, -- |/  a  \  b  \  c  \...
      -- separator = { left = "/", right = "\\", override = "left" },  -- |/  a  /  b  /  c  /...
      -- separator = { left = "/", right = "\\", override = "active" },-- |/  a  / b:active \  c  \...
      -- separator = "|",                                              -- ||  a  |  b  |  c  |...
      separator_active = nil, -- set separators around the active tab. nil falls back to `source_selector.separator`
      show_separator_on_edge = false,
      --                       true  : |/    a    \/    b    \/    c    \|
      --                       false : |     a    \/    b    \/    c     |
      highlight_tab = 'NeoTreeTabInactive',
      highlight_tab_active = 'NeoTreeTabActive',
      highlight_background = 'NeoTreeTabInactive',
      highlight_separator = 'NeoTreeTabSeparatorInactive',
      highlight_separator_active = 'NeoTreeTabSeparatorActive',
    },
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
