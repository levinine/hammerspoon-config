hs.hotkey.bind(HYPER, "0", function()
    hs.reload()
end)
hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()

hs.window.animationDuration = 0
hs.hotkey.bind(HYPER, "Left", function() -- left 50%
    local win = hs.window.focusedWindow();
    if not win then return end
    win:moveToUnit(hs.layout.left50)
end)
hs.hotkey.bind(HYPER, "Up", function()  -- Up - toggle fullscreen
    local win = hs.window.focusedWindow();
    if not win then return end
    win:setFullScreen(not win:isFullScreen())
end)
hs.hotkey.bind(HYPER, "Down", function()  -- Down - size focused window to middle third of display
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end)
hs.hotkey.bind(HYPER, "Right", function() -- right  50%
    local win = hs.window.focusedWindow();
    if not win then return end
    win:moveToUnit(hs.layout.right50)
end)


function hyperFocusOrOpen(key, app)
    local focus = mkFocusByPreferredApplicationTitle(true, app)
    function focusOrOpen()
        return (focus() or hs.application.launchOrFocus(app))
    end
    hs.hotkey.bind(HYPER, key, focusOrOpen)
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
    z = 'zoom.us',
    r = 'MacPass',
    y = 'Jira',
    h = 'Hammerspoon',
}
for key, app in pairs(applicationHotkeys) do
    hyperFocusOrOpen(tostring(key), app)
end


---ms teams unmute - capslosck + space

KEYSTROKE_DURATION = 1 -- A one-microsecond delay worked for me YMMV
PUSH_TO_TALK_KEY = "space"

-- Microsoft Teams Push-to-Talk
function toggleMute()
    --currentApp = hs.application.frontmostApplication()
    teamsApps = hs.application.applicationsForBundleID('com.microsoft.teams')
    teamsApp = teamsApps[1]
    teamsApp:activate()
    hs.eventtap.keyStroke({"shift", "cmd"}, "m", KEYSTROKE_DURATION)
    --currentApp:activate()
end

hs.hotkey.bind(HYPER, PUSH_TO_TALK_KEY, toggleMute)
---ms teams unmute
