local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local colors = {
  bg = "#122934",
  yellow = "#FFCB8B",
  green = "#D6F882",
  red = "#F08869",
}

local hide_in_width = function()
  return vim.fn.winwidth(0) > 70
end

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local mode = {
  function()
    return " "
  end,
  padding = { left = 0, right = 0 },
  color = {},
  cond = nil,
}

local branch = {
  "b:gitsigns_head",
  icon = " ",
  color = { gui = "bold" },
  cond = hide_in_width,
}

local filename = {
  "filename",
  color = {},
  cond = nil,
}

local diff = {
  "diff",
  source = diff_source,
  symbols = { added = "  ", modified = " ", removed = " " },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.yellow },
    removed = { fg = colors.red },
  },
  cond = nil,
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " ", hint = " " },
  cond = hide_in_width,
}

local treesitter = {
  function()
    local b = vim.api.nvim_get_current_buf()
    if next(vim.treesitter.highlighter.active[b]) then
      return ""
    end
    return ""
  end,
  color = { fg = colors.green },
  cond = hide_in_width,
}

local lsp = {
  function(msg)
    msg = msg or "LS Inactive"
    local buf_clients = vim.lsp.buf_get_clients()
    if next(buf_clients) == nil then
      -- TODO: clean up this if statement
      if type(msg) == "boolean" or #msg == 0 then
        return "LS Inactive"
      end
      return msg
    end
    local buf_ft = vim.bo.filetype
    local buf_client_names = {}

    -- add client
    for _, client in pairs(buf_clients) do
      if client.name ~= "null-ls" then
        table.insert(buf_client_names, client.name)
      end
    end

    -- add formatter
    local formatters = require "lvim.lsp.null-ls.formatters"
    local supported_formatters = formatters.list_registered(buf_ft)
    vim.list_extend(buf_client_names, supported_formatters)

    -- add linter
    local linters = require "lvim.lsp.null-ls.linters"
    local supported_linters = linters.list_registered(buf_ft)
    vim.list_extend(buf_client_names, supported_linters)

    local unique_client_names = vim.fn.uniq(buf_client_names)
    return "[" .. table.concat(unique_client_names, ", ") .. "]"
  end,
  color = { gui = "bold" },
  cond = hide_in_width,
}

local filetype = {
  "filetype",
  icons_enabled = false,
}

local scrollbar = {
  function()
    local current_line = vim.fn.line "."
    local total_lines = vim.fn.line "$"
    local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
  end,
  padding = { left = 0, right = 0 },
  color = { fg = colors.yellow, bg = colors.bg },
  cond = nil,
}

lualine.setup {
  options = {
    icons_enabled = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    theme = "auto",
    disabled_filetypes = { "alpha", "NvimTree", "Outline" },
    globalstatus = false,
  },
  sections = {
    lualine_a = { mode },
    lualine_b = { branch, filename },
    lualine_c = { diff },
    lualine_x = { diagnostics, treesitter, lsp, filetype },
    lualine_y = { },
    lualine_z = { scrollbar },
  },
  inactive_sections = {
    lualine_a = nil,
    lualine_b = nil,
    lualine_c = nil,
    lualine_x = nil,
    lualine_y = nil,
    lualine_z = nil,
  },
  tabline = nil,
  extensions = nil,
  on_config_done = nil,
}

