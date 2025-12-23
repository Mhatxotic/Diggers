-- POST.LUA ================================================================ --
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
-- Engine function aliases ------------------------------------------------- --
local UtilTableSize<const>, UtilIsInteger<const> =
  Util.TableSize, Util.IsInteger;
-- Diggers function and data aliases --------------------------------------- --
local BlitSLT, AdjustViewportX, AdjustViewportY, AdjustViewportNoScroll,
  DeInitLevel, Fade, GetAbsMousePos, InitEnding, InitFail, InitLobby,
  IsMouseXGreaterEqualThan, IsMouseXLessThan, IsMouseYGreaterEqualThan,
  IsMouseYLessThan, IsSpriteCollide, LoadResources, PlayMusic, PlayStaticSound,
  PrintC, RegisterFBUCallback, RenderFade, RenderObjects, RenderTerrain,
  SelectObject, SetCallbacks, SetCursor, SetHotSpot, SetKeys, oGlobalData,
  aLevelsData, aObjectFlags, aObjs, fontSpeech;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Required assets
      iCLeft, iCRight, iCTop, iCExit,  -- Cursor ids
      iCBottom, iCWait, iCArrow,       -- More cursor ids
      iHotSpotId,                      -- Hot spot id
      iKeyBankId,                      -- Key bank to monitor keypresses
      iObject,                         -- Current object
      iStageLmove, iStageRmove,        -- Mouse scrolling positions
      iSSelect, iSClick,               -- Sound effect ids
      nFade,                           -- Transition fade amount
      sObject;                         -- Object selected text
local sObjectDefault<const> = "MAP POST MORTEM";
local texEnd;                          -- Post mortem textures
-- Post mortem render ------------------------------------------------------ --
local function ProcRenderPostMortem()
  -- Render terrain and objects
  RenderTerrain();
  RenderObjects();
  -- Render post mortem banner and text
  BlitSLT(texEnd, 4, 8.0, 208.0);
  fontSpeech:SetCRGB(0.0, 0.0, 0.25);
  PrintC(fontSpeech, 160.0, 215.0, sObject);
end
-- On frame buffer updated ------------------------------------------------- --
local function OnStageUpdated(...)
  -- Update stage bounds
  local _, _, iStageL, _, iStageR, _ = ...;
  -- Update horizontal scrolling positions
  iStageLmove, iStageRmove = iStageL + 16, iStageR - 16;
end
-- When fade has completed? ------------------------------------------------ --
local function OnFadedOutToLobby()
  -- Unregister from frame buffer update
  RegisterFBUCallback("post");
  -- De-initialise the level
  DeInitLevel();
  -- Dereference assets for garbage collection
  texEnd = nil;
  -- Current level completed and clear new game and selected level status
  oGlobalData.gLevelsCompleted[oGlobalData.gSelectedLevel] = true;
  oGlobalData.gSelectedLevel, oGlobalData.gNewGame = nil, nil;
  -- Bank balance reached? Show good ending if bank balance reached
  if oGlobalData.gBankBalance >= oGlobalData.gZogsToWinGame then
    return InitEnding(oGlobalData.gSelectedRace) end;
  -- Count number of levels completed and if all levels
  -- completed? Show bad ending :(
  local iNumCompleted<const> = UtilTableSize(oGlobalData.gLevelsCompleted);
  if iNumCompleted >= #aLevelsData then return InitFail() end;
  -- More levels to play so go back to the lobby.
  oGlobalData.gGameSaved = false;
  InitLobby();
end
-- Fade out to lobby ------------------------------------------------------- --
local function GoFinish()
  -- Play button select sound
  PlayStaticSound(iSSelect);
  -- Start fading out
  Fade(0.0, 1.0, 0.04, ProcRenderPostMortem, OnFadedOutToLobby, true);
end
-- Set specific object ----------------------------------------------------- --
local function SetObject(iNewObj)
  -- Don't do anything if no objects
  if #aObjs == 0 then return end;
  -- Play click sound
  PlayStaticSound(iSClick);
  -- Set new object value
  iObject = iNewObj;
  -- Modulo it if it's out of range
  if iObject < 1 or iObject > #aObjs then
    iObject = 1 + ((iObject - 1) % #aObjs) end;
  -- Focus on the object even with the mouse cursor
  local oObj<const> = aObjs[iObject];
  SelectObject(oObj, true, true);
end
-- Cycle between objects --------------------------------------------------- --
local function GoNextObject() SetObject(iObject + 1) end;
local function GoPreviousObject() SetObject(iObject - 1) end;
-- Scroll the map ---------------------------------------------------------- --
local function GoScrollUp() AdjustViewportY(-16) end;
local function GoScrollDown() AdjustViewportY(16) end;
local function GoScrollLeft() AdjustViewportX(-16) end;
local function GoScrollRight() AdjustViewportX(16) end;
-- On hover ---------------------------------------------------------------- --
local function OnHover()
  -- Cursor at top edge of screen?
  if IsMouseXLessThan(iStageLmove) then SetCursor(iCLeft);
  -- Cursor at right edge of screen?
  elseif IsMouseXGreaterEqualThan(iStageRmove) then SetCursor(iCRight);
  -- Cursor at left edge of screen?
  elseif IsMouseYLessThan(16) then SetCursor(iCTop);
  -- Cursor over exit point?
  elseif IsMouseYGreaterEqualThan(224) then SetCursor(iCExit);
  -- Cursor over edge of bottom?
  elseif IsMouseYGreaterEqualThan(192) then SetCursor(iCBottom);
  -- Cursor in middle of screen
  else
    -- Get absolute mouse position on level
    local iAMX<const>, iAMY<const> = GetAbsMousePos();
    -- Walk through objects
    for iIndex = 1, #aObjs do
      -- Get object data and if cursor overlapping it ?
      local oObj<const> = aObjs[iIndex];
      if IsSpriteCollide(479, iAMX, iAMY, oObj.S, oObj.X, oObj.Y) then
        -- Set tip with name and health of object
        sObject = (oObj.OD.LONGNAME or oObj.OD.NAME)..
          " ("..oObj.H.."%)";
        -- Done
        return;
      end
    end
    -- Set generic message
    sObject = sObjectDefault;
  end
end
-- On scroll --------------------------------------------------------------- --
local function OnScroll(nX, nY)
  -- Mouse wheel is scrolling up? Goto previous object
  if nY > 0.0 then GoPreviousObject();
  -- Mouse wheel is scrolling down? Goto next object
  elseif nY < 0.0 then GoNextObject() end;
end
-- On mouse released (remove logic function) ------------------------------- --
local function OnRelease() SetCallbacks(nil, ProcRenderPostMortem) end;
-- Cursor drag event ------------------------------------------------------- --
local function OnDrag(_, _, _, iMoveX, iMoveY)
  -- Move the level to how the mouse is dragging
  AdjustViewportNoScroll(iMoveX, iMoveY);
  -- Keep arrow shown
  SetCursor(iCArrow)
end
-- On mouse pressed -------------------------------------------------------- --
local function OnPress()
  -- Mouse pressed over  top edge of screen?
  if IsMouseXLessThan(iStageLmove) then
    SetCallbacks(GoScrollLeft, ProcRenderPostMortem);
  -- Mouse pressed over right edge of screen?
  elseif IsMouseXGreaterEqualThan(iStageRmove) then
    SetCallbacks(GoScrollRight, ProcRenderPostMortem);
  -- Mouse pressed over left edge of screen?
  elseif IsMouseYLessThan(16) then
    SetCallbacks(GoScrollUp, ProcRenderPostMortem);
  -- Mouse pressed over exit point?
  elseif IsMouseYGreaterEqualThan(224) then GoFinish();
  -- Mouse pressed over edge of bottom?
  elseif IsMouseYGreaterEqualThan(192) then
    SetCallbacks(GoScrollDown, ProcRenderPostMortem);
  end
end
-- Proc fade in ------------------------------------------------------------ --
local function LogicAnimatedPostMortem()
  -- Fade in elements and return until zero
  if nFade > 0.0 then nFade = nFade - 0.01 return end;
  -- Clamp fade to fully transparent
  nFade = 0.0;
  -- Enable post mortem keys and hotspots
  SetKeys(true, iKeyBankId);
  SetHotSpot(iHotSpotId);
  -- Set no object id
  iObject = 0;
  -- Set post mortem procedure
  SetCallbacks(nil, ProcRenderPostMortem);
end
-- Render fade in ---------------------------------------------------------- --
local function RenderAnimatedPostMortem()
  -- Render terrain and objects
  RenderTerrain();
  RenderObjects();
  -- Render fade in
  RenderFade(nFade);
  -- Render post mortem banner and text
  local nAdj<const> = nFade * 128.0;
  BlitSLT(texEnd, 4, 8.0, 208.0 + nAdj);
  fontSpeech:SetCRGB(0.0, 0.0, 0.25);
  PrintC(fontSpeech, 160.0, 215.0 + nAdj, sObject);
end
-- When post mortem assets are loaded? ------------------------------------- --
local function OnAssetsLoaded(aResources)
  -- Register frame buffer update
  RegisterFBUCallback("post", OnStageUpdated);
  -- Get post mortem texture
  texEnd = aResources[1];
  -- Loop End music
  PlayMusic(aResources[2], nil, nil, nil, 371767);
  -- Object hovered over by mouse
  sObject = sObjectDefault
  -- Fade in counter
  nFade = 0.5;
  -- Set post mortem procedure
  SetCallbacks(LogicAnimatedPostMortem, RenderAnimatedPostMortem);
end
-- Initialise the lose screen ---------------------------------------------- --
local function InitPost(iLId)
  LoadResources("Post Mortem", aAssets, OnAssetsLoaded);
end
-- When the script has loaded ---------------------------------------------- --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, oAssetsData, oCursorIdData, oSfxData;
  -- Imports
  AdjustViewportX, AdjustViewportY, AdjustViewportNoScroll, BlitSLT,
    DeInitLevel, Fade, GetAbsMousePos, InitEnding, InitFail, InitLobby,
    IsMouseXGreaterEqualThan, IsMouseXLessThan, IsMouseYGreaterEqualThan,
    IsMouseYLessThan, IsSpriteCollide, LoadResources, PlayMusic,
    PlayStaticSound, PrintC, RegisterFBUCallback, RegisterHotSpot,
    RegisterKeys, RenderFade, RenderObjects, RenderTerrain, SelectObject,
    SetCallbacks, SetCursor, SetHotSpot, SetKeys, oAssetsData, oCursorIdData,
    oGlobalData, aLevelsData, aObjectFlags, aObjs, oSfxData, fontSpeech =
      GetAPI("AdjustViewportX", "AdjustViewportY", "AdjustViewportNoScroll",
        "BlitSLT", "DeInitLevel", "Fade", "GetAbsMousePos", "InitEnding",
        "InitFail", "InitLobby", "IsMouseXGreaterEqualThan",
        "IsMouseXLessThan", "IsMouseYGreaterEqualThan", "IsMouseYLessThan",
        "IsSpriteCollide", "LoadResources", "PlayMusic", "PlayStaticSound",
        "PrintC", "RegisterFBUCallback", "RegisterHotSpot", "RegisterKeys",
        "RenderFade", "RenderObjects", "RenderTerrain", "SelectObject",
        "SetCallbacks", "SetCursor", "SetHotSpot", "SetKeys", "oAssetsData",
        "oCursorIdData", "oGlobalData", "aLevelsData", "aObjectFlags", "aObjs",
        "oSfxData", "fontSpeech");
  -- Setup required assets
  aAssets = { oAssetsData.post, oAssetsData.postm };
  -- Register keybinds
  local oKeys<const>, oStates<const> = Input.KeyCodes, Input.States;
  local aScrUp<const>, aScrDown<const>, aScrLeft<const>, aScrRight<const> =
    { oKeys.UP,    GoScrollUp,    "igpmsmu", "SCROLL MAP UP"    },
    { oKeys.DOWN,  GoScrollDown,  "igpmsmd", "SCROLL MAP DOWN"  },
    { oKeys.LEFT,  GoScrollLeft,  "igpmsml", "SCROLL MAP LEFT"  },
    { oKeys.RIGHT, GoScrollRight, "igpmsmr", "SCROLL MAP RIGHT" };
  iKeyBankId = RegisterKeys("IN-GAME POST MORTEM", {
    [oStates.PRESS] = {
      { oKeys.ESCAPE, GoFinish,         "igpmc",  "CLOSE" },
      { oKeys.MINUS,  GoPreviousObject, "igpmop", "PREVIOUS" },
      { oKeys.EQUAL,  GoNextObject,     "igpmon", "NEXT" },
      aScrUp, aScrDown, aScrLeft, aScrRight
    }, [oStates.REPEAT] = { aScrUp, aScrDown, aScrLeft, aScrRight },
  });
  -- Set hot spot
  iHotSpotId = RegisterHotSpot({
    { 0, 0, 0, 240, 3, 0, OnHover, OnScroll, { OnRelease, OnPress, OnDrag } }
  });
  -- Set cursor ids
  iCLeft, iCRight, iCTop, iCBottom, iCWait, iCArrow, iCExit =
    oCursorIdData.LEFT, oCursorIdData.RIGHT, oCursorIdData.TOP,
      oCursorIdData.BOTTOM, oCursorIdData.WAIT, oCursorIdData.ARROW,
      oCursorIdData.EXIT;
  -- Set sound effect ids
  iSSelect, iSClick = oSfxData.SELECT, oSfxData.CLICK;
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitPost = InitPost }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
