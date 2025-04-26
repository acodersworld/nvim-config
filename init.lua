-- bootstrap lazy.nvim, LazyVim and your plugins
vim.g.mapleader = ','

require("config.lazy")
require("config.keymaps")
require("config.options")

-- Temporary fix for rust analyzer error popping up
for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
            return
        end
        return default_diagnostic_handler(err, result, context, config)
    end
end
