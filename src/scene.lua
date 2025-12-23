-- SCENE.LUA =============================================================== --
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
local BlitLT, Fade, LoadLevel, LoadResources, PlayMusic, PrintC, SetCallbacks,
  oGlobalData, aLevelTypesData, aLevelsData, fontLarge;
-- Locals ------------------------------------------------------------------ --
local aAssetsScene,                    -- Scene assets required
      aAssetsRequire,                  -- Required assets required
      iLevelId,                        -- Level id to load
      iWaitCounter,                    -- Ticks counted for next screen
      iTerrainId,                      -- Selected terrain id
      oLevelInfo,                      -- Selected level information
      sTextToWin,                      -- Text to win label
      texRequire,                      -- Pile of zogs
      texScene;                        -- Scene texture
-- Render the zogs requirement callback ------------------------------------ --
local function ProcRenderRequire()
  -- Draw appropriate background
  BlitLT(texRequire, 72.0, 32.0);
  -- Draw the text to win
  fontLarge:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  PrintC(fontLarge, 160.0, 192.0, sTextToWin);
end
-- Render the scene callback since we're using it multiple times ----------- --
local function ProcRenderScene() BlitLT(texScene, 0.0, 20.0) end;
-- On required fade out? --------------------------------------------------- --
local function OnFadeOutToGame()
  -- Release assets to garbage collector
  texRequire, sTextToWin, iWaitCounter = nil, nil, nil;
  -- Load the requested level
  LoadLevel(iLevelId, "game", -1);
  -- Done with level id
  iLevelId = nil;
end
-- Required Zogs wait procedure -------------------------------------------- --
local function ProcLogicRequired()
  -- Increment timer and don't do anything until 4 seconds
  iWaitCounter = iWaitCounter + 1;
  if iWaitCounter < 300 then return end;
  -- Fade out and then load the level
  Fade(0.0, 1.0, 0.04, ProcRenderRequire, OnFadeOutToGame, true);
end
-- Required Zogs fade in proc ---------------------------------------------- --
local function OnFadeInToRequired()
  -- Set required wait callbacks
  SetCallbacks(ProcLogicRequired, ProcRenderRequire);
end
-- Scene required assets loaded -------------------------------------------- --
local function OnRequireAssetsLoaded(aResources)
  -- Set pile of zogs texture
  texRequire = aResources[1];
  -- Set text to win label
  sTextToWin = "RAISE "..
    UtilFormatNumber(oLevelInfo.w.r + oGlobalData.gCapitalCarried, 0)..
    " ZOGS TO WIN";
  -- Fade in required scene
  Fade(1.0, 0.0, 0.04, ProcRenderRequire, OnFadeInToRequired);
end
-- Scene fade out proc ----------------------------------------------------- --
local function OnSceneFadedOut()
  -- Release scene asset
  texScene = nil;
  -- Load resources
  LoadResources("Scene Require "..oLevelInfo.n.."/"..iTerrainId,
    aAssetsRequire, OnRequireAssetsLoaded);
  -- Don't need terrain id value anymore
  iTerrainId = nil;
end
-- Waiting on scene graphic ------------------------------------------------ --
local function ProcLogicScene()
  -- Increment timer and don't do anything until 2 seconds
  iWaitCounter = iWaitCounter + 1;
  if iWaitCounter < 120 then return end;
  -- Set the gold scene
  Fade(0.0, 1.0, 0.04, ProcRenderScene, OnSceneFadedOut);
end
-- Fade in proc ------------------------------------------------------------ --
local function OnSceneFadedIn()
  -- Init wait timer
  iWaitCounter = 0;
  -- Set scene wait callbacks
  SetCallbacks(ProcLogicScene, ProcRenderScene);
end
-- On loaded function ------------------------------------------------------ --
local function OnSceneAssetsLoaded(aResources)
  -- Set scene textures
  texScene = aResources[1];
  -- Play scene music
  PlayMusic(aResources[2]);
  -- Fade in
  Fade(1.0, 0.0, 0.04, ProcRenderScene, OnSceneFadedIn);
end
-- Init scene function ----------------------------------------------------- --
local function InitScene(iZoneId)
  -- Set level number and get data for it.
  iLevelId = 1 + ((iZoneId - 1) % #aLevelsData);
  oLevelInfo = aLevelsData[iLevelId];
  -- Get level terrain information and set scene setter texture to load
  local oTerrain<const> = oLevelInfo.t;
  aAssetsScene[1].F = oTerrain.f.."ss";
  iTerrainId = oTerrain.n;
  -- Load resources
  LoadResources("Scene "..oLevelInfo.n.."/"..iTerrainId,
    aAssetsScene, OnSceneAssetsLoaded);
end
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Grab imports
  BlitLT, Fade, LoadLevel, LoadResources, PlayMusic, PrintC, SetCallbacks,
    oGlobalData, aLevelTypesData, aLevelsData, fontLarge =
      GetAPI("BlitLT", "Fade", "LoadLevel", "LoadResources", "PlayMusic",
        "PrintC", "SetCallbacks", "oGlobalData", "aLevelTypesData",
        "aLevelsData", "fontLarge");
  -- Setup assets
  local oAssetsData<const> = GetAPI("oAssetsData");
  aAssetsScene = { oAssetsData.scene, oAssetsData.scenem };
  aAssetsRequire = { oAssetsData.scenez };
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitScene = InitScene }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
