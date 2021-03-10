function toggle_audio_output()
    return function()
        local current = hs.audiodevice.defaultOutputDevice()
        local speakers = hs.audiodevice.findOutputByName('MacBook Pro Speakers')
        --local headphones = hs.audiodevice.findOutputByName('External Headphones')
        local galaxyBuds = hs.audiodevice.findOutputByName('Galaxy Buds+ (E83A)')

        if current:name() == speakers:name() then
            if galaxyBuds ~= nil then
                galaxyBuds:setDefaultOutputDevice()
            end
        else
            speakers:setDefaultOutputDevice()
        end
    end
end

hs.hotkey.bind(HYPER, "]", toggle_audio_output())

function getCurrentOutputDevicePrefix()
    return string.sub(hs.audiodevice.defaultOutputDevice():name(), 0, 3)
end

function audioChanged()
    audioMenu:setTitle(getCurrentOutputDevicePrefix())
end

audioMenu = hs.menubar.newWithPriority(2147483646)
audioChanged()
audioMenu:setClickCallback(toggle_audio_output())

hs.audiodevice.watcher.setCallback(audioChanged)
hs.audiodevice.watcher.start()

