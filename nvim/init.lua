-- Settings --
-- Editor UI
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "88"
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.mouse = ""
vim.opt.termguicolors = true

-- Editing
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.listchars:append { trail = "*" }
vim.opt.completeopt = { "menuone", "noinsert" }

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 3

-- Leader
vim.g.mapleader = " "

-- Plugins --
-- Autopairs
require("nvim-autopairs").setup {}

-- Treesitter
require("nvim-treesitter.configs").setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- LSP
local lspconfig = require('lspconfig')
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

local servers = {
    "gopls",
    "lua_ls",
    "nil_ls",
    "pyright",
    "zls",
}

local cmp = require("cmp")

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    window = {
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
    }, {
        { name = "buffer" },
    })
})

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
for _, server in ipairs(servers) do
    lspconfig[server].setup {
        on_attach = on_attach,
        capabilities = lsp_capabilities
    }
end

-- Keymaps --
-- General
vim.keymap.set("n", "<leader>ww", "<cmd>write<cr>")
vim.keymap.set("n", "<leader>be", "<cmd>quit<cr>")
vim.keymap.set("n", "<leader><cr>", "<cmd>source %<cr>")

-- Splits
vim.keymap.set("n", "<leader>v", "<cmd>wincmd v<cr>")
vim.keymap.set("n", "<leader>s", "<cmd>wincmd s<cr>")

-- Splits navigation
vim.keymap.set("n", "<leader>h", "<cmd>wincmd h<cr>")
vim.keymap.set("n", "<leader>j", "<cmd>wincmd j<cr>")
vim.keymap.set("n", "<leader>k", "<cmd>wincmd k<cr>")
vim.keymap.set("n", "<leader>l", "<cmd>wincmd l<cr>")

-- Telescope
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>tf", builtin.find_files, {})
vim.keymap.set("n", "<leader>tb", builtin.buffers, {})
vim.keymap.set("n", "<leader>ts", builtin.live_grep, {})
vim.keymap.set("n", "<leader>th", builtin.help_tags, {})

-- Colorscheme
vim.opt.background = "light"
vim.cmd("colorscheme gruvbox")
