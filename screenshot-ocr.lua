-- Hyper-O: select a screen region, OCR it (macOS Vision via ocr.js) and copy the text to the clipboard

local OCR_SCRIPT = hs.configdir .. '/ocr.js'
local capture, ocr

local function cleanup(path)
    os.remove(path)
end

local function runOcr(path)
    ocr = hs.task.new('/usr/bin/osascript', function(exitCode, stdout, stderr)
        cleanup(path)
        local text = (stdout or ''):gsub('%s+$', '')
        if exitCode ~= 0 then
            hs.alert('OCR failed: ' .. (stderr or ''))
        elseif text == '' then
            hs.alert('No text recognized')
        else
            hs.pasteboard.setContents(text)
            hs.alert('Copied ' .. #text .. ' chars:\n' .. text:sub(1, 200), 3)
        end
    end, { '-l', 'JavaScript', OCR_SCRIPT, path })
    ocr:start()
end

function screenshotToText()
    if capture and capture:isRunning() then return end
    local path = os.tmpname() .. '.png'
    -- -i interactive region selection, -x no shutter sound; Esc cancels and leaves no file
    capture = hs.task.new('/usr/sbin/screencapture', function()
        if hs.fs.attributes(path) then
            runOcr(path)
        end
    end, { '-i', '-x', path })
    capture:start()
end

hs.hotkey.bind(HYPER, 'o', screenshotToText)
