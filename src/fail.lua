-- FAIL.LUA ================================================================ --
-- ooooooo.--ooooooo--.ooooo.-----.ooooo.--oooooooooo-oooooooo.----.ooooo..o --
-- 888'-`Y8b--`888'--d8P'-`Y8b---d8P'-`Y8b-`888'---`8-`888--`Y88.-d8P'---`Y8 --
-- 888----888--888--888---------888---------888--------888--.d88'-Y88bo.---- --
-- 888----888--888--888---------888---------888oo8-----888oo88P'---`"Y888o.- --
-- 888----888--888--888----oOOo-888----oOOo-888--"-----888`8b.--------`"Y88b --
-- 888---d88'--888--`88.---.88'-`88.---.88'-888-----o--888-`88b.--oo----.d8P --
-- 888bd8P'--oo888oo-`Y8bod8P'---`Y8bod8P'-o888ooood8-o888o-o888o-8""8888P'- --
-- ========================================================================= --
-- (c) Mhatxotic Design, 2026          (c) Millennium Interactive Ltd., 1994 --
-- ========================================================================= --
-- Core function aliases --------------------------------------------------- --
local UtilFormatNumber<const> = Util.FormatNumber;
-- Engine function aliases ------------------------------------------------- --
-- Diggers function and data aliases --------------------------------------- --
local Fade, InitScore, LoadResources, PlayMusic, PlayStaticSound, PrintC,
  SetCallbacks, SetHotSpot, SetKeys, oGlobalData, fontLarge;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Assets required
      iHotSpotId,                      -- Hot spot id
      iKeyBankId,                      -- Key bank id
      iSSelect,                        -- Select sfx id
      strMsg;                          -- Message to show
-- Game over render tick --------------------------------------------------- --
local function ProcRender()
  -- Show fail message
  fontLarge:SetCRGB(1.0, 0.25, 0.25);
  PrintC(fontLarge, 160.0, 50.0, strMsg);
end
-- Finish procedure -------------------------------------------------------- --
local function GoScore()
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Fade out and load title with fade
  Fade(0.0, 1.0, 0.04, ProcRender, InitScore, true);
end
-- When fail screen has faded in ------------------------------------------- --
local function OnFadedIn()
  -- Set fail keys and hot spot
  SetKeys(true, iKeyBankId);
  SetHotSpot(iHotSpotId);
  -- Change render procedures
  SetCallbacks(nil, ProcRender);
end
-- When fail assets have loaded? ------------------------------------------- --
local function OnAssetsLoaded(aResources)
  -- Stop music so we can break the good news
  PlayMusic(aResources[1]);
  -- Set game over message
  strMsg = "NO ZONES LEFT TO MINE!\n\z
            \n\z
            "..UtilFormatNumber(oGlobalData.gBankBalance, 0).." IN BANK\n\z
            "..UtilFormatNumber(oGlobalData.gZogsToWinGame -
                oGlobalData.gBankBalance, 0).." SHORT\n\z
            \n\z
            YOUR MISSION HAS\n\z
            FAILED!"
  -- Fade in to show failure message
  Fade(1.0, 0.0, 0.04, ProcRender, OnFadedIn);
end
-- Init ending screen functions -------------------------------------------- --
local function InitFail() LoadResources("Fail", aAssets, OnAssetsLoaded) end;
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, oAssetsData, oCursorIdData, oSfxData;
  -- Grab imports
  Fade, InitScore, LoadResources, PlayMusic, PlayStaticSound, PrintC,
    RegisterHotSpot, RegisterKeys, SetCallbacks, SetHotSpot, SetKeys,
    oAssetsData, oCursorIdData, oGlobalData, oSfxData, fontLarge =
      GetAPI("Fade", "InitScore", "LoadResources", "PlayMusic",
        "PlayStaticSound", "PrintC", "RegisterHotSpot", "RegisterKeys",
        "SetCallbacks", "SetHotSpot", "SetKeys", "oAssetsData",
        "oCursorIdData", "oGlobalData", "oSfxData", "fontLarge");
  -- Set assets required
  aAssets = { oAssetsData.losem };
  -- Register hot spot
  iHotSpotId = RegisterHotSpot({
    { 0, 0, 0, 240, 3, oCursorIdData.EXIT, false, false, GoScore }
  });
  -- Register key binds
  iKeyBankId = RegisterKeys("IN-GAME NO MORE ZONES", { [Input.States.PRESS] = {
    { Input.KeyCodes.ESCAPE, GoScore, "ignmzl", "LEAVE" }
  } });
  -- Get select sound effect id
  iSSelect = oSfxData.SELECT;
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitFail = InitFail }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
