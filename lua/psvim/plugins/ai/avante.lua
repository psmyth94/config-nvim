return {
  { -- Avante Nvim: Cursor like Agent mode in Neovim
    'yetone/avante.nvim',

    version = false, -- Never set this value to "*"! Never!

    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
      'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
      'stevearc/dressing.nvim', -- for input provider dressing
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      'HakonHarnes/img-clip.nvim',
      'MeanderingProgrammer/render-markdown.nvim',
    },

    lazy = true,

    event = 'VeryLazy',

    build = function()
      if vim.fn.has 'win32' == 1 then
        return 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false'
      else
        return 'make'
      end
    end,

    opts = {
      mode = 'agentic',
      provider = 'openrouter',
      auto_suggestions_provider = 'openrouter',
      memory_summary_provider = 'openrouter',
      -- system_prompt = nil,

      providers = {
        openrouter = {
          __inherited_from = 'openai',
          endpoint = 'https://openrouter.ai/api/v1',
          api_key_name = 'OPENROUTER_AVANTE_API_KEY',
          model = 'qwen/qwen3-coder:free',
          allow_insecure = true,
          timeout = 120000,
          extra_request_body = {
            context_window = 262144,
            temperature = 0.5,
          },
        },

        ['openrouter-o4-mini-high'] = {
          __inherited_from = 'openrouter',
          model = 'openai/o4-mini-high',
          extra_request_body = {
            context_window = 200000,
            reasoning_effort = 'high',
          },
        },

        ['openrouter-o3'] = {
          __inherited_from = 'openrouter',
          model = 'openai/o3',
          extra_request_body = {
            context_window = 200000,
            reasoning_effort = 'high',
          },
        },

        ['openrouter-minimax-m1'] = {
          __inherited_from = 'openrouter',
          model = 'minimax/minimax-m1',
          extra_request_body = {
            context_window = 1000000,
            reasoning_effort = 'high',
          },
        },

        ['openrouter-grok-3-mini'] = {
          __inherited_from = 'openrouter',
          model = 'x-ai/grok-3-mini',
          extra_request_body = {
            context_window = 131000,
            reasoning_effort = 'high',
          },
        },

        ['openrouter-kimi-k2'] = {
          __inherited_from = 'openrouter',
          model = 'moonshotai/kimi-k2',
          extra_request_body = {
            context_window = 131000,
          },
        },

        ['openrouter-deepseek-r1-free'] = {
          __inherited_from = 'openrouter',
          model = 'deepseek/deepseek-r1-0528:free',
          extra_request_body = {
            context_window = 164000,
            reasoning_effort = 'high',
          },
        },

        ['openrouter-kimi-k2-free'] = {
          __inherited_from = 'openrouter',
          model = 'moonshotai/kimi-k2:free',
          extra_request_body = {
            context_window = 66000,
          },
        },
      },

      dual_boost = {
        enabled = false,
        first_provider = 'openrouter-o4-mini-high',
        second_provider = 'openrouter-o3',
        -- prompt = '',
        timeout = 120000,
      },

      web_search_engine = {
        provider = 'searxng',
        -- provider = 'brave', -- 2000 free requests per month @ 1 request per second
        -- provider = 'tavily', -- 1000 free requests per month
      },

      behaviour = {
        auto_focus_sidebar = true,
        auto_suggestions = false, -- Experimental stage
        auto_suggestions_respect_ignore = true,
        auto_set_highlight_group = true,
        -- suggest me
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        jump_result_buffer_on_finish = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
        enable_token_counting = true,
        use_cwd_as_project_root = true,
        auto_focus_on_diff_view = false,
        auto_approve_tool_permissions = false,
        auto_check_diagnostics = true,
      },

      prompt_logger = { -- logs prompts to disk (timestamped, for replay/debugging)
        enabled = true, -- toggle logging entirely
        log_dir = vim.fn.stdpath 'cache' .. '/avante_prompts', -- directory where logs are saved
        fortune_cookie_on_success = true, -- shows a random fortune after each logged prompt (requires `fortune` installed)
        next_prompt = {
          normal = '<C-n>', -- load the next (newer) prompt log in normal mode
          insert = '<C-n>',
        },
        prev_prompt = {
          normal = '<C-p>', -- load the previous (older) prompt log in normal mode
          insert = '<C-p>',
        },
      },

      mappings = {
        suggestion = {
          accept = '<M-l>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<M-h>',
        },
        jump = {
          next = ']]',
          prev = '[[',
        },
      },

      hints = {
        enabled = true,
      },

      windows = {
        sidebar_header = {
          enabled = true, -- true, false to enable/disable the header
          align = 'center', -- left, center, right for title
          rounded = false,
        },
        input = {
          height = 10, -- Height of the input window in vertical layout
        },
        edit = {
          start_insert = false,
        },
        ask = {
          start_insert = false,
        },
      },

      file_selector = {
        provider = 'native',
      },

      selector = {
        -- provider = 'telescope',
        provider = 'native',
      },

      input = {
        provider = 'native',
      },

      suggestion = {
        debounce = 600,
        throttle = 600,
      },

      -- Extra: RAG service
      rag_service = { -- RAG service configuration
        enabled = true, -- Enables the RAG service
        host_mount = os.getenv 'HOME', -- Host mount path for the RAG service (Docker will mount this path)
        runner = 'docker', -- The runner for the RAG service (can use docker or nix)
        llm = { -- Configuration for the Language Model (LLM) used by the RAG service
          provider = 'openrouter', -- The LLM provider
          endpoint = 'https://openrouter.ai/api/v1', -- The LLM API endpoint
          api_key = 'OPENROUTER_AVANTE_API_KEY', -- The environment variable name for the LLM API key
          model = 'google/gemini-2.0-flash-exp:free', -- The LLM model name
          extra = nil, -- Extra configuration options for the LLM
        },
        embed = { -- Configuration for the Embedding model used by the RAG service
          provider = 'ollama', -- The Embedding provider ("ollama")
          endpoint = 'http://localhost:11434', -- The Embedding API endpoint for Ollama
          api_key = '', -- Ollama typically does not require an API key
          model = 'nomic-embed-text', -- The Embedding model name (e.g., "nomic-embed-text")
          -- model = "bge-large", -- The Embedding model name (e.g., "bge-large")
          extra = { -- Extra configuration options for the Embedding model (optional)
            embed_batch_size = 16,
          },
        },
        docker_extra_args = '', -- Extra arguments to pass to the docker command
      },
    },

    -- opts = {
    --   provider = 'copilot',
    --   auto_suggestions_provider = nil,
    --   memory_summary_provider = nil,
    --   -- system_prompt = nil,
    --
    --   providers = {
    --     copilot = {
    --       model = 'gpt-4.1',
    --       allow_insecure = false,
    --       timeout = 300000,
    --       context_window = 128000,
    --       extra_request_body = {
    --         temperature = 0.75,
    --         max_tokens = 128000,
    --       },
    --     },
    --
    --     ['copilot-gpt-o1'] = {
    --       __inherited_from = 'copilot',
    --       model = 'o1',
    --     },
    --
    --     ['copilot-claude-3.7-sonnet-thinking'] = {
    --       __inherited_from = 'copilot',
    --       model = 'claude-3.7-sonnet-thought',
    --     },
    --   },
    --
    --   dual_boost = {
    --     enabled = false,
    --     first_provider = 'copilot-gpt-o1',
    --     second_provider = 'copilot-claude-3.7-sonnet-thinking',
    --     -- prompt = '',
    --     timeout = 300000,
    --   },
    --
    --   web_search_engine = {
    --     -- provider = 'searxng',
    --     provider = 'brave', -- 2000 free requests per month @ 1 request per second
    --     -- provider = 'tavily', -- 1000 free requests per month
    --   },
    --
    --   behaviour = {
    --     auto_focus_sidebar = true,
    --     auto_suggestions = false, -- Experimental stage
    --     auto_suggestions_respect_ignore = true,
    --     auto_set_highlight_group = true,
    --     auto_set_keymaps = true,
    --     auto_apply_diff_after_generation = false,
    --     jump_result_buffer_on_finish = false,
    --     support_paste_from_clipboard = false,
    --     minimize_diff = true,
    --     enable_token_counting = true,
    --     use_cwd_as_project_root = true,
    --     auto_focus_on_diff_view = false,
    --     auto_approve_tool_permissions = false,
    --     auto_check_diagnostics = true,
    --   },
    --
    --   prompt_logger = { -- logs prompts to disk (timestamped, for replay/debugging)
    --     enabled = true, -- toggle logging entirely
    --   },
    --
    --   mappings = {
    --     toggle = {
    --       hint = '<leader>ahi',
    --     },
    --     confirm = {
    --       focus_window = '<M-f>',
    --     },
    --   },
    --
    --   windows = {
    --     input = {
    --       height = 10, -- Height of the input window in vertical layout
    --     },
    --     ask = {
    --       start_insert = false,
    --     },
    --   },
    --
    --   file_selector = {
    --     provider = 'native',
    --   },
    --
    --   selector = {
    --     -- provider = 'telescope',
    --     provider = 'native',
    --   },
    --
    --   input = {
    --     provider = 'native',
    --   },
    --
    --   -- Extra: RAG service
    --   rag_service = { -- RAG service configuration
    --     enabled = true, -- Enables the RAG service
    --     host_mount = os.getenv 'HOME' .. '/workspace/', -- Host mount path for the RAG service (Docker will mount this path)
    --     runner = 'docker', -- The runner for the RAG service (can use docker or nix)
    --     llm = { -- Configuration for the Language Model (LLM) used by the RAG service
    --       provider = 'openrouter', -- The LLM provider
    --       endpoint = 'https://openrouter.ai/api/v1', -- The LLM API endpoint
    --       api_key = 'OPENROUTER_AVANTE_API_KEY', -- The environment variable name for the LLM API key
    --       model = 'moonshotai/kimi-k2:free', -- The LLM model name
    --       -- extra = nil, -- Extra configuration options for the LLM
    --     },
    --     embed = { -- Configuration for the Embedding model used by the RAG service
    --       provider = 'ollama', -- The Embedding provider ("ollama")
    --       endpoint = 'http://localhost:11434', -- The Embedding API endpoint for Ollama
    --       api_key = '', -- Ollama typically does not require an API key
    --       model = 'nomic-embed-text', -- The Embedding model name (e.g., "nomic-embed-text")
    --       -- model = "bge-large", -- The Embedding model name (e.g., "nomic-embed-text")
    --       extra = { -- Extra configuration options for the Embedding model (optional)
    --         embed_batch_size = 10,
    --       },
    --     },
    --     docker_extra_args = '', -- Extra arguments to pass to the docker command
    --   },
    -- },
  },
}
