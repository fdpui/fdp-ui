local NUI = unpack(FDPUI)
local SE = NUI:GetModule("Setup")

function SE.WarpDeplete(addon, import, resolution)
    local D = NUI:GetModule("Data")

    local profile = "warpdeplete" .. (resolution or "")

    if import then
        WarpDepleteDB.profiles.FDP = SE:RebrandImportData(D[profile])

        SE.CompleteSetup(addon)

        NUI.db.char.loaded = true
        NUI.db.global.version = NUI.version
    end

    if not SE.IsProfileExisting(WarpDepleteDB) then
        SE.RemoveFromDatabase(addon)

        return
    end

    WarpDeplete.db:SetProfile("FDP")
end
