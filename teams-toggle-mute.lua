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
