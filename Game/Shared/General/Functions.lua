local NUI = unpack(FDPUI)

local chatCommands = {}

function NUI.SetFrameStrata(frame, strata)
    frame:SetFrameStrata(strata)
end

function NUI:OpenSettings()
    if PluginInstallFrame and PluginInstallFrame:IsShown() then
        self.SetFrameStrata(PluginInstallFrame, "MEDIUM")
    end

    Settings.OpenToCategory(self.category)
end

function NUI:RunInstaller()
    local I = NUI:GetModule("Installer")

    local E, PI

    if InCombatLockdown() then

        return
    end

    if self:IsAddOnEnabled("ElvUI") then
        E = unpack(ElvUI)
        PI = E:GetModule("PluginInstaller")

        PI:Queue(I.installer)

        return
    end

    self:OpenSettings()
end

function chatCommands.install()
    NUI:RunInstaller()
end

function NUI:HandleChatCommand(input)
    local command = chatCommands[input]

    if not command then
        self:Print("Command does not exist")

        return
    end

    command()
end

function NUI:LoadProfiles()
    local SE = NUI:GetModule("Setup")

    for k in pairs(self.db.global.profiles) do
        if self:IsAddOnEnabled(k) then
            SE:Setup(k)
        end
    end

    self.db.char.loaded = true

    ReloadUI()
end
