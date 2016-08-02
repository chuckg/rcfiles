-- colors
local black = hs.drawing.color.asRGB(hs.drawing.color.colorsFor("Apple")["Black"])
local red = hs.drawing.color.asRGB(hs.drawing.color.colorsFor("Apple")["Red"])
local green = hs.drawing.color.asRGB(hs.drawing.color.colorsFor("Apple")["Green"])

-- Setup modal hotkey, ie: hyper
local hyper = hs.hotkey.modal.new(nil, 'F19')
--local log = hs.logger.new('godmode','debug')

-- Menu setup
local menu = hs.menubar.new()
local hyperOffTextAttributes = { 
    color = red,
    strokeWidth = 3.0 
} 
local hyperOnTextAttributes = { 
    color = green,
    strokeWidth = -3.0,
    strokeColor = black,
}
local hyperMenuText = hs.styledtext.new('G', hyperOffTextAttributes)
-- Setup default menu title.
menu:setTitle(hyperMenuText)
menu:setTooltip("Godmode indicator")

-- Window hints
hs.hints.style = 'vimperator'
hs.hotkey.bind({'cmd', 'alt'}, 'tab', function()
    hs.hints.windowHints()
end)

-- Enter godmode
function hyper:entered()
    hs.alert('Godmode', 30)
    menu:setTitle(hyperMenuText:setStyle(hyperOnTextAttributes))
end 

function hyper:exited()
    menu:setTitle(hyperMenuText)
    hs.alert.closeAll()
end 

-- Escape godmode
local escapeBindings = {
    'escape',
    'F19'
}
for i,bindKey in pairs(escapeBindings) do
    hyper:bind('', bindKey, function()
        hs.alert.closeAll()
        hyper:exit()
    end)
end

-- Godmode: Bind reload
hyper:bind('', 'r', function()
    hyper:exit()
    hs.alert.closeAll()
    hs.notify.new({title="Hammerspoon", informativeText="Reloading configuration"}):send()
    hs.reload()
end)

-- Godmode: Bind application window focus
local focusBindings = {
    ['iTerm']         = 'u',
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
