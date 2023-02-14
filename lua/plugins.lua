local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {"shortcuts/no-neck-pain.nvim", tag = "*" }
  use {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'}, { "nvim-telescope/telescope-live-grep-args.nvim" } }
  }
  use "lukas-reineke/indent-blankline.nvim"
  use "elihunter173/dirbuf.nvim"

  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use 'simrat39/rust-tools.nvim'
  use 'j-hui/fidget.nvim'

  use {
    'phaazon/hop.nvim',
    branch = 'v2' -- optional but strongly recommended
  }

  use { 'kyazdani42/nvim-web-devicons' }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use { "max397574/better-escape.nvim" }
  use { 'kdheepak/tabline.nvim' }

  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-nvim-lua' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-vsnip' }
  use { 'hrsh7th/vim-vsnip' }

  use { 'https://gitlab.com/yorickpeterse/nvim-window.git' }

  use { 'junegunn/fzf' }
  use { 'junegunn/fzf.vim' }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

require("no-neck-pain").setup {
	enableOnVimEnter = true,
	width = 150
}

local cmp = require'cmp'
cmp.setup {
	snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
	  end
	},
	sources = {
		{ name = 'buffer' },
		{ name = 'nvim_lua' },
		{ name = 'nvim_lsp' }
	},
	mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.select_prev_item(),
      ['<C-f>'] = cmp.mapping.select_next_item(),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    })
}

--require'tabline'.setup {
--    -- Defaults configuration options
--    enable = false,
--    options = {
--    -- If lualine is installed tabline will use separators configured in lualine by default.
--    -- These options can be used to override those settings.
--      section_separators = {'', ''},
--      component_separators = {'', ''},
--      max_bufferline_percent = nil, --66, -- set to nil by default, and it uses vim.o.columns * 2/3
--
--      show_tabs_always = false, -- this shows tabs only when there are more than one tab or if the first tab is named
--      show_devicons = true, -- this shows devicons in buffer section
--      show_bufnr = false, -- this appends [bufnr] to buffer section,
--      show_filename_only = false, -- shows base filename only instead of relative path in filename
--      modified_icon = "+ ", -- change the default modified icon
--      modified_italic = true, -- set to true by default; this determines whether the filename turns italic if modified
--      show_tabs_only = true, -- this shows only tabs instead of tabs + buffers
--    }
--}

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

require("better_escape").setup {
  mapping = {"jj"}, -- a table with mappings to use
  timeout = 200, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
  clear_empty_lines = false, -- clear line after escaping if there is only whitespace
  keys = function()
    return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
  end,
}

require'mason'.setup {}
--require('rust-tools').setup{}
require'lspconfig'.rust_analyzer.setup{
	capabilities = require('cmp_nvim_lsp').default_capabilities()
}
require'lspconfig'.eslint.setup{}
require'lspconfig'.pyright.setup{}

require("lspconfig").lua_ls.setup {
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' }
			}
		}
	},
	capabilities = require('cmp_nvim_lsp').default_capabilities()
}

require('telescope').setup {}
require("telescope").load_extension("live_grep_args")

require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
require"fidget".setup{}

local opts = {
  tools = { -- rust-tools options

    -- how to execute terminal commands
    -- options right now: termopen / quickfix
    executor = require("rust-tools.executors").termopen,

    -- callback to execute once rust-analyzer is done initializing the workspace
    -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
    on_initialized = nil,

    -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
    reload_workspace_from_cargo_toml = true,

    -- These apply to the default RustSetInlayHints command
    inlay_hints = {
      -- automatically set inlay hints (type hints)
      -- default: true
      auto = true,

      -- Only show inlay hints for the current line
      only_current_line = false,

      -- whether to show parameter hints with the inlay hints or not
      -- default: true
      show_parameter_hints = true,

      -- prefix for parameter hints
      -- default: "<-"
      parameter_hints_prefix = "<- ",

      -- prefix for all the other hints (type, chaining)
      -- default: "=>"
      other_hints_prefix = "=> ",

      -- whether to align to the length of the longest line in the file
      max_len_align = false,

      -- padding from the left if max_len_align is true
      max_len_align_padding = 1,

      -- whether to align to the extreme right or not
      right_align = false,

      -- padding from the right if right_align is true
      right_align_padding = 7,

      -- The color of the hints
      highlight = "Comment",
    },

    -- options same as lsp hover / vim.lsp.util.open_floating_preview()
    hover_actions = {

      -- the border that is used for the hover window
      -- see vim.api.nvim_open_win()
      border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      },

      -- Maximal width of the hover window. Nil means no max.
      max_width = nil,

      -- Maximal height of the hover window. Nil means no max.
      max_height = nil,

      -- whether the hover action window gets automatically focused
      -- default: false
      auto_focus = false,
    },

    -- settings for showing the crate graph based on graphviz and the dot
    -- command
    crate_graph = {
      -- Backend used for displaying the graph
      -- see: https://graphviz.org/docs/outputs/
      -- default: x11
      backend = "x11",
      -- where to store the output, nil for no output stored (relative
      -- path from pwd)
      -- default: nil
      output = nil,
      -- true for all crates.io and external crates, false only the local
      -- crates
      -- default: true
      full = true,

      -- List of backends found on: https://graphviz.org/docs/outputs/
      -- Is used for input validation and autocompletion
      -- Last updated: 2021-08-26
      enabled_graphviz_backends = {
        "bmp",
        "cgimage",
        "canon",
        "dot",
        "gv",
        "xdot",
        "xdot1.2",
        "xdot1.4",
        "eps",
        "exr",
        "fig",
        "gd",
        "gd2",
        "gif",
        "gtk",
        "ico",
        "cmap",
        "ismap",
        "imap",
        "cmapx",
        "imap_np",
        "cmapx_np",
        "jpg",
        "jpeg",
        "jpe",
        "jp2",
        "json",
        "json0",
        "dot_json",
        "xdot_json",
        "pdf",
        "pic",
        "pct",
        "pict",
        "plain",
        "plain-ext",
        "png",
        "pov",
        "ps",
        "ps2",
        "psd",
        "sgi",
        "svg",
        "svgz",
        "tga",
        "tiff",
        "tif",
        "tk",
        "vml",
        "vmlz",
        "wbmp",
        "webp",
        "xlib",
        "x11",
      },
    },
  },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
  server = {
    -- standalone file support
    -- setting it to false may improve startup time
    standalone = true,
  }, -- rust-analyzer options

  -- debugging stuff
  dap = {
    adapter = {
      type = "executable",
      command = "lldb-vscode",
      name = "rt_lldb",
    },
  },
}

require('rust-tools').setup(opts)

vim.cmd [[highlight IndentBlanklineIndent1 ctermfg=239 ]]
require('indent_blankline').setup{
	char_highlight_list = {
		'IndentBlanklineIndent1'
	}
}

require('nvim-window').setup({
  -- The characters available for hinting windows.
  chars = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
    'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
  },

  -- A group to use for overwriting the Normal highlight group in the floating
  -- window. This can be used to change the background color.
  normal_hl = 'Normal',

  -- The highlight group to apply to the line that contains the hint characters.
  -- This is used to make them stand out more.
  hint_hl = 'Bold',

  -- The border style to use for the floating window.
  border = 'single'
})

