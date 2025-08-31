return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local actions = require("telescope.actions")
      local action_layout = require "telescope.actions.layout"

      local picker_defaults = {
        previewer = false,
        show_line = true,
        results_title = false,
        preview_title = false,
      }

      -- Telescope
      require("telescope").setup({
        defaults = {
          -- These three settings are optional, but recommended.
          prompt_prefix = '',
          entry_prefix = ' ',
          selection_caret = ' ',

          -- This is the important part: without this, Telescope windows will look a
          -- bit odd due to how borders are highlighted.
          -- layout_strategy = 'grey',
          layout_config = {
            -- The extension supports both "top" and "bottom" for the prompt.
            prompt_position = 'top',

            -- You can adjust these settings to your liking.
            width = { 0.6, max = 135 },
            height = 0.5,
            horizontal = {
              preview_width = 0.6,
            },
          },
          preview = {
            hide_on_startup = true,
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
          },
          file_ignore_patterns = {
            "^.git/",
            ".png",
            ".PNG",
            ".jpg",
            ".jpeg",
            "^node_modules/",
            "^dist/",
          },
          mappings = {
            i = {
              ["<C-s>"] = action_layout.toggle_preview,
              ["<M-m>"] = action_layout.toggle_mirror,
              ["<C-k>"] = actions.cycle_history_next,
              ["<C-j>"] = actions.cycle_history_prev,
            },
          },
        },
        pickers = {
          file_browser = picker_defaults,
          find_files = {
            picker_defaults,
            hidden = true,
          },
          git_files = picker_defaults,
          buffers = picker_defaults,
          tags = picker_defaults,
          current_buffer_tags = picker_defaults,
          lsp_references = picker_defaults,
          lsp_document_symbols = picker_defaults,
          lsp_workspace_symbols = picker_defaults,
          lsp_implementations = picker_defaults,
          lsp_definitions = picker_defaults,
          git_commits = picker_defaults,
          git_bcommits = picker_defaults,
          git_branches = picker_defaults,
          treesitter = picker_defaults,
          reloader = picker_defaults,
          help_tags = picker_defaults,
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      pcall(require("telescope").load_extension("fzf")) -- Enable telescope fzf native, if installed
      pcall(require("telescope").load_extension("ui-select"))
      -- pcall(require("telescope").load_extension("grey"))

      local search_dotfiles = function()
        require("telescope.builtin").git_files({
          prompt_title = "~ dotfiles ~",
          shorten_path = false,
          hidden = true,
          cwd = "~/dotfiles",
        })
      end

      local builtin = require("telescope.builtin")
      local conf = require("telescope.config").values
      local finders = require "telescope.finders"
      local make_entry = require "telescope.make_entry"
      local pickers = require "telescope.pickers"

      local multi_rg = function(opts)
        opts = opts or {}
        opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.uv.cwd()
        opts.shortcuts = opts.shortcuts
            or {
              ["l"] = "*.lua",
              ["j"] = "*.js",
              ["p"] = "*.php",
            }
        opts.pattern = opts.pattern or "%s"

        local custom_grep = finders.new_async_job {
          command_generator = function(prompt)
            if not prompt or prompt == "" then
              return nil
            end

            local prompt_split = vim.split(prompt, "  ")

            local args = { "rg" }
            if prompt_split[1] then
              table.insert(args, "-e")
              table.insert(args, prompt_split[1])
            end

            if prompt_split[2] then
              table.insert(args, "-g")

              local pattern
              if opts.shortcuts[prompt_split[2]] then
                pattern = opts.shortcuts[prompt_split[2]]
              else
                pattern = prompt_split[2]
              end

              table.insert(args, string.format(opts.pattern, pattern))
            end

            return vim.iter({
              args,
              { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column",
                "--smart-case" },
            }):flatten():totable()
          end,
          entry_maker = make_entry.gen_from_vimgrep(opts),
          cwd = opts.cwd,
        }

        pickers.new(opts, {
          debounce = 100,
          prompt_title = "Live Grep (with shortcuts)",
          finder = custom_grep,
          previewer = conf.grep_previewer(opts),
          sorter = require("telescope.sorters").empty(),
        }):find()
      end

      vim.keymap.set("n", "<C-P>", builtin.find_files)
      vim.keymap.set("n", "<Leader>fg", builtin.git_files)
      vim.keymap.set("n", "<Leader>b", builtin.buffers)
      vim.keymap.set("n", "<Leader>fo", builtin.oldfiles)
      vim.keymap.set("n", "<Leader>fc", search_dotfiles)

      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>/", multi_rg, { desc = "[S]earch by [G]rep (with shortcuts)" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    end
  },
}
