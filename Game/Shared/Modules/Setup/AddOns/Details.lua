local NUI = unpack(FDPUI)
local SE = NUI:GetModule("Setup")

function SE.Details(addon, import, resolution)
    local D = NUI:GetModule("Data")

    local data, decompressedData, importData
    local profile = "details" .. (resolution or "")

    if import then
        importData = SE:RebrandImportData(D[profile])
        data = DetailsFramework:Trim(importData)
        decompressedData = Details:DecompressData(data, "print")
        decompressedData = SE:RebrandImportData(decompressedData)

        Details:EraseProfile("FDP")
        Details:ImportProfile(importData, "FDP", false, false, true)

        for i, v in Details:ListInstances() do
            DetailsFramework.table.copy(v.hide_on_context, decompressedData.profile.instances[i].hide_on_context)
        end

        SE.CompleteSetup(addon)

        NUI.db.char.loaded = true
        NUI.db.global.version = NUI.version

        return
    end

    if not Details:GetProfile("FDP") then
        SE.RemoveFromDatabase(addon)

        return
    end

    Details:ApplyProfile("FDP")
end
