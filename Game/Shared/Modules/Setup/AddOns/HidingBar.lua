local NUI = unpack(FDPUI)
local SE = NUI:GetModule("Setup")

local function ImportHidingBar(addon)
    local D = NUI:GetModule("Data")

    local profiles = {}

    for _, v in ipairs(HidingBarDB.profiles) do
        if v.name ~= "FDP" then
            v.isDefault = nil

            tinsert(profiles, v)
        end
    end

    tinsert(profiles, SE:RebrandImportData(D.hidingbar))

    HidingBarDB.profiles = profiles

    SE.CompleteSetup(addon)

    NUI.db.char.loaded = true
    NUI.db.global.version = NUI.version
end

function SE.HidingBar(addon, import)
    if import then
        ImportHidingBar(addon)
    end

    for _, v in ipairs(HidingBarDB.profiles) do
        if v.name == "FDP" then
            HidingBarDBChar = nil

            return
        end
    end

    SE.RemoveFromDatabase(addon)
end
