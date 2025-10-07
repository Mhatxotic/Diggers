-- CNTRL.LUA =============================================================== --
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
-- M-Engine function aliases ----------------------------------------------- --
-- Diggers function and data aliases --------------------------------------- --
local BlitSLTRB, BlitSLT, BlitLT, Fade, InitCon, LoadResources,
  PlayStaticSound, RenderShadow, RenderTipShadow, SetCallbacks, SetHotSpot,
  SetKeys, TypeIdToId, oGlobalData, aRaceStatData, texSpr;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Assets Required
      iHotSpotId,                      -- Hot spot id
      iKeyBankId,                      -- Key bank id
      iRaceId,                         -- Chosen race id
      iRaceIdSelected,                 -- Currently displayed race id
      iRaceObjId,                      -- Race object id selected
      iStatStr, iStatSta, iStatDsp,    -- Race trait power bars
      iStatPat, iStatAtp, iStatTel,    -- Race trait power bars
      iSClick, iSSelect,               -- Sound effect ids
      iTileLabel,                      -- Label id to draw
      iTilePortrait,                   -- Portrait id to draw
      iTileSpecial,                    -- Special id to draw
      texZmtc,                         -- Lobby texture
      texRace;                         -- Race texture
-- Tile data (See data.lua/oAssetsData.race.P) ----------------------------- --
local iTileRaceStart<const>    = 1;    -- First race texture
local iTileLabelStart<const>   = 6;    -- Race labels
local iTileSpecialStart<const> = 10;   -- Special items tile
-- Set clamped race id and race data --------------------------------------- --
local function SetRaceId(iId)
  -- Adjust and clamp race selection id
  iRaceId = iId % #aRaceStatData;
  -- Set tile ids to draw
  iTileLabel, iTilePortrait, iTileSpecial =
    iTileLabelStart + iRaceId,
    iTileRaceStart + iRaceId,
    iTileSpecialStart + iRaceId;
  -- Set race selected data
  local aRaceDataSelected<const> = aRaceStatData[1 + iRaceId];
  -- Set actual race object type
  iRaceObjId = aRaceDataSelected[1];
  -- Set power bars
  local iX<const> = 115;
  iStatStr, iStatSta, iStatDsp, iStatPat, iStatAtp, iStatTel =
    iX + aRaceDataSelected[2], iX + aRaceDataSelected[3],
    iX + aRaceDataSelected[4], iX + aRaceDataSelected[5],
    iX + aRaceDataSelected[6], iX + aRaceDataSelected[7];
end
-- Render race ------------------------------------------------------------- --
local function ProcRenderRace()
  -- Draw zmtc backdrop
  BlitLT(texZmtc, -96, 0);
  -- Draw race page backdrop, race title text and race special
  BlitLT(texRace, 8, 8);
  BlitSLT(texRace, iTilePortrait, 172, 54);
  BlitSLT(texRace, iTileLabel, 80, 24);
  BlitSLT(texRace, iTileSpecial, 114, 175);
  -- Draw selected symbol if this is the selected digger
  if iRaceId == iRaceIdSelected then
    BlitSLT(texRace, 5, 132, 80, 192, 208) end;
  -- Draw stats
  texSpr:SetCRGBA(1, 0, 0, 0.5);
  BlitSLTRB(texSpr, 1022, 115,  62, iStatStr,  65);
  BlitSLTRB(texSpr, 1022, 115,  82, iStatSta,  85);
  BlitSLTRB(texSpr, 1022, 115, 102, iStatDsp, 105);
  BlitSLTRB(texSpr, 1022, 115, 122, iStatPat, 125);
  BlitSLTRB(texSpr, 1022, 115, 142, iStatAtp, 145);
  BlitSLTRB(texSpr, 1022, 115, 162, iStatTel, 165);
  texSpr:SetCRGBA(1, 1, 1, 1);
  -- Draw background shadow
  RenderShadow(8, 8, 312, 208);
  -- Draw tip and shadow
  RenderTipShadow();
end
-- Proc race function while fading ----------------------------------------- --
local function ProcRaceInitial()
  -- Enable keybank and hotspots
  SetKeys(true, iKeyBankId);
  SetHotSpot(iHotSpotId);
  -- Set callbacks
  SetCallbacks(nil, ProcRenderRace);
end
-- Race selection function ------------------------------------------------- --
local function AdjustRace(iAmount)
  PlayStaticSound(iSClick);
  SetRaceId(iRaceId + iAmount);
end
-- Selext previous and next race functions --------------------------------- --
local function GoPrevious() AdjustRace(-1) end;
local function GoNext() AdjustRace(1) end;
-- When returning to controler --------------------------------------------- --
local function GoCntrl()
  -- Play select soud
  PlayStaticSound(iSSelect)
  -- When faded out?
  local function OnFadeOut()
    -- Dereference used variables and handles
    iRaceId, iRaceObjId, iStatStr, iStatSta, iStatDsp, iStatPat, iStatAtp,
      iStatTel, iTileLabel, iTilePortrait, iTileSpecial, texZmtc, texRace =
        nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil;
    -- Load controller screen
    InitCon();
  end
  -- Fade out to controller screen
  Fade(0, 1, 0.04, ProcRenderRace, OnFadeOut);
end
-- When accepting the race selection --------------------------------------- --
local function GoAccept()
  -- Apply new setting
  oGlobalData.gSelectedRace, iRaceIdSelected = iRaceObjId, iRaceId;
  -- Fade out to lobby
  GoCntrl();
end
-- When scroll wheel or trackpad is moved ---------------------------------- --
local function OnScroll(nX, nY)
  if nY > 0 then GoPrevious() elseif nY < 0 then GoNext() end;
end
-- Data loaded function ---------------------------------------------------- --
local function OnAssetsLoaded(aResources)
  -- Get lobby and race texture
  texZmtc, texRace = aResources[1], aResources[2];
  -- Set currently selected race
  iRaceIdSelected = oGlobalData.gSelectedRace;
  -- Set race already selected
  SetRaceId(iRaceIdSelected or 0);
  -- Fade in
  Fade(1, 0, 0.04, ProcRenderRace, ProcRaceInitial);
end
-- Init race screen function ----------------------------------------------- --
local function InitRace() LoadResources("Race", aAssets, OnAssetsLoaded) end;
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, oAssetsData, oCursorIdData, oSfxData;
  -- Grab imports
  BlitSLTRB, BlitSLT, BlitLT, Fade, InitCon, LoadResources, PlayStaticSound,
    RegisterHotSpot, RegisterKeys, RenderShadow, RenderTipShadow, SetCallbacks,
    SetHotSpot, SetKeys, oAssetsData, oCursorIdData, oGlobalData,
    aRaceStatData, oSfxData, texSpr =
      GetAPI("BlitSLTRB", "BlitSLT", "BlitLT", "Fade", "InitCon",
        "LoadResources", "PlayStaticSound", "RegisterHotSpot",
        "RegisterKeys", "RenderShadow", "RenderTipShadow", "SetCallbacks",
        "SetHotSpot", "SetKeys", "oAssetsData", "oCursorIdData", "oGlobalData",
        "aRaceStatData", "oSfxData", "texSpr");
  -- Set assets data
  aAssets = { oAssetsData.zmtc, oAssetsData.race };
  -- Set sound effect ids
  iSClick, iSSelect = oSfxData.CLICK, oSfxData.SELECT;
  -- Register keybinds
  local oKeys<const> = Input.KeyCodes;
  iKeyBankId = RegisterKeys("ZMTC RACE SELECT", {
    [Input.States.PRESS] = {
      { oKeys.ESCAPE, GoCntrl,    "zmtcrsc", "CANCEL"   },
      { oKeys.ENTER,  GoAccept,   "zmtcrsa", "ACCEPT"   },
      { oKeys.LEFT,   GoPrevious, "zmtcrsp", "PREVIOUS" },
      { oKeys.RIGHT,  GoNext,     "zmtcrsn", "NEXT"     },
    }
  });
  -- Register hotspots
  iHotSpotId = RegisterHotSpot({
    { 172,  54,  54, 128, 0, oCursorIdData.OK,
      "ACCEPT",      OnScroll, GoAccept },
    { 248, 192,  16,  16, 0, oCursorIdData.SELECT,
      "NEXT RACE",   OnScroll, GoNext   },
    {   8,   8, 304, 200, 0, 0,
      "SELECT RACE", OnScroll, false    },
    {   0,   0,   0, 240, 3, oCursorIdData.EXIT,
      "CANCEL",      OnScroll, GoCntrl  }
  });
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitRace = InitRace }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
