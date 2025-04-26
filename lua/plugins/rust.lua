vim.cmd [[
  set errorformat =%f:%l:%c:%m
  
  function! g:CargoLimitOpen(editor_data)
    let l:winnr = winnr()
  
    cgetexpr []
    for file in a:editor_data['files']
      caddexpr file['path'] . ':' . file['line'] . ':' . file['column'] . ':' . file['message']
    endfor
  
    if empty(a:editor_data['files'])
	  echo 'Cargo build successful'
      cclose
    else
      copen
    endif
  
    if mode() == 'i'
	  if l:winnr !=# winnr()
	    wincmd p
	  endif
    endif
    "if l:winnr !=# winnr()
    "  wincmd p
    "endif
  endf
]]


return {
   { 'alopatindev/cargo-limit', build = 'cargo install --locked cargo-limit nvim-send' },
   {
      'mrcjkb/rustaceanvim',
      version = '^5',
      init = function()
        -- Configure rustaceanvim here
        vim.g.rustaceanvim = {
		-- tools = {
		-- 	enable_clippy = false
		-- }
	}
      end,
      lazy = false,
    },

}


