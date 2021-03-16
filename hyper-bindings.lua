--- reload Hammerspoon config
hs.hotkey.bind(HYPER, "0", function()
    hs.reload()
end)
hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()

function focusOrOpen(app)
    local focus = mkFocusByPreferredApplicationTitle(true, app)
    return (focus() or hs.application.launchOrFocus(app))
end

function hyperFocusOrOpen(key, app)
    hs.hotkey.bind(HYPER, key, function() focusOrOpen(app) end)
end

-- creates callback function to select application windows by application name
function mkFocusByPreferredApplicationTitle(stopOnFirst, ...)
    local arguments = {...} -- create table to close over variadic args
    return function()
        local nowFocused = hs.window.focusedWindow()
        local appFound = false
        for _, app in ipairs(arguments) do
            if stopOnFirst and appFound then break end
            log:d('Searching for app ', app)
            local application = hs.application.get(app)
            if application ~= nil then
                log:d('Found app', application)
                local window = application:mainWindow()
                if window ~= nil then
                    log:d('Found main window', window)
                    if window == nowFocused then
                        log:d('Already focused, moving on', application)
                    else
                        window:focus()
                        appFound = true
                    end
                end
            end
        end
        return appFound
    end
end

local applicationHotkeys = {
    a = 'Activity monitor',
    w = 'WebStorm',
    b = 'Brave Browser',
    g = 'Google Chrome',
    c = 'Visual Studio Code',
    f = 'Franz',
    t = 'Microsoft Teams',
    e = 'Microsoft OneNote',
    --     e = 'Microsoft Excel',
    v = 'Viber',
    s = 'Spotify',
    p = 'Postman',
    --z = 'zoom.us',
    r = 'MacPass',
    --y = 'Jira',
    h = 'Hammerspoon',
}
for key, app in pairs(applicationHotkeys) do
    hyperFocusOrOpen(tostring(key), app)
end




