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
