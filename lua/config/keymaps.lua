-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local function map(lhs, rhs, desc)
	vim.keymap.set('n', lhs, rhs, { desc = desc })
end

map('<leader>f', '<cmd>Telescope find_files<CR>', 'Telescope')
map('<leader>b', '<cmd>Telescope buffers<CR>', 'Telescope')
map('<leader>g', '<cmd>Telescope live_grep_args<CR>', 'Telescope')
map('<leader>G', '<cmd>Telescope current_buffer_fuzzy_find<CR>', 'Telescope')
map('<leader>e', '<cmd>Dirbuf<CR>', '')
map('<leader>j', '<cmd>HopWord<CR>', '')

current_rust_test_buf = nil
current_rust_build_buf = nil
map('<leader>tw', function() 
	local curr_win = vim.api.nvim_get_current_win()
	if current_rust_test_buf ~= nil then
		pcall(function() vim.api.nvim_buf_delete(current_rust_test_buf, {}) end)
		current_rust_test_buf = nil
	end

	--vim.api.nvim_command(':w')
	vim.api.nvim_command(':w')
	local prev_buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_command(':RustTest -- --nocapture')
	local new_buf = vim.api.nvim_get_current_buf()
	if prev_buf ~= new_buf then
		vim.api.nvim_command(':normal G$')
		current_rust_test_buf = new_buf

		pcall(function()
			vim.api.nvim_set_current_win(curr_win)
		end)
	end
end, '')

map('<leader>tt', function() 
	local curr_win = vim.api.nvim_get_current_win()
	if current_rust_test_buf ~= nil then
		pcall(function() vim.api.nvim_buf_delete(current_rust_test_buf, {}) end)
		current_rust_test_buf = nil
	end

	--vim.api.nvim_command(':w')
	local prev_buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_command(':RustTest -- --nocapture')
	local new_buf = vim.api.nvim_get_current_buf()
	if prev_buf ~= new_buf then
		vim.api.nvim_command(':normal G$')
		current_rust_test_buf = new_buf

		pcall(function()
			vim.api.nvim_set_current_win(curr_win)
		end)
	end
end, '')

map('<leader>ta', function() 
	local curr_win = vim.api.nvim_get_current_win()
	if current_rust_test_buf ~= nil then
		pcall(function() vim.api.nvim_buf_delete(current_rust_test_buf, {}) end)
		current_rust_test_buf = nil
	end

	--vim.api.nvim_command(':w')
	local prev_buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_command(':RustTest! -- --nocapture')
	local new_buf = vim.api.nvim_get_current_buf()
	if prev_buf ~= new_buf then
		vim.api.nvim_command(':normal G$')
		current_rust_test_buf = new_buf

		pcall(function()
			vim.api.nvim_set_current_win(curr_win)
		end)
	end
end, '')

map('<leader>tb', function() 
	local curr_win = vim.api.nvim_get_current_win()
	if current_rust_build_buf ~= nil then
		pcall(function() vim.api.nvim_buf_delete(current_rust_build_buf, {}) end)
		current_rust_build_buf = nil
	end

	--vim.api.nvim_command(':w')
	local prev_buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_command('Cargo ltest --no-run')
	local new_buf = vim.api.nvim_get_current_buf()
	if prev_buf ~= new_buf then
		vim.api.nvim_command(':normal G$')
		current_rust_build_buf = new_buf

		pcall(function()
			vim.api.nvim_set_current_win(curr_win)
		end)
	end
end, '')


map('<leader>B', function() 
	local curr_win = vim.api.nvim_get_current_win()
	if current_rust_build_buf ~= nil then
		pcall(function() vim.api.nvim_buf_delete(current_rust_build_buf, {}) end)
		current_rust_build_buf = nil
	end

	--vim.api.nvim_command(':w')
	local prev_buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_command('Cargo lbuild')
	local new_buf = vim.api.nvim_get_current_buf()
	if prev_buf ~= new_buf then
		vim.api.nvim_command(':normal G$')
		current_rust_build_buf = new_buf

		pcall(function()
			vim.api.nvim_set_current_win(curr_win)
		end)
	end
end, '')

map('<leader>R', 'yiw:lua vim.lsp.buf.rename(\'\')<Left><Left><C-r>"' , '')

map('<leader>D', function() vim.api.nvim_command(':lua vim.lsp.buf.type_definition()') end, '')
map('<leader>r', function() vim.api.nvim_command(':lua vim.lsp.buf.references()') end, '')
map('<leader>n', function() vim.api.nvim_command(':lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })') end, '')
map('<leader>w', function() vim.api.nvim_command(':lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARNING })') end, '')

map('<leader>w', function() vim.api.nvim_command(':lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARNING })') end, '')

-- tab managment shortcuts
map('<C-t>', ':tab split<CR>', '')
map('<C-j>', ':tabprevious<CR>', '')
map('<C-k>', ':tabnext<CR>', '')

vim.api.nvim_create_user_command('One', function()
	if vim.fn.tabpagenr('$') > 1 then
		vim.api.nvim_command(':tabon')
	end

	if vim.fn.winnr('$') > 1 then
		vim.api.nvim_command(':on')
	end
end, {})

vim.cmd [[
   vmap <C-c><C-c> "+y
   " nnoremap <Leader>J :'!code %:' . line('$') . ':' . col('.')<CR>
   nnoremap <Leader>J :!code --goto . expand('%') . : . line('.') . : . col('.') . <CR>

  " Window size management, max current windows/equalize all windows
  noremap <C-w>M	<C-w>\|<C-w>_
  noremap <C-w>m	<C-w>=

  nnoremap <C-w>J	<C-w>j<C-w>\|<C-w>_
  nnoremap <C-w>K	<C-w>k<C-w>\|<C-w>_
  nnoremap <C-w>H	<C-w>h<C-w>\|<C-w>_
  nnoremap <C-w>L	<C-w>l<C-w>\|<C-w>_
  nnoremap <C-w>;	<C-w>p<C-w>\|<C-w>_

  nnoremap <Leader>sg	<C-w>s<C-]>
  nnoremap <Leader>vg	<C-w>v<C-]>
  nnoremap <Leader>sG	<C-w>s<C-]><C-w>\|<C-w>_
  nnoremap <Leader>vG	<C-w>v<C-]><C-w>\|<C-w>_

  nnoremap <Leader>cn	:cnext<CR>

  let g:searchHightlightOn=0
  function! SearchHightlightToggle()
  	if g:searchHightlightOn
  		let g:searchHightlightOn=0
  		set nohlsearch
  	else
  		let g:searchHightlightOn=1
  		set hlsearch
  	endif
  endfunction
  
  noremap <C-h>	:call SearchHightlightToggle()<CR>
  inoremap <C-h>	<Esc>:call SearchHightlightToggle()<CR>i
]]
--   nnoremap <Leader>J ':!code' -- ' . % . ':' . line('.') . '<CR>'

