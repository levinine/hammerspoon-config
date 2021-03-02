---init
local alert = require 'hs.alert'
local buf = {}
local log = hs.logger.new('main', 'info')
local HYPER = { "cmd", "alt", "ctrl", "shift" }
col = hs.drawing.color.x11
local wm=hs.webview.windowMasks


hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall.use_syncinstall = true
Install=spoon.SpoonInstall

Install:andUse("Tunnelblick")
Install:andUse("Keychain")
Install:andUse("HoldToQuit", { start = true })

function loadKeychainPasswordByComment(comment)
    local item = spoon.Keychain:getItem{comment = comment }
    return item.password
end

function loadKeychainPasswordByAccount(account)
    local item = spoon.Keychain:getItem{account = account }
    return item.password
end

--use local lua init
--local localfile = hs.configdir .. "/init-local.lua"
--if hs.fs.attributes(localfile) then
--    dofile(localfile)
--end

if hs.wasLoaded == nil then
    hs.wasLoaded = true
    table.insert(buf, "Hammerspoon loaded.")
else
    table.insert(buf, "Hammerspoon re-loaded. ")
end

alert.show(table.concat(buf))
---init

---wifi watcher
wifiMenu = hs.menubar.newWithPriority(2147483645)
wifiMenu:setTitle(string.sub(hs.wifi.currentNetwork(), 0, 5))

nsBedroomSSID = "IzvorInterneta"
nsLivingRoomSSID = "Tenda_48353C"
saBedroomSSID = "devolo-f4068d4eb428"
saLivingRoomSSID = "Ljuba"

function loadPasswordAndConnectToWifiNetwork(ssid)
    hs.wifi.associate(ssid, loadKeychainPasswordByComment(ssid))
end

function wifiClicked()
    local wifiName = hs.wifi.currentNetwork()
    if wifiName == saBedroomSSID then
        loadPasswordAndConnectToWifiNetwork(saLivingRoomSSID)
    end
	if wifiName == saLivingRoomSSID then
        loadPasswordAndConnectToWifiNetwork(saBedroomSSID)
        end
    if wifiName == nsLivingRoomSSID then
        loadPasswordAndConnectToWifiNetwork(nsBedroomSSID)
        end
    if wifiName == nsBedroomSSID then
        loadPasswordAndConnectToWifiNetwork(nsLivingRoomSSID)
        end
end

wifiMenu:setClickCallback(wifiClicked)

wifiWatcher = nil

function ssidChanged()
    local wifiName = hs.wifi.currentNetwork()
    if wifiName then
        wifiMenu:setTitle(string.sub(wifiName, 0, 5))
    else
        wifiMenu:setTitle("Wifi OFF")
    end
end

wifiWatcher = hs.wifi.watcher.new(ssidChanged):start()

---Audio device switch-----
function toggle_audio_output()
  return function()
  local current = hs.audiodevice.defaultOutputDevice()
  local speakers = hs.audiodevice.findOutputByName('MacBook Pro Speakers')
  local headphones = hs.audiodevice.findOutputByName('External Headphones')

  if not speakers or not headphones then
      hs.notify.new({title="Hammerspoon", informativeText="ERROR: Some audio devices missing", ""}):send()
      return
  end

  if current:name() == speakers:name() then
      headphones:setDefaultOutputDevice()
  else
      speakers:setDefaultOutputDevice()
  end
    end
end

hs.hotkey.bind(HYPER, "]", toggle_audio_output())
---Audio device switch-----


---audio watcher
audioMenu = hs.menubar.newWithPriority(2147483646)


function audioChanged()
	audioMenu:setTitle(getCurrentOutputDevicePrefix())
end

function getCurrentOutputDevicePrefix()
	return string.sub(hs.audiodevice.defaultOutputDevice():name(), 0, 3)
end

audioMenu:setTitle(audioChanged())
hs.audiodevice.watcher.setCallback(audioChanged)
hs.audiodevice.watcher.start()
audioMenu:setClickCallback(toggle_audio_output())
---audio watcher

---capslock shortcuts
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
    -- hs.hotkey.bind(HYPER, key, function()
    --   hs.application.launchOrFocus(app)
    hyperFocusOrOpen(tostring(key), app)
  end
---capslock shortcuts

---window management
function moveWindowToDisplay(d)
    return function()
      local displays = hs.screen.allScreens()
      local win = hs.window.focusedWindow()
      if win:isFullScreen() then
          win:setFullScreen(false)
          win:moveToScreen(displays[d], false, true)

          hs.timer.doAfter(0.6, function()
              win:focus()
          end)
          hs.timer.doAfter(0.6, function()
              win:setFullScreen(true)
          end)
      else
        win:moveToScreen(displays[d], false, true)
       win:focus()
      end
    end
  end

  hs.hotkey.bind(HYPER, "1", moveWindowToDisplay(2)) -- move to Macbook display
  hs.hotkey.bind(HYPER, "2", moveWindowToDisplay(1)) -- move to Macbook Dell No1
  --hs.hotkey.bind(HYPER, "3", moveWindowToDisplay(3)) -- move to Macbook Dell No2
---window management

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

----splitWindowPopup
function splitWindowPopup()
    return function()
        local windows = hs.fnutils.map(hs.window.filter.default:getWindows(), function(win)
            if win ~= hs.window.focusedWindow() then
                return {
                    text = win:title(),
                    subText = win:application():title(),
                    image = hs.image.imageFromAppBundle(win:application():bundleID()),
                    id = win:id()
                }
            end
        end)

        local chooser = hs.chooser.new(function(choice)
            if choice ~= nil then
                local layout = {}
                local focused = hs.window.focusedWindow()
                local toRead = hs.window.find(choice.id)
                if hs.eventtap.checkKeyboardModifiers()['alt'] then
                    hs.layout.apply({
                        { nil, focused, focused:screen(), hs.layout.left70, 0, 0 },
                        { nil, toRead, focused:screen(), hs.layout.right30, 0, 0 }
                    })
                else
                    hs.layout.apply({
                        { nil, focused, focused:screen(), hs.layout.left50, 0, 0 },
                        { nil, toRead, focused:screen(), hs.layout.right50, 0, 0 }
                    })
                end
                toRead:raise()
                focused:focus()
            end
        end)

        chooser:placeholderText("Choose window for 50/50 split. Hold ⎇ for 70/30."):searchSubText(true):choices(windows):show()
    end
end

    hs.hotkey.bind(HYPER, 'm', splitWindowPopup())
----splitWindowPopup


---Keyboard layout switch-----
function setLayout(layoutStr)
  return function()
  hs.keycodes.setLayout(layoutStr)
  end
end

hs.hotkey.bind(HYPER, "4", setLayout("x_layout"))
hs.hotkey.bind(HYPER, "5", setLayout("Serbian - Latin"))
hs.hotkey.bind(HYPER, "6", setLayout("Serbian"))


Install:andUse("MenubarFlag",
        {
            config = {
                colors = {
                    ["x_layout"] = { },
                    ["Serbian"] = {col.red, col.blue, col.white, col.yellow},
                    ["Serbian - Latin"] = {col.red, col.blue, col.white},
                }
            },
            start = true
        }
)

---Keyboard layout switch-----

---levi9 vpn
function connectToLevi9Vpn()
    return function()
        spoon.Tunnelblick.connection_name = "Levi9_OpenVPN"
        spoon.Tunnelblick.username = "f.stanisic@levi9.com"
        spoon.Tunnelblick.password_fn = function()
        return loadKeychainPasswordByComment("Tunnelblick-Auth-Levi9_OpenVPN")
        end
        spoon.Tunnelblick:connect()
    end
end

hs.hotkey.bind(HYPER, 'l', connectToLevi9Vpn())
---levi9 vpn


-- ---paste token
--    hs.hotkey.bind(
--        HYPER, "y", function()
--        hs.pasteboard.setContents("Bearer token")
--        hs.eventtap.keyStroke("cmd", "v")
--    end)
-- ---paste token


--- MouseCircle, rounded corners
Install:andUse("MouseCircle", { hotkeys = { show = { HYPER, "d" }}})
-- Draw pretty rounded corners on all screens
Install:andUse("RoundedCorners", { start = true })
--- MouseCircle, rounded corners

--- translation popup
Install:andUse("PopupTranslateSelection",
        {
            config = {
                popup_style = wm.utility|wm.HUD|wm.titled|
                        wm.closable|wm.resizable,
            },
            hotkeys = {
                translate_to_en = { HYPER, "z" },
            }
        }
)
--- translation popup

--- HoldToQuit
Install:andUse("HoldToQuit", { start = true })
spoon.HoldToQuit:start()
--- HoldToQuit
