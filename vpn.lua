Install:andUse("Tunnelblick")

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
