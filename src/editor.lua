-- EDITOR.LUA ============================================================== --
-- ooooooo.--ooooooo--.ooooo.-----.ooooo.--oooooooooo-oooooooo.----.ooooo..o --
-- 888'-`Y8b--`888'--d8P'-`Y8b---d8P'-`Y8b-`888'---`8-`888--`Y88.-d8P'---`Y8 --
-- 888----888--888--888---------888---------888--------888--.d88'-Y88bo.---- --
-- 888----888--888--888---------888---------888oo8-----888oo88P'---`"Y888o.- --
-- 888----888--888--888----oOOo-888----oOOo-888--"-----888`8b.--------`"Y88b --
-- 888---d88'--888--`88.---.88'-`88.---.88'-888-----o--888-`88b.--oo----.d8P --
-- 888bd8P'--oo888oo-`Y8bod8P'---`Y8bod8P'-o888ooood8-o888o-o888o-8""8888P'- --
-- ========================================================================= --
-- (c) Mhatxotic Design, 2025          (c) Millennium Interactive Ltd., 1994 --
-- ========================================================================= --
-- Core function aliases --------------------------------------------------- --
local UtilFormatNumber<const> = Util.FormatNumber;
-- Engine function aliases ------------------------------------------------- --
-- Diggers function and data aliases --------------------------------------- --
local LoadLevel, PlayStaticSound, PrintC, RenderTerrain,
  SetCallbacks, SetHotSpot, SetKeys, oGlobalData, oObjectTypes, fontLarge;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Assets required
      iHotSpotId,                      -- Hot spot id
      iKeyBankId,                      -- Key bank id
      iSSelect,                        -- Select sfx id
      strMsg;                          -- Message to show
-- Blank function ---------------------------------------------------------- --
local function BlankFunction() end
-- When fail assets have loaded? ------------------------------------------- --
local function EditorProc(aResources)
end
-- When fail assets are being rendered? ------------------------------------ --
local function EditorRender(aResources)
  RenderTerrain();
end
-- Init level editor function ---------------------------------------------- --
local function InitEditor()
  -- When faded out to title? Load demo level
  LoadLevel(1, nil, nil, nil, true, oObjectTypes.DIGRANDOM,
    true, EditorProc, EditorRender, BlankFunction, 0, nil, nil, true);
end
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, oCursorIdData, oSfxData;
  -- Grab imports
  LoadLevel, PlayStaticSound, PrintC, RegisterHotSpot, RegisterKeys,
    RenderTerrain,
    SetCallbacks, SetHotSpot, SetKeys, oCursorIdData, oObjectTypes, oSfxData,
    fontLarge =
      GetAPI("LoadLevel", "PlayStaticSound", "PrintC", "RegisterHotSpot",
        "RegisterKeys", "RenderTerrain", "SetCallbacks", "SetHotSpot", "SetKeys",
        "oCursorIdData", "oObjectTypes", "oSfxData", "fontLarge");
  -- Register hot spot
--  iHotSpotId = RegisterHotSpot({
--    { 0, 0, 0, 240, 3, oCursorIdData.EXIT, false, false, GoScore }
--  });
  -- Register key binds
--  iKeyBankId = RegisterKeys("IN-GAME NO MORE ZONES", { [Input.States.PRESS] = {
--    { Input.KeyCodes.ESCAPE, GoScore, "ignmzl", "LEAVE" }
--  } });
  -- Get select sound effect id
  iSSelect = oSfxData.SELECT;
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitEditor = InitEditor }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
