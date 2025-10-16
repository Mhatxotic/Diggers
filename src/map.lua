-- MAP.LUA ================================================================= --
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
local pairs<const>, floor<const> = pairs, math.floor;
-- Engine function aliases ------------------------------------------------- --
local CoreTicks<const>, UtilClampInt<const>, UtilFormatNumber<const>,
  UtilIsNumber<const>, UtilIsTable<const> = Core.Ticks, Util.ClampInt,
    Util.FormatNumber, Util.IsNumber, Util.IsTable;
-- Diggers function and data aliases --------------------------------------- --
local BlitSLT, BlitLT, Fade, GetMouseX, GetMouseY, InitCon, InitLobby,
  IsMouseXGreaterEqualThan, IsMouseXLessThan,  IsMouseYGreaterEqualThan,
  IsMouseYLessThan, LoadResources, PlayStaticSound, RegisterFBUCallback,
  RenderTipShadow, SetCallbacks, SetCursor, SetCursorPos, SetHotSpot, SetKeys,
  SetTip, oGlobalData, aLevelsData, aZoneData;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Assets required
      aSelectedZone,                   -- Currently selected zone
      aZoneAvail,                      -- Zones available
      aZoneCache, aFlagCache,          -- Zone hot points and completion cache
      iActionTimer,                    -- Action timer for tooltip
      iCBottom, iCSelect, iCArrow,     -- More cursor ids
      iCLeft, iCRight, iCTop, iCExit,  -- Cursor ids
      iHotSpotId,                      -- Hot spot id for cursor
      iHoverZone,                      -- Currently hovered over zone id
      iKeyBankId;                      -- Key bank id for keys
local iMapSizeX<const>,                -- Map size pixel width
      iMapSizeY<const> = 640, 350;     -- Map size pixel height
local iSClick, iSSelect,               -- Sound effect ids
      iStageL, iStageT, iStageR,       -- Stage upper-left co-ordinates
      iStageW, iStageH,                -- Stage width and height
      iStageLneg, iStageTneg,          -- Negatated upper-left stage co-ords
      iStageLmove, iStageRmove;        -- Mouse scrolling positions
local iZoneScroll;                     -- Zone button scrolling id
local iZoneMaxX, iZoneMaxY;            -- Maximum map bounds
local iZonePosX, iZonePosY = 0, 0;     -- Map scroll position (persists)
local oHoverData;                      -- Selected zone
local texZone;                         -- Zone map graphics texture
-- Set specific object ----------------------------------------------------- --
local function SetZone(iAdjust)
  -- Don't do anything if no objects
  if #aZoneAvail == 0 then return end;
  -- Play sound
  PlayStaticSound(iSClick);
  -- Set new zone wrapping out of bounds so it stays in bounds
  iZoneScroll = 1 + (((iZoneScroll + iAdjust) - 1) % #aZoneAvail) ;
  -- Get zone data and move to an actual zone that isn't completed
  local aZone<const> = aZoneData[aZoneAvail[iZoneScroll]];
  -- Centre map on zone point
  iZonePosX = UtilClampInt(aZone[1] - 160, 0, iZoneMaxX);
  iZonePosY = UtilClampInt(aZone[2] - 120, 0, iZoneMaxY);
  -- Set the new cursor position
  SetCursorPos(aZone[6] - (iZonePosX - iStageL),
               aZone[7] - (iZonePosY - iStageT));
end
-- Cycle between zones ----------------------------------------------------- --
local function GoNextZone() SetZone(1) end;
local function GoPreviousZone() SetZone(-1) end;
-- Render the map ---------------------------------------------------------- --
local function RenderMap()
  -- Draw main chunk of map
  BlitLT(texZone, -iZonePosX + iStageL, -iZonePosY + iStageT);
  -- For each flag data in flag cache
  for iFlagId = 1, #aFlagCache do
    -- Get flag data and draw the flag to say the level was completed
    local aFlagData<const> = aFlagCache[iFlagId];
    BlitSLT(texZone, 1, aFlagData[1] - (iZonePosX + iStageLneg),
                        aFlagData[2] - (iZonePosY + iStageTneg));
  end
  -- Draw an icon for the zone that is selected
  if aSelectedZone then
    BlitSLT(texZone, 2, aSelectedZone[1] - (iZonePosX + iStageLneg),
                        aSelectedZone[2] - (iZonePosY + iStageTneg));
  end
  -- Draw tip
  RenderTipShadow();
end
-- Set main tick procedure ------------------------------------------------- --
local function SetTick(fcbFunc) SetCallbacks(fcbFunc, RenderMap) end;
-- Functions to execute for action timer ----------------------------------- --
local oActionData<const> = {
  [  1] = function() SetTip(oHoverData.n) end,
  [ 60] = function() SetTip(oHoverData.t.n) end,
  [120] = function()
    SetTip(UtilFormatNumber(oHoverData.w.r, 0).." TO WIN") end,
  [180] = function() SetTip(oHoverData.w.n) end,
  [240] = function() SetTip("ZONE "..iHoverZone.."/"..#aZoneData) end,
  [300] = function() iActionTimer = 0 end
}
-- Hovered over zone tick function ----------------------------------------- --
local function ProcZoneHover()
  -- Increase action timer, match callback and run it
  iActionTimer = iActionTimer + 1;
  local fcbActionCallback<const> = oActionData[iActionTimer];
  if fcbActionCallback then fcbActionCallback() end;
end
-- Common function for selecting a new point of interest ------------------- --
local function OnHoverGeneric(iCId, iCmd, sTip, bTick)
  -- Zone no longer selected
  iHoverZone = 0;
  -- Set requested cursor
  SetCursor(iCId);
  -- Unset tick if not a command number
  if not UtilIsNumber(oHoverData) then SetTick() end;
  -- Update command for click
  oHoverData = iCmd;
  -- Set tip
  SetTip(sTip);
end
-- When mouse is hovered over the exit? ------------------------------------ --
local function OnHoverExit() OnHoverGeneric(iCExit, 0, "CONTROLLER") end;
-- Cursor moved event ------------------------------------------------------ --
local function OnHover()
  -- Cursor at left edge of screen?
  if IsMouseXLessThan(iStageLmove) then
    -- Map at left edge?
    if iZonePosX > 0 then OnHoverGeneric(iCLeft, 1, "SCROLL LEFT");
    -- Not at left edge so chance to exit without selecting
    else OnHoverExit() end;
    -- Done
    return;
  end
  -- Cursor at right edge of screen?
  if IsMouseXGreaterEqualThan(iStageRmove) then
    -- Map at right edge?
    if iZonePosX < iZoneMaxX then OnHoverGeneric(iCRight, 2, "SCROLL RIGHT");
    -- Not at right edge so chance to exit without selecting
    else OnHoverExit() end;
    -- Done
    return;
  end
  -- Cursor at top edge of screen?
  if IsMouseYLessThan(16) then
    -- Map at top edge?
    if iZonePosY > 0 then OnHoverGeneric(iCTop, 3, "SCROLL UP");
    -- Not at top edge so chance to exit without selecting
    else OnHoverExit() end;
    -- Done
    return;
  end
  -- Cursor at bottom edge of screen?
  if IsMouseYGreaterEqualThan(224) then
    -- Map at bottom edge?
    if iZonePosY < iZoneMaxY then OnHoverGeneric(iCBottom, 4, "SCROLL DOWN");
    -- Not at bottom edge so chance to exit without selecting
    else OnHoverExit() end;
    -- Done
    return;
  end
  -- Get mouse position on whole map adjusted by current map scroll
  local iX<const> = GetMouseX() + iZonePosX + iStageLneg;
  local iY<const> = GetMouseY() + iZonePosY;
  -- For each map data available
  for iZoneId = 1, #aZoneData do
    -- Get map data and if mouse cursor inside zone boundary?
    local aZoneItem<const> = aZoneData[iZoneId];
    if iX >= aZoneItem[1] and iY >= aZoneItem[2] and
       iX <  aZoneItem[3] and iY <  aZoneItem[4] then
      -- Get cache'd info of zone and if zone is not completed?
      local iNewZone<const> = aZoneCache[iZoneId];
      if iNewZone then
        -- Set selection cursor
        SetCursor(iCSelect);
        -- Stop scrolling
        SetTick(ProcZoneHover);
        -- Different?
        if iNewZone ~= iHoverZone then
          -- Set new zone selected
          iHoverZone = iNewZone;
          -- Reset action timer for tip
          iActionTimer = 0;
          -- Set selected level
          oHoverData = aLevelsData[iHoverZone];
        end
        -- Got a zone
        return;
      end
      -- Matched a hot zone
      break;
    end
  end
  -- Clear active entry
  OnHoverGeneric(iCArrow, nil, "SELECT ZONE");
end
-- Cursor released event to reset main tick and check hot spots ------------ --
local function OnRelease() SetTick() OnHover() end;
-- Adjust map view X and check hot spots ----------------------------------- --
local function AdjustMapViewX(iX)
  iZonePosX = UtilClampInt(iZonePosX + iX, 0, iZoneMaxX);
end
-- Adjust map view Y and check hot spots ----------------------------------- --
local function AdjustMapViewY(iY)
  iZonePosY = UtilClampInt(iZonePosY + iY, 0, iZoneMaxY);
end
-- On frame buffer updated ------------------------------------------------- --
local function OnStageUpdated(...)
  -- Update stage bounds
  iStageW, iStageH, iStageL, iStageT, iStageR = ...;
  -- Get negated stage left co-ordinate
  iStageLneg, iStageTneg = -iStageL, -iStageT;
  -- Update maximums
  iZoneMaxX, iZoneMaxY = 320 + (iStageL * 2), 110 + (iStageT * 2);
  -- Scrolling positions
  iStageLmove, iStageRmove = iStageL + 16, iStageR - 16;
  iZonePosX = UtilClampInt(iZonePosX - 8, 0, iZoneMaxX);
  -- Clamp current co-ordinates
  AdjustMapViewX(0);
  AdjustMapViewY(0);
  -- The mouse could be over something else now so clear selections
  oHoverData = 0;
  OnHoverGeneric(iCArrow, nil, nil);
end
-- When screen has faded out ----------------------------------------------- --
local function OnFadedOutToController()
  -- Remove FBO update callback
  RegisterFBUCallback("map");
  -- Dereference assets to garbage collector
  texZone = nil;
  -- Init controller screen
  InitCon();
end
-- Play sound and start fading out to controller --------------------------- --
local function GoFadeController()
  PlayStaticSound(iSSelect);
  Fade(0.0, 1.0, 0.04, RenderMap, OnFadedOutToController);
end
-- Set selected zone and transition to controller -------------------------- --
local function FinishAndAccept()
  oGlobalData.gSelectedLevel = iHoverZone;
  aSelectedZone = aZoneData[iHoverZone][8];
  GoFadeController();
end
-- Check zone selected then accept ----------------------------------------- --
local function GoFinishAndAcceptCheck()
  if iHoverZone then FinishAndAccept() end end
-- Mouse wheel scroll event to scroll around available zones --------------- --
local function OnScroll(nX, nY)
  if nY < 0 then GoNextZone() elseif nY > 0 then GoPreviousZone() end;
end
-- Scrolling functions ----------------------------------------------------- --
local function GoScrollLeft() AdjustMapViewX(-8) OnHover() end;
local function GoScrollRight() AdjustMapViewX(8) OnHover() end;
local function GoScrollUp() AdjustMapViewY(-8) OnHover() end;
local function GoScrollDown() AdjustMapViewY(8) OnHover() end;
-- Cursor drag event ------------------------------------------------------- --
local function OnDrag(_, _, _, iMoveX, iMoveY)
  -- Move the map to how the mouse is dragging
  AdjustMapViewX(-iMoveX);
  AdjustMapViewY(-iMoveY);
  -- Keep arrow shown
  SetCursor(iCArrow)
end
-- Cursor pressed event ---------------------------------------------------- --
local function OnPress()
  -- Ignore if nothing pressed or left button not pressed
  if not oHoverData then return;
  -- If a zone is selected then accept the level and fade out to lobby
  elseif UtilIsTable(oHoverData) then FinishAndAccept();
  -- If mouse is over the exit then cancel back to lobby
  elseif 0 == oHoverData then GoFadeController();
  elseif 1 == oHoverData then SetTick(GoScrollLeft);
  elseif 2 == oHoverData then SetTick(GoScrollRight);
  elseif 3 == oHoverData then SetTick(GoScrollUp);
  elseif 4 == oHoverData then SetTick(GoScrollDown) end;
end
-- On map faded in --------------------------------------------------------- --
local function OnMapFadedIn()
  -- Set key bank and hot spot
  SetKeys(true, iKeyBankId);
  SetHotSpot(iHotSpotId);
end
-- On loaded --------------------------------------------------------------- --
local function OnAssetsLoaded(aResources)
  -- Set texture handles
  texZone = aResources[1];
  -- Clear zone and flag cache
  aZoneCache, aFlagCache, aZoneAvail = { }, { }, { };
  -- Levels completed
  local aLevelsCompleted<const> = oGlobalData.gLevelsCompleted;
  -- Rebuild flag data cache
  for iZoneId in pairs(aLevelsCompleted) do
    aFlagCache[1 + #aFlagCache] = aZoneData[iZoneId][8];
  end
  -- Rebuild zone data cache
  for iZoneId = 1, #aZoneData do
    local aZoneItem<const> = aZoneData[iZoneId];
    local iZoneCompleted;
    if not aLevelsCompleted[iZoneId] then
      local aDep<const> = aZoneItem[5];
      if #aDep ~= 0 then
        for iDepId = 1, #aDep do
          local iDepZone<const> = aDep[iDepId];
          if aLevelsCompleted[iDepZone] then
            iZoneCompleted = iZoneId;
            break;
          end
        end
      else iZoneCompleted = iZoneId end;
    end
    -- Set completed or not
    if iZoneCompleted then
      aZoneCache[1 + #aZoneCache] = iZoneCompleted;
      aZoneAvail[1 + #aZoneAvail] = iZoneCompleted;
    else
      aZoneCache[1 + #aZoneCache] = false;
    end
  end
  -- SetHotSpot() calls OnHover() so for the tooltip to appear properly when
  -- a zone is already hovered over, we need to reset the hovered zone id.
  iHoverZone = 0;
  -- If a zone is selected
  local iSelectedZone<const> = oGlobalData.gSelectedLevel;
  if iSelectedZone then aSelectedZone = aZoneData[iSelectedZone][8];
                   else aSelectedZone = nil end;
  -- Set button scrolling id
  iZoneScroll = iSelectedZone or 0;
  -- Register frame buffer update
  RegisterFBUCallback("map", OnStageUpdated);
  -- Change render procedures
  Fade(1.0, 0.0, 0.04, RenderMap, OnMapFadedIn);
end
-- Init zone selection screen function ------------------------------------- --
local function InitMap()
  -- Load texture resource
  LoadResources("Map", aAssets, OnAssetsLoaded);
end
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, oAssetsData, oCursorIdData, oSfxData;
  -- Grab imports
  BlitSLT, BlitLT, Fade, GetMouseX, GetMouseY, InitCon, InitLobby,
    IsMouseXGreaterEqualThan, IsMouseXLessThan, IsMouseYGreaterEqualThan,
    IsMouseYLessThan, LoadResources, PlayStaticSound, RegisterFBUCallback,
    RegisterHotSpot, RegisterKeys, RenderTipShadow, SetCallbacks, SetCursor,
    SetCursorPos, SetHotSpot, SetKeys, SetTip, oAssetsData, oCursorIdData,
    oGlobalData, aLevelsData, oSfxData, aZoneData =
      GetAPI("BlitSLT", "BlitLT", "Fade", "GetMouseX", "GetMouseY", "InitCon",
        "InitLobby", "IsMouseXGreaterEqualThan", "IsMouseXLessThan",
        "IsMouseYGreaterEqualThan", "IsMouseYLessThan", "LoadResources",
        "PlayStaticSound", "RegisterFBUCallback", "RegisterHotSpot",
        "RegisterKeys", "RenderTipShadow", "SetCallbacks", "SetCursor",
        "SetCursorPos", "SetHotSpot", "SetKeys", "SetTip", "oAssetsData",
        "oCursorIdData", "oGlobalData", "aLevelsData", "oSfxData",
        "aZoneData");
  -- Set assets data
  aAssets = { oAssetsData.map };
  -- Register keybinds
  local oKeys<const> = Input.KeyCodes;
  local aScrollU<const>, aScrollD<const>, aScrollL<const>, aScrollR<const> =
    { oKeys.UP,     GoScrollUp,    "zmtczsu", "SCROLL MAP UP"    },
    { oKeys.DOWN,   GoScrollDown,  "zmtczsd", "SCROLL MAP DOWN"  },
    { oKeys.LEFT,   GoScrollLeft,  "zmtczsl", "SCROLL MAP LEFT"  },
    { oKeys.RIGHT,  GoScrollRight, "zmtczsr", "SCROLL MAP RIGHT" };
  local oStates<const> = Input.States;
  iKeyBankId = RegisterKeys("ZMTC ZONE SELECT", {
    [oStates.PRESS] = {
      { oKeys.ESCAPE, GoFadeController,       "zmtczsc", "GO TO CONTROLLER" },
      { oKeys.ENTER,  GoFinishAndAcceptCheck, "zmtczsa", "ACCEPT ZONE"      },
      { oKeys.MINUS,  GoPreviousZone,         "zmtczpz", "PREVIOUS ZONE"    },
      { oKeys.EQUAL,  GoNextZone,             "zmtcznz", "NEXT ZONE"        },
      aScrollU, aScrollD, aScrollL, aScrollR
    }, [oStates.REPEAT] = {
      aScrollU, aScrollD, aScrollL, aScrollR
    }
  });
  -- Set cursor ids
  iCLeft, iCRight, iCTop, iCBottom, iCSelect, iCArrow, iCExit =
    oCursorIdData.LEFT, oCursorIdData.RIGHT, oCursorIdData.TOP,
      oCursorIdData.BOTTOM, oCursorIdData.SELECT, oCursorIdData.ARROW,
      oCursorIdData.EXIT;
  -- Set sound effect ids
  iSSelect, iSClick = oSfxData.SELECT, oSfxData.CLICK;
  -- Add centre positions for zone data
  for iIndex = 1, #aZoneData do
    -- Get zone data, calculate and set centre position
    local aZone<const> = aZoneData[iIndex];
    local iX<const>, iY<const> = aZone[1], aZone[2];
    local iCX<const>, iCY<const> =
      iX + ((aZone[3] - iX) // 2), iY + ((aZone[4] - iY) // 2);
    aZone[6], aZone[7] = iCX, iCY;
    -- Calculate flag position
    aZone[8] = { iCX - 16, iCY - 16, iCX + 16, iCY + 16 };
  end
  -- Setup hot spots. This scene is complicated with dynamically changing
  -- points of interest so we won't be directly using them.
  iHotSpotId = RegisterHotSpot({
    { 0, 0, 0, 240, 3, 0, OnHover, OnScroll, { OnRelease, OnPress, OnDrag } }
  });
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitMap = InitMap }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
