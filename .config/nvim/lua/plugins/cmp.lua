return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    commit = 'ae644feb7b67bf1ce4260c231d1d4300b19c6f30',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      -- VSCode icons in completion
      'onsails/lspkind.nvim',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      luasnip.config.setup({})

      local lspkind = require('lspkind')

      local jump_next = cmp.mapping(function()
        if luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        end
      end, { 'i', 's' })
      local jump_prev = cmp.mapping(function()
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { 'i', 's' })

      cmp.setup({
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 50,
          }),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert({
          -- TODO: lmao there's 3 bindings of the same action
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          ['<C-y>'] = cmp.mapping.confirm({ select = true }),

          -- Super tab which (in order):
          -- 1. Accepts the completion if cmp is visible
          -- 2. Accepts the completion if copilot is visible
          -- 3. Expands the snippet if possible
          -- 4. Fallback to the default completion
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            elseif require('utils.copilot').copilot_try_accept() then
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if require('utils.copilot').copilot_try_accept() then
            elseif luasnip.expand_or_locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),

          -- Accept the copilot suggestion if it's visible
          ['<Right>'] = cmp.mapping(function(fallback)
            if require('utils.copilot').copilot_try_accept() then
            else
              fallback()
            end
          end),

          -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-e>'] = cmp.mapping.close(),

          -- Manually trigger a completion from nvim-cmp
          ['<C-Space>'] = cmp.mapping.complete(),

          ['<C-l>'] = jump_next,
          ['<C-Right>'] = jump_next,
          ['<C-h>'] = jump_prev,
          ['<C-Left>'] = jump_prev,
        }),
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      })

      -- Load custom snipmate snippets in the snippets directory
      require('luasnip.loaders.from_snipmate').lazy_load() -- { paths = './snippets' }
    end,
  },
}
