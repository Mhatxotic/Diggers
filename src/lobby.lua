-- LOBBY.LUA =============================================================== --
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
local error<const>, tostring<const>, unpack<const> =
  error, tostring, table.unpack;
-- M-Engine aliases (optimisation) ----------------------------------------- --
local CoreTicks<const>, UtilBlank<const>, UtilIsTable<const>,
  UtilIsBoolean<const>, UtilIsInteger<const> =
    Core.Ticks, Util.Blank, Util.IsTable, Util.IsBoolean, Util.IsInteger;
-- Diggers function and data aliases --------------------------------------- --
local BlitLT, BlitSLT, Fade, GameProc, GetActiveObject, InitBank, InitCon,
  InitContinueGame, InitScene, InitShop, InitTitle, LoadResources, PlayMusic,
  PlayStaticSound, Print, RegisterFBUCallback, RenderAll, RenderShadow,
  RenderTip, RenderTipShadow, SetCallbacks, SetHotSpot, SetKeys, SetTip,
  aGlobalData, fontSpeech;
-- Locals ------------------------------------------------------------------ --
local aActiveObject,                   -- Selected object when entering lobby
      aClosedAssetsMusic,              -- Out of game lobby with music
      aClosedAssetsNoMusic,            -- Out of game lobby with no music
      aOpenAssetsMusic,                -- In-game lobby with music
      aOpenAssetsNoMusic,              -- In-game lobby with no music
      fcbRenderExtra,                  -- Any extra rendering to be done
      iHotSpotClosedExitId,            -- Closed hotspot id (can exit)
      iHotSpotClosedNoExitId,          -- Closed hotspot id (cannot exit)
      iHotSpotClosedReadyId,           -- Closed hotspot id (can start)
      iHotSpotClosedSelectedId,        -- Closed hotspot active id
      iHotSpotOpenedId,                -- Opened hotspot id
      iKeyBankClosedExitId,            -- Closed key bank id (saved, can exit)
      iKeyBankClosedNoExitId,          -- Closed key bank id (no save, no exit)
      iKeyBankClosedReadyId,           -- Closed key bank id (can play zone)
      iKeyBankClosedSelectedId,        -- Closed key bank selected
      iKeyBankOpenedId,                -- Opened key bank id
      iSSelect,                        -- Select sound effect id
      iStageL, iStageR,                -- Stage bounds
      texLobby,                        -- Lobby texture
      texZmtc;                         -- Background texture
-- Register frame buffer update -------------------------------------------- --
local function OnStageUpdated(...)
  local _; _, _, iStageL, _, iStageR, _ = ...;
end
-- Lobby open render proc -------------------------------------------------- --
local function RenderOpen()
  -- Render game interface, backdrop, shadow and tip
  RenderAll();
  BlitLT(texLobby, 8, 8);
  RenderShadow(8, 8, 312, 208);
  -- Render fire
  local iFrame<const> = CoreTicks() % 9;
  if iFrame >= 6 then BlitSLT(texLobby, 1, 113, 74);
  elseif iFrame >= 3 then BlitSLT(texLobby, 2, 113, 74);
  else fcbRenderExtra() end;
  -- Render tip
  RenderTip();
end
-- Lobby closed render proc ------------------------------------------------ --
local function RenderClosed()
  -- Draw backdrop, lobby background and shadow around lobby
  BlitLT(texZmtc, -96, 0);
  RenderShadow(8, 8, 312, 208);
  BlitLT(texLobby, 8, 8);
  -- Render fire
  local iFrame<const> = CoreTicks() % 9;
  if iFrame >= 6 then BlitSLT(texLobby, 4, 113, 74);
  elseif iFrame >= 3 then BlitSLT(texLobby, 3, 113, 74);
  -- Flash if not ready to play
  else fcbRenderExtra() end;
  -- Draw foliage
  BlitSLT(texLobby, 1, iStageR-238, 184);
  BlitSLT(texLobby, 2, iStageL,      56);
  -- Render tip
  RenderTipShadow();
end
-- When closed lobby has faded in? Set lobby callbacks --------------------- --
local function OnFadedIn()
  -- Set requested closed hotspots
  SetHotSpot(iHotSpotClosedSelectedId);
  -- Set requested closed key bank keys
  SetKeys(true, iKeyBankClosedSelectedId);
  -- Set callbacks
  SetCallbacks(ProcClosed, RenderClosed);
end
-- Lobby loaded in game ---------------------------------------------------- --
local function OnLoadedOpened(aResources, bSetMusic, iSaveMusicPos)
  -- Play lobby music if requested
  if bSetMusic then PlayMusic(aResources[2], nil, iSaveMusicPos) end;
  -- Set lobby texture
  texLobby = aResources[1];
  -- Clear tip
  SetTip();
  -- Set opened hotspots
  SetHotSpot(iHotSpotOpenedId);
  -- Set opened key bank
  SetKeys(true, iKeyBankOpenedId);
  -- Change render procedures
  SetCallbacks(GameProc, RenderOpen);
end
-- Lobby loaded pre-game --------------------------------------------------- --
local function OnLoadedClosed(aResources, bSetMusic)
  -- Play lobby music if requested
  if bSetMusic then PlayMusic(aResources[3]) end;
  -- Set background and lobby texture
  texZmtc, texLobby = aResources[1], aResources[2];
  -- Clear tip
  SetTip();
  -- Register frame buffer update
  RegisterFBUCallback("lobby", OnStageUpdated);
  -- Set speech colour to white
  fontSpeech:SetCRGBAI(0xFFFFFFFF);
  -- Fade In a closed lobby
  Fade(1, 0, 0.04, RenderClosed, OnFadedIn);
end
-- Not ready callback ------------------------------------------------------ --
local function NotReadyCallback() Print(fontSpeech, 157, 115, "!") end;
-- Init lobby function ----------------------------------------------------- --
local function InitLobby(bNoSetMusic, iSaveMusicPos)
  -- Active object must be specified or omitted
  aActiveObject = GetActiveObject();
  if aActiveObject ~= nil and not UtilIsTable(aActiveObject) then
    error("Invalid object owner table! "..tostring(aActiveObject)) end;
  -- No set music flag can be nil set to false as a result
  if bNoSetMusic == nil then bNoSetMusic = false;
  -- Else if it's specified and it's not a boolean then show error
  elseif not UtilIsBoolean(bNoSetMusic) then
    error("Invalid set music flag! "..tostring(bNoSetMusic));
  -- Must specify position if bNoSetMusic is false
  elseif aActiveObject and not bNoSetMusic and
    not UtilIsInteger(iSaveMusicPos) then
      error("Invalid save pos id! "..tostring(iSaveMusicPos)); end;
  -- Resources to load
  local aAssets, fcbOnLoaded;
  -- In a game?
  if aActiveObject then
    -- In-game onloaded event
    fcbOnLoaded = OnLoadedOpened;
    -- Set resources depending on music requested
    if bNoSetMusic then aAssets = aOpenAssetsNoMusic;
                   else aAssets = aOpenAssetsMusic end;
    -- No extra rendering
    fcbRenderExtra = UtilBlank;
  -- Not in a game?
  else
    -- In-game onloaded event
    fcbOnLoaded = OnLoadedClosed;
    -- Set resources depending on music requested
    if bNoSetMusic then aAssets = aClosedAssetsNoMusic;
                   else aAssets = aClosedAssetsMusic end;
    -- If game is ready to play?
    if aGlobalData.gSelectedLevel ~= nil and
       aGlobalData.gSelectedRace ~= nil then
      -- Can exit to zone start hotspots
      iHotSpotClosedSelectedId = iHotSpotClosedReadyId;
      -- Player is allowed to begin the zone
      iKeyBankClosedSelectedId = iKeyBankClosedReadyId;
      -- Set exclamation mark callback
      fcbRenderExtra = UtilBlank;
    -- If game has been saved?
    elseif aGlobalData.gGameSaved then
      -- Can't exit hotspots
      iHotSpotClosedSelectedId = iHotSpotClosedExitId;
      -- Player is allowed to exit to the title screen
      iKeyBankClosedSelectedId = iKeyBankClosedExitId;
      -- No extra rendering
      fcbRenderExtra = NotReadyCallback;
    -- Player did not save the game?
    else
      -- Can't exit hotspots
      iHotSpotClosedSelectedId = iHotSpotClosedNoExitId;
      -- Can't exit key binds
      iKeyBankClosedSelectedId = iKeyBankClosedNoExitId;
      -- Set exclamation mark callback
      fcbRenderExtra = NotReadyCallback;
    end
  end
  -- Load closed lobby texture
  LoadResources("Lobby", aAssets, fcbOnLoaded, not bNoSetMusic, iSaveMusicPos);
end
-- Click when lobby is closed ---------------------------------------------- --
local function ExitClose(bFadeMusic, fcbCallback, ...)
  -- Remove frame buffer update event
  RegisterFBUCallback("lobby");
  -- Play sound and init the bank screen
  PlayStaticSound(iSSelect);
  -- Store parameters
  local aParams<const> = { ... };
  -- When faded out?
  local function OnFadeOutClosed()
    -- Call exit function with requested parameters
    fcbCallback(unpack(aParams));
    -- Dereference assets for the garbage collector
    texLobby, texZmtc = nil, nil;
  end
  -- Fade out to title screen
  return Fade(0, 1, 0.04, RenderClosed, OnFadeOutClosed, bFadeMusic);
end
-- Click when lobby is opened ---------------------------------------------- --
local function ExitOpen(fcbCallback, ...)
  -- Play sound and init the bank screen
  PlayStaticSound(iSSelect);
  -- Disable current hotspots and keys
  SetHotSpot();
  SetKeys(false);
  -- Start the loading waiting procedure
  SetCallbacks(GameProc, RenderAll);
  -- Load requested screen
  fcbCallback(...);
  -- Dereference assets for the garbage collector
  texLobby = nil;
end
-- On activate and hover event callbacks ----------------------------------- --
local function GoAbort() ExitClose(true, InitTitle) end;
local function GoBank() ExitOpen(InitBank) end;
local function GoClose() ExitOpen(InitContinueGame, true) end;
local function GoCntrl() ExitClose(false, InitCon) end;
local function GoShop() ExitOpen(InitShop) end;
local function GoStart()
  ExitClose(true, InitScene, aGlobalData.gSelectedLevel) end;
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, aAssetsData, aCursorIdData, aSfxData;
  -- Grab imports
  BlitLT, BlitSLT, Fade, GameProc, GetActiveObject, InitBank, InitCon,
    InitContinueGame, InitScene, InitShop, InitTitle, LoadResources, PlayMusic,
    PlayStaticSound, Print, RegisterFBUCallback, RegisterHotSpot, RegisterKeys,
    RenderAll, RenderShadow, RenderTip, RenderTipShadow, SetCallbacks,
    SetHotSpot, SetKeys, SetTip, aAssetsData, aCursorIdData, aGlobalData,
    aSfxData, fontSpeech =
      GetAPI("BlitLT", "BlitSLT", "Fade", "GameProc", "GetActiveObject",
        "InitBank", "InitCon", "InitContinueGame", "InitScene", "InitShop",
        "InitTitle", "LoadResources", "PlayMusic", "PlayStaticSound", "Print",
        "RegisterFBUCallback", "RegisterHotSpot", "RegisterKeys",
        "RenderAll", "RenderShadow", "RenderTip", "RenderTipShadow",
        "SetCallbacks", "SetHotSpot", "SetKeys", "SetTip", "aAssetsData",
        "aCursorIdData", "aGlobalData", "aSfxData", "fontSpeech");
  -- Prepare assets
  local aMusicAsset<const> = aAssetsData.lobbym;
  local aClosedTexture<const> = aAssetsData.lobbyc;
  local aZmtcTexture<const> = aAssetsData.zmtc;
  aClosedAssetsNoMusic = { aZmtcTexture, aClosedTexture };
  aClosedAssetsMusic = { aZmtcTexture, aClosedTexture, aMusicAsset };
  local aOpenTexture<const> = aAssetsData.lobbyo;
  aOpenAssetsNoMusic = { aOpenTexture };
  aOpenAssetsMusic = { aOpenTexture, aMusicAsset };
  -- Set sound effect ids
  iSSelect = aSfxData.SELECT;
  -- Set cursor ids
  local iCOK<const>, iCSelect<const>, iCExit<const>, iCArrow<const> =
    aCursorIdData.OK, aCursorIdData.SELECT, aCursorIdData.EXIT,
    aCursorIdData.ARROW;
  -- Frequently used hotspots
  local aControllerHotSpot<const>, aHotSpot<const> =
    { 151, 124,  13,  13, 0, iCSelect, "CONTROLLER", false, GoCntrl },
    {   8,   8, 304, 200, 0, iCArrow,  "LOBBY",      false, false   };
  -- Register closed (can start) lobby hotspots
  iHotSpotClosedReadyId = RegisterHotSpot({ aControllerHotSpot, aHotSpot,
    { 0, 0, 0, 240, 3, iCExit, "START GAME", false, GoStart } });
  -- Register closed (can exit) lobby hotspots
  iHotSpotClosedExitId = RegisterHotSpot({ aControllerHotSpot, aHotSpot,
    { 0, 0, 0, 240, 3, iCExit, "ABORT GAME", false, GoAbort } });
  -- Register closed (cannot exit) lobby hotspots
  iHotSpotClosedNoExitId =
    RegisterHotSpot({ aControllerHotSpot, aHotSpot });
  -- Register open lobby hotspots
  iHotSpotOpenedId = RegisterHotSpot({
    {  74,  87,  29,  17, 0, iCSelect, "BANK",     false, GoBank  },
    { 217,  87,  29,  17, 0, iCSelect, "SHOP",     false, GoShop  },
    aHotSpot,
    {   0,   0,   0, 240, 3, iCExit,   "CONTINUE", false, GoClose }
  });
  -- Prepare key bind registration
  local aKeys<const>, aStates<const> = Input.KeyCodes, Input.States;
  local iEscape<const> = aKeys.ESCAPE;
  local iPress<const> = aStates.PRESS;
  local sName<const> = "ZMTC LOBBY";
  -- Register open lobby keybanks
  iKeyBankOpenedId = RegisterKeys(sName, { [iPress] = {
    { aKeys.B, GoBank,  "zmtclb",  "BANK"          },
    { aKeys.S, GoShop,  "zmtcls",  "SHOP"          },
    { iEscape, GoClose, "zmtclcg", "CONTINUE GAME" }
  } } );
  -- Controller bind
  local aController<const> = { aKeys.ENTER, GoCntrl, "zmtclc", "CONTROLLER" };
  -- Register closed lobby keybanks
  iKeyBankClosedExitId = RegisterKeys(sName, { [iPress] = { aController,
    { iEscape, GoAbort, "zmtclatg", "ABORT THE GAME" } } });
  iKeyBankClosedNoExitId = RegisterKeys(sName, { [iPress] = { aController } });
  iKeyBankClosedReadyId = RegisterKeys(sName, { [iPress] = { aController,
    { iEscape, GoStart, "zmtclstg", "START THE GAME" } } });
end
-- Exports and imports------------------------------------------------------ --
return { A = { InitLobby = InitLobby }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
