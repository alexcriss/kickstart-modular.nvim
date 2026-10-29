# nvim config

Neovim 0.12+. Plugins are managed by the built-in `vim.pack`; the lockfile is
`nvim-pack-lock.json`. 22 plugins, no plugin manager, no completion engine,
no statusline plugin: snacks.nvim, mini.nvim and Neovim builtins do most of it.

- `lua/plugins/init.lua`: plugin list, then one file per concern.
- `lua/lsp.lua`: servers, Mason packages, native completion.
- `lua/debugging.lua`: nvim-dap + nvim-dap-view, mouse breakpoints, hover eval.

## Maintenance

- `:lua vim.pack.update()` fetches plugin updates. Review the buffer, `:w` to apply, `:q` to discard.
- `:Mason` manages language servers and tools. Missing ones from the list in
  `lua/lsp.lua` are installed automatically on startup.
- `:TSUpdate` updates tree-sitter parsers (needs `tree-sitter-cli`, `brew install tree-sitter-cli`).
- `:checkhealth`, `:lsp` (interactive LSP manager), `ZR` restarts nvim and restores the session.
- Messages/cmdline use the experimental `ui2`. `g<` shows the message pager. To go back to
  the classic UI delete the `ui2` block at the bottom of `lua/options.lua`.

## Daily keys

Finding things (all snacks pickers; `<C-q>` inside any picker sends the results to quickfix,
`i` / `/` toggles between typing and Normal-mode navigation of the list):

| Key | What |
|---|---|
| `<leader><leader>` | smart find: open buffers, recent files, then project files |
| `<leader>/` | project files (dotfiles shown, gitignored hidden) |
| `<leader>sg` | live grep. Type the pattern. `<a-i>` include gitignored, `<a-h>` hidden |
| `<leader>sw` | grep word under cursor / visual selection |
| `<leader>s/` | grep only open buffers |
| `<leader>sb` `<leader>sr` `<leader>sh` `<leader>sk` | buffers, resume last picker, help, keymaps |
| `<leader>sd` `<leader>sD` | diagnostics (project / buffer) |
| `<leader>ss` `<leader>sS` | document symbols / workspace symbols |
| `<leader>sq` `<leader>sj` `<leader>sm` `<leader>su` `<leader>sc` | quickfix, jumps, marks, undo history, command history |
| `<leader>sn` | this config's files |
| `<leader>sP` | list of every picker |
| `\` or `<leader>e` | focus the file tree (opens it if closed, closes it when pressed inside it). `<leader>E` reveals the current file. snacks explorer keys: `a` add, `d` delete, `r` rename, `m` move, `c` copy, `y`/`p` yank/paste files, `o` open with system app, `H` toggle dotfiles, `I` toggle ignored, `Z` collapse all, `.` focus dir, `<BS>` up, `/` then type to search the whole tree (needs `fd`) |
| `Y` in any picker list, `<C-y>` in the prompt | copy basename / relative path / absolute path of the item to the clipboard |
| `-` | oil: edit the current directory as a buffer |
| `<leader>op` `<leader>oh` | open a project / recent project (restores the session) |

LSP (`K` hover, `gd` definition, `gD` declaration, `gI` implementation, `gT` type definition
open pickers and jump straight away when there is a single result). Builtin Neovim maps
still work too: `grn` rename, `gra` code action, `grr` references to quickfix, `gri`
implementation, `grt` type definition, `gO` outline, `[d` `]d` diagnostics, `<C-w>d` float.

| Key | What |
|---|---|
| `gR` | references in a picker (bottom panel, live filter) |
| `grr` | references into the quickfix list (persistent, editable, see primer) |
| `<leader>rn` `<leader>ca` | rename, code action |
| `<leader>th` `<leader>td` `<leader>tf` `<leader>tw` `<leader>ts` | toggle inlay hints, diagnostics, autoformat, wrap, spell |
| `<leader>f` | format buffer |

Completion is Neovim's own and manual: `<C-Space>` asks the LSP, `<C-n>`/`<C-p>` complete
from open buffers, `<C-x><C-f>` paths. While the menu is open `<Tab>`/`<S-Tab>` move,
`<CR>` accepts the highlighted item, `<C-e>` closes. Nothing is selected by default, so
`<CR>` with no highlighted item just inserts a newline. To get the menu as you type,
set `o.autocomplete = true` in `lua/options.lua`.

Git: `<leader>gg` lazygit, `<leader>gs` status, `<leader>gl` log, `<leader>gL` file log,
`<leader>gb` branches, `<leader>gy` copy permalink, `<leader>gY` open in browser,
`]c` `[c` hunks, `<leader>hs` stage/unstage hunk, `<leader>hr` reset, `<leader>hp` preview,
`<leader>hb` blame, `<leader>hd` diff against index, `<leader>tb` line blame.
`:DiffTool a b` diffs files or directories, `<leader>u` opens the undo tree.
`<leader>gd` opens `git difftool --dir-diff` (Araxis Merge) for the working tree against
the index, `<leader>gD` asks for a revision or range (`HEAD`, `main...`, `HEAD~3 HEAD`).
Araxis sees symlinks to the real working-tree files, so edits there land in the repo.

Multicursor: `<C-n>` add a cursor on the next match of the word/selection (then `q` skips
one, `Q` removes the current cursor), `<C-Up>` `<C-Down>` add cursors vertically,
`<leader>ma` cursor on every match, `ga{motion}` cursor on every line of a motion
(`gaip`), `<C-LeftMouse>` click to add a cursor, `<C-q>` pause/resume cursors, `<Esc>`
clears them. Then just edit: `ciw`, `I`, `A`, `.`, everything applies to all cursors.

Notifications: `<leader>n` history.

## Quickfix primer

The quickfix list is a project-wide list of "file:line:col: text" entries that lives
outside any buffer. Many things fill it; one window shows it; one set of keys walks it.
quicker.nvim makes that window pretty and editable.

Filling it:

- `grr` on a symbol: all references.
- `:grep foo` (ripgrep underneath, so `:grep -t go 'func New'` or `:grep foo lua/`): all matches.
- `<leader>xx`: all diagnostics. `<leader>xX`: this buffer's diagnostics into the location list.
- `<C-q>` in any picker: whatever the picker currently shows (filtered grep, references, files).
- grug-far results via its "open in quickfix" action.

Using it:

- `<leader>q` toggles the window. It opens at the bottom, one line per hit, syntax highlighted.
- `<CR>` on a line jumps there, the window stays open. `]q` `[q` next/previous entry from
  anywhere in the code, `]Q` `[Q` first/last. `:cc 5` jumps to entry 5.
- `>` expands two lines of context around every entry, `<` collapses again.
- Edit the text in place. Change a line, or do `:%s/old/new/g` inside the quickfix window,
  then `:w`. quicker writes every edited line back to its file. That is project-wide
  find and replace with normal Vim editing.
- `:cdo s/old/new/g | update` is the builtin version: run a command on every entry.
- `:cfdo` runs once per file instead of once per entry.
- Delete lines you don't care about with `dd` before `:cdo` or before editing, and
  they're gone from the list.
- Lists stack: `:colder` and `:cnewer` go back to a previous list (so you can `grr`,
  then grep, then return to the references).
- `<leader>sq` opens the current list in a picker if you want to fuzzy-filter it.
- The location list is the same thing but per window: `<leader>l` toggles it,
  `]l` `[l` walk it.

Typical reference workflow: cursor on a function, `grr`, `<leader>q` if the window
didn't open, `>` to see context, `<CR>` to visit, `]q` to walk through, `dd` to drop
noise, edit lines and `:w` to rename call sites by hand where an LSP rename is too blunt.

Typical search-and-replace workflow, interactive: `<leader>Ss` (or `<leader>Sw` with
the word under cursor, or in visual mode on a selection, or `<leader>Sf` for the current
file). The grug-far buffer has four fields: search, replace, files filter (globs like
`*.go` or `!vendor/**`), flags (e.g. `-i`, `-w`, `--multiline`). Results update as you
type. `<Tab>` moves between fields. `<localleader>r` replaces everywhere,
`<localleader>j`/`<localleader>k` apply one replacement at a time (next/previous),
`<Up>`/`<Down>` open the previous/next result in a split, `<CR>` on a result jumps to it,
`<localleader>q` sends results to quickfix, `<localleader>s` syncs edits you made
directly in the result lines back to the files, `<localleader>e` swaps the
ripgrep/ast-grep engine, `<localleader>t` opens search history, `<localleader>c` closes.
Use `g?` inside for the full key list. Replacement is plain ripgrep regex, so `$1`
captures work. The local leader is space, same as leader.

## Debugging

`<F5>` starts/continues (asks which configuration the first time), `<F10>` step over,
`<F11>` step into, `<S-F11>` step out. Same under `<leader>d`: `dc` `do` `di` `dO`,
`dC` run to cursor, `dl` run last, `dt` terminate, `dg` debug nearest Go test.

Mouse: left-click in the gutter (sign/number column) toggles a breakpoint, right-click
sets a conditional one. Double-click a variable while stopped to see its value.
`K` while stopped evaluates the word under cursor (or the visual selection).
`<leader>dw` adds the word to the watches.

nvim-dap-view opens automatically at the bottom when a session starts. The winbar tabs
(Scopes, Watches, Breakpoints, Threads, Exceptions, REPL, Console) are clickable, and
the control buttons on the right run/step/stop. Double-click or `<CR>` expands a
variable, `s` sets its value, `[[` jumps to the parent. Variable values are also shown
inline next to the code. `<leader>du` toggles the view, `g?` inside shows keys.

Adapters: Go via delve (`dap-go`), Python via debugpy, both installed by Mason.
