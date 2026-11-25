function setLayout(layoutStr)
    return function()
        hs.keycodes.setLayout(layoutStr)
    end
end

hs.hotkey.bind(HYPER, "4", setLayout("Unicode Hex Input"))
hs.hotkey.bind(HYPER, "5", setLayout("Serbian (Latin)"))
hs.hotkey.bind(HYPER, "6", setLayout("Serbian"))


Install:andUse("MenubarFlag",
        {
            config = {
                colors = {
                    ["Unicode Hex Input"] = { },
                    ["Serbian"] = {col.red, col.blue, col.white, col.yellow},
                    ["Serbian (Latin)"] = {col.red, col.blue, col.white},
                }
            },
            start = true
        }
)
