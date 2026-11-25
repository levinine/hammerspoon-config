local GIT = '/usr/bin/git'

local function shell(cmd)
    local out, ok = hs.execute(cmd, true)
    return (out or ''):gsub('%s+$', ''), ok
end

local function quote(s)
    return "'" .. s:gsub("'", "'\\''") .. "'"
end

-- Working dir of the frontmost iTerm session: shell integration first, then the foreground process on its tty
local function currentItermDirectory()
    local script = [[
        tell application "iTerm2"
            tell current session of current window
                return (variable named "session.path") & "|" & (tty)
            end tell
        end tell
    ]]
    local ok, result = hs.osascript.applescript(script)
    if not ok or not result then return nil end

    local path, tty = result:match('^(.*)|(.*)$')
    if path and path ~= '' then return path end
    if not tty or tty == '' then return nil end

    local pids = shell('ps -t ' .. quote(tty:gsub('^/dev/', '')) .. ' -o pid=,stat= | awk \'$2 ~ /\\+/ {print $1}\'')
    local pid = pids:match('(%d+)%s*$')
    if not pid then return nil end

    local cwd = shell('lsof -a -d cwd -p ' .. pid .. ' -Fn | grep "^n" | cut -c2-')
    return cwd ~= '' and cwd or nil
end

local function gitRoot()
    local dir = currentItermDirectory()
    if not dir then
        hs.alert('No iTerm session found')
        return nil
    end
    local root, ok = shell(GIT .. ' -C ' .. quote(dir) .. ' rev-parse --show-toplevel 2>/dev/null')
    if not ok or root == '' then
        hs.alert('Not a git repository:\n' .. dir)
        return nil
    end
    return root
end

local function git(args)
    local root = gitRoot()
    if not root then return nil end
    local out, ok = shell(GIT .. ' -C ' .. quote(root) .. ' ' .. args .. ' 2>&1')
    return out, ok, root
end

local function showOutput(title, text)
    hs.alert.show(title .. '\n' .. text, { textFont = 'Menlo', textSize = 14, atScreenEdge = 0 }, 6)
end

local function prettyPrintJson()
    local input = hs.pasteboard.getContents()
    if not input or input == '' then
        hs.alert('Clipboard is empty')
        return
    end

    local tmp = os.tmpname()
    local f = io.open(tmp, 'w')
    f:write(input)
    f:close()
    local out, ok = shell('/usr/bin/python3 -m json.tool --indent 2 ' .. quote(tmp) .. ' 2>&1')
    os.remove(tmp)

    if not ok then
        local decoded = hs.json.decode(input)
        if decoded == nil then
            hs.alert('Clipboard is not valid JSON')
            return
        end
        out = hs.json.encode(decoded, true)
    end
    hs.pasteboard.setContents(out)
    hs.alert('JSON pretty printed to clipboard')
end

local function gitStatus()
    local out, _, root = git('status -sb')
    if out then showOutput(root:match('[^/]+$'), out) end
end

local function copyBranch()
    local out, ok = git('rev-parse --abbrev-ref HEAD')
    if not out then return end
    if not ok then return hs.alert(out) end
    hs.pasteboard.setContents(out)
    hs.alert('Branch copied: ' .. out)
end

local function copyLastCommitHash()
    local out, ok = git('rev-parse HEAD')
    if not out then return end
    if not ok then return hs.alert(out) end
    hs.pasteboard.setContents(out)
    hs.alert('Commit copied: ' .. out:sub(1, 8))
end

local function gitPull()
    hs.alert('Pulling...')
    local out = git('pull')
    if out then showOutput('git pull', out) end
end

local function recentCommits()
    local out = git('log -10 --pretty=format:"%h %<(50,trunc)%s (%an, %ar)"')
    if out then showOutput('Recent commits', out) end
end

-- Sequential keybindings, e.g. Hyper-D,S for git status

developerMode = hs.hotkey.modal.new(HYPER, 'd')
developerModeRunning = false

function developerMode:entered()
    developerModeRunning = true

    hs.alert'Entered developer mode\n J = Pretty print JSON (clipboard)\n S = Git status\n C = Copy branch name\n H = Copy last commit hash\n P = Git pull\n L = Recent commits\n Esc = Exit'

    hs.timer.delayed.new(3, function()
        if developerModeRunning then
            developerMode:exit()
        end
    end):start()
end

function developerMode:exited()
    developerModeRunning = false
    hs.alert'Exited developer mode'
end

local function bindAction(key, fn)
    developerMode:bind('', key, function()
        developerMode:exit()
        fn()
    end)
end

bindAction('j', prettyPrintJson)
bindAction('s', gitStatus)
bindAction('c', copyBranch)
bindAction('h', copyLastCommitHash)
bindAction('p', gitPull)
bindAction('l', recentCommits)

developerMode:bind('', 'escape', function()
    developerMode:exit()
end)
