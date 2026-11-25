function extractCurrentEdgeUrl()
    local script = [[
        tell application "Microsoft Edge"
            set currentURL to URL of active tab of first window
        end tell
        return currentURL
    ]]

    local ok, currentURL = hs.applescript(script)
    return currentURL
end


function copyCurrentEdgeAzureDevopsBoardsTicketNumber()
    local currentEdgeUrl = extractCurrentEdgeUrl()

    local extracted = string.match(currentEdgeUrl, "workitem=(%d+)")

    hs.pasteboard.setContents(extracted)
    hs.alert.show(extracted)
end


function copyCurrentEdgeUrl()
    local currentEdgeUrl = extractCurrentEdgeUrl()

    hs.pasteboard.setContents(currentEdgeUrl)
    hs.alert.show(currentEdgeUrl)
end


-- Sequential keybindings, e.g. Hyper-W,J for AzureDevopsBoards

webMode = hs.hotkey.modal.new(HYPER, 'w')
webModeRunning = false

function webMode:entered()

    function alertAndAutoClose()
        webModeRunning = true

        hs.alert'Entered web mode\n B = Azure Devops Boards\n C = Confluence\n A = Azure Devops repositories\n E = Extract URL\n T = Extract Azure devops Ticket number\n R = Pull Requests\n Esc = Exit'

        hs.timer.delayed.new(3, function()
            if webModeRunning then
                webMode:exit()
            end
        end):start()
    end

    alertAndAutoClose()
end


function webMode:exited()
    webModeRunning = false
    hs.alert'Exited web mode'
end


webMode:bind('', 'B', function()
    hs.urlevent.openURLWithBundle(
        'https://dev.azure.com/ns-topaas/RCREIZ/_boards/board/t/Team%20Fundamentals/Stories',
        'com.microsoft.edgemac'
    )
    webMode:exit()
end)

webMode:bind('', 'c', function()
    hs.urlevent.openURLWithBundle(
        'https://ns-topaas.atlassian.net/wiki/home',
        'com.microsoft.edgemac'
    )
    webMode:exit()
end)

webMode:bind('', 'r', function()
    hs.urlevent.openURLWithBundle(
        'https://dev.azure.com/ns-topaas/BACKPACK/_git/backpack/pullrequests?_a=active',
        'com.microsoft.edgemac'
    )
    webMode:exit()
end)

webMode:bind('', 'A', function()
    hs.urlevent.openURLWithBundle(
        'https://dev.azure.com/ns-topaas',
        'com.microsoft.edgemac'
    )
    webMode:exit()
end)

webMode:bind('', 't', function()
    copyCurrentEdgeAzureDevopsBoardsTicketNumber()
    webMode:exit()
end)

webMode:bind('', 'e', function()
    copyCurrentEdgeUrl()
    webMode:exit()
end)

webMode:bind('', 'escape', function()
    webMode:exit()
end)