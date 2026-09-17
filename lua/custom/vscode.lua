-- ===========================================================================
-- VSCode-flavoured Neovim
-- ===========================================================================
-- Required from the bottom of init.lua, so everything here wins over keymaps
-- and options set earlier.
--
-- Why Ctrl and not Cmd: Ghostty keeps the macOS Cmd shortcuts for itself, so
-- these follow VSCode's Windows/Linux keymap, which reaches Neovim through a
-- terminal intact. The Cmd (<D-...>) twin of each chord is registered too --
-- inert under Ghostty, but it makes this same config behave like macOS VSCode
-- if you ever open it in Neovide.
--
-- Ctrl+Shift+<key>, Ctrl+/ and Ctrl+` need the kitty keyboard protocol to be
-- distinguishable. Ghostty speaks it. In Terminal.app they silently do nothing.
--
-- Deliberate casualties, where VSCode beat Vim:
--   <C-d>  half-page down    -> add next occurrence to multi-cursor
--   <C-f>  page forward      -> find in file      (page with <PageDown>/<C-e>)
--   <C-b>  page backward     -> toggle sidebar
--   <C-a>  increment number  -> select all        (increment moved to g<C-a>)
--   <C-x>  decrement number  -> cut               (decrement moved to g<C-x>)
--   <C-t>  pop tag stack     -> go to symbol      (jump back with <C-o>)
--   <C-z>  suspend Neovim    -> undo
--   <C-g>  show file info    -> go to line
-- <C-v> is left alone: blockwise visual is worth more than a paste key that
-- Cmd+V already covers.

local function map(mode, lhs, rhs, desc, extra)
  local opts = { silent = true, desc = desc }
  if extra then
    opts = vim.tbl_extend('force', opts, extra)
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Bind one action to both Ctrl+<suffix> and Cmd+<suffix>.
local function chord(mode, suffix, rhs, desc, extra)
  map(mode, '<C-' .. suffix .. '>', rhs, desc, extra)
  map(mode, '<D-' .. suffix .. '>', rhs, desc, extra)
end

local function picker(name, opts)
  return function()
    require('telescope.builtin')[name](opts or {})
  end
end

-- Pickers are normal/visual only. Insert mode is left to nvim-cmp, which owns
-- <C-p>, <C-n>, <C-f> and <C-b> while the suggestion menu is up.
local nv = { 'n', 'v' }

-- --- Files, search, symbols ------------------------------------------------

chord(nv, 'p', picker 'find_files', 'Quick Open file')
chord(nv, 'S-p', picker 'commands', 'Command palette')
chord(nv, 'S-f', picker 'live_grep', 'Find in files')
chord(nv, 'S-r', picker 'oldfiles', 'Open recent')
chord(nv, 'S-o', picker 'lsp_document_symbols', 'Go to symbol in file')
chord(nv, 't', picker 'lsp_dynamic_workspace_symbols', 'Go to symbol in workspace')
chord(nv, 'f', picker('current_buffer_fuzzy_find', { previewer = false, sorting_strategy = 'ascending' }), 'Find in file')

chord(nv, ',', function()
  require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
end, 'Open settings (Neovim config)')

chord(nv, 'g', function()
  vim.ui.input({ prompt = 'Go to line: ' }, function(input)
    local n = tonumber(input)
    if not n then
      return
    end
    local last = vim.api.nvim_buf_line_count(0)
    vim.api.nvim_win_set_cursor(0, { math.max(1, math.min(n, last)), 0 })
    vim.cmd 'normal! zz'
  end)
end, 'Go to line')

-- --- Editor tabs ----------------------------------------------------------

-- Closes the buffer while leaving the window layout alone, and asks about
-- unsaved work the way VSCode does.
local function close_editor()
  local cur = vim.api.nvim_get_current_buf()

  if vim.bo[cur].modified then
    local name = vim.fn.expand '%:t'
    local answer = vim.fn.confirm(('Save changes to "%s"?'):format(name == '' and '[No Name]' or name), '&Save\n&Discard\n&Cancel', 1, 'Question')
    if answer == 1 then
      vim.cmd 'write'
    elseif answer ~= 2 then
      return
    end
  end

  local replacement
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= cur and vim.bo[buf].buflisted then
      replacement = buf
      break
    end
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == cur then
      if replacement then
        vim.api.nvim_win_set_buf(win, replacement)
      else
        vim.api.nvim_win_call(win, function()
          vim.cmd 'enew'
        end)
      end
    end
  end

  vim.cmd('bdelete! ' .. cur)
end

map('n', '<C-PageDown>', '<Cmd>BufferLineCycleNext<CR>', 'Next editor')
map('n', '<C-PageUp>', '<Cmd>BufferLineCyclePrev<CR>', 'Previous editor')
map('n', '<D-S-]>', '<Cmd>BufferLineCycleNext<CR>', 'Next editor')
map('n', '<D-S-[>', '<Cmd>BufferLineCyclePrev<CR>', 'Previous editor')
map('n', ']b', '<Cmd>BufferLineCycleNext<CR>', 'Next editor')
map('n', '[b', '<Cmd>BufferLineCyclePrev<CR>', 'Previous editor')

chord('n', 'S-w', close_editor, 'Close editor')
map('n', '<D-w>', close_editor, 'Close editor')
map('n', '<leader>bd', close_editor, 'Close editor')
map('n', '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', 'Close other editors')
map('n', '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', 'Pin editor')

-- Jump straight to a tab. <leader>N always works; Alt/Cmd need a terminal that
-- forwards those modifiers.
for i = 1, 9 do
  local function go()
    require('bufferline').go_to(i, true)
  end
  map('n', '<leader>' .. i, go, 'Go to editor ' .. i)
  map('n', '<A-' .. i .. '>', go, 'Go to editor ' .. i)
  map('n', '<D-' .. i .. '>', go, 'Go to editor ' .. i)
end

-- --- Sidebar, panels, terminal ---------------------------------------------

chord('n', 'b', '<Cmd>Neotree toggle<CR>', 'Toggle sidebar')
chord('n', 'S-e', '<Cmd>Neotree focus reveal<CR>', 'Focus Explorer')
chord('n', 'S-m', '<Cmd>Trouble diagnostics toggle<CR>', 'Problems panel')
chord('n', 'S-g', '<Cmd>LazyGit<CR>', 'Source Control')
chord('n', 'S-x', '<Cmd>Lazy<CR>', 'Extensions (plugin manager)')

chord('n', '`', '<Cmd>ToggleTerm<CR>', 'Toggle terminal')
map('t', '<C-`>', '<Cmd>ToggleTerm<CR>', 'Toggle terminal')
map('n', '<leader>tt', '<Cmd>ToggleTerm<CR>', 'Toggle terminal')

map('n', '<leader>xx', '<Cmd>Trouble diagnostics toggle<CR>', 'Problems (workspace)')
map('n', '<leader>xX', '<Cmd>Trouble diagnostics toggle filter.buf=0<CR>', 'Problems (this file)')
map('n', '<leader>xs', '<Cmd>Trouble symbols toggle<CR>', 'Outline')

chord('n', '\\', '<Cmd>vsplit<CR>', 'Split editor right')

-- --- Editing --------------------------------------------------------------

-- Save. VSCode saves from wherever you are; leaving insert first keeps
-- format-on-save from reflowing the text under the cursor.
chord('n', 's', '<Cmd>write<CR>', 'Save')
chord('i', 's', '<Esc><Cmd>write<CR>', 'Save')
chord('n', 'S-s', '<Cmd>wall<CR>', 'Save all')

-- Undo / redo, rather than suspending Neovim to the shell.
chord('n', 'z', 'u', 'Undo')
chord('i', 'z', '<C-o>u', 'Undo')
chord('n', 'S-z', '<C-r>', 'Redo')
chord('i', 'S-z', '<C-o><C-r>', 'Redo')

-- Select all.
chord('n', 'a', 'ggVG', 'Select all')
chord('i', 'a', '<Esc>ggVG', 'Select all')
map('n', 'g<C-a>', '<C-a>', 'Increment number')
map('n', 'g<C-x>', '<C-x>', 'Decrement number')

-- Cut / copy. Paste is only bound in insert and cmdline mode, so normal-mode
-- <C-v> stays blockwise visual.
chord('x', 'x', '"+d', 'Cut')
chord('n', 'x', '"+dd', 'Cut line')
chord('x', 'c', '"+y', 'Copy')
chord('i', 'v', '<C-r>+', 'Paste')
chord('c', 'v', '<C-r>+', 'Paste')

-- Toggle comment. Terminals encode Ctrl+/ as either <C-/> or <C-_>.
for _, lhs in ipairs { '<C-/>', '<C-_>', '<D-/>' } do
  map('n', lhs, 'gcc', 'Toggle line comment', { remap = true })
  map('x', lhs, 'gc', 'Toggle comment', { remap = true })
  map('i', lhs, '<Esc>gccgi', 'Toggle line comment', { remap = true })
end

-- Move line(s). Alt matches VSCode; <C-j>/<C-k> is the version guaranteed to
-- survive a terminal that does not forward Option as Alt.
--
-- The line moves verbatim. Kickstart used to append `==` to reindent it, which
-- VSCode does not do and which silently rewrites the indentation of whatever
-- you just moved. Append `==` again here if you preferred that.
local move_down = { '<A-Down>', '<A-j>', '<C-j>' }
local move_up = { '<A-Up>', '<A-k>', '<C-k>' }
for _, lhs in ipairs(move_down) do
  map('n', lhs, '<Cmd>move .+1<CR>', 'Move line down')
  map('i', lhs, '<Esc><Cmd>move .+1<CR>gi', 'Move line down')
  map('x', lhs, ":move '>+1<CR>gv", 'Move selection down')
end
for _, lhs in ipairs(move_up) do
  map('n', lhs, '<Cmd>move .-2<CR>', 'Move line up')
  map('i', lhs, '<Esc><Cmd>move .-2<CR>gi', 'Move line up')
  map('x', lhs, ":move '<-2<CR>gv", 'Move selection up')
end

-- Duplicate line(s).
map('n', '<A-S-Down>', 'yyp', 'Duplicate line down')
map('n', '<A-S-Up>', 'yyP', 'Duplicate line up')
map('x', '<A-S-Down>', ":copy '><CR>gv", 'Duplicate selection down')
map('x', '<A-S-Up>', ":copy '<-1<CR>gv", 'Duplicate selection up')

-- Delete line.
chord('n', 'S-k', '"_dd', 'Delete line')
chord('i', 'S-k', '<Esc>"_ddgi', 'Delete line')

-- Insert line below / above without splitting at the cursor.
chord('n', 'CR', 'o', 'Insert line below')
chord('i', 'CR', '<Esc>o', 'Insert line below')
chord('n', 'S-CR', 'O', 'Insert line above')
chord('i', 'S-CR', '<Esc>O', 'Insert line above')

-- Expand the selection to whole lines.
chord('n', 'l', 'V', 'Select line')
chord('x', 'l', 'j', 'Extend selection by line')

-- Indent / outdent a selection, keeping it selected.
map('x', '<Tab>', '>gv', 'Indent')
map('x', '<S-Tab>', '<gv', 'Outdent')

-- Delete the previous word while typing.
map('i', '<C-BS>', '<C-w>', 'Delete word before cursor')

-- --- Multi-cursor ---------------------------------------------------------
-- Ctrl+D and Ctrl+Shift+L are configured on vim-visual-multi itself, in
-- lua/custom/plugins/multicursor.lua. These are the add-cursor-above/below
-- pair, on a chord that survives terminals which eat Ctrl+Alt+Arrow.

map({ 'n', 'x' }, '<C-S-Down>', '<Plug>(VM-Add-Cursor-Down)', 'Add cursor below', { remap = true })
map({ 'n', 'x' }, '<C-S-Up>', '<Plug>(VM-Add-Cursor-Up)', 'Add cursor above', { remap = true })

-- --- Language features ----------------------------------------------------

local function diagnostic_jump(count)
  return function()
    if vim.diagnostic.jump then
      vim.diagnostic.jump { count = count, float = true }
    elseif count > 0 then
      vim.diagnostic.goto_next { float = true }
    else
      vim.diagnostic.goto_prev { float = true }
    end
  end
end

map('n', '<F8>', diagnostic_jump(1), 'Next problem')
map('n', '<S-F8>', diagnostic_jump(-1), 'Previous problem')

local function format_buffer()
  require('conform').format { async = true, lsp_format = 'fallback' }
end

chord({ 'n', 'x' }, 'S-i', format_buffer, 'Format document')
map({ 'n', 'x' }, '<A-S-f>', format_buffer, 'Format document')
chord({ 'n', 'x' }, '.', vim.lsp.buf.code_action, 'Quick fix / code action')

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('vscode-lsp-keys', { clear = true }),
  callback = function(event)
    local function lmap(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, silent = true, desc = 'VSCode: ' .. desc })
    end

    lmap('n', '<F2>', vim.lsp.buf.rename, 'Rename symbol')
    lmap('n', '<F12>', picker 'lsp_definitions', 'Go to definition')
    lmap('n', '<S-F12>', picker 'lsp_references', 'Go to references')
    lmap('n', '<C-F12>', picker 'lsp_implementations', 'Go to implementation')
    lmap({ 'n', 'i' }, '<C-S-Space>', vim.lsp.buf.signature_help, 'Parameter hints')

    -- Ctrl+click a symbol to jump to its definition, as in VSCode.
    lmap('n', '<C-LeftMouse>', function()
      vim.cmd 'normal! <LeftMouse>'
      require('telescope.builtin').lsp_definitions()
    end, 'Go to definition (mouse)')
  end,
})

-- --- Diagnostics presentation ---------------------------------------------
-- VSCode underlines problems and shows the message when you rest on them,
-- rather than printing it at the end of the line. <leader>tv turns the inline
-- text on if you prefer the Error Lens look.

vim.diagnostic.config {
  underline = true,
  virtual_text = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
}

map('n', '<leader>tv', function()
  local on = vim.diagnostic.config().virtual_text
  vim.diagnostic.config { virtual_text = not on and { prefix = '●', spacing = 2 } or false }
end, 'Toggle inline diagnostics')

local hover_group = vim.api.nvim_create_augroup('vscode-hover-diagnostics', { clear = true })
vim.api.nvim_create_autocmd('CursorHold', {
  group = hover_group,
  callback = function()
    -- Don't stack a second float on top of one that is already open.
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(win).relative ~= '' then
        return
      end
    end
    vim.diagnostic.open_float(nil, {
      scope = 'cursor',
      focusable = false,
      close_events = { 'CursorMoved', 'CursorMovedI', 'InsertEnter', 'BufLeave' },
    })
  end,
})

-- --- Behaviour ------------------------------------------------------------

-- Pick up edits made outside Neovim, the way VSCode reloads a changed file.
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave', 'CursorHold' }, {
  group = vim.api.nvim_create_augroup('vscode-autoread', { clear = true }),
  callback = function()
    if vim.bo.buftype == '' and vim.fn.mode() ~= 'c' then
      vim.cmd 'checktime'
    end
  end,
})

-- Reopen a file where you left off.
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('vscode-restore-cursor', { clear = true }),
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(event.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- --- Options --------------------------------------------------------------
-- Only the ones kickstart does not already set. `relativenumber` and
-- `listchars` are turned down in init.lua, where they are first defined.

vim.opt.termguicolors = true
vim.opt.wrap = false -- VSCode ships with word wrap off
vim.opt.autoread = true
vim.opt.confirm = true -- prompt about unsaved work instead of refusing to quit
vim.opt.title = true
vim.opt.laststatus = 3 -- one status bar for the whole window, not per split
vim.opt.showtabline = 2 -- editor tabs are always visible
vim.opt.pumheight = 12 -- bound the suggestion list
vim.opt.sidescrolloff = 8
vim.opt.smoothscroll = true
vim.opt.splitkeep = 'screen'
vim.opt.mousemoveevent = true -- lets the tab bar react to hover
vim.opt.keymodel = 'startsel,stopsel' -- Shift+arrows select, like every other editor
