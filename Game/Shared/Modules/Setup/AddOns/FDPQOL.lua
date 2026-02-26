local NUI = unpack(FDPUI)
local SE = NUI:GetModule("Setup")

local PROFILE_NAME = "FDPQOL"

function SE.FDPQOL(addon, import, resolution)
    local D = NUI:GetModule("Data")

    local profile = "fdpqol" .. (resolution or "")
    local db

    if import then
        NaowhQOL_API.Import(D[profile], nil, PROFILE_NAME)

        SE.CompleteSetup(addon)

        NUI.db.char.loaded = true
        NUI.db.global.version = NUI.version

        return
    end

    if not SE.IsProfileExisting(NaowhQOL_Profiles, PROFILE_NAME) then
        SE.RemoveFromDatabase(addon)

        return
    end

    db = LibStub("AceDB-3.0"):New(NaowhQOL_Profiles)

    db:SetProfile(PROFILE_NAME)
end
