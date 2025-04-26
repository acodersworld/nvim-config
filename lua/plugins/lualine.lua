return {
{
    enabled=false,
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    init = function()
	    require('lualine').setup {
		options = {
			globalstatus = true
		},
	--  	tabline = {
	--      lualine_a = { require'tabline'.tabline_tabs },
	--      lualine_b = {},
	--      lualine_x = { require'tabline'.tabline_buffers },
	--      lualine_y = {},
	--      lualine_z = {},
	--    },
		winbar = {
		  lualine_a = {},
		  lualine_b = {},
		  lualine_c = {'filename'},
		  lualine_x = {},
		  lualine_y = {},
		  lualine_z = {}
		},

		inactive_winbar = {
		  lualine_a = {},
		  lualine_b = {},
		  lualine_c = {'filename'},
		  lualine_x = {},
		  lualine_y = {},
		  lualine_z = {}
		}
	}

    end
  }

}
