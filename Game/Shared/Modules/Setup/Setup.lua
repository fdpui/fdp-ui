local NUI = unpack(FDPUI)
local SE = NUI:GetModule("Setup")

local pairs, type = pairs, type
local LEGACY_QOL_ADDON_NAME = "NaowhQOL"
local LEGACY_BRAND_NAME = LEGACY_QOL_ADDON_NAME:match("^(.-)QOL$") or ""

local REBRAND_IMPORT_REPLACEMENTS = {
    {"Interface\\AddOns\\" .. LEGACY_BRAND_NAME .. "UI\\", "Interface\\AddOns\\FDPUI\\"},
    {LEGACY_BRAND_NAME .. "MouseoverArrows", "FDPMouseoverArrows"},
    {LEGACY_BRAND_NAME .. "Mouseover", "FDPMouseover"},
    {LEGACY_BRAND_NAME .. "Gradient", "FDPGradient"},
    {LEGACY_BRAND_NAME .. "Target", "FDPTarget"},
    {LEGACY_BRAND_NAME .. "Right", "FDPRight"},
    {LEGACY_BRAND_NAME .. "Left", "FDPLeft"},
    {LEGACY_BRAND_NAME, "FDP"}
}

local function RebrandImportString(value)
    local updated = value

    for i = 1, #REBRAND_IMPORT_REPLACEMENTS do
        local from = REBRAND_IMPORT_REPLACEMENTS[i][1]
        local to = REBRAND_IMPORT_REPLACEMENTS[i][2]

        updated = updated:gsub(from, to)
    end

    return updated
end

local function RebrandImportValue(value, seen)
    if type(value) == "string" then
        return RebrandImportString(value)
    end

    if type(value) ~= "table" then
        return value
    end

    if seen[value] then
        return value
    end

    seen[value] = true

    local pendingKeyRenames = {}

    for k, v in pairs(value) do
        local updatedValue = RebrandImportValue(v, seen)

        if updatedValue ~= v then
            value[k] = updatedValue
        end

        if type(k) == "string" then
            local updatedKey = RebrandImportString(k)

            if updatedKey ~= k then
                pendingKeyRenames[#pendingKeyRenames + 1] = { old = k, new = updatedKey }
            end
        end
    end

    for i = 1, #pendingKeyRenames do
        local oldKey = pendingKeyRenames[i].old
        local newKey = pendingKeyRenames[i].new

        if value[oldKey] ~= nil and value[newKey] == nil then
            value[newKey] = value[oldKey]
            value[oldKey] = nil
        end
    end

    return value
end

function SE:RebrandImportData(value)
    return RebrandImportValue(value, {})
end

function SE:Setup(addon, ...)
    local setup = self[addon]

    setup(addon, ...)
end

function SE.CompleteSetup(addon)
    if PluginInstallStepComplete then
        if PluginInstallStepComplete:IsShown() then
            PluginInstallStepComplete:Hide()
        end

        PluginInstallStepComplete.message = "Success"

        PluginInstallStepComplete:Show()
    end

    NUI.db.global.profiles = NUI.db.global.profiles or {}
    NUI.db.global.profiles[addon] = true
end

function SE.IsProfileExisting(table, profileName)
    local db = LibStub("AceDB-3.0"):New(table)
    local profiles = db:GetProfiles()
    local expectedProfile = profileName or "FDP"

    for i = 1, #profiles do
        if profiles[i] == expectedProfile then

            return true
        end
    end
end

function SE.RemoveFromDatabase(addon)
    NUI.db.global.profiles[addon] = nil

    if NUI.db.global.profiles and not next(NUI.db.global.profiles) then
        for k in pairs(NUI.db.char) do
            k = nil
        end

        NUI.db.global.profiles = nil
    end
end
