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
local format<const> = string.format;
-- Engine function aliases ------------------------------------------------- --
local UtilFormatNumber<const> = Util.FormatNumber;
-- Diggers function and data aliases --------------------------------------- --
local BlitSLT, GetMouseX, GetMouseY, GetViewportData, LoadLevel,
  PlayStaticSound, PrintC, RegisterFBUCallback,
  RenderFade, RenderObjects, RenderTerrain, SetCallbacks, SetHotSpot, SetKeys,
  oGlobalData, oObjectTypes, fontLarge, AdjustViewportNoScroll, SetCursor,
  GetAbsMousePos, IsSpriteCollide, aObjs, Print;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Assets required
      fontTiny,                        -- Tiny font
      iBrushPosX, iBrushPosY,          -- Brush position
      iBrushAPos,                      -- Brush absolute position
      iHotSpotId,                      -- Hot spot id
      iKeyBankId,                      -- Key bank id
      iLvlId,                          -- Level id
      iMouseX, iMouseY,                -- Mouse position
      iSSelect,                        -- Select sfx id
      iStageW, iStageH, iStageL,       -- Stage bounds
      iStageT, iStageR, iStageB,       -- Stage bounds
      iWinLimit,                       -- Win limit
      nStatusX, nStatusY,              -- Status position
      sLvlName,                        -- Level name
      sLvlType,                        -- Level type
      oObject,                         -- Selected object
      texSpr;                          -- Sprites texture
-- Viewport data ----------------------------------------------------------- --
local iPixPosX, iPixPosY, iPixPosTargetX, iPixPosTargetY, iPixCenPosX,
  iPixCenPosY, iPosX, iPosY, iAbsCenPosX, iAbsCenPosY, iViewportW, iViewportH,
  iVPX, iVPY, oPlrActive, oObjActive, oPlrOpponent;
-- Blank function ---------------------------------------------------------- --
local function BlankFunction() end
-- When fail assets have loaded? ------------------------------------------- --
local function EditorProc(aResources)
  -- Get viewport data
  iPixPosX, iPixPosY, iPixPosTargetX, iPixPosTargetY, iPixCenPosX,
    iPixCenPosY, iPosX, iPosY, iAbsCenPosX, iAbsCenPosY, iViewportW,
    iViewportH, iVPX, iVPY = GetViewportData();
--[[
  // Create pointer to objects list
  register POBJECT Object = App.Game.Object.First;
  // Create pointer to the mouse over object
  register POBJECT OverObject = NULL;

  // Objects exist
  if(Object)
  {
    // Walk objects list. Render object
    do
    {
      // Mouse is over this object?
      if(OverObject == NULL && Object->GETMCOLLISION())
      {
        // Set over object
        OverObject = Object;
        // Show tip
        ShowTip("OBJECT %s", Object->ObjData->Name);
      }
      // Render object and grab the next object
      Object = Object->RENDER();
    }
    // Goto next object
    while(Object);
  }

  // Browser activated?
  if(App.Game.Editor.Flags & EFL_BROWSER)
  {
    // Show title
    ShowTip("TILE AND OBJECT BROWSER");
    // Draw transparency
    App.Video.Tex.Trans->BLTFASTCUSTOM(8, 32, 0, 0, 304, 200, 0);
    // If escape pressed
    if(App.Input.Keyb.State[DIK_ESCAPE] & 1 || App.Input.Mouse.State[MID_MMB] & 1)
      // Close browser
      App.Game.Editor.Flags ^= EFL_BROWSER;
    // Scroll?
//    else if(App.Input.

    // Counters for tiles
    register INT X, Y;

    for(Y = 0; Y < 11; ++Y)
      for(X = 0; X < 18; ++X)
        App.Video.Tex.Terrain->BLT(16 + X * TILE_SIZE, 40 + Y * TILE_SIZE, Y * 18 + X + App.Game.Editor.BrowserStart);
  }
  // Browser not activated
  else
  {
    // If escape pressed
    if(App.Input.Keyb.State[DIK_ESCAPE] == 1)
      // Quit game
      CreateTransition(TRUE, (GAMEFUNC)QuitGame);
    // If user pressed F1?
    else if(App.Input.Keyb.State[DIK_F1] & 1 && App.Game.Level > 0)
    {
      // Previous level
      App.Game.NewLevel = App.Game.Level - 1;
      // Load previous level
      CreateTransition(TRUE, (GAMEFUNC)InitEditorProc);
    }
    // If user pressed F2?
    else if(App.Input.Keyb.State[DIK_F2] & 1 && App.Game.Level < LEVEL_NUM)
    {
      // Previous level
      App.Game.NewLevel = App.Game.Level + 1;
      // Load previous level
      CreateTransition(TRUE, (GAMEFUNC)InitEditorProc);
    }
    // Mouse is at left of screen
    else if(!App.Input.Mouse.Pos.X)
    {
      // Set left scroll arrow
      SetMouseCursor(CID_LEFT);
      // If button pressed?
      if(App.Input.Mouse.State[MID_LMB])
        // Scroll left
        SetViewport(App.Game.ViewPoint.X - 1, App.Game.ViewPoint.Y);
    }
    // Mouse is at the top of screen
    else if(!App.Input.Mouse.Pos.Y)
    {
      // Set top scroll arrow
      SetMouseCursor(CID_TOP);
      // If button pressed?
      if(App.Input.Mouse.State[MID_LMB])
        // Scroll left
        SetViewport(App.Game.ViewPoint.X, App.Game.ViewPoint.Y - 1);
    }
    // Mouse is at the right of screen
    else if(App.Input.Mouse.Pos.X == ASPECT_WIDTH - 1)
    {
      // Set right scroll arrow
      SetMouseCursor(CID_RIGHT);
      // If button pressed?
      if(App.Input.Mouse.State[MID_LMB])
        // Scroll left
        SetViewport(App.Game.ViewPoint.X + 1, App.Game.ViewPoint.Y);
    }
    // Mouse is at the bottom of screen
    else if(App.Input.Mouse.Pos.Y == ASPECT_HEIGHT - 1)
    {
      // Set right scroll arrow
      SetMouseCursor(CID_BOTTOM);
      // If button pressed?
      if(App.Input.Mouse.State[MID_LMB])
        // Scroll left
        SetViewport(App.Game.ViewPoint.X, App.Game.ViewPoint.Y + 1);
    }
    // Page up pressed or home held
    else if(App.Input.Keyb.State[DIK_HOME] || App.Input.Keyb.State[DIK_PRIOR] & 1)
      // Set previous tile
      App.Game.Editor.BrushTile = App.Game.Editor.BrushTile - 1 < 0 ? TILES_NUM - 1 : App.Game.Editor.BrushTile - 1;
    // Page down pressed or end held
    else if(App.Input.Keyb.State[DIK_END] || App.Input.Keyb.State[DIK_NEXT] & 1)
      // Set previous tile
      App.Game.Editor.BrushTile = App.Game.Editor.BrushTile + 1 >= TILES_NUM ? 0 : App.Game.Editor.BrushTile + 1;
    // Insert pressed
    else if(App.Input.Keyb.State[DIK_INSERT] & 1)
      // Set previous object
      App.Game.Editor.BrushObject = (OBJTYP)(App.Game.Editor.BrushObject - 1 < 0 ? TYP_MAX - 1 : App.Game.Editor.BrushObject - 1);
    // Delete pressed
    else if(App.Input.Keyb.State[DIK_DELETE] & 1)
      // Set next object
      App.Game.Editor.BrushObject = (OBJTYP)(App.Game.Editor.BrushObject + 1 >= TYP_MAX ? 0 : App.Game.Editor.BrushObject + 1);
    // Left or right bracket pressed
    else if(App.Input.Keyb.State[DIK_LBRACKET] & 1 || App.Input.Keyb.State[DIK_RBRACKET] & 1)
    {
      // Left bracket pressed?
      if(App.Input.Keyb.State[DIK_LBRACKET] & 1 && --App.Game.LevelScene >= SCENE_MAX) App.Game.LevelScene = SCENE_MAX - 1;
      // Right bracket pressed?
      else if(App.Input.Keyb.State[DIK_RBRACKET] & 1 && ++App.Game.LevelScene >= SCENE_MAX) App.Game.LevelScene = 0;
      // Free parallax and terrain textures
      delete App.Video.Tex.Terrain;
      delete App.Video.Tex.Parallax;
      // Reload parallax and terrain textures
      App.Video.Tex.Terrain = new TEXTURE((BMPID)(BMP_TSDESERT + App.Game.LevelScene), TILE_SIZE, TRUE);
      App.Video.Tex.Parallax = new TEXTURE((BMPID)(BMP_PLXDESERT + App.Game.LevelScene), 0, FALSE);
      // Init palette
      MergePalette(App.Video.Tex.Terrain, App.Video.Tex.Parallax);
      // Upload parallax and terrain textures
      App.Video.Tex.Terrain->UPLOAD(FALSE);
      App.Video.Tex.Parallax->UPLOAD(FALSE);
    }
    // Backspace pressed
    else if(App.Input.Keyb.State[DIK_BACK] & 1 && App.Game.Object.Active != NULL)
      // Delete the selected object
      delete App.Game.Object.Active;
    // Else
    else
    {
      // Mouse button pressed?
      if(App.Input.Mouse.State[MID_LMB])
      {
        // Mouse over an object
        if(OverObject != NULL)
        {
          // Object already selected and mouse button clicked?
          if(App.Game.Object.Active == OverObject && App.Input.Mouse.State[MID_LMB] & 1)
            // Make object the new brush
            App.Game.Editor.BrushObject = OverObject->Type;
          // Object not selected
          else
            // Select it
            OverObject->SELECT();
        }
        // Mouse not over an object
        else
        {
          // Get new tile position info
          register INT X = App.Game.ViewPoint.X + (App.Input.Mouse.Pos.X / TILE_SIZE);
          register INT Y = App.Game.ViewPoint.Y + (App.Input.Mouse.Pos.Y / TILE_SIZE);
          register INT P = (Y * LEVEL_WIDTH) + X;
          // Position changed?
          if(P != iBrushAPos)
            // Set new position
            iBrushPosX = X,
            iBrushPosY = Y,
            iBrushAPos = P;
          // Else if user clicked mouse?
          else if(App.Input.Mouse.State[MID_LMB] & 1)
            // Select new brush tile
            App.Game.Editor.BrushTile = App.Game.LevelData[P];
        }
      }
      // Middle mouse button pressed?
      if(App.Input.Mouse.State[MID_MMB] & 1)
        // Toggle browser
        App.Game.Editor.Flags ^= EFL_BROWSER;
      // Right mouse button pressed
      if(App.Input.Mouse.State[MID_RMB])
        // Replace tile
        App.Game.LevelData[iBrushAPos] = App.Game.Editor.BrushTile;
      // Set arrow cursor
      SetMouseCursor(CID_ARROW);
    }

    // Print selected tile
    App.Video.Tex.Interface->BLT((iBrushPosX - App.Game.ViewPoint.X) * TILE_SIZE, (iBrushPosY - App.Game.ViewPoint.Y) * TILE_SIZE, 116 + (App.Game.Time / 5 % 2));
    // Tab is not being held
    if(App.Input.Keyb.State[DIK_TAB] == 0)
    {
      App.Video.Tex.Trans->BLTFASTCUSTOM(216, 152, 32, 32, 128, 112, 0);

      // Print data
      App.Video.Tex.FontTiny->PRINT(220, 156, FALSE, "BRUSH TILE");
      App.Video.Tex.FontSmall->PRINTF(220, 164, FALSE, "%u/%03u", App.Game.LevelScene, App.Game.Editor.BrushTile);
      App.Video.Tex.Terrain->BLT(292, 156, App.Game.Editor.BrushTile);

      App.Video.Tex.FontTiny->PRINT(220, 176, FALSE, "BRUSH OBJECT");
      App.Video.Tex.FontSmall->PRINTF(220, 184, FALSE, "%02u %s", App.Game.Editor.BrushObject, ObjectData[App.Game.Editor.BrushObject].Name);
      App.Video.Tex.Sprite->BLT(292, 176, ObjectData[App.Game.Editor.BrushObject].ActData[ACT_STOP].DirData[DIR_R].AnimStart);

      App.Video.Tex.FontTiny->PRINT(220, 196, FALSE, "OBJECT SELECTED");
      if(App.Game.Object.Active != NULL)
      {
        // Print selected tile border
        App.Video.Tex.Interface->BLT((App.Game.Object.Active->PositionAbs.X - App.Game.ViewPoint.X) * TILE_SIZE, (App.Game.Object.Active->PositionAbs.Y - App.Game.ViewPoint.Y) * TILE_SIZE, 118 + (App.Game.Time / 5 % 2));
        App.Video.Tex.FontSmall->PRINTF(220, 204, FALSE, "X:%03u Y:%03u", App.Game.Object.Active->PositionAbs.X, App.Game.Object.Active->PositionAbs.Y);
        App.Video.Tex.Sprite->BLT(292, 196, App.Game.Object.Active->DirData->AnimStart);
      }
      else
        App.Video.Tex.FontSmall->PRINT(220, 204, FALSE, "NONE");

      App.Video.Tex.FontTiny->PRINTF(220, 216, FALSE, "V:%03ux%03u;
        M:%03ux%03u\nT:%03ux%03u (%05u) #%03u", App.Game.ViewPoint.X,
        App.Game.ViewPoint.Y, App.Input.Mouse.Pos.X, App.Input.Mouse.Pos.Y,
        iBrushPosX, iBrushPosY, iBrushAPos, App.Game.LevelData[iBrushAPos]);
    }
  }
--]]
end
-- When fail assets are being rendered? ------------------------------------ --
local function EditorRender(aResources)
  -- Render terrain
  RenderTerrain();
  -- Render objects
  RenderObjects();
  -- Draw status panel
  RenderFade(0.75, nStatusX, nStatusY, nStatusX + 96.0, nStatusY + 80.0);
  -- Draw mouse position
  PrintC(fontTiny, nStatusX + 48.0, nStatusY + 64.0,
    format("V:%03ux%03u; M:%03ux%03u\n\z
            T:%03ux%03u (%05u) #%03u",
    iVPX, iVPY, iPixPosX + iMouseX, iPixPosY + iMouseY, iBrushPosX, iBrushPosY, iBrushAPos, 0));
  if oObject then
    -- Print selected tile border
    BlitSLT(texSpr, oObject.S, nStatusX + 4.0, nStatusY + 4.0);
    PrintC(fontTiny, nStatusX + 58.0, nStatusY + 4.0,
      format("%s\n\z
              I:%03u L:%03ux%03u\n\z
              T:%02u A:%03ux%03u", oObject.OD.LONGNAME, oObject.U,
              oObject.X, oObject.Y, oObject.ID, oObject.AX, oObject.AY));
  else
    BlitSLT(texSpr, 864, nStatusX + 4, nStatusY + 4);
    PrintC(fontTiny, nStatusX + 58.0, nStatusY + 9.0, "NO SELECTION!");
  end
  -- Selected?
  if iBrushPosX >= iPixPosX and
     iBrushPosY >= iPixPosY and
     iBrushPosX < iViewportW and
     iBrushPosY < iViewportH then
    BlitSLT(texSpr, 866 + ((Core.Ticks() // 2) % 2),
                         iStageL + (iVPX * 16),
                         iStageT + (iVPY * 16));
  end
end
-- When stage updated ------------------------------------------------------ --
local function OnStageUpdated(...)
  -- Set new stage bounds
  iStageW, iStageH, iStageL, iStageT, iStageR, iStageB = ...;
  -- Set status position
  nStatusX, nStatusY = iStageR - (96.0 + 8.0), iStageB - (80.0 + 8.0);
end
-- When level loaded ------------------------------------------------------- --
local function OnLoad(...)
  -- Initialise level variables
  iLvlId, sLvlName, sLvlType, iWinLimit = ...;
  -- Reset brush position
  iBrushPosX, iBrushPosY, iBrushAPos = 0, 0, 0;
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
  LoadLevel(1, nil, nil, nil, true, oObjectTypes.DIGRANDOM,
    true, EditorProc, EditorRender, BlankFunction, iHotSpotId, nil, nil, true,
    OnLoad);
end
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, oCursorIdData, oSfxData;
  -- Grab imports
  BlitSLT, GetMouseX, GetMouseY, GetViewportData, LoadLevel, PlayStaticSound, PrintC, RegisterFBUCallback,
    RenderFade, RegisterHotSpot,
    RegisterKeys, RenderObjects, RenderTerrain, SetCallbacks, SetHotSpot,
    SetKeys, oCursorIdData, oObjectTypes, oSfxData, fontLarge, fontTiny,
    texSpr, AdjustViewportNoScroll, SetCursor, GetAbsMousePos,
    IsSpriteCollide, aObjs, Print =
      GetAPI("BlitSLT", "GetMouseX", "GetMouseY", "GetViewportData", "LoadLevel", "PlayStaticSound", "PrintC",
        "RegisterFBUCallback",
        "RenderFade",
        "RegisterHotSpot", "RegisterKeys", "RenderObjects", "RenderTerrain",
        "SetCallbacks", "SetHotSpot", "SetKeys", "oCursorIdData",
        "oObjectTypes", "oSfxData", "fontLarge", "fontTiny", "texSpr",
        "AdjustViewportNoScroll", "SetCursor", "GetAbsMousePos",
        "IsSpriteCollide", "aObjs", "Print");
  local function OnHover(...)
    iMouseX, iMouseY = ...;
    iMouseX = iMouseX - iStageL;
    iMouseY = iMouseY - iStageT;
  end
  local function OnMouseClick(iButton, iX, iY)
    if iButton == 0 then
      -- Get absolute mouse position on level
      local iAMX<const>, iAMY<const> = GetAbsMousePos();
      -- Walk through objects
      for iIndex = 1, #aObjs do
        -- Get object data and if cursor overlapping it ?
        local oObj<const> = aObjs[iIndex];
        if IsSpriteCollide(479, iAMX, iAMY, oObj.S, oObj.X, oObj.Y) then
          -- Set tip with name and health of object
          oObject = oObj;
          -- Done
          return;
        end
      end
      -- Set generic message
      oObject = nil;

      iBrushPosX, iBrushPosY = (iVPX//16) + (iX // 16),
                               (iVPY//16) + (iY // 16);
      iBrushAPos = (iBrushPosY * 128) + iBrushPosX;
    end
  end
  -- On mouse pressed -------------------------------------------------------- --
  local function OnPress() end
  -- On mouse released (remove logic function) ------------------------------- --
  local function OnRelease() end;
  -- Cursor drag event ------------------------------------------------------- --
  local function OnDrag(iButton, _, _, iMoveX, iMoveY)
    -- Right click held?
    if iButton == 1 then
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
