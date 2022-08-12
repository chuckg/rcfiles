-- Variables. Modify me to your hearts content.

local hyperKey = 'F19'
-- info/debug/warning/etc.
hs.logger.defaultLogLevel = 'info'

-- ***************************************************************************
-- Constants 
local black = hs.drawing.color.asRGB(hs.drawing.color.colorsFor("Apple")["Black"])
local red = hs.drawing.color.asRGB(hs.drawing.color.colorsFor("Apple")["Red"])
local green = hs.drawing.color.asRGB(hs.drawing.color.colorsFor("Apple")["Green"])

local textMenuOffAttributes = { 
    color = red,
    strokeWidth = 3.0 
} 
local textMenuOnAttributes = { 
    color = green,
    strokeWidth = -3.0,
    strokeColor = black,
}
local textMenu = hs.styledtext.new('G', textMenuOffAttributes)

-- ***************************************************************************
-- Initialize

-- If experiencing issues w/ the single letter modal keys not firing, its because
-- there's a secure input active somewhere. Close things till it works again.
-- More info:
--  * https://github.com/Hammerspoon/hammerspoon/issues/2897
--  * https://smile.helpscoutdocs.com/article/402-textexpander-and-secure-input
local hyper = hs.hotkey.modal.new({}, hyperKey)
--local menu = hs.menubar.new()
local log = hs.logger.new('hypermode')

-- ***************************************************************************
-- Menu

--local imageIconOff = hs.image.imageFromPath('chakra.png'):setSize({h=18, w=16})
--local imageIcon = hs.image.imageFromPath('chakra.pdf'):setSize({h=18, w=16})

--menu:setTooltip("Hypermode indicator")
--menu:setIcon(imageIcon)

-- ***************************************************************************
-- Window hints

hs.hints.style = 'vimperator'
hs.hotkey.bind({'cmd', 'alt'}, 'tab', function()
    hs.hints.windowHints()
end)

-- ***************************************************************************
-- Hypermode

-- Hypermode: Callbacks
function hyper:entered()
    hs.alert('hyperboi', 30)
    --menu:setIcon(imageIconOn)
    --menu:setTitle(textMenu:setStyle(textMenuOnAttributes))
end 

function hyper:exited()
    --menu:setTitle(textMenu)
    --menu:setIcon(imageIconOff)
    hs.alert.closeAll()
end 

-- Hypermode: Bind console
hyper:bind('', '`', function()
    local win = hs.appfinder.windowFromWindowTitle("Hammerspoon Console")
    if not win then
        log.d('Console is not open, opening and focusing.')
        hs.openConsole(true)
    elseif win:application():isFrontmost() then
        log.d('Console is visible, closing.')
        win:close()
    else
        log.d('Console is not visible, focusing.')
        win:focus()
    end
    hyper:exit()
end)

-- Hypermode: Bind reload
hyper:bind('', 'z', function()
    hyper:exit()
    hs.notify.new({title="Hypermode", informativeText="Reloading configuration"}):send()
    hs.reload()
end)

-- Hypermode: Bind exit keys
local escapeBindings = {
    'escape',
    hyperKey
}
for i,bindKey in pairs(escapeBindings) do
    hyper:bind('', bindKey, function()
        hs.alert.closeAll()
        hyper:exit()
    end)
end

-- Hypermode: Window hints
hyper:bind('', 'tab', function()
    hs.hints.windowHints()
    hyper:exit()
end)


-- Hypermode: Dimensions
local windowDimension = {
    left = function(window)
        local max = window:screen():frame()
        return hs.geometry.rect(
            max.x,
            max.y,
            max.w / 2,
            max.h
        )
    end,
    mid = function(window)
        local max = window:screen():frame()
        return hs.geometry.rect(
            max.x + (max.w / 12),
            max.y,
            max.w / 12 * 10,
            max.h
        )
    end,
    full = function(window)
        return window:screen():frame()
    end,
    right = function(window)
        local max = window:screen():frame()
        return hs.geometry.rect(
            max.x + (max.w / 2),
            max.y,
            max.w / 2,
            max.h
        )
    end
}

local windowManagement = {
    left = function(window)
        local max = window:screen():frame()
        local location = hs.geometry.rect(
            max.x,
            max.y,
            max.w / 2,
            max.h
        )
        window:setFrame(location, 0)
    end,
    mid = function(window)
        local max = window:screen():frame()
        local location = hs.geometry.rect(
            max.x + (max.w / 12),
            max.y,
            max.w / 12 * 10,
            max.h
        )
        window:setFrame(location, 0)
    end,
    full = function(window)
        window:setFrame(window:screen():frame(), 0)
    end,
    right = function(window)
        local max = window:screen():frame()
        local location = hs.geometry.rect(
            max.x + (max.w / 2),
            max.y,
            max.w / 2,
            max.h
        )
        window:setFrame(location, 0)
    end,
    throwUp = function(window)
        window:moveOneScreenNorth(false, true, 0)
    end,
    throwDown = function(window)
        window:moveOneScreenSouth(false, true, 0)
    end,
    throwLeft = function(window)
        window:moveOneScreenWest(false, true, 0)
    end,
    throwRight = function(window)
        window:moveOneScreenEast(false, true, 0)
    end
}

-- Hypermode: VIM window management bindings
local vimBindings = {
    -- function name = {hyper modifier key, regular key}
    -- https://www.hammerspoon.org/docs/hs.hotkey.modal.html#bind
    {windowManagement.left, '', 'h'},
    {windowManagement.mid, '', 'j'},
    {windowManagement.full, '', 'k'},
    {windowManagement.right, '', 'l'},
    {windowManagement.throwUp, 'shift', 'k'},
    {windowManagement.throwDown, 'shift', 'j'},
    {windowManagement.throwLeft, 'shift', 'h'},
    {windowManagement.throwRight, 'shift', 'l'}
}

for _, windowBind in pairs(vimBindings) do
    local setWindowLocation = windowBind[1]
    local modifier = windowBind[2]
    local key = windowBind[3]

    if modifier == '' then
        log.d('Bound ' .. key .. ' to ' .. tostring(setWindowLocation))
    else
        log.d('Bound ' .. modifier .. '+' .. key .. ' to ' .. tostring(setWindowLocation))
    end

    hyper:bind(modifier, key, function()
        local win = hs.window.focusedWindow()
        setWindowLocation(win)
        hyper:exit()
    end)
end


-- 2019-11-06 15:42:28: *** ERROR: /Users/chuckg/.hammerspoon/init.lua:227: attempt to concatenate a nil value
-- stack traceback:
-- 	/Users/chuckg/.hammerspoon/init.lua:227: in main chunk
-- 	[C]: in function 'xpcall'
-- 	...app/Contents/Resources/extensions/hs/_coresetup/init.lua:630: in function 'hs._coresetup.setup'
-- 	(...tail calls...)

-- Hypermode: Window throw to monitor bindings by screen number
-- local screens = hs.screen.allScreens()
-- if screens == nil then
--     log.d('No screens detected, skipping hyperbind for monitors on 1-9')
--     hs.alert('No screens detected, skpping 1-9 hyperbinds', 3)
-- else 
--     log.d('Screens detected, binding..')
--     for screenId, screen in airs(screens) do
--         log.d('Bound ' .. screenId .. ': ' .. screen:name())
--         hyper:bind('', string.format("%i", screenId), function()
--             local win = hs.window.focusedWindow()
--             win:moveToScreen(screen, false, true, 0)
--             hyper:exit()
--         end)
--     end
-- end

-- Hypermode: Bind application window focus
local focusBindings = {
    ['Mail']          = 'a',
    ['Messages']      = 'm',
    ['Slack']         = 'c',
 
    ['Google Chrome'] = 'o',
    ['Safari']        = 's',
    ['Notes']         = 'n',
    ['1Password 6']   = 'p',
    ['Quip']          = 'q',

    ['MacVim']        = 'i',
    ['GoLand']        = 'g',
    ['RubyMine']      = 'e',
    ['CLion']         = 'y',
    ['PyCharm']       = 'p',
    ['IntelliJ IDEA'] = 'd',
    ['Sourcetree']    = 't',
    ['iTerm2']        = 'u',
    ['OmniGraffle']   = 'f',

    ['Reminders']     = 'r'
}

for appName, bindKey in pairs(focusBindings) do
    hyper:bind({}, bindKey, nil, function()
        local app = hs.appfinder.appFromName(appName)
        if app then
            app:activate()
        end
        hyper:exit()
    end, nil, nil)
end
