local wezterm = require 'wezterm'

local config = wezterm.config_builder()


-- Cross-platform shell
local is_windows = wezterm.target_triple:find 'windows' ~= nil
if is_windows then
    -- config.default_prog = { 'nu' }
    config.default_prog = { 'pwsh' }
else
    -- config.default_prog = { 'nu' }
    config.default_prog = { os.getenv 'SHELL' or 'bash' }
end

config.font = wezterm.font_with_fallback { 'IosevkaTerm Nerd Font', 'Sarasa Term Sc' }
config.font_size = 13

-- 什么样丧心病狂的终端才会把默认键位绑到 Ctrl+Shift 上啊！！！
local act = wezterm.action

config.keys = {
    -- just use WM...
    -- {
    --     key = 'v',
    --     mods = 'CTRL|SHIFT',
    --     action = act.SpawnWindow,
    -- },

    {
        key = 't',
        mods = 'CTRL|SHIFT',
        action = act.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = 'w',
        mods = 'CTRL|SHIFT',
        action = act.CloseCurrentTab { confirm = true },
    },

    {
        key = 'n',
        mods = 'CTRL|SHIFT',
        action = act.ActivateTabRelative(1),
    },
    {
        key = 'p',
        mods = 'CTRL|SHIFT',
        action = act.ActivateTabRelative(-1),
    },
    {
        key = 'n',
        mods = 'CTRL|SHIFT',
        action = act.MoveTabRelative(1),
    },
    {
        key = 'p',
        mods = 'CTRL|SHIFT',
        action = act.MoveTabRelative(-1),
    },

    {
        key = 'u',
        mods = 'CTRL|SHIFT',
        action = act.ScrollByPage(-1),
    },
    {
        key = 'd',
        mods = 'CTRL|SHIFT',
        action = act.ScrollByPage(1),
    },

    {
        key = '/',
        mods = 'CTRL|SHIFT',
        action = act.Search { CaseSensitiveString = '' },
    },
    {
        key = 'Space',
        mods = 'CTRL|SHIFT',
        action = act.QuickSelect,
    },

    {
        key = 'x',
        mods = 'CTRL|SHIFT',
        action = act.ActivateCommandPalette,
    },

    {
        key = 'c',
        mods = 'CTRL|SHIFT',
        action = act.ActivateCopyMode,
    },

    {
        key = 'v',
        mods = 'CTRL|SHIFT',
        action = act.SplitVertical { domain = "CurrentPaneDomain" },
    },
    {
        key = 'g',
        mods = 'CTRL|SHIFT',
        action = act.SplitHorizontal { domain = "CurrentPaneDomain" },
    },
    {
        key = 'q',
        mods = 'CTRL|SHIFT',
        action = act.CloseCurrentPane { confirm = true },
    },

    {
        key = 'h',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Left',
    },
    {
        key = 'j',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Down',
    },
    {
        key = 'k',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Up',
    },
    {
        key = 'l',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Right',
    },

    {
        key = 'h',
        mods = 'CTRL|SHIFT|ALT',
        action = act.AdjustPaneSize { 'Left', 1 },
    },
    {
        key = 'j',
        mods = 'CTRL|SHIFT|ALT',
        action = act.AdjustPaneSize { 'Down', 1 },
    },
    {
        key = 'k',
        mods = 'CTRL|SHIFT|ALT',
        action = act.AdjustPaneSize { 'Up', 1 },
    },
    {
        key = 'l',
        mods = 'CTRL|SHIFT|ALT',
        action = act.AdjustPaneSize { 'Right', 1 },
    },
}

-- palette
-- rezuiro_cloudy
-- background = '#F0F8FF'
-- alter-background = '#DAE2E9'
-- text = '#3B3B3B'
-- alter-text = '#FFFFFF'
--
-- stress = '#56A0D1'
-- less-stress = '#99BFD1'
--
-- red = '#C998AE'
-- green = '#7FAD9C'
-- yellow = '#CFB886'
-- blue = '#56A0D1'
-- magenta = '#CBA0E3'
-- cyan = '#789eb1'
-- gray = '#C2C2C2'

-- Locate the bundled themes whether the config is loaded from the repo
-- (config_dir/theme) or from the installed location (config_dir/themes, ~/.config/wezterm).
local theme_candidates = {
    wezterm.config_dir .. '/themes',
    wezterm.config_dir .. '/theme',
    wezterm.home_dir .. '/.config/wezterm/themes',
    wezterm.home_dir .. '/.config/wezterm/theme',
}
for _, dir in ipairs(theme_candidates) do
    if #wezterm.glob(dir .. '/*.toml') > 0 then
        config.color_scheme_dirs = { dir }
        break
    end
end
config.color_scheme = 'alice-sunny'

-- config.color_schemes = {
--     ['Alice Sunny'] = {
--         foreground = '#3B3B3B',
--         background = '#F0F8FF',
--
--         cursor_fg = '#FFFFFF',
--         cursor_bg = '#56A0D1',
--
--         compose_cursor = '#C998AE',
--
--         selection_fg = '#FFFFFF',
--         selection_bg = '#56A0D1',
--
--         scrollbar_thumb = '#C2C2C2',
--
--         split = '#C2C2C2',
--
--         ansi = {
--             '#3B3B3B',
--             '#C998AE',
--             '#7FAD9C',
--             '#CFB886',
--             '#56A0D1',
--             '#CBA0E3',
--             '#789eb1',
--             '#C2C2C2',
--         },
--
--         brights = {
--             '#969696',
--             '#D6ABBC',
--             '#93B89F',
--             '#C4B290',
--             '#7DB0D6',
--             '#C0A3DE',
--             '#98BECF',
--             '#D4D4D4'
--         },
--
--         -- retro tab bar
--         tab_bar = {
--             background = '#DAE2E9',
--
--             active_tab = {
--                 bg_color = '#56A0D1',
--                 fg_color = '#FFFFFF',
--             },
--
--             inactive_tab = {
--                 bg_color = '#99BFD1',
--                 fg_color = '#FFFFFF',
--             },
--             inactive_tab_hover = {
--                 bg_color = '#C998AE',
--                 fg_color = '#FFFFFF',
--             },
--
--             new_tab = {
--                 bg_color = '#7FAD9C',
--                 fg_color = '#FFFFFF',
--             },
--             new_tab_hover = {
--                 bg_color = '#C998AE',
--                 fg_color = '#FFFFFF',
--             },
--         },
--     },
-- }

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

return config
