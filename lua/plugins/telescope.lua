return {
    {
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		  dependencies = { { 'nvim-lua/plenary.nvim' }, { 'nvim-telescope/telescope-live-grep-args.nvim' } },
		  init = function()
			require('telescope').setup {}
			require('telescope').load_extension('live_grep_args')
		  end
    },

}
