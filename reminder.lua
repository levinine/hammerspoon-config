-- Hyper-R: "remind me in N minutes", optionally with a message.
-- Input examples: "10", "10 call mom", "1h30 standup", "45s tea", "2h"

local reminders = {}

local UNIT_SECONDS = { s = 1, m = 60, h = 3600 }

local function parse(input)
    input = input .. ' '
    local hours, minutes, rest = input:match('^%s*(%d+)h(%d*)m?%s+(.-)%s*$')
    if hours then
        return tonumber(hours) * 3600 + (tonumber(minutes) or 0) * 60, rest
    end

    local amount, unit, message = input:match('^%s*(%d+%.?%d*)([smh]?)%s+(.-)%s*$')
    if not amount then return nil end
    return tonumber(amount) * UNIT_SECONDS[unit ~= '' and unit or 'm'], message
end

local function formatDuration(seconds)
    if seconds >= 3600 then
        local h, m = math.floor(seconds / 3600), math.floor(seconds % 3600 / 60)
        return h .. 'h' .. (m > 0 and (' ' .. m .. 'm') or '')
    elseif seconds >= 60 then
        return math.floor(seconds / 60) .. 'm'
    end
    return math.floor(seconds) .. 's'
end

local function fire(message)
    hs.sound.getByName('Glass'):play()
    hs.notify.new({
        title = 'Reminder',
        informativeText = message,
        withdrawAfter = 0,
    }):send()
    hs.alert.show('Reminder\n' .. message, { atScreenEdge = 0 }, 10)
end

function remindMe()
    hs.focus()
    local button, input = hs.dialog.textPrompt(
        'Remind me in…',
        'Minutes, optionally followed by a message.\nExamples: 10 | 10 call mom | 1h30 standup | 45s tea',
        '', 'Set', 'Cancel')
    if button ~= 'Set' then return end

    local seconds, message = parse(input)
    if not seconds or seconds <= 0 then
        hs.alert('Could not parse: ' .. input)
        return
    end
    if message == '' then message = 'Time is up (' .. formatDuration(seconds) .. ')' end

    local timer
    timer = hs.timer.doAfter(seconds, function()
        reminders[timer] = nil
        fire(message)
    end)
    reminders[timer] = true
    hs.alert('Reminder in ' .. formatDuration(seconds) .. ':\n' .. message)
end

hs.hotkey.bind(HYPER, 'r', remindMe)
