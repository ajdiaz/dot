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

-- Customize diagnostics messages: color, position and also de the
-- status bar counter.
function PrintDiagnostics(opts, bufnr, line_nr, client_id)
  opts = opts or {}

  bufnr = bufnr or 0
  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)

  local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line_nr, opts, client_id)
  if vim.tbl_isempty(line_diagnostics) then return end

  local diagnostic_message = ""
  if #line_diagnostics > 0 then
    diagnostic_message = line_diagnostics[1].message
  end
  vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})
end

vim.cmd [[ autocmd CursorHold * lua PrintDiagnostics() ]]

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
})

local signs = { Error = "⛔", Warning = "⚠️", Hint = "💡" , Info = "ℹ️ " }

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.cmd [[ 
  hi! LspDiagnosticsUnderlineError ctermfg=white ctermbg=red
  hi! LspDiagnosticsUnderlineWarning ctermfg=black ctermbg=yellow
  hi! LspDiagnosticsUnderlineInformation ctermfg=white ctermbg=lightblue
  hi! LspDiagnosticsUnderlineHint ctermfg=white ctermbg=lightmagenta

  hi! LspDiagnosticsSignError ctermbg=234
  hi! LspDiagnosticsSignWarning ctermbg=234
  hi! LspDiagnosticsSignInformation ctermbg=234
  hi! LspDiagnosticsSignHint ctermbg=234
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
    ['<C-n>'] = cmp.mapping.select_next_item(),
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

local servers = { 'clangd', 'pylsp', 'gopls', 'zls' }

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
