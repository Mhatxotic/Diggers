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
local format<const>, remove<const>, maxinteger<const> =
  string.format, table.remove, math.maxinteger;
-- Engine function aliases ------------------------------------------------- --
local UtilClampInt<const>, UtilIsTable<const>, UtilIsInteger<const>,
  JsonTable<const> =
  Util.ClampInt, Util.IsTable, Util.IsInteger, Json.Table;
-- Diggers function and data aliases --------------------------------------- --
local ACT, AdjustViewportNoScroll, aLvlData, aObjs, aTileData, BlitSLT,
  BlitSLTWH, CreateObject, DIR, fontLarge, GetAbsMousePos, GetMouseX,
  GetMouseY, GetViewportData, IsSpriteCollide, JOB, LoadLevel, LoadResources,
  OFL, oObjectData, oObjectTypes, Print, PrintC, RegisterFBUCallback,
  RenderFade, RenderObjects, RenderTerrain, ScrollViewport, SelectObject,
  SetAction, SetCallbacks, SetCursor, SetHotSpot, SetKeys, SetPosition,
  SwitchTerrainType;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Assets required
      bShift,                          -- Shift being held?
      fontTiny,                        -- Tiny font
      iBrushAPos,                      -- Brush absolute position
      iBrushPosX, iBrushPosY,          -- Brush position
      iBrushSizeW, iBrushSizeH,        -- Brush size
      iEditorHotSpotId,                -- Editor hot spot id
      iEditorKeyBankId,                -- Editor key bank id
      iPickerHotSpotId,                -- Picker hot spot id
      iObjPickerHotSpotId,             -- Object picker hotspot id
      iObjPickerKeyBankId,             -- Picker key bank id
      iLvlId,                          -- Level id
      iLastPicker,                     -- Last picker opened
      iMouseX, iMouseY,                -- Mouse position
      iObject, oObject,                -- Selected object and its index
      iPickerSelected,                 -- Tile or object selected in picker
      iPickerStart,                    -- Picker start index
      iPickerSelX, iPickerSelY,        -- Picker selection rectangle
      iPaintTile, iPaintObject,        -- Tile or object to paint with
      iPaintObjectSprite,              -- Sprite to show for paint object
      iStageT, iStageR, iStageB,       -- Stage bounds
      iStageW, iStageH, iStageL,       -- Stage bounds
      iWinLimit,                       -- Win limit
      sLvlName,                        -- Level name
      sLvlType, iLvlType,              -- Level type and id
      texSpr, texLev;                  -- Sprites texture
local oEditorTypes<const> = { };       -- Convert type to selectable type
local aEditorThumbs<const> = { };      -- Thumbnails for each editor type
local nStatusX, nStatusY = 200, 236;   -- Status bar position
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
    local iTile<const> = 866 + ((Core.Ticks() // 2) % 2);
    for iY = iBrushPosY, iBrushPosY + iBrushSizeH do
      local iYpix<const> = (iY * 16) - iVPY;
      for iX = iBrushPosX, iBrushPosX + iBrushSizeW do
        BlitSLT(texSpr, iTile, (iX * 16) - iVPX, iYpix);
      end
    end
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
    format("%s (%u)\n\z
            C:%04ux%04u T:%03u",
    sLvlName, iLvlType, iVPX + iMouseX, iVPX + iMouseY, #aObjs));
  -- Draw brushes
  RenderFade(0.75, nStatusX - 94.0, nStatusY,
                   nStatusX - 120.0, nStatusY - 26.0);
  RenderFade(0.75, nStatusX + 4.0, nStatusY,
                   nStatusX + 30.0, nStatusY - 26.0);
  -- Draw terrain selected background
  texSpr:SetCRGB(0.0, 0.0, 1.0);
  BlitSLTWH(texSpr, 864, nStatusX - 116.0, nStatusY - 22, 18, 18);
  BlitSLT(texLev, iPaintTile, nStatusX - 115.0, nStatusY - 21);
  texSpr:SetCRGB(0.0, 1.0, 0.0);
  BlitSLTWH(texSpr, 864, nStatusX + 8.0, nStatusY - 22, 18, 18);
  texSpr:SetCRGB(1.0, 1.0, 1.0);
  BlitSLT(texSpr, iPaintObjectSprite, nStatusX + 9.0, nStatusY - 21);
end
-- Draw tile preview ------------------------------------------------------- --
local function PickerDrawPreview(texT, iSpr, iXAdjS, iYAdjS, iXAdjL, iYAdjL)
  -- Draw background tile
  BlitSLTWH(texSpr, 864, iPickerSelX + iXAdjS, iPickerSelY + iYAdjS, 34, 34);
  -- Draw request texture and sprite on top of it
  BlitSLTWH(texT, iSpr, iPickerSelX + iXAdjL, iPickerSelY + iYAdjL, 32, 32);
end
-- Editor terrain tile picker renderer ------------------------------------- --
local function TerrainPickerRender()
  -- Render terrain background
  RenderTerrain();
  -- Draw shadow border
  texSpr:SetCRGB(0.0, 0.0, 0.25);
  RenderFade(0.75);
  RenderFade(1.0, 0.0, 0.0, 320.0, 240.0, 1022);
  texSpr:SetCRGB(1.0, 1.0, 1.0);
  -- Starting position
  local iIndex = iPickerStart;
  for iY = 0, 224, 16 do
    -- For each tile on the X axis
    for iX = 0, 304, 16 do
      -- Draw a background for a sprite
      BlitSLT(texSpr, 864, iX, iY);
      BlitSLT(texLev, iIndex, iX, iY);
      iIndex = iIndex + 1;
    end
  end
  -- Set object selection colour
  texSpr:SetCRGB(0.0, 0.0, 1.0);
  -- Draw object selection rectangle
  BlitSLT(texSpr, 866 + ((Core.Ticks() // 2) % 2),
                       iPickerSelX,
                       iPickerSelY);
  texSpr:SetCRGB(1.0, 1.0, 1.0);
  if iPickerSelX < 160 then
    if iPickerSelY < 120 then
      PickerDrawPreview(texLev, iPickerSelected, 15, 15, 16, 16);
    else PickerDrawPreview(texLev, iPickerSelected, 15, -33, 16, -32) end;
  elseif iPickerSelY < 120 then
    PickerDrawPreview(texLev, iPickerSelected, -33, 15, -32, 16);
  else PickerDrawPreview(texLev, iPickerSelected, -33, -33, -32, -32) end
  PrintC(fontTiny, iPickerSelX + 8, iPickerSelY + 5, iPickerSelected);
end
-- Editor object tile picker renderer -------------------------------------- --
local function ObjPickerRender()
  -- Render terrain background
  RenderTerrain();
  -- Draw shadow border
  texSpr:SetCRGB(0.0, 0.25, 0.0);
  RenderFade(0.75);
  RenderFade(1.0, 0.0, 0.0, 320.0, 240.0, 1022);
  texSpr:SetCRGB(1.0, 1.0, 1.0);
  -- Starting position
  local iIndex = iPickerStart;
  -- For each tile on the Y axis
  for iY = 0, 224, 16 do
    -- For each tile on the X axis
    for iX = 0, 304, 16 do
      -- Draw a background for a sprite
      BlitSLT(texSpr, 864, iX, iY);
      BlitSLT(texSpr, aEditorThumbs[1 + iIndex], iX, iY);
      iIndex = iIndex + 1;
      if iIndex >= #aEditorThumbs then break end;
    end
    if iIndex >= #aEditorThumbs then break end;
  end
  -- Set object selection colour
  texSpr:SetCRGB(0.0, 1.0, 0.0);
  -- Draw object selection rectangle
  BlitSLT(texSpr, 866 + ((Core.Ticks() // 2) % 2),
                       iPickerSelX,
                       iPickerSelY);
  texSpr:SetCRGB(1.0, 1.0, 1.0);
  if iPickerSelX < 160 then
    if iPickerSelY < 120 then
      PickerDrawPreview(texSpr, aEditorThumbs[1 + iPickerSelected], 15, 15, 16, 16);
    else
      PickerDrawPreview(texSpr, aEditorThumbs[1 + iPickerSelected], 15, -33, 16, -32);
    end
  elseif iPickerSelY < 120 then
    PickerDrawPreview(texSpr, aEditorThumbs[1 + iPickerSelected], -33, 15, -32, 16);
  else
    PickerDrawPreview(texSpr, aEditorThumbs[1 + iPickerSelected], -33, -33, -32, -32)
  end
  PrintC(fontTiny, iPickerSelX + 8, iPickerSelY + 5, iPickerSelected);
end
-- When stage updated ------------------------------------------------------ --
local function OnStageUpdated(...)
  -- Set new stage bounds
  iStageW, iStageH, iStageL, iStageT, iStageR, iStageB = ...;
end
-- Set paint object -------------------------------------------------------- --
local function SetPaintObject(iNPaintObject)
  -- Set new paint object
  iPaintObject = iNPaintObject;
  -- Get object data
  local oPObjData<const> = oObjectData[iPaintObject];
  if not UtilIsTable(oPObjData) then
    error("Invalid object '"..iPaintObject.."'!") end;
  -- Set the first sprite of the animation
  iPaintObjectSprite = oPObjData.THUMBNAIL;
  if not UtilIsInteger(iPaintObjectSprite) then
    error("Can't find first sprite '"..iPaintObject.."'!") end;
end
-- When level loaded ------------------------------------------------------- --
local function OnLoad(iNLvlId, sNLvlName, sNLvlType, iNWinLimit, texNLev,
  iLvlNType)
  -- Walk through objects and set all phasing objects to stopped
  for iIndex = 1, #aObjs do
    -- Get object data and if cursor overlapping it ?
    local oObj<const> = aObjs[iIndex];
    if oObj.A == ACT.PHASE then
      SetAction(oObj, ACT.STOP, JOB.NONE, DIR.NONE) end;
  end
  -- Initialise level variables
  iLvlId, sLvlName, sLvlType, iWinLimit, texLev, iLvlType =
    iNLvlId, sNLvlName, sNLvlType, iNWinLimit, texNLev, iLvlNType;
  -- Reset objects
  oObject, iObject, iPaintTile = nil, 0, 0;
  -- Set Jennite as initial paint object
  SetPaintObject(oObjectTypes.JENNITE);
  -- Reset brush position
  iBrushPosX, iBrushPosY, iBrushSizeW, iBrushSizeH, iBrushAPos =
    0, 0, 0, 0, nil;
  iPickerSelX, iPickerSelY, iPickerStart, iPickerSelected = 0, 0, 0, 0;
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
  LoadLevel(1, nil, iEditorKeyBankId, nil, true, oObjectTypes.DIGRANDOM,
    true, EditorProc, EditorRender, BlankFunction, iEditorHotSpotId, nil, nil,
    true, OnLoad);
end
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only ----------------------- --
  local RegisterHotSpot<const>, RegisterKeys<const>, aEditorTypes<const>,
    aLevelTypesData<const>, oCursorIdData<const>, oSfxData<const>,
    PlayStaticSound<const> =
      GetAPI("RegisterHotSpot", "RegisterKeys", "aEditorTypes",
        "aLevelTypesData", "oCursorIdData", "oSfxData", "PlayStaticSound");
  -- Grab imports from other add-ons --------------------------------------- --
  ACT, AdjustViewportNoScroll, aLvlData, aObjs, aTileData, BlitSLT, BlitSLTWH,
  CreateObject, DIR, fontLarge, fontTiny, GetAbsMousePos, GetMouseX, GetMouseY,
  GetViewportData, IsSpriteCollide, JOB, LoadLevel, LoadResources, oObjectData,
  OFL, oObjectTypes, Print, PrintC, RegisterFBUCallback, RenderFade,
  RenderObjects, RenderTerrain, ScrollViewport, SelectObject, SetAction,
  SetCallbacks, SetCursor, SetHotSpot, SetKeys, SetPosition, SwitchTerrainType,
  texSpr =
    GetAPI("oObjectActions", "AdjustViewportNoScroll", "aLvlData", "aObjs",
      "aTileData", "BlitSLT", "BlitSLTWH", "CreateObject", "oObjectDirections",
      "fontLarge", "fontTiny", "GetAbsMousePos", "GetMouseX", "GetMouseY",
      "GetViewportData", "IsSpriteCollide", "oObjectJobs", "LoadLevel",
      "LoadResources", "oObjectData", "oObjectFlags", "oObjectTypes", "Print",
      "PrintC", "RegisterFBUCallback", "RenderFade", "RenderObjects",
      "RenderTerrain", "ScrollViewport", "SelectObject", "SetAction",
      "SetCallbacks", "SetCursor", "SetHotSpot",  "SetKeys", "SetPosition",
      "SwitchTerrainType", "texSpr");
  -- Get cursor ids -------------------------------------------------------- --
  local iCArrow<const> = oCursorIdData.ARROW;
  -- Get sound effect ids -------------------------------------------------- --
  local iSClick<const>, iSSelect<const>, iSPhase<const>, iSError<const>,
    iSKick<const>, iSPunch<const> =
      oSfxData.CLICK, oSfxData.SELECT, oSfxData.PHASE, oSfxData.ERROR,
      oSfxData.KICK, oSfxData.PUNCH;
  -- On editor mouse hover callback ---------------------------------------- --
  local function OnEditorHover(...)
    iMouseX, iMouseY = ...;
    iMouseX, iMouseY = iMouseX - iStageL, iMouseY - iStageT;
  end
  -- Prepare picker -------------------------------------------------------- --
  local function InitPicker(fcbRender, iNHotSpotId, iNKeyBankId, iPickerId)
    -- Play click sound
    PlayStaticSound(iSClick);
    -- Set picker callbacks
    SetCallbacks(EditorProc, fcbRender);
    -- Set picker hotspot and keybank id
    SetHotSpot(iNHotSpotId);
    SetKeys(true, iNKeyBankId);
    -- Return if we opened this picker the last time
    if iLastPicker == iPickerId then return end;
    iLastPicker = iPickerId;
    -- Reset picker position to the start
    iPickerSelected, iPickerSelX, iPickerSelY, iPickerStart = 0, 0, 0, 0;
  end
  -- On picker utility function -------------------------------------------- --
  local function OnPickerGenericHover(iMaximum, ...)
    iMouseX, iMouseY = ...;
    if iMouseX < 0 or iMouseX >= 320 then return end;
    local iX<const> = (iMouseX // 16);
    local iY<const> = (iMouseY // 16);
    local iPickerId<const> = iPickerStart + (iX + iY * 20);
    if iPickerId < 0 or iPickerId >= iMaximum then return end;
    iPickerSelected = iPickerId;
    iPickerSelX, iPickerSelY = iX * 16, iY * 16;
  end
  -- Object and terrain picker key pressed --------------------------------- --
  local function CbKObjectPicker()
    InitPicker(ObjPickerRender, iObjPickerHotSpotId, iObjPickerKeyBankId, 1);
  end
  local function CbKTerrainPicker()
    InitPicker(TerrainPickerRender, iPickerHotSpotId, iPickerKeyBankId, 2);
  end
  -- On editor mouse click callback ---------------------------------------- --
  local function OnEditorClick(iButton)
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
      -- Deselect active object
      oObject, iObject = nil, 0;
      SelectObject();
      -- Get clicked tile position on level
      local iX<const>, iY<const> = iAMX // 16, iAMY // 16;
      -- If shift is held and we already have a position
      if bShift and iBrushAPos then
        if iX < iBrushPosX then
          iBrushSizeW = iBrushSizeW + (iBrushPosX - iX);
          iBrushPosX = iX;
        elseif iX > iBrushPosX then
          iBrushSizeW = iX - iBrushPosX;
        end;
        if iY < iBrushPosY then
          iBrushSizeH = iBrushSizeH + (iBrushPosY - iY);
          iBrushPosY = iY;
        elseif iY > iBrushPosY then
          iBrushSizeH = iY - iBrushPosY;
        end
      else
        iBrushPosX, iBrushPosY, iBrushSizeW, iBrushSizeH =
          iX, iY, 0, 0;
      end
      iBrushAPos = (iBrushPosY * 128) + iBrushPosX;
    -- Middle click?
    elseif iButton == 3 then CbKTerrainPicker();
    -- Middle click?
    elseif iButton == 4 then CbKObjectPicker();
    -- Other click?
    elseif iButton ~= 1 then PlayStaticSound(iSError) end;
  end
  -- On editor mouse released (remove logic function) ---------------------- --
  local function OnEditorRelease() end
  -- Cursor drag event ----------------------------------------------------- --
  local function OnEditorDrag(iButton, _, _, iMoveX, iMoveY)
    -- Left click held?
    if iButton == 0 then OnEditorClick(iButton);
    -- Right click held?
    elseif iButton == 1 then
      -- Move the level to how the mouse is dragging
      AdjustViewportNoScroll(iMoveX, iMoveY);
      -- Keep arrow shown
      SetCursor(iCArrow)
    end
  end
  -- Set specific object --------------------------------------------------- --
  local function CycleObject(iAmount)
    -- Don't do anything if no objects
    if #aObjs == 0 then return PlayStaticSound(iSError) end;
    -- Play click sound
    PlayStaticSound(iSClick);
    -- Save current object
    local iOObject<const> = iObject;
    -- Set new object value
    iObject = iObject + iAmount;
    -- Wrap if it's out of range
    ::Retry::
    if iObject < 1 or iObject > #aObjs then
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
  -- On picker scroll wheel moved ------------------------------------------ --
  local function OnEditorScroll(nX, nY)
    -- Scroll backwards or forwards
    if nY < 0 then CbKNextObject() elseif nY > 0 then CbKLastObject() end;
  end
  -- Register editor hot spots --------------------------------------------- --
  iEditorHotSpotId = RegisterHotSpot({
    { 0, 0, 0, 240, 3, iCArrow, OnEditorHover, OnEditorScroll,
      { OnEditorRelease, OnEditorClick, OnEditorDrag } }
  });
  -- Copy terrain tile ----------------------------------------------------- --
  local function PushTerrainOrObject()
    -- If terrain selected?
    if iBrushAPos then iPaintTile = aLvlData[1 + iBrushAPos] end;
    -- If object selected
    if oObject then SetPaintObject(oObject.ID) end;
    -- Feedback sound
    PlayStaticSound(iSClick);
  end
  -- Add an object --------------------------------------------------------- --
  local function AddObject(iTypeId)
    -- Get adjusted absolute mouse position on level
    local iAMX<const>, iAMY<const> = GetAbsMousePos();
    -- Create object at specified position and return if failed
    local oNObject<const> = CreateObject(iTypeId, iAMX - 8, iAMY - 8);
    if not oNObject then PlayStaticSound(iSError) end;
    -- Set selected object
    oObject, iObject = oNObject, #aObjs;
    SelectObject(oObject);
    -- Stop if phasing
    if oObject.A == ACT.PHASE then
      SetAction(oObject, ACT.STOP, JOB.NONE, DIR.NONE) end;
    -- Play feedback sound
    PlayStaticSound(iSKick);
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
    for iY = iBrushPosY, iBrushPosY + iBrushSizeH do
      for iX = iBrushPosX, iBrushPosX + iBrushSizeW do
        aLvlData[1 + ((iY * 128) + iX)] = iTileId;
      end
    end
  end
  -- Delete selected object ------------------------------------------------ --
  local function CbKDeleteSelectedObject()
    -- Return if there is no object or it is a digger
    if not oObject then return SetTerrain(0) end;
    -- Remove and clear the selected object
    remove(aObjs, iObject);
    oObject, iObject, iBrushAPos = nil, 0, nil;
    SelectObject(nil);
    -- Feedback for deleting object
    PlayStaticSound(iSPunch);
  end
  -- Move object in the specified direction -------------------------------- --
  local function MoveObject(iX, iY)
    -- If there is no active object?
    if not oObject then
      -- Shift pressed? Move viewport gradually
      if bShift then return AdjustViewportNoScroll(-iX, -iY) end;
      -- Move viewport in tile sizes
      return AdjustViewportNoScroll(-(iX * 16), -(iY * 16));
    end
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
      -- If we have a terrain position
      if iBrushAPos then
        -- Cycle the terrain id
        SetTerrain(aLvlData[1 + iBrushAPos] + iAmount);
        return PlayStaticSound(iSClick);
      end
      -- No terrain selected
      return PlayStaticSound(iSError);
    end
    -- Convert type to indice from supported types list and wrap the value
    local iT = oEditorTypes[oObject.ID] + iAmount;
    if iT < 1 or iT > #aEditorTypes then
      iT = aEditorTypes[((iT - 1) % #aEditorTypes) + 1];
    else iT = aEditorTypes[iT] end;
    -- Create a new object and return if failed
    local oNObject<const> = CreateObject(iT, oObject.X, oObject.Y);
    if not oNObject then return PlayStaticSound(iSError) end;
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
    -- Play sound for success
    return PlayStaticSound(iSClick);
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
    if not oObject then return PlayStaticSound(iSError) end;
    -- Play click sound
    PlayStaticSound(iSClick);
    -- Swap the order with the adjacent requested object
    SwapObject(UtilClampInt(iObject + iAmount, 1, #aObjs));
  end
  -- Request to cycle the order by the specified requested object ---------- --
  local function CycleOrderEnd(iDstId)
    -- Return if no object is selected
    if not oObject then return PlayStaticSound(iSError) end;
    -- Play click sound
    PlayStaticSound(iSClick);
    -- Swap the order with the specified requested object
    SwapObject(iDstId);
  end
  -- Cycle order keyboard events ------------------------------------------- --
  local function CbKMoveOrderNext() CycleOrder(1) end;
  local function CbKMoveOrderLast() CycleOrder(-1) end;
  local function CbKMoveOrderBottom() CycleOrderEnd(1) end;
  local function CbKMoveOrderTop() CycleOrderEnd(#aObjs) end;
  -- Paint selected tile and object ---------------------------------------- --
  local function CbKPaintTile() SetTerrain(iPaintTile) end;
  local function CbKPaintObject() AddObject(iPaintObject) end;
  local function CbKCopy() PushTerrainOrObject() end;
  -- Save current level ---------------------------------------------------- --
  local function CbKSave()
    -- Reformatted base objects list
    local aObjects<const> = { };
    -- Save data
    local aSaveData<const> = {
      Version = 1,                     -- Manifest version
      Name    = sLvlName,              -- Level name
      Type    = iLvlType,              -- Terrain type
      Terrain = aLvlData,              -- Terrain data
      Objects = aObjects               -- Reformatted objects
    };
    -- Enumerate through all the object indicies
    for iIndex = 1, #aObjs do
      -- Get the object and add the only data that matters
      local oObject<const> = aObjs[iIndex];
      aObjects[1 + #aObjects] = { oObject.ID, oObject.X, oObject.Y };
    end
    -- Write the data to json
    File.WriteOneStr("test.json", JsonTable(aSaveData):ToString());
  end
  -- Switch terrain type --------------------------------------------------- --
  local function CbKSwitchTerrain()
    -- Play click sound
    PlayStaticSound(iSPhase);
    -- Set next terrain type id and wrap it if invalid
    iLvlType = iLvlType + 1;
    if iLvlType < 1 or iLvlType > #aLevelTypesData then
      iLvlType = 1 + ((iLvlType - 1) % #aLevelTypesData);
    end
    -- When new texture has loaded event
    local function OnLoaded(texNLev, sNLvlType)
      -- Set the new level type and texture handle
      sLvlType, texLev = sNLvlType, texNLev;
      -- Restore editor callbacks
      SetCallbacks(EditorProc, EditorRender);
      -- Restore hotspot and keybank id
      SetHotSpot(iEditorHotSpotId);
      SetKeys(true, iEditorKeyBankId);
    end
    -- Execute the switch
    SwitchTerrainType(iLvlType, OnLoaded);
  end
  -- Input states and binds ------------------------------------------------ --
  -- Get key state ids ----------------------------------------------------- --
  local oKeys<const>, oStates<const> = Input.KeyCodes, Input.States;
  local iKSPress<const>, iKSRepeat<const> = oStates.PRESS, oStates.REPEAT;
  -- Create key bind datas which are used more than once
  local aEditorCursorUp<const>, aEditorCursorDown<const>,
    aEditorCursorLeft<const>, aEditorCursorRight<const>,
    aEditorCycleLeft<const>, aEditorCycleRight<const>,
    aEditorMoveForward<const>, aEditorMoveBack<const>,
    aEditorMoveBottom<const>, aEditorMoveTop<const>,
    aEditorPreviousObject<const>, aEditorNextObject<const>,
    aEditorDelete<const>, aEditorPaintTile<const> =
      { oKeys.UP,    CbKUpCursor,        "eup",  "MOVE OBJECT UP" },
      { oKeys.DOWN,  CbKDownCursor,      "edn",  "MOVE OBJECT DOWN" },
      { oKeys.LEFT,  CbKLeftCursor,      "esl",  "MOVE OBJECT LEFT" },
      { oKeys.RIGHT, CbKRightCursor,     "esr",  "MOVE OBJECT RIGHT" },
      { oKeys.LEFT_BRACKET,
        CbKLeftBracket,                 "elot",  "LAST OBJECT OR TERRAIN ID" },
      { oKeys.RIGHT_BRACKET,
        CbKRightBracket,                "enot",  "NEXT OBJECT OR TERRAIN ID" },
      { oKeys.N,     CbKMoveOrderNext,   "eof",  "MOVE OBJECT FORWARD" },
      { oKeys.L,     CbKMoveOrderLast,   "eob",  "MOVE OBJECT BACK" },
      { oKeys.B,     CbKMoveOrderBottom, "eoeb", "MOVE OBJECT BOTTOM" },
      { oKeys.T,     CbKMoveOrderTop,    "eoet", "MOVE OBJECT TOP" },
      { oKeys.MINUS, CbKLastObject,      "elo",  "SELECT LAST OBJECT" },
      { oKeys.EQUAL, CbKNextObject,      "eno",  "SELECT NEXT OBJECT" },
      { oKeys.BACKSPACE,
        CbKDeleteSelectedObject,         "eclr", "CLEAR OBJECT OR TERRAIN" },
      { oKeys.SPACE, CbKPaintTile,       "ept",  "PAINT SELECTED TILE" };
  -- Register the new editor keyboard input events
  iEditorKeyBankId = RegisterKeys("MAP EDITOR", {
    -- Key pressed events
    [iKSPress] = {
      { oKeys.LEFT_SHIFT, CbKShiftHeld, "eeaf", "ENABLE ALTERNATE FUNCTION" },
      { oKeys.C,     CbKCopy,           "eoct", "COPY OBJECT OR TILE" },
      { oKeys.O,     CbKObjectPicker,   "eop",  "SHOW TERRAIN TILE PICKER" },
      { oKeys.S,     CbKSave,           "es",   "SAVE CURRENT LEVEL" },
      { oKeys.V,     CbKTerrainPicker,  "etp",  "SHOW TERRAIN TILE PICKER" },
      { oKeys.Y,     CbKSwitchTerrain,  "est",  "SWITCH TERRAIN TYPE" },
      { oKeys.ENTER, CbKPaintObject,    "epo",  "PAINT SELECTED OBJECT" },
      aEditorPreviousObject, aEditorNextObject, aEditorCursorUp,
      aEditorCursorDown, aEditorCursorLeft, aEditorCursorRight,
      aEditorCycleLeft, aEditorCycleRight, aEditorMoveBack, aEditorMoveForward,
      aEditorMoveBottom, aEditorMoveTop, aEditorDelete, aEditorPaintTile,
      aEditorPicker
    -- Key repeat events
    }, [iKSRepeat] = {
      aEditorPreviousObject, aEditorNextObject, aEditorCursorUp,
      aEditorCursorDown, aEditorCursorLeft, aEditorCursorRight,
      aEditorCycleLeft, aEditorCycleRight, aEditorMoveBack, aEditorMoveForward,
      aEditorMoveBottom, aEditorMoveTop, aEditorDelete, aEditorPaintTile
    -- Key release events
    }, [oStates.RELEASE] = {
      { oKeys.LEFT_SHIFT,
        CbKShiftRelease, "eedf", "DISABLE ALTERNATE FUNCTION" },
    }
  });
  -- Move the picker cursor ------------------------------------------------ --
  local function MovePCursor(iX, iY)
    -- Going backwards?
    if iX < 0 or iY < 0 then
      -- Calculate new id and clamp it if gone too far
      local iNewId = iPickerSelected + (iX + (iY * 20));
      if iNewId < 0 then iNewId = 0 end;
      -- Return failure if already at minimum
      if iPickerSelected == 0 then return end;
      iPickerSelected = iNewId;
    -- Going forwards?
    elseif iX > 0 or iY > 0 then
      -- Calculate new id and clamp it if gone too far
      local iNewId = iPickerSelected + (iX + (iY * 20));
      if iNewId >= #aTileData then iNewId = #aTileData end;
      -- Return failure if already at maximum
      if iPickerSelected == #aTileData then return end;
      iPickerSelected = iNewId;
    -- Not going anywhere
    else return PlayStaticSound(iSError) end;
    -- Cursor at top end of tiles?
    if iPickerSelected < 140 then
      iPickerStart = 0;
      iPickerSelX = iPickerSelected % 20 * 16;
      iPickerSelY = iPickerSelected // 20 * 16;
    -- Cursor in the middle of tiles?
    elseif iPickerSelected < 380 then
      local iOffset<const> = iPickerSelected - 140;
      iPickerStart = (iOffset // 20) * 20;
      iPickerSelX = iPickerSelected % 20 * 16;
      iPickerSelY = (iPickerSelected // 20 * 16) - ((iOffset // 20) * 16);
    -- Cursor at the end of tiles?
    else
      iPickerStart = 220;
      iPickerSelX = iPickerSelected % 20 * 16;
      iPickerSelY = (iPickerSelected // 20 * 16) - 176;
    end
  end
  -- Move the picker cursor events ----------------------------------------- --
  local function CbKPUpCursor() MovePCursor(0, -1) end;
  local function CbKPDownCursor() MovePCursor(0, 1) end;
  local function CbKPLeftCursor() MovePCursor(-1, 0) end;
  local function CbKPRightCursor() MovePCursor( 1, 0) end;
  local function CbKPHomeCursor() MovePCursor(-#aTileData, 0) end;
  local function CbKPEndCursor() MovePCursor(#aTileData, 0) end;
  local function CbKPPgUpCursor() MovePCursor(0, -5) end;
  local function CbKPPgDownCursor() MovePCursor(0, 5) end;
  -- Restore editor -------------------------------------------------------- --
  local function RestoreEditor()
    -- Restore editor callbacks
    SetCallbacks(EditorProc, EditorRender);
    -- Restore editor hotspot and keybank id
    SetHotSpot(iEditorHotSpotId);
    SetKeys(true, iEditorKeyBankId);
  end
  -- On picker mouse click callback ---------------------------------------- --
  local function OnPickerClick(iButton)
    -- If the cursor is in the main area?
    if iButton == 0 and iMouseX >= 0 and iMouseX < 320 then
      -- Set the requested tile to paint with
      iPaintTile = iPickerSelected;
      -- Play success selection sound
      PlayStaticSound(iSSelect);
    -- Play cancel sound
    else PlayStaticSound(iSClick) end;
    -- Restore editor callbacks
    RestoreEditor();
  end
  -- On picker mouse click callback ---------------------------------------- --
  local function OnObjPickerClick(iButton)
    -- If the cursor is in the main area?
    if iButton == 0 and iMouseX >= 0 and iMouseX < 320 then
      -- Set the requested tile to paint with
      SetPaintObject(aEditorTypes[1 + iPickerSelected]);
      -- Play success selection sound
      PlayStaticSound(iSSelect);
    -- Play cancel sound
    else PlayStaticSound(iSClick) end;
    -- Restore editor callbacks
    RestoreEditor();
  end
  -- Accept or cancel the selection event ---------------------------------- --
  local function CbKPObjSelect() OnObjPickerClick(0) end;
  local function CbKPTileSelect() OnPickerClick(0) end;
  local function CbKPEscape() PlayStaticSound(iSClick) RestoreEditor() end;
  -- Create key bind datas which are used more than once ------------------- --
  local aPickerCursorUp<const>, aPickerCursorDown<const>,
    aPickerCursorLeft<const>, aPickerCursorRight<const>, aPickerPageUp<const>,
    aPickerPageDown<const>, aPickerCancel<const>, aPickerHome<const>,
    aPickerEnd<const> =
      { oKeys.UP,        CbKPUpCursor,     "epup", "MOVE CURSOR UP" },
      { oKeys.DOWN,      CbKPDownCursor,   "epdn", "MOVE CURSOR DOWN" },
      { oKeys.LEFT,      CbKPLeftCursor,   "epl",  "MOVE CURSOR LEFT" },
      { oKeys.RIGHT,     CbKPRightCursor,  "epr",  "MOVE CURSOR RIGHT" },
      { oKeys.PAGE_UP,   CbKPPgUpCursor,   "eppu", "MOVE CURSOR UP A PAGE" },
      { oKeys.PAGE_DOWN, CbKPPgDownCursor, "eppd", "MOVE CURSOR DOWN A PAGE" },
      { oKeys.ESCAPE,    CbKPEscape,       "epsc", "CANCEL SELECTION" },
      { oKeys.HOME,      CbKPHomeCursor,   "eph",  "MOVE CURSOR TO HOME" },
      { oKeys.END,       CbKPEndCursor,    "epe",  "MOVE CURSOR TO END" };
  -- Register the new editor keyboard input events ------------------------- --
  iPickerKeyBankId = RegisterKeys("MAP TERRAIN PICKER", {
    -- Key pressed events
    [iKSPress] = {
      { oKeys.ENTER,  CbKPTileSelect, "epstt", "ACCEPT SELECTION" },
      aPickerCancel, aPickerHome, aPickerEnd, aPickerCursorUp,
      aPickerCursorDown, aPickerCursorLeft, aPickerCursorRight, aPickerPageUp,
      aPickerPageDown
    -- Key repeat events
    }, [iKSRepeat] = {
      aPickerCursorUp, aPickerCursorDown, aPickerCursorLeft,
      aPickerCursorRight, aPickerPageUp, aPickerPageDown
    }
  });
  -- Register the new object picker keyboard input events ------------------ --
  iObjPickerKeyBankId = RegisterKeys("MAP OBJECT PICKER", {
    -- Key pressed events
    [oStates.PRESS] = {
      { oKeys.ENTER,  CbKPObjSelect,  "epsot", "ACCEPT SELECTION" },
      aPickerCancel, aPickerHome, aPickerEnd, aPickerCursorUp,
      aPickerCursorDown, aPickerCursorLeft, aPickerCursorRight, aPickerPageUp,
      aPickerPageDown
    -- Key repeat events
    }, [iKSRepeat] = {
      aPickerCursorUp, aPickerCursorDown, aPickerCursorLeft,
      aPickerCursorRight, aPickerPageUp, aPickerPageDown
    }
  });
  -- On picker scroll wheel moved ------------------------------------------ --
  local function OnPickerScroll(nX, nY)
    -- Can we scroll backwards?
    if nY < 0 and iPickerStart < 220 then
      -- Scroll view of tiles backwards and play success sound
      iPickerStart = iPickerStart + 20;
    -- Scroll view of tiles forwards if we can
    elseif nY > 0 and iPickerStart >= 20 then
      -- Scroll view of tiles forwards and play success sound
      iPickerStart = iPickerStart - 20;
    end
  end
  -- On terrain picker mouse released (remove logic function) -------------- --
  local function OnPickerRelease() end;
  -- On terrain picker mouse hover callback -------------------------------- --
  local function OnPickerHover(...) OnPickerGenericHover(#aTileData, ...) end;
  -- Register terrain picker hot spots ------------------------------------- --
  iPickerHotSpotId = RegisterHotSpot({
    { 0, 0, 0, 240, 3, iCArrow, OnPickerHover, OnPickerScroll,
      { OnPickerRelease, OnPickerClick, false } }
  });
  -- On object picker mouse hover callback --------------------------------- --
  local function OnObjPickerHover(...)
    OnPickerGenericHover(#aEditorTypes, ...) end;
  -- Register object picker hot spots -------------------------------------- --
  iObjPickerHotSpotId = RegisterHotSpot({
    { 0, 0, 0, 240, 3, iCArrow, OnObjPickerHover, false,
      { OnPickerRelease, OnObjPickerClick, false } }
  });
  -- Build editor objects databases ---------------------------------------- --
  for iId = 1, #aEditorTypes do
    -- Grab the type
    local iObjId<const> = aEditorTypes[iId];
    -- Assign thumbnail to editor id to thumbnails array
    aEditorThumbs[iId] = oObjectData[iObjId].THUMBNAIL;
    -- Add a lookup for the type so we can convert it to an array id
    oEditorTypes[iObjId] = iId;
  end
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitEditor = InitEditor }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
