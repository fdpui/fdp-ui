local NUI = unpack(FDPUI)
local SE = NUI:GetModule("Setup")

function SE.BetterCooldownManager(addon, import, resolution)
    local D = NUI:GetModule("Data")

    local profile = "bettercooldownmanager" .. (resolution or "")
    local db

    if import then
        BCDMG:ImportBCDM(SE:RebrandImportData(D[profile]), "FDP")

        SE.CompleteSetup(addon)

        NUI.db.char.loaded = true
        NUI.db.global.version = NUI.version

        return
    end

    if not SE.IsProfileExisting(BCDMDB) then
        SE.RemoveFromDatabase(addon)

        return
    end

    db = LibStub("AceDB-3.0"):New(BCDMDB)

    db:SetProfile("FDP")
end
