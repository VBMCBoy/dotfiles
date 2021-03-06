local vi_mode_utils = require'feline.providers.vi_mode'
local lsp = require'feline.providers.lsp'
local vlsp = vim.lsp

-- from https://github.com/famiu/feline.nvim/blob/master/lua/feline/providers/lsp.lua

local components = {
    left = {active = {}, inactive = {}},
    mid = {active = {}, inactive = {}},
    right = {active = {}, inactive = {}}
}

-- vi_mode
table.insert(components.left.active, {
        provider = 'vi_mode',
        hl = function()
                local val = {}
                val.bg = vi_mode_utils.get_mode_color()
                val.fg = 'black'
                val.style = 'bold'
                return val
        end,
        right_sep = 'block',
        left_sep =  'block',
        icon = ''
})

-- file info
table.insert(components.left.active, {
        provider = 'file_info',
        hl = function()
                local val = {}
                val.bg = vi_mode_utils.get_mode_color()
                val.fg = 'black'
                return val
        end,
        type = 'relative',
        right_sep = 'block',
})

-- file size
table.insert(components.left.active, {
        provider = 'file_size',
        hl = function()
                local val = {}
                val.bg = vi_mode_utils.get_mode_color()
                val.fg = 'black'
                return val
        end,
        type = 'relative',
        left_sep = 'block',
        right_sep = function()
                local val = { hl = { fg = vi_mode_utils.get_mode_color() } }
                if (false) then
                        val.str = 'block'
                else
                        val.str = 'right_rounded'
                end
                return val
        end,
})

-- git branch
table.insert(components.left.active, {
        provider = 'git_branch',
})

-- git changes
table.insert(components.left.active, {
        provider = 'git_diff_added',
        icon = '+',
        hl = function()
                local val = {}
                val.bg = 'bg1'
                val.fg = 'green'
                return val
        end,
        left_sep = ' '
})
table.insert(components.left.active, {
        provider = 'git_diff_changed',
        icon = '~',
        hl = function()
                local val = {}
                val.bg = 'bg1'
                val.fg = 'yellow'
                return val
        end,
        left_sep = ' '
})
table.insert(components.left.active, {
        provider = 'git_diff_removed',
        icon = '-',
        hl = function()
                local val = {}
                val.bg = 'bg1'
                val.fg = 'red'
                return val
        end,
        left_sep = ' '
})

-- diagnostics
table.insert(components.right.active, {
        provider = 'diagnostic_errors',
        enabled = function() return lsp.diagnostics_exist('Error') end,
        hl = function()
                local val = {}
                val.bg = 'red'
                val.fg = 'black'
                return val
        end,
        left_sep = 'left_rounded',
        right_sep = 'block',
})
table.insert(components.right.active, {
        provider = 'diagnostic_warnings',
        enabled = function() return lsp.diagnostics_exist('Warning') end,
        hl = function()
                local val = {}
                val.bg = 'orange'
                val.fg = 'black'
                return val
        end,
        right_sep = 'block',
        left_sep = function()
                local val = { hl = { fg = 'orange', bg = 'black' } }
                if (lsp.diagnostics_exist('Error')) then
                        val.str = 'block'
                else
                        val.str = 'left_rounded'
                end
                return val
        end,
})
table.insert(components.right.active, {
        provider = 'diagnostic_hints',
        enabled = function() return lsp.diagnostics_exist('Hint') end,
        hl = function()
                local val = {}
                val.bg = 'blue'
                val.fg = 'black'
                return val
        end,
        right_sep = 'block',
        left_sep = function()
                local val = { hl = { fg = 'blue', bg = 'black' } }
                if (lsp.diagnostics_exist('Warning') or lsp.diagnostics_exist('Error')) then
                        val.str = 'block'
                else
                        val.str = 'left_rounded'
                end
                return val
        end,
})
table.insert(components.right.active, {
        provider = 'diagnostic_info',
        enabled = function() return lsp.diagnostics_exist('Information') end,
        hl = function()
                local val = {}
                val.bg = 'white'
                val.fg = 'black'
                return val
        end,
        right_sep = 'block',
        left_sep = function()
                local val = { hl = { fg = 'blue', bg = 'black' } }
                if (lsp.diagnostics_exist('Hint') or lsp.diagnostics_exist('Warning') or lsp.diagnostics_exist('Error')) then
                        val.str = 'block'
                else
                        val.str = 'left_rounded'
                end
                return val
        end,
})

-- file type
table.insert(components.right.active, {
        provider = 'file_encoding',
        hl = function()
                local val = {}
                val.bg = vi_mode_utils.get_mode_color()
                val.fg = 'black'
                return val
        end,
        right_sep = 'block',
        left_sep = function()
                local val = { hl = { fg = vi_mode_utils.get_mode_color() } }
                if (lsp.diagnostics_exist('Information') or lsp.diagnostics_exist('Hint') or lsp.diagnostics_exist('Warning') or lsp.diagnostics_exist('Error')) then
                        val.str = 'block'
                else
                        val.str = 'left_rounded'
                end
                return val
        end,
})

-- position
table.insert(components.right.active, {
        provider = 'position',
        hl = function()
                local val = {}
                val.bg = vi_mode_utils.get_mode_color()
                val.fg = 'black'
                val.style = 'bold'
                return val
        end,
        right_sep = 'block',
        left_sep = 'block',
})

-- line_percentage
table.insert(components.right.active, {
        provider = 'line_percentage',
        hl = function()
                local val = {}
                val.bg = vi_mode_utils.get_mode_color()
                val.fg = 'black'
                val.style = 'bold'
                return val
        end,
        right_sep = 'block',
        left_sep = 'block',
})


local properties = {
        force_inactive = {
                filetypes = {},
                buftypes = {},
                bufnames = {}
        }
}

return {
        default_fg = require'colors'.fg,
        default_bg = require'colors'.bg1,
        colors = require'colors',
        components = components,
        properties = properties,
        vi_mode_colors = { 
                NORMAL = 'green',
                OP = 'green',
                INSERT = 'blue',
                VISUAL = 'orange',
                BLOCK = 'orange',
                REPLACE = 'purple',
                ['V-REPLACE'] = 'purple',
                ENTER = 'yellow',
                MORE = 'yellow',
                SELECT = 'red',
                COMMAND = 'green',
                SHELL = 'green',
                TERM = 'green',
                NONE = '#ffffff',
        }
}
