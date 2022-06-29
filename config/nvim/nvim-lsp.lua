-- This file configure the LSP stuff to use with nvim and native LSP
-- via nvim-lsp-config, nvim-lsp-status and others.

-- Local required modules, if someone fails, stop loading the file and return
-- silently.
local modules = { 'lspconfig', 'luasnip', 'lsp-status', 'cmp', 'cmp_nvim_lsp' }

for _, i in ipairs(modules) do
  local ok, _ = pcall(require, i)
  if not ok then -- not loaded
    return ''
  end
end

-- Set Capabilities.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

vim.diagnostic.config({
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      if vim.api.nvim_buf_get_option(0, "commentstring") then
        return string.format(vim.api.nvim_buf_get_option(0, "commentstring"),
          " " .. diagnostic.message .. " ")
      else
        return diagnostic.message
      end
    end,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

local signs = { Error = "⛔", Warn = "⚠️", Hint = "💡" , Info = "ℹ️ " }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.cmd [[ 
  hi! DiagnosticError ctermbg=234 ctermfg=238
  hi! DiagnosticWarn ctermbg=234 ctermfg=238
  hi! DiagnosticInfo ctermbg=234 ctermfg=238
  hi! DiagnosticHint ctermbg=234 ctermfg=238

  hi! DiagnosticVirtualTextError ctermfg=236
  hi! DiagnosticVirtualTextWarn ctermfg=236 cterm=italic
  hi! DiagnosticVirtualTextInfo ctermfg=236
  hi! DiagnosticVirtualTextHint ctermfg=236
]]

-- You will likely want to reduce updatetime which affects CursorHold
vim.o.updatetime = 250

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Snippets setup
local luasnip = require 'luasnip'
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- On attach handler.
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- Declare servers.
lspconfig = require('lspconfig')

local servers = { 'clangd', 'pylsp', 'gopls', 'zls', 'rls' }

for _, i in ipairs(servers) do
  lspconfig[i].setup { on_attach = on_attach, capabilities = capabilities }
end

-- yamlls require some settings.
local schemas = {}
schemas["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json"] = {'/**k8s**', '/**kubernetes**'}
schemas["https://json.schemastore.org/helmfile.json"] = {'/**Chart.y*ml', '/**charts/**.y*ml'}
schemas["https://json.schemastore.org/github-action.json"] = {'/.github/actions/*.y*ml'}
schemas["https://json.schemastore.org/gitlab-ci.json"] = {'/.gitlab-ci.y*ml'}

lspconfig.yamlls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    redhat = {
      telemetry = {
        enabled = false
      }
    },
    yaml = {
      schemas = schemas
    },
  },
}
