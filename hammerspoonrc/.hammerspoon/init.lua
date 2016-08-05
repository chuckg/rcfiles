-- Variables. Modify me to your hearts content.

local hyperKey = 'F19'
-- info/debug/warning/etc.
local logLevel = 'debug'


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

local hyper = hs.hotkey.modal.new(nil, hyperKey)
local menu = hs.menubar.new()
local log = hs.logger.new('godmode',logLevel)

-- ***************************************************************************
-- Menu

menu:setTitle(textMenu)
menu:setTooltip("Godmode indicator")

-- ***************************************************************************
-- Window hints

hs.hints.style = 'vimperator'
hs.hotkey.bind({'cmd', 'alt'}, 'tab', function()
    hs.hints.windowHints()
end)

-- ***************************************************************************
-- Godmode

-- Godmode: Callbacks
function hyper:entered()
    hs.alert('Godmode', 30)
    menu:setTitle(textMenu:setStyle(textMenuOnAttributes))
end 

function hyper:exited()
    menu:setTitle(textMenu)
    hs.alert.closeAll()
end 

-- Godmode: Bind console
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

-- Godmode: Bind reload
hyper:bind('', 'r', function()
    hyper:exit()
    hs.notify.new({title="Godmode", informativeText="Reloading configuration"}):send()
    hs.reload()
end)

-- Godmode: Bind exit keys
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

-- Godmode: Window hints
hyper:bind('', 'tab', function()
    hs.hints.windowHints()
    hyper:exit()
end)


-- Godmode: Dimensions
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

-- Godmode: VIM window management bindings
local vimBindings = {
    ['h'] = windowDimension.left,
    ['j'] = windowDimension.mid,
    ['k'] = windowDimension.full,
    ['l'] = windowDimension.right
}
for bindKey, location in pairs(vimBindings) do
    hyper:bind('', bindKey, function()
        local win = hs.window.focusedWindow()
        win:setFrame(location(win), 0)
        hyper:exit()
    end)
end

-- Godmode: Window throw to monitor bindings by screen number
for screenId, screen in pairs(hs.screen.allScreens()) do
    log.d('Bound ' .. screenId .. ': ' .. screen:name())
    hyper:bind('', string.format("%i", screenId), function()
        local win = hs.window.focusedWindow()
        win:moveToScreen(screen, false, true, 0)
        hyper:exit()
    end)
end

-- Godmode: Bind application window focus
local focusBindings = {
    ['iTerm2']        = 'u',
    ['MacVim']        = 'i',
    ['Google Chrome'] = 'o',
    ['Evernote']      = 'e',
    ['Messages']      = 'm',
    ['Skype']         = 's',
    ['Slack']         = 'c',
    ['1Password 6']   = 'p',
    ['Notes']         = 'n',
    ['SourceTree']    = 't',
    ['Discord']       = 'd'
}

for appName, bindKey in pairs(focusBindings) do
    hyper:bind('', bindKey, function()
        local app = hs.appfinder.appFromName(appName)
        if app then
            app:activate()
        end
        hyper:exit()
    end)
end
