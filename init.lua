---init
alert = require 'hs.alert'
buf = {}
log = hs.logger.new('main', 'info')
HYPER = { "cmd", "alt", "ctrl", "shift" }
col = hs.drawing.color.x11
wm=hs.webview.windowMasks


hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
Install=spoon.SpoonInstall

Install:andUse("Keychain")

function loadKeychainPasswordByComment(comment)
    local item = spoon.Keychain:getItem{comment = comment }
    return item.password
end

function loadKeychainPasswordByAccount(account)
    local item = spoon.Keychain:getItem{account = account }
    return item.password
end

-- log debug info to Hyperspoon Console
-- We can disable all logging in one place
function debuglog(text)
    hs.console.printStyledtext("DEBUG: "..tostring(text))
end



----	Auto-reload config file. Called whenever a *.lua in the directory changes
--function reloadConfig(files)
--    doReload = false
--    for _,file in pairs(files) do
--        if file:sub(-4) == ".lua" then
--            doReload = true
--        end
--    end
--    if doReload then
--        hs.reload()
--    end
--end
---- Alert "Config loaded" here, happens not as we call reload, but as we load. Default alert durration=2 sec.
--hs.alert.show("Config loaded")
--
--local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
--local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/dev/git/hammerspoon/", reloadConfig):start()


if hs.wasLoaded == nil then
    hs.wasLoaded = true
    table.insert(buf, "Hammerspoon loaded.")
else
    table.insert(buf, "Hammerspoon re-loaded. ")
end

alert.show(table.concat(buf))

---init

require 'hyper-bindings'
require 'web-mode-binder'
require 'teams-toggle-mute'
require 'window-management'
require 'keyboard-layout-switcher'
require 'vpn'
require 'translation-popup'
require 'hold-to-quit'
require 'text-manipulation'
require 'mouse-finder'
require 'audio-watcher'
require 'wifi-watcher'
require 'rounded-corners'
--require 'keypress-show'
