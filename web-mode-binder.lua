function extractCurrentBraveUrl()
    script = [[
    tell application "Brave"
        set currentURL to URL of active tab of first window
    end tell
    return currentURL
    ]]
    ok, currentURL = hs.applescript(script)
    return currentURL
end

function copyCurrentBraveJiraTicketNumber()
    currentBraveUrl = extractCurrentBraveUrl()
    local extracted = string.match(currentURL, "PRODUCT%-%d+")
    hs.pasteboard.setContents(extracted)
    alert.show(extracted)
end

function copyCurrentBraveUrl()
    currentBraveUrl = extractCurrentBraveUrl()
    hs.pasteboard.setContents(currentBraveUrl)
    alert.show(currentBraveUrl)
end

-- Sequential keybindings, e.g. Hyper-Q,J for Jira
webMode = hs.hotkey.modal.new(HYPER, 'q') --- enter the web mode
function webMode:entered() hs.alert'Entered web mode. J = Jira, C = Confluence, G = Github, E = Extract URL, T = Extract Jira Ticket number, Esc = Exit' end
function webMode:exited()  hs.alert'Exited web mode'  end
webMode:bind('', 'j', function() hs.urlevent.openURLWithBundle('https://foleon.atlassian.net/secure/RapidBoard.jspa?rapidView=53&projectKey=PRODUCT', 'com.brave.Browser'); webMode:exit(); end)
webMode:bind('', 'c', function() hs.urlevent.openURLWithBundle('https://foleon.atlassian.net/wiki/spaces/FOLEON/overview', 'com.brave.Browser'); webMode:exit(); end)
webMode:bind('', 'g', function() hs.urlevent.openURLWithBundle('https://github.com/Foleon', 'com.brave.Browser'); webMode:exit(); end)
webMode:bind('', 't', function() copyCurrentBraveJiraTicketNumber(); webMode:exit(); end)
webMode:bind('', 'e', function() copyCurrentBraveUrl(); webMode:exit(); end)
webMode:bind('', 'escape', function() webMode:exit() end)
