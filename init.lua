vim.cmd('packadd nvim-lspconfig')
vim.cmd('packadd cmp-nvim-lsp')
vim.cmd('packadd nvim-cmp')
vim.cmd('packadd vim-vsnip')
vim.cmd('packadd cmp-vsnip')
vim.cmd('packadd vim-polyglot')
vim.cmd('packadd tokyonight')
vim.cmd('packadd nvim-tree')
vim.cmd('packadd nvim-plenary')
vim.cmd('packadd nvim-telescope')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

vim.cmd('set textwidth=1000')
vim.cmd('set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store,.git')
vim.cmd('set mouse=a')
vim.cmd('set encoding=UTF-8')
vim.cmd('set ff=unix')
vim.cmd('set number')
vim.cmd('set nowrap')
vim.cmd('set ignorecase')
vim.cmd('set cursorline')
vim.cmd('set mouse=a')
vim.cmd('set clipboard=unnamedplus')
vim.cmd('set completeopt=menu,menuone,noselect')
vim.cmd('colorscheme tokyonight-moon')

vim.api.nvim_set_keymap("n", "<c-p>", ":Telescope find_files hidden=true no_ignore=true<cr>", { noremap=true })
vim.api.nvim_set_keymap("n", "<leader>f", ":Telescope live_grep hidden=true no_ignore=true<cr>", { noremap=true })
vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope buffers<cr>", { noremap=true })
vim.api.nvim_set_keymap("n", "<leader>fr", ":Telescope registers<cr>", { noremap=true })
vim.api.nvim_set_keymap("n", "<c-n>", ":NvimTree<CR>", {})
vim.api.nvim_set_keymap("n", "<c-t>", ":NvimTreeToggle<CR>", {})
vim.api.nvim_set_keymap("n", "<c-f>", ":NvimTreeFindFile<CR>", {})
vim.api.nvim_set_keymap("n", "<c-s>", ":w<CR>", {})
vim.api.nvim_set_keymap("i", "<c-s>", "<Esc>:w<CR>a", {})
vim.api.nvim_set_keymap("n", "ff", ":resize 100 <CR> <BAR> :vertical resize 220<CR>", { noremap=true })
vim.api.nvim_set_keymap("n", "fm", "<C-w>=", { noremap=true })
vim.api.nvim_create_user_command("Format", function() vim.lsp.buf.format { async = true } end, { nargs = 0 })

lspconfig = require "lspconfig"
util = require "lspconfig/util"

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'gl', vim.diagnostic.open_float, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ac', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
end

-- Typescript lsp integration
lspconfig.tsserver.setup {
  on_attach = on_attach,
  cmd = {"typescript-language-server", "--stdio"},
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
}
-- Golang lsp integration
lspconfig.gopls.setup {
  on_attach = on_attach,
  cmd = {vim.env.HOME.."/.local/share/nvim/lsp-runtime/gopls", "serve"},
  filetypes = {"go", "gomod"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}

-- Rust lsp integration
lspconfig.gopls.setup {
  on_attach = on_attach,
  cmd = {vim.env.HOME.."/.local/share/nvim/lsp-runtime/rust-analyzer"},
  filetypes = {"rust"},
  root_dir = util.root_pattern("Cargo.toml", "rust-project.json"),
  settings = {
    ["rust-analyzer"] = {},
  },
}

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  mapping = {
    ["<Up>"] = cmp.mapping.select_prev_item(),
    ["<Down>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
  }, {
    { name = 'buffer' },
  })
})

require("nvim-tree").setup()

require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      "node_modules",
      "bin/",
      "/.git/"
    }
  }
}
