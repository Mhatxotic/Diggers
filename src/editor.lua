-- EDITOR.LUA ============================================================== --
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
local format<const>, remove<const> = string.format, table.remove;
-- Engine function aliases ------------------------------------------------- --
local UtilClampInt<const> = Util.ClampInt;
-- Diggers function and data aliases --------------------------------------- --
local ACT, AdjustViewportNoScroll, aEditorTypes, aLvlData, aObjs, aTileData,
  BlitSLT, BlitSLTWH, CreateObject, DIR, fontLarge, GetAbsMousePos, GetMouseX,
  GetMouseY, GetViewportData, IsSpriteCollide, JOB, LoadLevel, OFL,
  oGlobalData, oObjectTypes, PlayStaticSound, Print, PrintC,
  RegisterFBUCallback, RenderFade, RenderObjects, RenderTerrain,
  ScrollViewport, SelectObject, SetAction, SetCallbacks, SetCursor, SetHotSpot,
  SetKeys, SetPosition;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Assets required
      bShift,                          -- Shift being held?
      fontTiny,                        -- Tiny font
      iBrushAPos,                      -- Brush absolute position
      iBrushPosX, iBrushPosY,          -- Brush position
      iHotSpotId,                      -- Hot spot id
      iKeyBankId,                      -- Key bank id
      iLvlId,                          -- Level id
      iMouseX, iMouseY,                -- Mouse position
      iObject, oObject,                -- Selected object and its index
      iPaintTile, iPaintObject,        -- Tile or object to paint with
      iSSelect,                        -- Select sfx id
      iStageT, iStageR, iStageB,       -- Stage bounds
      iStageW, iStageH, iStageL,       -- Stage bounds
      iWinLimit,                       -- Win limit
      nStatusX, nStatusY,              -- Status position
      sLvlName,                        -- Level name
      sLvlType,                        -- Level type
      texSpr, texLev;                  -- Sprites texture
local oEditorTypes<const> = { };       -- Convert type to selectable type
-- Viewport data ----------------------------------------------------------- --
local iPixPosX, iPixPosY, iPixPosTargetX, iPixPosTargetY, iPixCenPosX,
  iPixCenPosY, iPosX, iPosY, iAbsCenPosX, iAbsCenPosY, iViewportW, iViewportH,
  iVPX, iVPY, oPlrActive, oObjActive, oPlrOpponent;
-- Blank function ---------------------------------------------------------- --
local function BlankFunction() end
-- When fail assets have loaded? ------------------------------------------- --
local function EditorProc(aResources)
  -- Scroll viewport to specified position
  ScrollViewport();
  -- Get viewport data
  iPixPosX, iPixPosY, iPixPosTargetX, iPixPosTargetY, iPixCenPosX,
    iPixCenPosY, iPosX, iPosY, iAbsCenPosX, iAbsCenPosY, iViewportW,
    iViewportH, iVPX, iVPY = GetViewportData();
end
-- When fail assets are being rendered? ------------------------------------ --
local function EditorRender(aResources)
  -- Render terrain and objects
  RenderTerrain();
  RenderObjects();
  -- Set text colour
  fontTiny:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  -- Object selected?
  if oObject then
    -- Set object selection colour
    texSpr:SetCRGB(0.0, 1.0, 0.0);
    -- Draw object selection rectangle
    BlitSLT(texSpr, 866 + ((Core.Ticks() // 2) % 2),
                         oObject.X - iVPX,
                         oObject.Y - iVPY);
    -- Draw status panel background
    RenderFade(0.75, nStatusX, nStatusY, nStatusX - 90.0, nStatusY - 42.0);
    -- Set object selection colour
    texSpr:SetCRGB(0.0, 1.0, 0.0);
    -- Draw object preview background
    BlitSLTWH(texSpr, 864, nStatusX - 86.0, nStatusY - 38.0, 18, 18);
    -- Restore sprite texture colour
    texSpr:SetCRGB(1.0, 1.0, 1.0);
    -- Draw object sprite preview
    BlitSLT(texSpr, oObject.S, nStatusX - 85.0, nStatusY - 37.0);
    -- Print selected object data
    PrintC(fontTiny, nStatusX - 34.0, nStatusY - 38.0,
      format("%s\n\z
              T:%02u P:%04ux%04u\n\z
              O:%03u A:%03ux%03u", oObject.OD.LONGNAME, oObject.ID,
              oObject.X, oObject.Y, iObject, oObject.AX, oObject.AY));
  -- Object not selected but terrain selected?
  elseif iBrushAPos then
    -- Set terrain selection colour
    texSpr:SetCRGB(0.0, 0.0, 1.0);
    -- Draw terrain selection rectangle
    BlitSLT(texSpr, 866 + ((Core.Ticks() // 2) % 2),
                         (iBrushPosX * 16) - iVPX,
                         (iBrushPosY * 16) - iVPY);
    -- Draw status panel background
    RenderFade(0.75, nStatusX, nStatusY, nStatusX - 90.0, nStatusY - 42.0);
    -- Get selected tile id and if valid?
    local iId<const> = aLvlData[1 + iBrushAPos];
    -- Set terrain selection colour
    texSpr:SetCRGB(0.0, 0.0, 1.0);
    -- Draw terrain selected background
    BlitSLTWH(texSpr, 864, nStatusX - 86.0, nStatusY - 38.0, 18, 18);
    -- Restore sprite intensity
    texSpr:SetCRGB(1.0, 1.0, 1.0);
    -- Draw the selected terrain tile
    BlitSLT(texLev, iId, nStatusX - 85.0, nStatusY - 37.0);
    -- Print information about the selected terrain tile
    PrintC(fontTiny, nStatusX - 34.0, nStatusY - 38.0,
      format("B:x%02Xx%02X I:%03u\n\z
              O:x%04X/%05u\n\z
              X:%03u Y:%03u\n\z",
        iId & 0xFF, (iId >> 8) & 0xFF, iId, iBrushAPos, iBrushAPos,
        iBrushPosX, iBrushPosY));
  -- Nothing selected?
  else
    -- Draw status panel background
    RenderFade(0.75, nStatusX, nStatusY, nStatusX - 90.0, nStatusY - 20.0);
  end
  -- Draw mouse position
  PrintC(fontTiny, nStatusX - 46.0, nStatusY - 16.0,
    format("VIEWPORT: %04ux%04u\n\z
            CURSOR: %04ux%04u",
    iVPX, iVPY, iVPX + iMouseX, iVPX + iMouseY));
end
-- When stage updated ------------------------------------------------------ --
local function OnStageUpdated(...)
  -- Set new stage bounds
  iStageW, iStageH, iStageL, iStageT, iStageR, iStageB = ...;
  -- Set status position
  nStatusX, nStatusY = iStageR - 8, iStageB - 8;
end
-- When level loaded ------------------------------------------------------- --
local function OnLoad(iNLvlId, sNLvlName, sNLvlType, iNWinLimit, texNLev)
  -- Walk through objects and set all phasing objects to stopped
  for iIndex = 1, #aObjs do
    -- Get object data and if cursor overlapping it ?
    local oObj<const> = aObjs[iIndex];
    if oObj.A == ACT.PHASE then
      SetAction(oObj, ACT.STOP, JOB.NONE, DIR.NONE) end;
  end
  -- Initialise level variables
  iLvlId, sLvlName, sLvlType, iWinLimit, texLev =
    iNLvlId, sNLvlName, sNLvlType, iNWinLimit, texNLev;
  -- Reset objects
  aObject, iObject, iPaintTile, iPaintObject = nil, 0, 0, oObjectTypes.JENNITE;
  -- Reset brush position
  iBrushPosX, iBrushPosY, iBrushAPos = 0, 0, nil;
  -- Get mouse position
  iMouseX, iMouseY = GetMouseX(), GetMouseY();
  -- Initial default viewport and mouse details
  iPixPosX, iPixPosY, iPixPosTargetX, iPixPosTargetY, iPixCenPosX,
    iPixCenPosY, iPosX, iPosY, iAbsCenPosX, iAbsCenPosY, iViewportW,
    iViewportH, iVPX, iVPY = GetViewportData();
  -- Register frame buffer update to save stage bounds
  RegisterFBUCallback("editor", OnStageUpdated);
end
-- Init level editor function ---------------------------------------------- --
local function InitEditor()
  -- When faded out to title? Load demo level
  LoadLevel(1, nil, iKeyBankId, nil, true, oObjectTypes.DIGRANDOM,
    true, EditorProc, EditorRender, BlankFunction, iHotSpotId, nil, nil, true,
    OnLoad);
end
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, oCursorIdData, oSfxData;
  -- Grab imports from other addons
  ACT, AdjustViewportNoScroll, aEditorTypes, aLvlData, aObjs, aTileData,
  BlitSLT, BlitSLTWH, CreateObject, DIR, fontLarge, fontTiny, GetAbsMousePos, GetMouseX,
  GetMouseY, GetViewportData, IsSpriteCollide, JOB, LoadLevel, oCursorIdData,
  OFL, oObjectTypes, oSfxData, PlayStaticSound, Print, PrintC,
  RegisterFBUCallback, RegisterHotSpot, RegisterKeys, RenderFade,
  RenderObjects, RenderTerrain, ScrollViewport, SelectObject, SetAction,
  SetCallbacks, SetCursor, SetHotSpot, SetKeys, SetPosition, texSpr =
    GetAPI("oObjectActions", "AdjustViewportNoScroll", "aEditorTypes",
      "aLvlData", "aObjs", "aTileData", "BlitSLT", "BlitSLTWH", "CreateObject",
      "oObjectDirections", "fontLarge", "fontTiny", "GetAbsMousePos",
      "GetMouseX", "GetMouseY", "GetViewportData", "IsSpriteCollide",
      "oObjectJobs", "LoadLevel", "oCursorIdData", "oObjectFlags",
      "oObjectTypes", "oSfxData", "PlayStaticSound", "Print", "PrintC",
      "RegisterFBUCallback", "RegisterHotSpot", "RegisterKeys", "RenderFade",
      "RenderObjects", "RenderTerrain", "ScrollViewport", "SelectObject",
      "SetAction", "SetCallbacks", "SetCursor", "SetHotSpot", "SetKeys",
      "SetPosition", "texSpr");
  -- On mouse hover callback ----------------------------------------------- --
  local function OnHover(...)
    iMouseX, iMouseY = ...;
    iMouseX = iMouseX - iStageL;
    iMouseY = iMouseY - iStageT;
  end
  -- On mouse click callback ----------------------------------------------- --
  local function OnMouseClick(iButton)
    -- If a left click?
    if iButton == 0 then
      -- Get adjusted absolute mouse position on level
      local iAMX<const>, iAMY<const> = GetAbsMousePos();
      -- Walk through objects
      for iIndex = 1, #aObjs do
        -- Get object data and if cursor overlapping it and isn't a digger ?
        local oObj<const> = aObjs[iIndex];
        if IsSpriteCollide(479, iAMX, iAMY, oObj.S, oObj.X, oObj.Y) and
          oObj.F & OFL.DIGGER == 0 then
          -- Set tip with name and health of object
          oObject, iObject = oObj, iIndex;
          -- Select the object in the actual game so the object will always
          -- be visible and focused in the viewport.
          SelectObject(oObj);
          -- Clear brush position
          iABrushPos = nil;
          -- Done
          return;
        end
      end
      -- Set generic message
      oObject, iObject = nil, 0;
      SelectObject(nil);
      iBrushPosX, iBrushPosY = iAMX // 16, iAMY // 16;
      iBrushAPos = (iBrushPosY * 128) + iBrushPosX;
    end
  end
  -- On mouse pressed -------------------------------------------------------- --
  local function OnPress() end;
  -- On mouse released (remove logic function) ------------------------------- --
  local function OnRelease() end;
  -- Cursor drag event ------------------------------------------------------- --
  local function OnDrag(iButton, _, _, iMoveX, iMoveY)
    -- Left click held?
    if iButton == 0 then OnMouseClick(iButton);
    -- Right click held?
    elseif iButton == 1 then
      -- Move the level to how the mouse is dragging
      AdjustViewportNoScroll(iMoveX, iMoveY);
      -- Keep arrow shown
      SetCursor(oCursorIdData.ARROW)
    end
  end
  -- Register hot spot
  iHotSpotId = RegisterHotSpot({
    { 0, 0, 0, 240, 3, oCursorIdData.ARROW, OnHover, false,
      { OnRelease, OnMouseClick, OnDrag } }
  });
  -- Copy terrain tile ----------------------------------------------------- --
  local function PushTerrainOrObject()
    -- If terrain selected?
    if iBrushAPos then iPaintTile = aLvlData[1 + iBrushAPos];
    -- If object selected
    elseif oObject then iPaintObject = oObject.ID end;
  end
  -- Add an object --------------------------------------------------------- --
  local function AddObject(iTypeId)
    -- Get adjusted absolute mouse position on level
    local iAMX<const>, iAMY<const> = GetAbsMousePos();
    -- Create object at specified position and select it
    oObject = CreateObject(iTypeId, iAMX, iAMY);
    iObject = #aObjs
    SelectObject(oObject);
    if oObject.A == ACT.PHASE then
      SetAction(oObject, ACT.STOP, JOB.NONE, DIR.NONE);
    end
  end
  -- Set terrain tile ------------------------------------------------------ --
  local function SetTerrain(iTileId)
    -- Return if no brush position
    if not iBrushAPos then return end;
    -- Wrap it if needed
    if iTileId < 0 or iTileId >= #aTileData then
      iTileId = iTileId % #aTileData;
    end
    -- Push the new tile id back into the terrain data and return
    aLvlData[1 + iBrushAPos] = iTileId;
  end
  -- Delete selected object ------------------------------------------------ --
  local function CbKDeleteSelectedObject()
    -- Return if there is no object or it is a digger
    if not oObject then return SetTerrain(0) end;
    -- Remove and clear the selected object
    remove(aObjs, iObject);
    oObject, iObject, iBrushAPos = nil, 0, nil;
    SelectObject(nil);
  end
  -- Move object in the specified direction -------------------------------- --
  local function MoveObject(iX, iY)
    -- Ignore if there is no active object
    if not oObject then return end;
    -- Get the current object position
    local iNewPosX, iNewPosY = oObject.X, oObject.Y;
    -- If the shift key is pressed (move faster)
    if bShift then
      -- X position is not aligned to terrain?
      if iNewPosX % 16 ~= 0 then
        -- Align it and move to next tile if going forward
        iNewPosX = iNewPosX - (iNewPosX % 16);
        if iX > 0 then iNewPosX = iNewPosX + (iX * 16) end;
      -- Y position is not aligned to terrain?
      elseif iNewPosY % 16 ~= 0 then
        -- Align it and move to next tile if going forward
        iNewPosY = iNewPosY - (iNewPosY % 16);
        if iY > 0 then iNewPosY = iNewPosY + (iY * 16) end;
      -- Already aligned so just move it
      else iNewPosX, iNewPosY = iNewPosX + (iX * 16),
                                iNewPosY + (iY * 16) end;
    -- Shift not pressed so just move by pixel
    else iNewPosX, iNewPosY = iNewPosX + iX, iNewPosY + iY end;
    -- Set the new position clamped so the object can't leave the terrain
    SetPosition(oObject, UtilClampInt(iNewPosX, 0, 2032),
                         UtilClampInt(iNewPosY, 0, 2032));
  end
  -- Move the object events ------------------------------------------------ --
  local function CbKUpCursor() MoveObject(0, -1) end;
  local function CbKDownCursor() MoveObject(0, 1) end;
  local function CbKLeftCursor() MoveObject(-1, 0) end;
  local function CbKRightCursor() MoveObject( 1, 0) end;
  -- Cycle the current object type or terrain id --------------------------- --
  local function CycleObjectOrTerrain(iAmount)
    -- Only terrain selected?
    if not oObject then
      -- Ignore if no brush position selected
      return SetTerrain(aLvlData[1 + iBrushAPos] + iAmount);
    end
    -- Convert type to indice from supported types list and wrap the value
    local iT = oEditorTypes[oObject.ID] + iAmount;
    if iT < 1 or iT > #aEditorTypes then
      iT = aEditorTypes[((iT - 1) % #aEditorTypes) + 1];
    else iT = aEditorTypes[iT] end;
    -- Create a new object and return if failed
    local oNObject<const> = CreateObject(iT, oObject.X, oObject.Y);
    if not oNObject then return end;
    -- If phasing then unphase it
    if oNObject.A == ACT.PHASE then
      SetAction(oNObject, ACT.STOP, JOB.NONE, DIR.NONE);
    end
    -- Assign it to the currently selected object's value, overwriting it and
    -- then remove the last value that was added and select the new object
    aObjs[iObject] = oNObject;
    remove(aObjs);
    SelectObject(oNObject);
    oObject = oNObject;
    -- Clear brush position
    iABrushPos = nil;
  end
  -- Cycle the object/terrain id events ------------------------------------ --
  local function CbKLeftBracket() CycleObjectOrTerrain(-1) end;
  local function CbKRightBracket() CycleObjectOrTerrain(1) end;
  -- Alternate function key pressed or released ---------------------------- --
  local function CbKShiftHeld() bShift = true end;
  local function CbKShiftRelease() bShift = false end;
  -- Object order swapper utility function --------------------------------- --
  local function SwapObject(iDstId)
    -- Get the destination object from the specified id
    local oDstObject<const> = aObjs[iDstId];
    -- Do the swap and set the new selected object id
    aObjs[iDstId], aObjs[iObject], iObject = oObject, oDstObject, iDstId;
  end
  -- Request to cycle the order by the specified amount -------------------- --
  local function CycleOrder(iAmount)
    -- Return if no object is selected
    if not oObject then return end;
    -- Swap the order with the adjacent requested object
    SwapObject(UtilClampInt(iObject + iAmount, 1, #aObjs));
  end
  -- Request to cycle the order by the specified requested object ---------- --
  local function CycleOrderEnd(iDstId)
    -- Return if no object is selected
    if not oObject then return end;
    -- Swap the order with the specified requested object
    SwapObject(iDstId);
  end
  -- Set specific object --------------------------------------------------- --
  local function CycleObject(iAmount)
    -- Don't do anything if no objects
    if #aObjs == 0 then return end;
    -- Save current object
    local iOObject<const> = iObject;
    -- Set new object value
    iObject = iObject + iAmount;
    -- Modulo it if it's out of range
    ::Retry:: if iObject < 1 or iObject > #aObjs then
      iObject = 1 + ((iObject - 1) % #aObjs) end;
    -- Select the object and try next object if is a digger
    local oObj<const> = aObjs[iObject];
    if oObj.F & OFL.DIGGER ~= 0 then
      -- Set next adjacent object value and retry if we're not at same object
      iObject = iObject + iAmount;
      if iObject ~= iOObject then goto Retry end;
      return;
    end
    -- Select the obejct
    SelectObject(oObj, true, true);
    -- Set new object
    oObject = oObj;
  end
  -- Cycle between objects ------------------------------------------------- --
  local function CbKNextObject() CycleObject(1) end;
  local function CbKLastObject() CycleObject(-1) end;
  -- Cycle order keyboard events ------------------------------------------- --
  local function CbKMoveOrderNext() CycleOrder(1) end;
  local function CbKMoveOrderLast() CycleOrder(-1) end;
  local function CbKMoveOrderBottom() CycleOrderEnd(1) end;
  local function CbKMoveOrderTop() CycleOrderEnd(#aObjs) end;
  -- Paint selected tile and object ---------------------------------------- --
  local function CbKPaintTile() SetTerrain(iPaintTile) end;
  local function CbKPaintObject() AddObject(iPaintObject) end;
  local function CbKCopy() PushTerrainOrObject() end;
  -- Input states and binds ------------------------------------------------ --
  local oKeys<const>, oStates<const> = Input.KeyCodes, Input.States;
  -- Create key bind datas which are used more than once
  local aCursorUp<const>, aCursorDown<const>, aCursorLeft<const>,
    aCursorRight<const>, aCycleLeft<const>, aCycleRight<const>,
    aMoveBack<const>, aMoveForward<const>, aMoveBottom<const>,
    aMoveTop<const>, aPreviousObject<const>, aNextObject<const>,
    aDelete<const>, aPaintTile<const>, aPaintObject<const> =
      { oKeys.UP,    CbKUpCursor,    "eup",   "MOVE OBJECT UP" },
      { oKeys.DOWN,  CbKDownCursor,  "edown", "MOVE OBJECT DOWN" },
      { oKeys.LEFT,  CbKLeftCursor,  "esl",   "MOVE OBJECT LEFT" },
      { oKeys.RIGHT, CbKRightCursor, "esr",   "MOVE OBJECT RIGHT" },
      { oKeys.LEFT_BRACKET, CbKLeftBracket,
        "elo", "LAST OBJECT OR TERRAIN ID" },
      { oKeys.RIGHT_BRACKET, CbKRightBracket,
        "eno", "NEXT OBJECT OR TERRAIN ID" },
      { oKeys.N,     CbKMoveOrderNext,   "eof",  "MOVE OBJECT FORWARD" },
      { oKeys.L,     CbKMoveOrderLast,   "eob",  "MOVE OBJECT BACK" },
      { oKeys.B,     CbKMoveOrderBottom, "eoeb", "MOVE OBJECT BOTTOM" },
      { oKeys.T,     CbKMoveOrderTop,    "eoet", "MOVE OBJECT TOP" },
      { oKeys.MINUS, CbKLastObject,      "eop",  "SELECT LAST OBJECT" },
      { oKeys.EQUAL, CbKNextObject,      "eon",  "SELECT NEXT OBJECT" },
      { oKeys.BACKSPACE, CbKDeleteSelectedObject,
        "eclear", "CLEAR OBJECT OR TERRAIN" },
      { oKeys.SPACE, CbKPaintTile,   "ept", "PAINT SELECTED TILE" },
      { oKeys.ENTER, CbKPaintObject, "epo", "PAINT SELECTED OBJECT" };
  -- Register the new keyboard inpute events
  iKeyBankId = RegisterKeys("MAP EDITOR", {
    -- Key pressed events
    [oStates.PRESS] = {
      { oKeys.RIGHT_SHIFT, CbKShiftHeld,
        "eeaf", "ENABLE ALTERNATE FUNCTION" },
      { oKeys.C, CbKCopy, "eoct", "COPY OBJECT OR TILE" },
      aPreviousObject, aNextObject, aCursorUp, aCursorDown, aCursorLeft,
      aCursorRight, aCycleLeft, aCycleRight, aMoveBack, aMoveForward,
      aMoveBottom, aMoveTop, aDelete, aPaintTile, aPaintObject
    -- Key repeat events
    }, [oStates.REPEAT] = {
      aPreviousObject, aNextObject, aCursorUp, aCursorDown, aCursorLeft,
      aCursorRight, aCycleLeft, aCycleRight, aMoveBack, aMoveForward,
      aMoveBottom, aMoveTop, aDelete, aPaintTile, aPaintObject
    -- Key release events
    }, [oStates.RELEASE] = {
      { oKeys.RIGHT_SHIFT, CbKShiftRelease,
        "eedf", "DISABLE ALTERNATE FUNCTION" },
    }
  });
  -- Get select sound effect id
  iSSelect = oSfxData.SELECT;
  -- Convert available editor objects to a key/value list which converts the
  -- given type id into an index from 'aEditorTypes'.
  for iId = 1, #aEditorTypes do oEditorTypes[aEditorTypes[iId]] = iId end;
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitEditor = InitEditor }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
