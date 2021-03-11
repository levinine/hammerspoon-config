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
k = hs.hotkey.modal.new(HYPER, 'q') --- enter the web mode
function k:entered() hs.alert'Entered web mode. J = Jira, C = Confluence, G = Github, E = Extract URL, T = Extract Jira Ticket number' end
function k:exited()  hs.alert'Exited web mode'  end
k:bind('', 'j', function() hs.urlevent.openURLWithBundle('https://foleon.atlassian.net/secure/RapidBoard.jspa?rapidView=53&projectKey=PRODUCT', 'com.brave.Browser'); k:exit(); end)
k:bind('', 'c', function() hs.urlevent.openURLWithBundle('https://foleon.atlassian.net/wiki/spaces/FOLEON/overview', 'com.brave.Browser'); k:exit(); end)
k:bind('', 'g', function() hs.urlevent.openURLWithBundle('https://github.com/Foleon', 'com.brave.Browser'); k:exit(); end)
k:bind('', 't', function() copyCurrentBraveJiraTicketNumber(); k:exit(); end)
k:bind('', 'e', function() copyCurrentBraveUrl(); k:exit(); end)
