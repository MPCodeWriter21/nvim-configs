-- local llm = require('llm')
--
-- llm.setup({
--   api_token = "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", -- cf Install paragraph
--   -- model = "bigcode/starcoder", -- can be a model ID or an http(s) endpoint
--   model = "bigcode/starcoder", -- can be a model ID or an http(s) endpoint
--   -- parameters that are added to the request body
--   query_params = {
--     max_new_tokens = 60,
--     temperature = 0.2,
--     top_p = 0.95,
--     stop_token = "<|endoftext|>",
--   },
--   -- set this if the model supports fill in the middle
--   fim = {
--     enabled = true,
--     prefix = "<fim_prefix>",
--     middle = "<fim_middle>",
--     suffix = "<fim_suffix>",
--   },
--   debounce_ms = 150,
--   accept_keymap = "<Tab>",
--   dismiss_keymap = "<S-Tab>",
--   max_context_after = 5000,
--   max_context_before = 5000,
--   tls_skip_verify_insecure = false,
--   -- llm-ls integration
--   lsp = {
--     enabled = false,
--     bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/llm_nvim/bin/llm-ls",
--   },
--   tokenizer_path = nil, -- when setting model as a URL, set this var
--   context_window = 8192, -- max number of tokens for the context window
-- })

local llm = require('llm')

llm.setup({
  api_token = nil, -- cf Install paragraph
  model = "bigcode/starcoder", -- the model ID, behavior depends on backend
  backend = "huggingface", -- backend ID, "huggingface" | "ollama" | "openai" | "tgi"
  url = "https://huggingface.github.io/text-generation-inference/#/Text%20Generation%20Inference/generate", -- the http url of the backend
  tokens_to_clear = { "<|endoftext|>" }, -- tokens to remove from the model's output
  -- parameters that are added to the request body, values are arbitrary, you can set any field:value pair here it will be passed as is to the backend
  request_body = {
    parameters = {
      max_new_tokens = 60,
      temperature = 0.2,
      top_p = 0.95,
    },
  },
  -- set this if the model supports fill in the middle
  fim = {
    enabled = true,
    prefix = "<fim_prefix>",
    middle = "<fim_middle>",
    suffix = "<fim_suffix>",
  },
  debounce_ms = 150,
  accept_keymap = "<Tab>",
  dismiss_keymap = "<S-Tab>",
  tls_skip_verify_insecure = false,
  -- llm-ls configuration, cf llm-ls section
  lsp = {
    bin_path = nil,
    host = nil,
    port = nil,
    version = "0.5.2",
  },
  tokenizer = nil, -- cf Tokenizer paragraph
  context_window = 8192, -- max number of tokens for the context window
  enable_suggestions_on_startup = true,
  enable_suggestions_on_files = "*", -- pattern matching syntax to enable suggestions on specific files, either a string or a list of strings
})
