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

if hs.wasLoaded == nil then
    hs.wasLoaded = true
    table.insert(buf, "Hammerspoon loaded.")
else
    table.insert(buf, "Hammerspoon re-loaded. ")
end

alert.show(table.concat(buf))
---init

require 'audio-watcher'
require 'wifi-watcher'
require 'hyper-bindings'
require 'teams-toggle-mute'
require 'window-management'
require 'keyboard-layout-switcher'
require 'vpn'
require 'mouse-finder'
require 'rounded-corners'
require 'translation-popup'
require 'hold-to-quit'
