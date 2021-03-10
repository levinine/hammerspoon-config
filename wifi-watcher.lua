wifiMenu = hs.menubar.newWithPriority(2147483645)

function lanConnectedText()
    if hs.network.interfaceDetails(v4) then
        if hs.network.interfaceDetails(v4)["AirPort"] then
            return ""
        else
            return "LAN+"
        end
    end
    return ""
end

function ssidChanged()
    local wifiName = hs.wifi.currentNetwork()
    if wifiName then
        wifiMenu:setTitle(lanConnectedText() .. string.sub(wifiName, 0, 3))
    else
        wifiMenu:setTitle(lanConnectedText() .."Wifi OFF")
    end
end


ssidChanged()
--check is lan connected every 2 minutes
lanConnectedTimer = hs.timer.new(120, ssidChanged):start()

nsBedroomSSID = "IzvorInterneta"
nsLivingRoomSSID = "Tenda_48353C"
saBedroomSSID = "devolo-f4068d4eb428"
saLivingRoomSSID = "Ljuba"

function loadPasswordAndConnectToWifiNetwork(ssid)
    hs.wifi.associate(ssid, loadKeychainPasswordByAccount(ssid))
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
wifiWatcher = hs.wifi.watcher.new(ssidChanged):start()
