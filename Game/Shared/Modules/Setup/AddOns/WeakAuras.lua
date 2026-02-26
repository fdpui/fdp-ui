local NUI = unpack(FDPUI)
local SE = NUI:GetModule("Setup")

function SE.WeakAuras(_, frame, strata, weakaura)
    local D = NUI:GetModule("Data")

    if frame and strata then
        NUI.SetFrameStrata(frame, strata)
    end

    WeakAuras.Import(SE:RebrandImportData(D[weakaura]))
end
