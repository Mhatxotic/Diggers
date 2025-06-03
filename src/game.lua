-- GAME.LUA ================================================================ --
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
local abs<const>, ceil<const>, error<const>, floor<const>, format<const>,
  max<const>, maxinteger<const>, min<const>, pairs<const>, random<const>,
  remove<const>, tostring<const> =
    math.abs, math.ceil, error, math.floor, string.format, math.max,
    math.maxinteger, math.min, pairs, math.random, table.remove, tostring;
-- M-Engine function aliases ----------------------------------------------- --
local CoreLog<const>, CoreQuit<const>, CoreWrite<const>, CoreTicks<const>,
  CoreTime<const>, MaskCreateZero<const>, UtilClamp<const>,
  UtilClampInt<const>, UtilFormatNumber<const>, UtilIsBoolean<const>,
  UtilIsFunction<const>, UtilIsInteger<const>, UtilIsString<const>,
  UtilIsTable<const>, UtilRound<const> =
    Core.Log, Core.Quit, Core.WriteEx, Core.Ticks, Core.Time,
    Mask.CreateZero, Util.Clamp, Util.ClampInt, Util.FormatNumber,
    Util.IsBoolean, Util.IsFunction, Util.IsInteger, Util.IsString,
    Util.IsTable, Util.Round;
-- Assets required --------------------------------------------------------- --
local aAssetsMusic, aAssetsNoMusic, aAssetsContinue;
-- Diggers shared functions and data --------------------------------------- --
local ACT, AI, BlitSLTRB, BlitSLT, DF, DIR, Fade, GetMouseX, GetMouseY,
  GetTestMode, InitBook, InitLobby, InitLose, InitLoseDead, InitPause,
  InitTNTMap, InitWin, InitWinDead, IsMouseInBounds, JOB, LoadResources, MFL,
  MNU, OFL, PlayMusic, PlaySound, PlayStaticSound, Print, PrintC, PrintR,
  RegisterFBUCallback, RenderFade, RenderShadow, RenderTip, SetCallbacks,
  SetCursor, SetCursorPos, SetHotSpot, SetKeys, SetTip, TileA, TYP,
  aAIChoicesData, aDigBlockData, aDigData, aDigTileData, aDugRandShaftData,
  aExplodeAboveData, aExplodeDirData, aFloodGateData, aGlobalData,
  aJumpFallData, aJumpRiseData, aLevelsData, aMenuData, aObjectData, aSfxData,
  aShopData, aShroudCircle, aShroudTileLookup, aTileData, aTileFlags,
  aTimerData, aTrainTrackData, iSlowDown, iSavedSlowDown, fontLarge,
  fontLittle, fontTiny, iPosX, iPosY, texSpr;
-- High priority variables (because of MAXVARS limit) ---------------------- --
local function HighPriorityVars()
-- Prototype functions (assigned later) ------------------------------------ --
local CreateObject, MoveOtherObjects, PlayInterfaceSound, PlaySoundAtObject,
  SetAction;
-- Locals ------------------------------------------------------------------ --
local aActiveObject, aActivePlayer, aContextMenu, aContextMenuData, aFloodData,
  aGemsAvailable, aLevelData, aObjects, aOpponentPlayer, aPlayers, aRacesData,
  aRacesAvailable, aShroudColour, aShroudData, bAIvsAI, fcbInfoScreenCallback,
  fcbLogic, fcbRender, iAbsCenPosX, iAbsCenPosY, iAnimMoney, iGameTicks,
  iHotSpotId, iKeyBankId, iLevelId, iLLAbsHmVP, iLLAbsWmVP, iLLPixHmVP,
  iLLPixWmVP, iMenuLeft, iMenuTop, iMenuRight, iMenuBottom, iPixCenPosX,
  iPixCenPosY, iPixPosTargetX, iPixPosTargetY, iPixPosX, iPixPosY, iScrTilesH,
  iScrTilesHd2, iScrTilesHd2p1, iScrTilesHm1, iScrTilesHmVPS, iScrTilesW,
  iScrTilesWd2, iScrTilesWd2p1, iScrTilesWm1, iScrTilesWmVPS, iScrollRate,
  iStageB, iStageH, iStageL, iStageR, iStageT, iStageW, iTilesHeight,
  iTilesWidth, iUniqueId, iViewportH, iViewportW, iWinLimit, maskLev, maskSpr,
  maskZone, sLevelName, sLevelType, sMoney, texBg, texLev =
    nil, nil, nil, nil, { }, { }, { }, { }, nil, { }, { }, { }, nil, { }, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil, nil;
-- Level limits ------------------------------------------------------------ --
local iLLAbsW<const>   = 128;                -- Total # of horizontal tiles
local iLLAbsH<const>   = 128;                -- Total # of vertical tiles
local iLLAbsWm1<const> = iLLAbsW - 1;        -- Horizontal tiles minus one
local iLLAbsHm1<const> = iLLAbsH - 1;        -- Vertical tiles minus one
local iLLAbs<const>    = iLLAbsW * iLLAbsH;  -- Total # of tiles in level
local iLLAbsM1<const>  = iLLAbs - 1;         -- Total tiles minus one
local iLLAbsMLW<const> = iLLAbs - iLLAbsW;   -- Total tiles minus one row
local iLLPixW<const>   = iLLAbsW * 16;       -- Total # of horizontal pixels
local iLLPixH<const>   = iLLAbsH * 16;       -- Total # of vertical pixels
local iLLPixWm1<const> = iLLPixW - 1;        -- Total H pixels minus one
local iLLPixHm1<const> = iLLPixH - 1;        -- Total V pixels minus one
-- Other consts ------------------------------------------------------------ --
local iVPScrollThreshold<const> = 4;         -- Limit before centring viewport
-- Bounds checking sprite blitter ------------------------------------------ --
local function BCBlit(iTexIndex, iLeft, iTop, iRight, iBottom)
  -- Draw only if not occluded outside the viewport
  if min(iRight, iStageR) > max(iLeft, iStageL) or
     min(iBottom, iStageB) > max(iTop, iStageT) then
    BlitSLTRB(texSpr, iTexIndex, iLeft, iTop, iRight, iBottom) end;
end
-- Function to play a sound ------------------------------------------------ --
local function DoPlaySoundAtObject(aObject, iSfxId, nPitch)
  -- Check that object is in the players view
  local nX<const> = (aObject.X / 16) - iPosX;
  if nX < -1 or nX > iScrTilesW then return end;
  local nY<const> = (aObject.Y / 16) - iPosY;
  if nY < -1 or nY > iScrTilesH then return end;
  -- Play the sound and clamp the pan value as engine requires
  PlaySound(iSfxId, UtilClamp(-1 + ((nX / iScrTilesW) * 2), -1, 1), nPitch);
end
-- Enable or disable playing sounds ---------------------------------------- --
local function BlankFunction() end;
local function SetPlaySounds(bState)
  if bState then PlaySoundAtObject, PlayInterfaceSound =
    DoPlaySoundAtObject, PlayStaticSound;
  else PlaySoundAtObject, PlayInterfaceSound =
    BlankFunction, BlankFunction end;
end
-- Update viewport data ---------------------------------------------------- --
local function UpdateViewPort(nPos, iTLMVPS, iTTD2, iTT, iTL)
  -- Obey limits of level
  if nPos > iTLMVPS then nPos = iTLMVPS elseif nPos < 0 then nPos = 0 end;
  -- Reuse limit and calculate centre tile
  iTLMVPS = nPos // 16;
  -- Return calculated results
  return nPos,                    -- iPixPos[X|Y]    (Abs position)
         -(nPos % 16),            -- iPixCenPos[X|Y] (Pixel centre)
         iTLMVPS,                 -- iPos[X|Y]       (Tile position)
         iTLMVPS + iTTD2,         -- iAbsCenPos[X|Y] (Centre tile position)
         min(iTLMVPS + iTT, iTL); -- iViewport[W|H]  (Scroll pos)
end
-- Update horizontal viewport data ----------------------------------------- --
local function SetViewPortX(nX)
  iPixPosX, iPixCenPosX, iPosX, iAbsCenPosX, iViewportW =
    UpdateViewPort(nX, iLLPixWmVP, iScrTilesWd2, iScrTilesW, iLLAbsW);
  if iPixCenPosX < 0 then iTilesWidth = iScrTilesW;
                     else iTilesWidth = iScrTilesWm1 end;
end
-- Update vertical viewport data ------------------------------------------- --
local function SetViewPortY(nY)
  iPixPosY, iPixCenPosY, iPosY, iAbsCenPosY, iViewportH =
    UpdateViewPort(nY, iLLPixHmVP, iScrTilesHd2,
      iScrTilesH, iLLAbsWm1);
  if iPixCenPosY < 0 then iTilesHeight = iScrTilesH;
                     else iTilesHeight = iScrTilesHm1 end;
end
-- Adjust viewport --------------------------------------------------------- --
local function AdjustViewPortX(iX) SetViewPortX(iPixPosX + iX) end;
local function AdjustViewPortY(iY) SetViewPortY(iPixPosY + iY) end;
-- Scroll viewport --------------------------------------------------------- --
local function ProcessViewPort()
  -- Move horizontally if not over requested viewport
  if iPixPosTargetX < iPixPosX then
    AdjustViewPortX(-ceil((iPixPosX - iPixPosTargetX) / iScrollRate));
  elseif iPixPosTargetX > iPixPosX then
    AdjustViewPortX(ceil((iPixPosTargetX - iPixPosX) / iScrollRate)) end;
  -- Move vertically if not over requested viewport
  if iPixPosTargetY < iPixPosY then
    AdjustViewPortY(-ceil((iPixPosY - iPixPosTargetY) / iScrollRate));
  elseif iPixPosTargetY > iPixPosY then
    AdjustViewPortY(ceil((iPixPosTargetY - iPixPosY) / iScrollRate)) end;
end
-- Update new viewport ----------------------------------------------------- --
local function SetViewPort(iX, iY) SetViewPortX(iX) SetViewPortY(iY) end
-- Set instant focus on object horizontally -------------------------------- --
local function ScrollViewPortTo(iX, iY)
  iPixPosTargetX, iPixPosTargetY =
    UtilClampInt(iX, 0, iLLAbsWmVP) * 16,
    UtilClampInt(iY, 0, iLLAbsHmVP) * 16;
end
-- Force viewport position without scrolling ------------------------------- --
local function ForceViewport() SetViewPort(iPixPosTargetX, iPixPosTargetY) end;
-- Lock viewport to top left ----------------------------------------------- --
local function LockViewPort() ScrollViewPortTo(0, 0) ForceViewport() end;
-- Focus on object --------------------------------------------------------- --
local function ObjectFocus(aObj)
  -- This object is not selected? Ignore it
  if aActiveObject ~= aObj then return end;
  -- Get object absolute position
  local iX<const>, iY<const> = aObj.AX, aObj.AY;
  -- Object is almost out of the viewport?
  if (iPosX > 0 and                             -- VP not left edge? *and*
      iX - iVPScrollThreshold < iPosX) or       -- ...Near off left VP? *or*
     (iPosX < iLLAbsWmVP and                    -- ...VP not right edge? *and*
      iX + iVPScrollThreshold >= iViewportW) or -- ...Near right VP? *or*
     (iPosY > 0 and                             -- ...VP not top edge? *and*
      iY - iVPScrollThreshold < iPosY) or       -- ...Near top VP? *or*
     (iPosY < iLLAbsHmVP and                    -- ...VP not bottom edge? *and*
      iY + iVPScrollThreshold >= iViewportH) then -- ...Near bottom VP?
    -- Gradually scroll to this position centred on the object
    ScrollViewPortTo(iX - iScrTilesWd2, iY - iScrTilesHd2);
    -- If we're already off the end of the screen?
    if (abs(iX - iAbsCenPosX) > iScrTilesWd2p1 or
        abs(iY - iAbsCenPosY) > iScrTilesHd2p1) and not bAIvsAI then
      -- Set instant focus on object horizontally
      ForceViewport();
    end
  end
end
-- Get mouse position on level --------------------------------------------- --
local function GetAbsMousePos()
  return GetMouseX() - iStageL + iPixPosX, GetMouseY() - iStageT + iPixPosY;
end
-- Update object menu position --------------------------------------------- --
local function UpdateMenuPosition(iX, iY)
  -- Get menu size (reuse vars)
  iMenuRight, iMenuBottom = aContextMenu[1] * 16, aContextMenu[2] * 16;
  -- Update left and top co-ordinates
  iMenuLeft, iMenuTop =
    UtilClampInt(iX, iStageL, iStageR - iMenuRight),
    UtilClampInt(iY, iStageT, iStageB - iMenuBottom - 32);
  -- Update right and bottom co-ordinates
  iMenuRight, iMenuBottom = iMenuRight + iMenuLeft, iMenuBottom + iMenuTop;
  -- Get context menu item data
  local aMData<const> = aContextMenu[3];
  -- Start building context menu data to help with rendering
  aContextMenuData = { };
  -- Current position of title
  local iX, iY = iMenuLeft, iMenuTop;
  -- Walk through selected menu
  for iMIndex = 1, #aMData do
    -- Get menu item data
    local aMItem<const> = aMData[iMIndex];
    -- Build formatted item which helps processing more efficent
    aContextMenuData[1 + #aContextMenuData] = {
      aMItem,                    -- Actual data
      aMItem[1],                 -- Menu tile id
      aMItem[2] & MFL.BUSY ~= 0, -- Disabled if busy?
      iX,                        -- Menu render position X
      iY,                        -- Menu render position Y
      iX + 16,                   -- Menu render position end X
      iY + 16                    -- Menu render position end Y
    };
    -- Increment tile position and wrap the
    iX = iX + 16;
    if iX >= iMenuRight then iX, iY = iMenuLeft, iY + 16 end;
  end
end
-- Update object menu position with current mouse -------------------------- --
local function UpdateMenuPositionAtMouseCursor()
  UpdateMenuPosition(GetMouseX(), GetMouseY());
end
-- Set active object menu -------------------------------------------------- --
local function SetContextMenu(iId, bUpdatePos)
  -- Hide the menu?
  if not iId then aContextMenu, aContextMenuData = nil, nil return end;
  -- Get requested context menu and if it is a different context menu?
  aContextMenu = aMenuData[iId];
  if not UtilIsTable(aContextMenu) then
    error("Invalid menu data for "..iId.."! "..tostring(aContextMenu)) end;
  -- Update menu position if requested
  if bUpdatePos then UpdateMenuPositionAtMouseCursor();
  -- Just update menu size
  else UpdateMenuPosition(iMenuLeft, iMenuTop) end;
end
-- Select an object -------------------------------------------------------- --
local function SelectObject(aObj, bNow, bCursor)
  -- Save active object
  local aObjActive<const> = aActiveObject;
  -- Set active object and remove menu if different object
  aActiveObject = aObj;
  if aActiveObject ~= aObjActive then SetContextMenu() end;
  -- Return if no object to focus on
  if not aObj then return end;
  -- Focus on object
  ObjectFocus(aObj)
  -- Do it now instead of animated?
  if bNow then ForceViewport() end;
  -- Also set the cursor?
  if bCursor then
    SetCursorPos(aObj.X - (iPixPosX - iStageL) + aObj.OFX + 8,
                 aObj.Y - (iPixPosY - iStageT) + aObj.OFY + 8) end;
end
-- Return game ticks ------------------------------------------------------- --
local function GetGameTicks() return iGameTicks end;
-- Render an information frame --------------------------------------------- --
local function DrawInfoFrameAndTitle(iTileId)
  -- Draw the left part of the title bar
  BlitSLT(texSpr, 847, 8, 8);
  -- Draw the middle part of the title bar
  for iColumn = 1, 17 do BlitSLT(texSpr, 848, 8 + (iColumn * 16), 8) end;
  -- Draw the right part of the title bar
  BlitSLT(texSpr, 849, 296, 8);
  -- Draw transparent backdrop
  RenderFade(0.75, 8, 32, 312, 208);
  -- Draw frame around transparent backdrop
  BlitSLT(texSpr, 850, 8, 32);
  for iX = 24, 280, 16 do BlitSLT(texSpr, 851, iX, 32) end;
  BlitSLT(texSpr, 852, 296, 32);
  for iY = 48, 176, 16 do
    BlitSLT(texSpr, 856, 8, iY);
    BlitSLT(texSpr, 858, 296, iY);
  end
  BlitSLT(texSpr, 853, 8, 192);
  for iX = 24, 280, 16 do BlitSLT(texSpr, 854, iX, 192) end;
  BlitSLT(texSpr, 855, 296, 192);
  -- Draw shadows
  RenderShadow(8, 8, 312, 24);
  RenderShadow(8, 32, 312, 208);
  -- Print the title bar text
  PrintC(fontLittle, 160, 12, iTileId);
end
-- Draw health bar --------------------------------------------------------- --
local function DrawHealthBar(iHealth, iDivisor, iL, iT, iR, iB)
  -- White (100%) to green bar (50%)
  if iHealth >= 50 then
    texSpr:SetCRGB(1, 1, (iHealth - 50) / 50);
    BlitSLTRB(texSpr, 1022, iL, iT, iR + iHealth / iDivisor, iB);
    texSpr:SetCRGB(1, 1 ,1);
  -- Green (50%) to red bar (0%)
  elseif iHealth > 0 then
    texSpr:SetCRGB(1, iHealth / 50, 0);
    BlitSLTRB(texSpr, 1022, iL, iT, iR + iHealth / iDivisor, iB);
    texSpr:SetCRGB(1, 1 ,1);
  end
end
-- Select info screens ----------------------------------------------------- --
local function SelectInfoScreen()
  -- Draw digger inventory
  local function InfoScreenRenderInventory()
    -- Draw frame and title
    DrawInfoFrameAndTitle("DIGGER INVENTORY");
    -- Set tiny font spacing and colour
    fontTiny:SetLSpacing(2);
    fontTiny:SetCRGB(0, 0.75, 1);
    -- For each digger
    for iDiggerId = 1, #aActivePlayer.D do
      -- Calculate Y position
      local iY<const> = iDiggerId * 33;
      -- Print id number of digger
      Print(fontLarge, 16, iY + 8, iDiggerId);
      -- Draw health bar background
      BlitSLTRB(texSpr, 1023, 24, iY + 31, 291, iY + 33);
      -- Get Digger data and if it exists?
      local aDigger<const> = aActivePlayer.D[iDiggerId];
      if aDigger then
        -- Draw digger health bar
        DrawHealthBar(aDigger.H, 0.375, 24, iY + 31, 24, iY + 33);
        -- Draw digger portrait
        BlitSLT(texSpr, aDigger.S, 31, iY + 8);
        -- Digger has items?
        if aDigger.IW > 0 then
          -- Get digger inventory and enumerate through it and draw it
          local aInventory<const> = aDigger.I;
          for iInvIndex = 1, #aInventory do
            BlitSLT(texSpr, aInventory[iInvIndex].S,
              iInvIndex * 16 + 32, iY + 8) end;
        -- No inventory. Print no inventory message
        else Print(fontTiny, 48, iY + 13, "NOT CARRYING ANYTHING") end;
        -- Draw weight and impatience
        PrintR(fontLittle, 308, iY + 4,
          format("%03u%%          %03u%%\n\z
                  %03u%%         %05u\n\z
                  %04u          %03u%%",
            aDigger.H, floor(aDigger.IW / aDigger.STR * 100),
            max(0, floor(aDigger.JT / aDigger.PL * 100)), aDigger.DUG,
            aDigger.GEM, ceil(aDigger.LDT / iGameTicks * 100)));
      -- Digger is dead
      else
        -- Draw grave icon
        BlitSLT(texSpr, 319, 31, iY + 8);
        -- Draw dead labels
        PrintR(fontLittle, 308, iY + 4,
          "---%          ---%\n\z
           ---%         -----\n\z
           ----          ---%");
      end
      -- Draw labels
      fontTiny:SetLSpacing(2);
      PrintR(fontTiny, 308, iY + 5,
        "HEALTH:             WEIGHT:        \n\z
         IMPATIENCE:         GROADS DUG:        \n\z
         GEMS FOUND:         EFFICIENCY:        ");
    end
    -- Reset tiny font spacing
    fontTiny:SetLSpacing(0);
  end
  -- Draw digger locations
  local function InfoScreenRenderLocations()
    -- Draw frame and title
    DrawInfoFrameAndTitle("DIGGER LOCATIONS");
    -- Draw map grid of level
    for Y = 37, 188, 15 do for X = 141, 291, 15 do
      BlitSLT(texSpr, 864, X, Y);
    end end
    -- For each digger
    for iDiggerId = 1, #aActivePlayer.D do
      -- Calculate Y position
      local iY<const> = iDiggerId * 31;
      -- Print id number of digger
      Print(fontLarge, 16, iY + 8, iDiggerId);
      -- Draw colour key of digger
      BlitSLT(texSpr, 858 + iDiggerId, 31, iY + 11);
      -- Draw X and Y letters
      fontTiny:SetCRGB(0, 0.75, 1);
      Print(fontTiny, 64, iY + 8, "X:       Y:");
      -- Draw health bar background
      BlitSLTRB(texSpr, 1023, 24, iY + 30, 124, iY + 32);
      -- Get digger and if it exists?
      local aDigger<const> = aActivePlayer.D[iDiggerId];
      if aDigger then
        -- Draw digger health bar
        DrawHealthBar(aDigger.H, 1, 24, iY + 30, 24, iY + 32);
        -- Draw digger item data
        Print(fontLittle, 72, iY + 8,
          format("%04u  %04u\n\\%03u  \\%03u",
            aDigger.X, aDigger.Y, aDigger.AX, aDigger.AY));
        -- Draw digger portrait
        BlitSLT(texSpr, aDigger.S, 43, iY + 8);
        -- Draw position of digger
        BlitSLT(texSpr, 858 + iDiggerId, 141 + (aDigger.AX * 1.25),
          38 + (aDigger.AY * 1.25));
      -- Digger is dead
      else
        -- Draw grave icon
        BlitSLT(texSpr, 319, 43, iY + 8);
        -- Draw dashes for unavailable digger item data
        Print(fontLittle, 72, iY + 8, "----  ----\n\\---  \\---");
      end
    end
  end
  -- Draw digger locations
  local function InfoScreenRenderStatus()
    -- Draw frame and title
    DrawInfoFrameAndTitle("ZONE STATUS");
    -- Score for who is winning
    local ScoreAP, ScoreOP = 0, 0;
    -- Draw little labels first for rendering performance. Print level info
    Print(fontLittle, 16, 56, sLevelType.." TERRAIN");
    PrintR(fontLittle, 304, 56, "OPERATIONS TIME");
    local iPDiggers<const> = aActivePlayer.DC;
    PrintC(fontLittle, 160, 88, "YOU HAVE "..iPDiggers.." OF "..
      aActivePlayer.DT.." DIGGERS REMAINING");
    -- Draw who has the most diggers
    local iODiggers<const>, sDiggers = aOpponentPlayer.DC;
    if iPDiggers > iODiggers then
      ScoreAP, sDiggers = ScoreAP + 1,
        "YOU HAVE MORE DIGGERS THEN YOUR OPPONENT";
    elseif iPDiggers < iODiggers then
      ScoreOP, sDiggers = ScoreOP + 1, "YOUR OPPONENT HAS MORE DIGGERS";
    else sDiggers = "YOU AND YOUR OPPONENT HAVE EQUAL DIGGERS" end;
    PrintC(fontLittle, 160, 96, sDiggers);
    -- Show who has mined the most terrain
    local iPDug, iODug<const> = aActivePlayer.DUG, aOpponentPlayer.DUG;
    PrintC(fontLittle, 160, 112, "YOU MINED "..
      UtilFormatNumber(aActivePlayer.GEM, 0)..
      " GEMS AND "..UtilFormatNumber(iPDug, 0).." GROADS OF TERRAIN");
    local sMined;
    if iPDug > iODug then sMined = "YOU HAVE MINED THE MOST TERRAIN";
    elseif iPDug < iODug then
      sMined = "YOUR OPPONENT HAS MINED THE MOST TERRAIN";
    else sMined = "YOU AND YOUR OPPONENT HAVE MINED EQUAL TERRAIN" end;
    PrintC(fontLittle, 160, 120, sMined);
    -- Draw who has found the most gems
    local iPGems<const>, iOGems<const>, sGems =
      aActivePlayer.GEM, aOpponentPlayer.GEM;
    if iPGems > iOGems then sGems = "YOU HAVE FOUND THE MOST GEMS";
    elseif iPGems < iOGems then
      sGems = "YOUR OPPONENT HAS FOUND THE MOST GEMS";
    else sGems = "YOU AND YOUR OPPONENT HAVE FOUND EQUAL GEMS" end;
    PrintC(fontLittle, 160, 128, sGems);
    -- Draw who has the most zogs
    local iPlayerMoney<const> = aActivePlayer.M;
    PrintC(fontLittle, 160,  146, "YOU HAVE RAISED "..
      UtilFormatNumber(iPlayerMoney, 0)..
      " OF "..iWinLimit.." ZOGS ("..
      UtilFormatNumber(iPlayerMoney/iWinLimit*100, 0).."%)");
    local iOpponentMoney<const> = aOpponentPlayer.M;
    local sZogs;
    if iPlayerMoney > iOpponentMoney then
      ScoreAP, sZogs = ScoreAP + 1, "YOU HAVE THE MOST ZOGS";
    elseif iPlayerMoney < iOpponentMoney then
      ScoreOP, sZogs = ScoreOP + 1, "YOUR OPPONENT HAS MORE ZOGS";
    else sZogs = "YOU AND YOUR OPPONENT HAVE EQUAL ZOGS" end;
    PrintC(fontLittle, 160, 154, sZogs);
    PrintC(fontLittle, 160, 162, "RAISE "..
      UtilFormatNumber(iWinLimit-iPlayerMoney, 0).." MORE ZOGS TO WIN");
    -- Draw prediction
    local sPName<const>, sOName<const>, sWinning =
      aActivePlayer.RD.NAME, aOpponentPlayer.RD.NAME;
    if ScoreAP > ScoreOP then sWinning = sPName;
    elseif ScoreAP < ScoreOP then sWinning = sOName;
    else sWinning = "NOBODY" end;
    PrintC(fontLittle, 160, 178, "THE TRADE CENTRE HAS PREDICTED");
    -- Draw large labels now
    Print(fontLarge, 16, 40, sLevelName);
    PrintR(fontLarge, 304, 40, format("%02u:%02u:%02u",
      iGameTicks // 216000 % 24,
      iGameTicks // 3600 % 60,
      iGameTicks // 60 % 60));
    PrintC(fontLarge, 160, 72, sPName.." VS "..sOName);
    PrintC(fontLarge, 160, 186, sWinning.." IS WINNING");
  end
  -- Inventory button pressed?
  local aInfoScreenData<const> = {
    { 248, 216, 815, 816, InfoScreenRenderInventory },
    { 264, 216, 817, 818, InfoScreenRenderLocations },
    { 280, 216, 802, 803, InfoScreenRenderStatus },
    { 296, 216, 819, 820, BlankFunction }
  };
  -- Active screen item
  local aInfoScreenActiveItem;
  -- Button disabled function
  local function InfoScreenEnabled()
    -- Enumerate each button
    for iIndex = 1, #aInfoScreenData do
      -- Get info screen item and if its the active button?
      local aInfoScreenItem<const> = aInfoScreenData[iIndex];
      if aInfoScreenItem == aInfoScreenActiveItem then
        -- Draw enabled button
        BlitSLT(texSpr, aInfoScreenItem[4],
          aInfoScreenItem[1], aInfoScreenItem[2])
        -- Set font colours
        fontTiny:SetCRGB(1, 1, 1);
        fontLarge:SetCRGB(1, 1, 1);
        fontLittle:SetCRGB(1, 1, 1);
        -- Execute render function
        aInfoScreenItem[5]();
      -- Inactive so draw disabled button
      else BlitSLT(texSpr, aInfoScreenItem[3],
        aInfoScreenItem[1], aInfoScreenItem[2]) end;
    end
  end
  -- Button disabled function
  local function InfoScreenDisabled()
    -- Enumerate each button
    for iIndex = 1, #aInfoScreenData do
      -- Get info screen item
      local aInfoScreenItem<const> = aInfoScreenData[iIndex];
      -- Draw disabled button
      BlitSLT(texSpr, aInfoScreenItem[3],
        aInfoScreenItem[1], aInfoScreenItem[2]);
    end
  end
  -- Actual function
  local function SelectInfoScreen(iScreen)
    -- Reset?
    if iScreen == nil then
      -- Disable it
      aInfoScreenActiveItem = nil;
      fcbInfoScreenCallback = InfoScreenDisabled;
      -- Done
      return;
    end
    -- Check parameter
    if not UtilIsInteger(iScreen) or
           iScreen < 1 or
           iScreen > #aInfoScreenData then
      error("Invalid screen! "..tostring(iScreen)) end
    -- Play sound effect to show the player clicked it
    PlayInterfaceSound(aSfxData.CLICK);
    -- Get the screen info data and if we're already showing it?
    local aInfoScreenItem<const> = aInfoScreenData[iScreen];
    if aInfoScreenActiveItem == aInfoScreenItem then
      -- Disable it
      aInfoScreenActiveItem = nil;
      fcbInfoScreenCallback = InfoScreenDisabled;
    -- We're not showing this one
    else
      -- Enable it
      aInfoScreenActiveItem = aInfoScreenItem;
      fcbInfoScreenCallback = InfoScreenEnabled;
    end
  end
  -- Set disabled callback
  fcbInfoScreenCallback = InfoScreenDisabled;
  -- Return actual function
  return SelectInfoScreen;
end
-- De-init the level ------------------------------------------------------- --
local function DeInitLevel()
  -- Unset FBU callback
  RegisterFBUCallback("game");
  -- De-init information screen
  SelectInfoScreen();
  -- Dereference loaded assets for garbage collector
  texBg, texLev, maskZone = nil, nil, nil;
  -- Flush specified tables whilst keeping the actual table
  local aTables<const> = { aObjects, aPlayers, aFloodData, aRacesAvailable,
    aGemsAvailable, aLevelData, aShroudData };
  for iIndex = 1, #aTables do
    local aTable<const> = aTables[iIndex];
    while #aTable > 0 do remove(aTable, #aTable) end;
  end
  -- Reset positions and other variables
  iPixPosTargetX, iPixPosTargetY, iPixPosX, iPixPosY, iGameTicks, iAnimMoney,
    iLevelId, iWinLimit, sMoney, iUniqueId, fcbLogic, fcbRender =
      0, 0, 0, 0, 0, 0, nil, nil, nil, 0, nil, nil;
  -- Reset active objects, menus and players
  aActivePlayer, aOpponentPlayer = nil, nil;
  -- Remove active object and menu data
  SelectObject();
  -- We don't want to hear sounds
  SetPlaySounds(false);
end
-- Get level tile location from absolute ca-ordinates ---------------------- --
local function GetTileOffsetFromAbsCoordinates(iAbsX, iAbsY)
  -- Check parameters
  if not UtilIsInteger(iAbsX) then
    error("Invalid X co-ordinate! "..tostring(iAbsX)) end;
  if not UtilIsInteger(iAbsY) then
    error("Invalid Y co-ordinate! "..tostring(iAbsY)) end;
  -- Return tile offset if valid
  if iAbsX >= 0 and iAbsX < iLLAbsW and iAbsY >= 0 and iAbsY < iLLAbsH then
    return iAbsY * iLLAbsW + iAbsX end;
end
-- Get level tile location from absolute ca-ordinates ---------------------- --
local function GetLevelOffsetFromAbsCoordinates(iAbsX, iAbsY)
  -- Check parameters
  if not UtilIsInteger(iAbsX) then
    error("Invalid X co-ordinate! "..tostring(iAbsX)) end;
  if not UtilIsInteger(iAbsY) then
    error("Invalid Y co-ordinate! "..tostring(iAbsX)) end;
  -- Return location if valid
  local iLoc<const> = GetTileOffsetFromAbsCoordinates(iAbsX, iAbsY);
  if iLoc then return iLoc end;
end
-- Get zero based tile id at specified absolute location ------------------- --
local function GetLevelDataFromAbsCoordinates(iAbsX, iAbsY)
  -- Check parameters
  if not UtilIsInteger(iAbsX) then
    error("Invalid X co-ordinate! "..tostring(iAbsX)) end;
  if not UtilIsInteger(iAbsY) then
    error("Invalid Y co-ordinate! "..tostring(iAbsX)) end;
  -- Get tile at specified location and return tile id if valid
  local iLoc<const> = GetLevelOffsetFromAbsCoordinates(iAbsX, iAbsY);
  if iLoc then return aLevelData[1 + iLoc], iLoc end;
end
-- Get zero based tile id at specified absolute location ------------------- --
local function GetLevelDataFromLevelOffset(iLoc)
  -- Check parameters
  if not UtilIsInteger(iLoc) then
    error("Invalid location! "..tostring(iLoc)) end;
  -- Get tile at specified location
  if iLoc >= 0 and iLoc < iLLAbs then return aLevelData[1 + iLoc] end;
end
-- Get zero based tile id at specified absolute location ------------------- --
local function GetLevelDataFromTileOffset(iLoc)
  -- Check parameters
  if not UtilIsInteger(iLoc) then
    error("Invalid location! "..tostring(iLoc)) end;
  -- Get tile at specified location
  return GetLevelDataFromLevelOffset(iLoc);
end
-- Get tile location from pixel co-ordinates ------------------------------- --
local function GetTileOffsetFromCoordinates(iPixX, iPixY)
  -- Check parameters
  if not UtilIsInteger(iPixX) then
    error("Invalid X co-ordinate! "..tostring(iPixX)) end;
  if not UtilIsInteger(iPixY) then
    error("Invalid Y co-ordinate! "..tostring(iPixY)) end;
  -- Return location if valid
  if iPixX >= 0 and iPixX < iLLPixW and iPixY >= 0 and iPixY < iLLPixH then
    return (iPixY // 16 * iLLAbsW) + (iPixX // 16) end;
end
-- Get level tile location from co-ordinates ------------------------------- --
local function GetLevelOffsetFromCoordinates(iPixX, iPixY)
  -- Check parameters
  if not UtilIsInteger(iPixX) then
    error("Invalid X co-ordinate! "..tostring(iPixX)) end;
  if not UtilIsInteger(iPixY) then
    error("Invalid Y co-ordinate! "..tostring(iPixY)) end;
  -- Return level offset if valid
  local iLoc<const> = GetTileOffsetFromCoordinates(iPixX, iPixY);
  if iLoc then return iLoc end;
end
-- Get zero based tile id at specified location ---------------------------- --
local function GetLevelDataFromCoordinates(iPixX, iPixY)
  -- Check parameters
  if not UtilIsInteger(iPixX) then
    error("Invalid X co-ordinate! "..tostring(iPixX)) end;
  if not UtilIsInteger(iPixY) then
    error("Invalid Y co-ordinate! "..tostring(iPixY)) end;
  -- Return tile at specified location
  local iLoc<const> = GetLevelOffsetFromCoordinates(iPixX, iPixY);
  if iLoc then return aLevelData[1 + iLoc], iLoc end;
end
-- Get zero based tile id at specified object ------------------------------ --
local function GetLevelDataFromObject(aObject, iPixX, iPixY)
  -- Check parameters
  if not UtilIsTable(aObject) then
    error("Invalid object specified! "..tostring(aObject)) end;
  if not UtilIsInteger(iPixX) then
    error("Invalid X co-ordinate! "..tostring(iPixX)) end;
  if not UtilIsInteger(iPixY) then
    error("Invalid Y co-ordinate! "..tostring(iPixY)) end;
  -- Return level data from object co-ordinates
  return GetLevelDataFromCoordinates(aObject.X + aObject.OFX + iPixX,
                                     aObject.Y + aObject.OFY + iPixY);
end
-- Get tile at specified object offset pixels ------------------------------ --
local function GetTileOffsetFromObject(aObject, iPixX, iPixY)
  -- Check parameters
  if not UtilIsTable(aObject) then
    error("Invalid object specified! "..tostring(aObject)) end;
  if not UtilIsInteger(iPixX) then
    error("Invalid X co-ordinate! "..tostring(iPixX)) end;
  if not UtilIsInteger(iPixY) then
    error("Invalid Y co-ordinate! "..tostring(iPixY)) end;
  -- Return tile offset from object co-ordinates
  return GetTileOffsetFromCoordinates(aObject.X + aObject.OFX + iPixX,
                                      aObject.Y + aObject.OFY + iPixY);
end
-- Get tile at specified object offset pixels ------------------------------ --
local function GetLevelOffsetFromObject(aObject, iPixX, iPixY)
  -- Check parameters
  if not UtilIsTable(aObject) then
    error("Invalid object specified! "..tostring(aObject)) end;
  if not UtilIsInteger(iPixX) then
    error("Invalid X co-ordinate! "..tostring(iPixX)) end;
  if not UtilIsInteger(iPixY) then
    error("Invalid Y co-ordinate! "..tostring(iPixY)) end;
  -- Get tile offset from location and return level offset if valid
  local iLoc<const> = GetTileOffsetFromObject(aObject, iPixX, iPixY);
  if iLoc then return iLoc end;
end
-- Update level and level mask --------------------------------------------- --
local function UpdateLevel(iPos, iId)
  -- Check parameters
  if not UtilIsInteger(iPos) then
    error("Invalid level tile position! "..tostring(iPos)) end;
  if not UtilIsInteger(iId) then
     error("Invalid level tile index!"..tostring(iId)) end;
  -- Update level data with specified tile
  aLevelData[1 + iPos] = iId;
  -- Calculate absolute X and Y position from location
  local iX<const>, iY<const> = iPos % iLLAbsW * 16, iPos // iLLAbsW * 16;
  -- Update zone collision bit-mask
  maskZone:Copy(maskLev, iId, iX, iY);
  -- This part will keep the 1 pixel barrier around the level
  if iPos < iLLAbsW then
    -- Keep top-left corner barrier to stop objects going off screen
    if iPos == 0 then maskZone:Fill(0, 0, 16, 1);
                      maskZone:Fill(0, 0, 1, 16);
    -- Keep top-right corner barrier to stop objects going off screen
    elseif iPos == iLLAbsWm1 then
      maskZone:Fill(iX - 16, 0, 16, 1);
      maskZone:Fill(iX - 1, 0, 1, 16);
    -- Top row
    else maskZone:Fill(iX, 0, iX + 16, 1) end;
  -- Bottom row?
  elseif iPos >= iLLAbsMLW then
    -- Keep bottom-left corner barrier to stop objects going off screen
    if iPos == iLLAbsMLW then
      maskZone:Fill(0, iY, 1, 16);
      maskZone:Fill(0, iY + 15, 16, 1);
    -- Keep bottom-right corner barrier to stop objects going off screen
    elseif iPos == iLLAbsM1 then
      maskZone:Fill(iX + 15, iY, 1, 16);
      maskZone:Fill(iX, iY + 15, 16, 1);
    -- Bottom row?
    else maskZone:Fill(iX, iY + 15, 16, 1) end;
    -- Keep left side barrier to stop objects going off screen
  elseif iPos % iLLAbsW == 0 then maskZone:Fill(0, iY, 1, iY + 16);
  -- Keep right side barrier to stop objects going off screen
  elseif iPos % iLLAbsW == iLLAbsWm1 then
    maskZone:Fill(iX + 15, iY, 1, iY + 16);
  end
end
-- Can sell gem? ----------------------------------------------------------- --
local function CanSellGem(iObjId)
  -- Check parameters
  if not UtilIsInteger(iObjId) then
    error("Object not specified! "..tostring(iObjId)) end;
  -- Jennites can always be sold
  if iObjId == TYP.JENNITE then return true end;
  -- Not a Jennite so we need to check if it's a gem we can sell. If we can
  -- sell it? Then return success.
  for iGem = 1,3 do if aGemsAvailable[iGem] == iObjId then return true end end;
  -- Can't sell this gem so return failed
  return false;
end
-- Update shroud (Original Diggers only lets so much) ---------------------- --
local function UpdateShroud(iOX, iOY)
  -- For each entry in the circle
  for iI = 1, #aShroudCircle do
    -- Get the information about the circle
    local aShroudCircleItem<const> = aShroudCircle[iI];
    -- Calculate adjusted position based on object
    local iX<const>, iY<const> =
      iOX + aShroudCircleItem[1], iOY + aShroudCircleItem[2];
    -- If the co-ordinates are valid?
    if iX >= 0 and iY >= 0 and iX < iLLAbsW and iY < iLLAbsH then
      -- Get shroud flags and calc new flags data and if different?
      local aShroudItem<const> = aShroudData[iY * iLLAbsW + iX + 1];
      local iOldFlags<const> = aShroudItem[2];
      local iNewFlags<const> = iOldFlags | aShroudCircleItem[3];
      if iOldFlags ~= iNewFlags then
        -- Lookup new tile id and if theres only one? Set first tile
        local aTiles<const> = aShroudTileLookup[1 + iNewFlags];
        if #aTiles == 1 then aShroudItem[1], aShroudItem[2] =
                               aTiles[1], iNewFlags;
        -- More than one tile? Randomly select one
        else aShroudItem[1], aShroudItem[2] =
               aTiles[random(#aTiles)], iNewFlags end;
      end
    end
  end
end
-- Set object X position --------------------------------------------------- --
local function SetPositionX(aObject, iX)
  -- Calculate new absolute X position
  local iAX<const> = iX // 16;
  -- Update absolute and pixel position
  aObject.AX, aObject.X = iAX, iX;
  -- Update shroud if requested
  if aObject.US then UpdateShroud(iAX, aObject.AY) end;
  -- Refocus on object if needed
  ObjectFocus(aObject);
end
-- Set object Y position --------------------------------------------------- --
local function SetPositionY(aObject, iY)
  -- Calculate new absolute Y position
  local iAY<const> = iY // 16;
  -- Update absolute and pixel position
  aObject.AY, aObject.Y = iAY, iY;
  -- Update shroud if requested
  if aObject.US then UpdateShroud(aObject.AX, iAY) end;
  -- Refocus on object if needed
  ObjectFocus(aObject);
end
-- Set object X and Y position --------------------------------------------- --
local function SetPosition(aObject, iX, iY)
  -- Calculate new absolute X position
  local iAX<const>, iAY<const> = iX // 16, iY // 16;
  -- Update absolute and pixel position
  aObject.AX, aObject.X, aObject.AY, aObject.Y = iAX, iX, iAY, iY;
  -- Update shroud if requested
  if aObject.US then UpdateShroud(iAX, iAY) end;
  -- Refocus on object if needed
  ObjectFocus(aObject);
end
-- Trigger end condition --------------------------------------------------- --
local function TriggerEnd(fcbFunc)
  -- Parameter must be a function
  if not UtilIsFunction(fcbFunc) then
    error("End function not specified! "..tostring(fcbFunc)) end;
  -- Call the function
  fcbFunc(iLevelId, aActivePlayer, aOpponentPlayer);
end
-- Get win limit ----------------------------------------------------------- --
local function HaveZogsToWin(aPlayer) return aPlayer.M >= iWinLimit end;
-- Level end conditions check ---------------------------------------------- --
local function EndConditionsCheck()
  -- No active player? (Playing a demo?) Just ignore
  if bAIvsAI or PlaySoundAtObject == BlankFunction then return end;
  -- Player has enough Zogs?
  if HaveZogsToWin(aActivePlayer) then return TriggerEnd(InitWin) end;
  -- All the opponents Diggers have died?
  if aOpponentPlayer.DC <= 0 then return TriggerEnd(InitWinDead) end;
  -- The opponent has enough Zogs?
  if HaveZogsToWin(aOpponentPlayer) then return TriggerEnd(InitLose) end;
  -- All the players Diggers have died?
  if aActivePlayer.DC <= 0 then return TriggerEnd(InitLoseDead) end;
end
-- Destroy object ---------------------------------------------------------- --
local function DestroyObject(iObj, aObj)
  -- Check parameters
  if not UtilIsInteger(iObj) then
    error("Specified id is not an integer! "..tostring(iObj)) end;
  if not UtilIsTable(aObj) then
    error("Invalid object specified! "..tostring(aObj)) end;
  -- Object respawns?
  if aObj.F & OFL.RESPAWN ~= 0 then
    -- Restore object health
    aObj.H = 100;
    -- Move back to start position
    SetPosition(aObj, aObj.SX, aObj.SY);
    -- Get object data
    local aObjData<const> = aObj.OD;
    -- Restore object animation speed
    aObj.ANT = aObjData.ANIMTIMER;
    -- Phase back in with originally specified criteria
    SetAction(aObj, aObjData.ACTION, aObjData.JOB, aObjData.DIRECTION);
    -- Not actually destroyed
    return false;
  end
  -- Function to remove specified object from specified list
  local function RemoveObjectFromList(aList, aObj)
    -- Check parameters
    if not UtilIsTable(aList) then
      error("Specified list is not a table! "..tostring(aList)) end;
    if not UtilIsTable(aObj) then
      error("Invalid object specified! "..tostring(aObj)) end;
    -- Return if list empty
    if #aList == 0 then return end;
    -- Enumerate each object from the end to the start of the list. If target
    -- object is our object then delete it from the list
    for iObj = #aList, 1, -1 do
      if aList[iObj] == aObj then remove(aList, iObj) end;
    end
  end
  -- Remove object from the global objects list
  remove(aObjects, iObj);
  -- Get objects Telepole destinations and remove them all
  local aObjTPD<const> = aObj.TD;
  for iTPIndex = #aObjTPD, 1, -1 do remove(aObjTPD, iTPIndex) end;
  -- Get objects inventory and if there are items?
  local aObjInv<const> = aObj.I;
  if #aObjInv > 0 then
    -- Remove all objects
    for iIIndex = #aObjInv, 1, -1 do remove(aObjInv, iIIndex) end;
    -- Reset weight
    aObj.IW = 0;
  end
  -- If pursuer had a target? Remove pursuer from targets pursuer list
  local aTarget<const> = aObj.T;
  if aTarget then aTarget.TL[aObj.U] = nil end;
  -- Get digger id and if it was not a Digger?
  local iDiggerId<const> = aObj.DI;
  if not iDiggerId then
    -- Deselect the object and its menu
    if aActiveObject == aObj then SelectObject() end;
    -- Success
    return true;
  end
  -- Get player owner and mark it as dead and reduce players' digger count
  local aPlayer<const> = aObj.P;
  aPlayer.D[iDiggerId], aPlayer.DC = false, aPlayer.DC - 1;
  -- Remove pursuers and reset pursuer targets
  local aPursuers<const> = aObj.TL;
  for iUId, aPursuer in pairs(aPursuers) do
    aPursuer.T, aPursuers[iUId] = nil, nil;
  end
  -- If selected object is this digger then disable the menu
  if aActiveObject == aObj then SelectObject() end;
  -- Recheck ending conditions
  EndConditionsCheck();
  -- Object removed successfully
  return true;
end
-- Destroy object without knowing the object id ---------------------------- --
local function DestroyObjectUnknown(aObject)
  -- Check id specified
  if not UtilIsTable(aObject) then
    error("Invalid object specified! "..tostring(aObject)) end;
  -- Enumerate through each global object and find the specified object and
  -- destroy it if we find it.
  for iIndex = 1, #aObjects do
    if aObjects[iIndex] == aObject then
      return DestroyObject(iIndex, aObject)
    end
  end
  -- Failed to find object
  return false;
end
-- Add to inventory -------------------------------------------------------- --
local function AddToInventory(aOwnObj, aTakeObj, bOnlyTreasure)
  -- Check parameters
  if not UtilIsTable(aOwnObj) then
    error("Invalid owner object specified! "..tostring(aOwnObj)) end;
  if not UtilIsTable(aTakeObj) then
    error("Invalid take object specified! "..tostring(aTakeObj)) end;
  -- Failed if the object to take is...
  if aTakeObj.F & OFL.BUSY ~= 0 or        -- ...busy? -or-
    #aTakeObj.I > 0 or                    -- ...has inventory? -or-
    (bOnlyTreasure and                    -- ...only pick up treasure? -and-
     aTakeObj.F & OFL.TREASURE == 0) then -- ...treasure flag not set?
    -- We cannot pickup this object!
    return false;
  end
  -- Find object in objects array and when we find it?
  for iObj = 1, #aObjects do
    if aObjects[iObj] == aTakeObj then
      -- Remove object and add requested object to owners inventory
      remove(aObjects, iObj);
      local aOwnObjInv<const> = aOwnObj.I;
      aOwnObjInv[1 + #aOwnObjInv] = aTakeObj;
      -- Add weight and set active inventory object to this object
      aOwnObj.IW, aOwnObj.IS = aOwnObj.IW + aTakeObj.W, aTakeObj;
      -- Stop the taken object for inventory preview purposes
      SetAction(aTakeObj, ACT.STOP, JOB.NONE, DIR.NONE);
      -- If item picked up was the active object then deselect it and its menu
      if aActiveObject == aTakeObj then SelectObject() end;
      -- Success
      return true;
    end
  end
  -- This shouldn't happen! The object should be in the objects list!
  return false;
end
-- Buy an item ------------------------------------------------------------- --
local function BuyItem(aObj, iItemId)
  -- Check parameters
  if not UtilIsTable(aObj) then
    error("Invalid object specified! "..tostring(aObj)) end;
  if not UtilIsInteger(iItemId) then
    error("Invalid item id specified! "..tostring(iItemId)) end;
  -- Get object data
  local aObjData<const> = aObjectData[iItemId];
  if not UtilIsTable(aObjData) then
    error("No such item id exists! "..tostring(aObjData)) end;
  -- If objects owner doesn't have enough money or strength then failed
  local aParent<const> = aObj.P;
  local iValue<const> = aObjData.VALUE;
  local iParentMoney<const> = aParent.M;
  if iValue > iParentMoney or aObj.IW + aObjData.WEIGHT > aObj.STR or
    not AddToInventory(aObj,
      CreateObject(iItemId, aObj.X, aObj.Y, aParent)) then
        return false end;
  -- Reduce money
  aParent.M = iParentMoney - iValue;
  -- Total purchases plus one
  aParent.PUR = aParent.PUR + 1
  -- Log the purchase
  CoreLog(aObj.OD.NAME.." "..aObj.DI.." purchased "..aObjData.NAME..
    " for "..iValue.." Zogs ("..iParentMoney..">"..aParent.M..")!");
  -- Success!
  return true;
end
-- Drop Object ------------------------------------------------------------- --
local function DropObject(aOwnObj, aDropObj)
  -- Get object inventory and enumerate it until we find the object
  local aOwnObjInv<const> = aOwnObj.I;
  for iIndex = 1, #aOwnObjInv do
    if aOwnObjInv[iIndex] == aDropObj then
      -- Remove object from owner inventory
      remove(aOwnObjInv, iIndex);
      -- Set new position of object
      SetPosition(aDropObj, aOwnObj.X, aOwnObj.Y);
      -- Add back to playfield
      aObjects[1 + #aObjects] = aDropObj;
      -- Reduce carrying weight
      aOwnObj.IW = aOwnObj.IW - aDropObj.W;
      -- Select next object
      aOwnObj.IS = aOwnObjInv[iIndex];
      -- If invalid select first object
      if not aOwnObj.IS then aOwnObj.IS = aOwnObjInv[1] end;
      -- Success!
      return true;
    end
  end
  -- Failed to drop object
  return false;
end
-- Sell an item ------------------------------------------------------------ --
local function SellItem(aOwnObj, aSellObj)
  -- Check parameters
  if not UtilIsTable(aOwnObj) then
    error("Invalid object specified! "..tostring(aOwnObj)) end;
  if not UtilIsTable(aSellObj) then
    error("Invalid inventory object specified! "..tostring(aSellObj)) end;
  -- Remove object from inventory and return if failed
  if not DropObject(aOwnObj, aSellObj) then return false end;
  -- Increment funds but deduct value according to damage
  local aParent<const> = aOwnObj.P;
  local nValue<const> = aSellObj.OD.VALUE / 2;
  local nDamage<const> = aSellObj.H / 100;
  local iValue<const> = floor(nValue * nDamage);
  local iValuePenalty<const> = floor(nValue) - iValue;
  local iMoney<const>, iAdded = aParent.M;
  aParent.M = iMoney + iValue;
  -- If treasure?
  if aSellObj.F & OFL.TREASURE ~= 0 then
    -- Add value based on time
    aParent.GS = aParent.GS + 1;
    iAdded = iGameTicks // 18000;
    aParent.GI = aParent.GI + iAdded;
    aParent.M = aParent.M + iAdded;
  -- No added value
  else iAdded = 0 end;
  -- Destroy the object
  DestroyObjectUnknown(aSellObj);
  -- Log the destruction
  CoreLog(aOwnObj.OD.NAME.." "..aOwnObj.DI.." sold "..aSellObj.OD.NAME..
    " for "..iValue.." Zogs (P:"..iValuePenalty..";A:"..iAdded..";"..
    iMoney..">"..aParent.M..")!");
  -- Sold
  return true;
end
-- Sell all available items of specified type ------------------------------ --
local function SellSpecifiedItems(aObj, iItemId)
  -- Check parameters
  if not UtilIsTable(aObj) then
    error("Invalid object specified! "..tostring(aObj)) end;
  if not UtilIsInteger(iItemId) then
    error("Item type not specified! "..tostring(iItemId)) end;
  -- Get digger inventory and return if no items
  local aObjInv<const> = aObj.I;
  if #aObjInv == 0 then return -1 end;
  -- Something sold?
  local iItemsSold = 0;
  local iInvId = 1 while iInvId <= #aObjInv do
    -- Get object and if is a matching type and we can sell and we sold it?
    local aInvObj<const> = aObjInv[iInvId];
    local iTypeId<const> = aInvObj.ID;
    if iTypeId == iItemId and
       CanSellGem(iTypeId) and
       SellItem(aObj, aInvObj) then
      -- Sold something
      iItemsSold = iItemsSold + 1;
    -- Not sellable solid so increment inventory index
    else iInvId = iInvId + 1 end;
  end
  -- Return if we sold something
  return iItemsSold;
end
-- Sprite collides with another sprite ------------------------------------- --
local function IsSpriteCollide(S1, X1, Y1, S2, X2, Y2)
  return maskSpr:IsCollideEx(S1, X1, Y1, maskSpr, S2, X2, Y2);
end
-- Pickup Object ----------------------------------------------------------- --
local function PickupObject(aObj, aTObj, bOnlyTreasure)
  -- Return failure if target...
  if aObj == aTObj or                -- ...is me?
     aTObj.F & OFL.PICKUP == 0 or    -- *or* cant be grabbed?
     aObj.IW + aTObj.W > aObj.STR or -- *or* too heavy?
     not IsSpriteCollide(            -- *or* not touching?
       aObj.S, aObj.X+aObj.OFX, aObj.Y+aObj.OFY,
       aTObj.S, aTObj.X+aTObj.OFX, aTObj.Y+aTObj.OFY) then
    return false end;
  -- Add object to objects inventory
  return AddToInventory(aObj, aTObj, bOnlyTreasure);
end
-- Pickup Objects ---------------------------------------------------------- --
local function PickupObjects(aObj, bOnlyTreasure)
  -- Look for objects that can be picked up
  local iObj = 1 while iObj <= #aObjects do
    -- Try to pickup specified object and return success if succeeded
    if PickupObject(aObj, aObjects[iObj], bOnlyTreasure) then return true end;
    -- Try next object
    iObj = iObj + 1;
  end
  -- Failed!
  return false;
end
-- Set a random action, job and direction ---------------------------------- --
local function SetRandomJob(aObject, bUser)
  -- Select a random choice
  local aChoice = aAIChoicesData[random(#aAIChoicesData)];
  -- Failed direction matches then try something else
  if aChoice[1] == aObject.FDD then aChoice = aChoice[2];
  -- We're not blocked from digging so try moving in that direction
  else aChoice = aChoice[3] end;
  -- Set new AI choice and return
  SetAction(aObject, aChoice[1], aChoice[2], aChoice[3], bUser);
end
-- AI player override patience logic --------------------------------------- --
local function AIPatienceLogic(aObject)
  -- Return if...
  if (aObject.F & OFL.BUSY ~= 0 and -- Digger is busy? -AND-
     aObject.A ~= ACT.REST) or      -- Digger is NOT resting? -OR-
     aObject.JT < aObject.PL then   -- Digger is not at impatience limit?
    return end;
  -- If have rest ability? (25% chance to execute). Use it and return
  if aObject.OD[ACT.REST] and random() < 0.25 then
    return SetAction(aObject, ACT.REST, JOB.NONE, DIR.NONE);
  end
  -- Do something casual
  SetRandomJob(aObject, true);
end
-- Add player -------------------------------------------------------------- --
local function CreatePlayer(iX, iY, iPlayerId, iRaceId, bIsAI)
  -- Check parameters
  if not UtilIsInteger(iX) then
    error("X coord not an integer! "..tostring(iX)) end;
  if iX < 0 then
    error("X coord "..iX.." must be positive!") end;
  if iX >= iLLAbsW then
    error("X coord "..iX.." limit is "..iLLAbsW.."!") end;
  if not UtilIsInteger(iY) then
    error("X coord not an integer! "..tostring(iY)) end;
  if iY < 0 then
    error("Y coord "..iY.." must be positive!") end;
  if iY >= iLLAbsW then
    error("Y coord "..iY.." limit is "..iLLAbsH.."!") end;
  if not UtilIsInteger(iPlayerId) then
    error("Player id is invalid! "..tostring(iPlayerId)) end;
  if aPlayers[iPlayerId] then
    error("Player "..iPlayerId.." already initialised!") end;
  if not UtilIsInteger(iRaceId) then
    error("Race id is invalid! "..tostring(iRaceId)) end;
  if not UtilIsBoolean(bIsAI) then
    error("AI boolean is invalid! "..tostring(bIsAI)) end;
  if #aRacesAvailable == 0 then
    error("No races are available!") end;
  -- Digger in races list picked
  local iRacesId;
  -- If random digger requested?
  if iRaceId == TYP.DIGRANDOM then
    -- Pick a random race from the races array
    iRacesId = random(#aRacesAvailable);
    -- Override the random race type with an actual race type
    iRaceId = aRacesAvailable[iRacesId];
  -- Actually specified specific race
  else
    -- For each available race
    iRacesId = 1;
    while iRacesId <= #aRacesAvailable do
      -- Get race type id and if we matched requested race then break
      if aRacesAvailable[iRacesId] == iRaceId then break end;
      -- Try next races id
      iRacesId = iRacesId + 1;
    end
    -- Wasn't able to remove anything? Show error
    if iRacesId > #aRacesAvailable then
      error("Race "..iRaceId.." not available!") end;
  end
  -- Remove the race from the table so it can't be duplicated
  remove(aRacesAvailable, iRacesId);
  -- Players diggers and number of diggers to create
  local aDiggers<const>, iNumDiggers<const> = { }, 5;
  -- Calculate home point
  local iHomeX, iHomeY<const> = iX * 16 - 2, iY * 16 + 32;
  -- Get object data for race
  local aRaceData<const> = aObjectData[iRaceId];
  if not UtilIsTable(aRaceData) then
    error("Invalid race data for "..iRaceId.."! "..tostring(aRaceData)) end;
  -- Build player data object
  local aPlayer<const> = {
    AI  = bIsAI,                       -- Set AI status
    D   = aDiggers,                    -- List of diggers
    DT  = iNumDiggers,                 -- Diggers total
    DC  = iNumDiggers,                 -- Diggers count
    DUG = 0,                           -- Dirt dug
    EK  = 0,                           -- Enemies killed (OFL.ENEMY)
    GEM = 0,                           -- Gems found
    GS  = 0,                           -- Gems sold
    PUR = 0,                           -- Purchases made
    GI  = 0,                           -- Total income
    M   = 100,                         -- Money
    R   = iRaceId,                     -- Race type (TYP.*)
    I   = iPlayerId,                   -- Player index
    LK  = 0,                           -- Lifeforms killedV (OFL.LIVING)
    HX  = iHomeX,                      -- Home point X position
    HY  = iHomeY,                      -- Home point Y position
    SX  = (iX - 1) * 16,               -- Adjust home point X
    SY  = (iY + 2) * 16,               -- Adjust home point Y
    RD  = aRaceData                    -- Race data
  };
  -- If this is player one?
  if iPlayerId == 1 then
    -- Set active player
    aActivePlayer = aPlayer;
    -- Is not AI?
    if not bIsAI then
      -- Set to un-shroud the players' objects
      aPlayer.US = true;
      -- Add capital carried and reset its value
      aActivePlayer.M = aActivePlayer.M + aGlobalData.gCapitalCarried;
      aGlobalData.gCapitalCarried = 0;
      -- Not demo mode
      bAIvsAI = false;
      -- Fast scrolling
      iScrollRate = 16;
    -- Not AI vs AI
    else
      -- Slow scrolling
      iScrollRate = 32;
      -- Demo mode
      bAIvsAI = true;
    end
    -- Set viewpoint on this player and synchronise
    ScrollViewPortTo(iX - iScrTilesWd2p1, iY - iScrTilesHd2 + 3);
    ForceViewport();
  -- Set opponent player
  else aOpponentPlayer = aPlayer end;
  -- Adjust starting X co-ordinate for first Digger at the trade centre
  iHomeX = iHomeX - 16;
  -- Get weight of treasure
  local iMaxInventory<const> = aRaceData.STRENGTH;
  -- For each digger of the player
  for iDiggerId = 1, iNumDiggers do
    -- Create a new digger
    local aDigger<const> = CreateObject(iRaceId, iHomeX, iHomeY, aPlayer);
    if aDigger then
      -- Digger is not AI?
      if not bIsAI then
        -- Set patience AI for player controlled digger
        aDigger.AI, aDigger.AIF = AI.PATIENCE, AIPatienceLogic;
        -- Set and verify patience warning value
        local iPatience = aDigger.OD.PATIENCE;
        if not UtilIsInteger(iPatience) then
          error("Digger "..iDiggerId.." of player "..aPlayer.I..
            "has no patience warning value!") end;
        -- Randomise patience by +/- 25%
        local iOffset = random(floor(iPatience * 0.25));
        if random() < 0.5 then iOffset = -iOffset end;
        iPatience = iPatience + iOffset;
        aDigger.PW = iPatience;
        -- Digger will stray between 30-60 seconds of indicated impatience
        aDigger.PL = iPatience + 1800 + random(1800);
      -- Is AI?
      else
        -- Set maximum treasure items to carry (for AI)
        aDigger.MI = iMaxInventory;
        -- Initialise Digger AI anti-wriggle system
        aDigger.AW, aDigger.AWR = 0, 0;
        -- Infinite patience
        aDigger.PW, aDigger.PL = maxinteger, maxinteger;
      end;
      -- Set Digger id
      aDigger.DI = iDiggerId;
      -- Insert into Digger list
      aDiggers[1 + #aDiggers] = aDigger;
    -- Failed so show map maker in console that the object id is invalid
    else CoreWrite("Warning! Digger "..iDiggerId..
      " not created for player "..iPlayerId.."! Id="..iRaceId..", X="..iX..
      ", Y="..iY..".", 9) end;
    -- Increment home point X position
    iHomeX = iHomeX + 5;
  end
  -- Add player data to players array
  aPlayers[1 + #aPlayers] = aPlayer;
  -- Log creation of item
  CoreLog("Created player "..iPlayerId.." as '"..aObjectData[iRaceId].NAME..
    "'["..iRaceId.."] at AX:"..iX..",AY:"..iY.." in position #"..
    #aPlayers.."!");
end
-- Object is at home ------------------------------------------------------- --
local function ObjectIsAtHome(aObject)
  -- Check parameter is valid
  if not UtilIsTable(aObject) then
    error("Invalid object specified! "..tostring(aObject)) end;
  -- Make sure object has an owner
  local aPlayer<const> = aObject.P;
  if not UtilIsTable(aPlayer) then
    error("Object has invalid parent! "..tostring(aPlayer)) end;
  -- Return if object is at the home point
  return aObject.X == aPlayer.HX and aObject.Y == aPlayer.HY;
end
-- Cycle object inventory -------------------------------------------------- --
local function CycleObjInventory(aObject, iDirection)
  -- Get object inventory and return failed if no inventory
  local aInv<const> = aObject.I;
  if #aInv == 0 then return false end;
  -- Enumerate inventory to find selected item
  for iInvIndex = 1, #aInv do
    -- Get inventory object and if we got it
    local aInvObj<const> = aInv[iInvIndex];
    if aInvObj == aObject.IS then
      -- Cycle object wrapping on low or high
      aObject.IS = aInv[1 + (((iInvIndex - 1) + iDirection) % #aInv)];
      -- Success
      return true;
    end
  end
  -- Failure
  return false;
end
-- Prevent all diggers entering trade centre ------------------------------- --
local function SetAllDiggersNoHome(aDiggers)
  -- Get player data and enumerate their diggers
  for iDiggerId = 1, #aDiggers do
    -- Get digger object and stop it from going home
    local aDigger<const> = aDiggers[iDiggerId];
    if aDigger then aDigger.F = aDigger.F | OFL.NOHOME end;
  end
end
-- Set object action ------------------------------------------------------- --
local function InitSetAction()
  -- Deployment of train track
  local function DEPLOYTrack(O)
    -- Deploy success
    local bDeploySuccess = false;
    -- Check 5 tiles at object position and lay track
    for I = 0, 4 do
      -- Calculate absolute location of object and get tile id. Break if bad
      local iId, iLoc<const> = GetLevelDataFromObject(O, (I * 16) + 8, 15);
      if not iId then break end;
      -- Check if it's a tile we can convert and break if we can't
      iId = aTrainTrackData[iId];
      if not iId then break end;
      -- Get terrain tile id blow this tile and if we can deploy on this?
      if aTileData[1 + aLevelData[1 + iLoc + iLLAbsW]] &
        aTileFlags.F ~= 0 then
        -- Update level data
        UpdateLevel(iLoc, iId);
        -- Deployed successfully and continue
        bDeploySuccess = true;
      end
    end
    -- Deploy if succeeded
    return bDeploySuccess;
  end
  -- Deployment of flood gate
  local function DEPLOYGate(O)
    -- Calculate absolute location of object below and if valid and the tile
    -- below it is firm ground? Also creation of an invisible flood gate
    -- object was successful?
    local iId, iLoc<const> = GetLevelDataFromObject(O, 8, 16);
    if iId and aTileData[1 + iId] & aTileFlags.F ~= 0 and
      CreateObject(TYP.GATEB,
        iLoc % iLLAbsW * 16,
        (iLoc - iLLAbsW) // iLLAbsW * 16, O.P) then
      -- Update tile to a flood gate
      UpdateLevel(iLoc - iLLAbsW, 438);
      -- Success!
      return true;
    end
    -- Failed
    return false;
  end
  -- Deployment functions
  local function DEPLOYLift(O)
    -- Calculate absolute location of object
    local iLoc<const> = GetLevelOffsetFromObject(O, 8, 0);
    -- Search for a buildable ground surface
    for iBottom = iLoc, iLLAbsMLW, iLLAbsW do
      -- Get tile
      local iId<const> = aLevelData[1 + iBottom];
      local iTileId<const> = aTileData[1 + iId];
      -- Tile has not been dug
      if iTileId & aTileFlags.AD == 0 then
        -- If we're on firm ground?
        if iTileId & aTileFlags.F ~= 0 then
          -- Search for a buildable above ground surface
          for iTop = iLoc, iLLAbsW, -iLLAbsW do
            -- Get tile
            local iId<const> = aLevelData[1 + iTop];
            local iTileId<const> = aTileData[1 + iId];
            -- Tile has not been dug
            if iTileId & aTileFlags.AD == 0 then
              -- Tile is firm buildable ground?
              if iTileId & aTileFlags.F ~= 0 then
                -- Height check and if ok and creating an object went ok?
                -- Create lift object
                if iTop >= iLLAbsW and iBottom-iTop >= 384 and
                  CreateObject(TYP.LIFTB,
                    (O.X + 8) // 16 * 16,
                    (O.Y + 15) // 16 * 16, O.P) then
                  -- Update level data for top and bottom part of lift
                  UpdateLevel(iTop, 62);
                  UpdateLevel(iBottom, 190);
                  -- Draw cable
                  for iTop = iTop + iLLAbsW,
                    iBottom - iLLAbsW, iLLAbsW do
                    -- Update level data for bottom part of lift
                    UpdateLevel(iTop, 189);
                  end
                  -- We are deploying now so set success
                  return true;
                end
              end
              -- Done
              break;
            end
          end
        end
        -- Done
        break;
      end
    end
    -- Failed to deploy
    return false;
  end
  -- Deployment lookup table
  local aDeployments<const> = {
    [TYP.TRACK] = DEPLOYTrack,
    [TYP.GATE]  = DEPLOYGate,
    [TYP.LIFT]  = DEPLOYLift,
  }
  -- Deploy specified device
  local function ACTDeployObject(O)
    -- Get deploy function and if deployable?
    local fcbDeployFunc<const> = aDeployments[O.ID];
    if fcbDeployFunc and fcbDeployFunc(O) then
      -- Destroy the object and return success
      DestroyObjectUnknown(O);
      return true, true;
    end
    -- Failed so return failure
    return true, false;
  end
  -- Jump requested?
  local function ACTJump(O)
    -- Object is...
    if O.A ~= ACT.FIGHT and            -- ...not fighting *and*
       O.F & OFL.BUSY == 0 and         -- ...not busy *and*
       O.F & OFL.JUMPRISE == 0 and     -- ...not jumping *and*
       O.F & OFL.JUMPFALL == 0 and     -- ...not jump falling *and*
       O.FS == 1 and                   -- ...not actually falling *and*
       O.FD == 0 then                  -- ...not accumulating fall damage
      -- Remove fall flag and add busy and jumping flags
      O.F = (O.F | OFL.BUSY | OFL.JUMPRISE) & ~OFL.FALL;
      -- Play jump sound
      PlaySoundAtObject(O, aSfxData.JUMP);
      -- Reset action timer
      O.AT = 0;
      -- Jump succeeded
      return true, true;
    end
    -- Jump failed
    return true, false;
  end
  -- Dying or eaten requested?
  local function ACTDeathOrEaten(O)
    -- Remove jump and fall flags or if the digger is jumping then busy will
    -- be unset and they will be able to instantly come out of phasing.
    O.F = O.F & ~(OFL.JUMPRISE | OFL.JUMPFALL);
    -- Force normal timer speed for animation
    O.ANT = aTimerData.ANIMNORMAL;
    -- Continue execution of function
    return false;
  end
  -- Display map requested?
  local function ACTDisplayMap()
    -- Remove play sound function
    SetPlaySounds(false);
    -- Display map
    InitTNTMap();
    -- Halt further execution of function
    return true, true;
  end
  -- Open or close a gate
  local function ACTOpenCloseGate(O, A)
    -- Get location at specified tile and if id is valid?
    local iId<const>, iLoc<const> = GetLevelDataFromAbsCoordinates(O.AX, O.AY);
    if iId then
      -- Location updater and sound player
      local function UpdateFloodGate(iTileId, iSfxId)
        -- Update level with specified id and play requested sound effect
        UpdateLevel(iLoc, iTileId);
        PlaySoundAtObject(O, iSfxId);
        -- Halt further execution of function
        return true, true;
      end
      -- Open gate?
      if A == ACT.OPEN then
        -- Gate closed (no water any side)?
        if iId == 434 then
          -- Set open non-flooded gate tile and halt further exec of function
          return UpdateFloodGate(438, aSfxData.GOPEN);
        -- Gate closed (water on left, right or both sides)?
        elseif iId >= 435 and iId <= 437 then
          -- Check if opening caused a flood
          aFloodData[1 + #aFloodData] = { iLoc, aTileData[1 + iId] };
          -- Set flooded open gate and halt further execution of function
          return UpdateFloodGate(439, aSfxData.GOPEN);
        end
      -- Closed gate and gate open? (water on neither side)?
      elseif iId == 438 then
        -- Set non-flooded gate tile and halt further execution of function
        return UpdateFloodGate(434, aSfxData.GCLOSE);
      -- Gate open (water on both sides)?
      elseif iId == 439 then
        -- Set flooded gate tile and halt further execution of function
        return UpdateFloodGate(437, aSfxData.GCLOSE);
      end
    end
    -- Failed so halt further execution of function
    return true, false;
  end
  -- Grab requested?
  local function ACTGrabItem(O)
    return true, PickupObjects(O, false);
  end
  -- Drop requested?
  local function ACTDropItem(O)
    return true, DropObject(O, O.IS);
  end
  -- Next inventory item requested?
  local function ACTNextItem(O)
    return true, CycleObjInventory(O, 1);
  end
  -- Previous inventory item requested?
  local function ACTPreviousItem(O)
    return true, CycleObjInventory(O, -1);
  end
  -- Phase requested?
  local function ACTPhase(O, _, J, D)
    -- Phasing home? Refuse action if not enough health
    if J == JOB.PHASE and D == DIR.U and O.H <= 5 and
      O.F & OFL.TPMASTER == 0 then return true, false end;
    -- Remove jump and fall flags or if the digger is jumping then busy will
    -- be unset and they will be able to instantly come out of phasing.
    O.F = O.F & ~(OFL.JUMPRISE | OFL.JUMPFALL);
    -- Continue function execution
    return false;
  end
  -- Dig requested? Save current action to restore when digging completes
  local function ACTDig(O) O.LA = O.A return false end;
  -- Actions to perform depending on action. They return a boolean and if
  -- false then execution of the action continues, else the action is blocked
  -- from further processing and an additional boolean is returned of the
  -- success of that action (used by the the player interface).
  local aActions<const> = {
    [ACT.DEATH]  = ACTDeathOrEaten,    [ACT.DIG]   = ACTDig,
    [ACT.EATEN]  = ACTDeathOrEaten,    [ACT.MAP]   = ACTDisplayMap,
    [ACT.OPEN]   = ACTOpenCloseGate,   [ACT.CLOSE] = ACTOpenCloseGate,
    [ACT.DEPLOY] = ACTDeployObject,    [ACT.JUMP]  = ACTJump,
    [ACT.GRAB]   = ACTGrabItem,        [ACT.DROP]  = ACTDropItem,
    [ACT.NEXT]   = ACTNextItem,        [ACT.PREV]  = ACTPreviousItem,
    [ACT.PHASE]  = ACTPhase,
  };
  -- Going left or right?
  local function DIRLeftRight(_, A, J, D)
    -- 50% chance to go left?
    if random() < 0.5 then return A, J, DIR.L end;
    -- Else go right
    return A, J, DIR.R;
  end
  -- Going up or down?
  local function DIRUpDown(_, A, J, D)
    -- 50% chance to go left?
    if random() < 0.5 then return A, J, DIR.U end;
    -- Else go right
    return A, J, DIR.D;
  end
  -- Going to centre of tile (to dig down)?
  local function DIRMoveToCentre(O, A, J, D)
    -- Set direction so it heads to the centre of the tile
    if O.X % 16 - 8 < 0 then D = DIR.L else D = DIR.R end;
    -- Return original parameters
    return A, J, D;
  end
  -- Move towards trade centre?
  local function DIRMoveHomeward(O, A, J, D)
    -- If going home isn't allowed? Not allow it to go home
    if J == JOB.HOME and O.F & OFL.NOHOME ~= 0 then J = JOB.NONE end;
    -- Preserve action but action stopped? Set object walking
    if A == ACT.KEEP and O.A == ACT.STOP then A = ACT.WALK end;
    -- Go left if homeward is to the left
    if O.X < O.P.HX then return A, J, DIR.R end;
    -- Go right if homeward is to the right
    if O.X > O.P.HX then return A, J, DIR.L end;
    -- If can't go inside then just stop
    if O.F & OFL.NOHOME ~= 0 then return ACT.STOP, JOB.NONE, DIR.NONE end;
    -- Prevent all Diggers entering trade centre
    SetAllDiggersNoHome(O.P.D);
    -- On the exact X pixel of home so go inside
    return ACT.PHASE, JOB.PHASE, DIR.UL;
  end
  -- Keep original direction
  local function DIRKeep(O, A, J, D) return A, J, O.D end;
  -- Opposite directions
  local aOpposites<const> = {
    [DIR.UL] = DIR.UR, [DIR.L] = DIR.R, [DIR.DL] = DIR.DR,
    [DIR.UR] = DIR.UL, [DIR.R] = DIR.L, [DIR.DR] = DIR.DL;
  };
  -- Keep original direction if moving
  local function DIRKeepIfMoving(O, A, J, D)
    -- If going in a recognised moving direction? Don't change direction
    if aOpposites[O.D] then return A, J, O.D end;
    -- Set a random direction
    return DIRLeftRight(O, A, J, D);
  end
  -- Go opposite direction
  local function DIROpposite(O, A, J, D)
    -- Set opposite direction or just go right
    D = aOpposites[O.D] or DIR.R;
    -- Return original parameters
    return A, J, D;
  end
  -- Actions to perform depending on direction
  local aDirections<const> = {
    [DIR.LR]       = DIRLeftRight,     [DIR.TCTR]     = DIRMoveToCentre,
    [DIR.HOME]     = DIRMoveHomeward,  [DIR.KEEP]     = DIRKeep,
    [DIR.KEEPMOVE] = DIRKeepIfMoving,  [DIR.OPPOSITE] = DIROpposite,
    [DIR.UD]       = DIRUpDown,
  };
  -- Actions to ignore for job in danger function
  local aActionsToIgnore<const> = { [ACT.DEATH] = true, [ACT.PHASE] = true };
  -- Performed when object is in danger
  local function JOBInDanger(aObject, iJob)
    -- Keep busy unset if not dead or phasing!
    if not aActionsToIgnore[aObject.A] then
      aObject.F = aObject.F & ~OFL.BUSY end;
    -- Return originally set job
    return iJob;
  end
  -- Keep existing job but don't dig down?
  local function JOBKeepNoDigDown(aObject, iJob)
    -- Get current job and is digging down? Remove job
    iJob = aObject.J;
    if iJob == JOB.DIGDOWN then return JOB.NONE end;
    -- Return object's current job
    return iJob;
  end
  -- Keep existing job
  local function JOBKeep(aObject, iJob) return aObject.J end;
  -- Actions to perform depending on job
  local aJobs<const> = {
    [JOB.INDANGER] = JOBInDanger,
    [JOB.KNDD]     = JOBKeepNoDigDown,
    [JOB.KEEP]     = JOBKeep
  };
  -- Do set action function
  local function SetAction(aObject, iAction, iJob, iDirection, bResetJobTimer)
    -- Check parameters
    if not UtilIsTable(aObject) then
      error("Invalid object table specified! "..tostring(aObject)) end;
    if not UtilIsInteger(iAction) then
      error("Invalid action integer specified! "..tostring(iAction)) end;
    if not UtilIsInteger(iJob) then
      error("Invalid job integer specified! "..tostring(iJob)) end;
    if not UtilIsInteger(iDirection) then
      error("Invalid direction integer specified! "..tostring(iDirection)) end;
    -- Get action function and if we have one?
    local fcbActionCallback<const> = aActions[iAction];
    if fcbActionCallback then
      -- Call the function and return results
      local bBlock, bResult =
        fcbActionCallback(aObject, iAction, iJob, iDirection);
      -- If callback said to block further execution return execution result
      if bBlock then return bResult end;
    end
    -- Reset action timer
    aObject.AT = 0;
    -- Get direction function and if we have one? Call it and set new args
    local fcbDirCallback<const> = aDirections[iDirection];
    if fcbDirCallback then iAction, iJob, iDirection =
      fcbDirCallback(aObject, iAction, iJob, iDirection) end;
    -- Get job function and if we have one? Call it and set new args
    local fcbJobCallback<const> = aJobs[iJob];
    if fcbJobCallback then iJob = fcbJobCallback(aObject, iJob) end;
    -- Get object data
    local aObjInitData<const> = aObject.OD;
    -- Compare action. Stop requested?
    if iAction == ACT.STOP then
      -- If object can stop? Keep busy unset!
      if aObject.CS then aObject.F = aObject.F & ~OFL.BUSY;
      -- Can't stop? Set default action and move in opposite direction
      else return SetAction(aObject, aObjInitData.ACTION,
                    JOB.KEEP, DIR.OPPOSITE) end;
    -- Keep existing job? Keep existing action!
    elseif iAction == ACT.KEEP then iAction = aObject.A end;
    -- If...
    if iAction == aObject.A and     -- ...action is same as requested?
       iJob == aObject.J and        -- *and* job is same as requested?
       iDirection == aObject.D then -- *and* direction is same as requested?
      -- Reset job timer if user initiated
      if bResetJobTimer then aObject.JT = 0 end;
      -- Success regardless
      return true;
    end
    -- Set new action, direction and job
    aObject.A, aObject.J, aObject.D = iAction, iJob, iDirection;
    -- Remove all flags that are related to object actions
    local iDirFlags<const> = aObject.AD.FLAGS or OFL.NONE;
    aObject.F = aObject.F & ~iDirFlags;
    -- Set action data according to lookup table
    local aAction<const> = aObjInitData[iAction];
    if not UtilIsTable(aAction) then
      error(aObjInitData.NAME.." actdata for "..iAction..
        " not found!"..tostring(aAction)) end;
    aObject.AD = aAction;
    -- If object has patience?
    local iPatience<const> = aObject.PW;
    if iPatience then
      -- Object starts as impatient? Set impatient
      if iDirFlags & OFL.IMPATIENT ~= 0 then aObject.JT = iPatience;
      -- Reset value if the user made this action
      elseif bResetJobTimer then aObject.JT = 0 end;
    -- Patience disabled
    else aObject.JT = 0 end;
    -- Set directional data according to lookup table
    local aDirection<const> = aAction[iDirection];
    if not UtilIsTable(aDirection) then
      error(aObjInitData.NAME.." dirdata for "..iAction.."->"..iDirection..
        " not found! "..tostring(aDirection)) end;
    aObject.DD = aDirection;
    -- Get and check starting sprite id
    local iSprIdBegin<const> = aDirection[1];
    if not UtilIsInteger(iSprIdBegin) then
      error(aObjInitData.NAME.." dirdata for "..iAction.."->"..iDirection..
        " missing starting sprite! "..tostring(iSprIdBegin)) end;
    aObject.S1 = iSprIdBegin;
    -- Get and check ending sprite id
    local iSprIdEnd<const> = aDirection[2];
    if not UtilIsInteger(iSprIdEnd) then
      error(aObjInitData.NAME.." dirdata for "..iAction.."->"..iDirection..
        " missing starting sprite! "..tostring(iSprIdEnd)) end;
    aObject.S2 = iSprIdEnd;
    -- Set optional sprite draw offset
    aObject.OFX, aObject.OFY = aDirection[3] or 0, aDirection[4] or 0;
    -- Random tile requested?
    if aObject.F & OFL.RNGSPRITE ~= 0 then
      -- Get random sprite id
      local iSprite<const> = random(0) % (iSprIdEnd - iSprIdBegin);
      -- Does a new animation id need to be set?
      -- Set first animation frame and reset animation timer
      aObject.S, aObject.ST = iSprIdBegin + iSprite, iSprite;
    -- No random tile requested
    else
      -- Get current sprite id and does a new animation id need to be set?
      local iSprite<const> = aObject.S;
      if iSprite < iSprIdBegin or iSprite > iSprIdEnd then
        -- Set first animation frame and reset animation timer
        aObject.S, aObject.ST = iSprIdBegin, 0;
      end
    end
    -- Get and check attachment id
    local iAttTypeId<const> = aObject.STA;
    if iAttTypeId then
      -- Check that its valid
      if not UtilIsInteger(iAttTypeId) then
        error(aObjInitData.NAME.."'s specified attachment id is invalid! "..
          tostring(iAttTypeId)) end;
      -- Get and check object data for attachment
      local aAttObjectData<const> = aObjectData[iAttTypeId];
      if not UtilIsTable(aAttObjectData) then
        error(aObjInitData.NAME.."'s specified attachment id #"..iAttTypeId..
          " is invalid! "..tostring(aAttObjectData)) end;
      -- Get and check action data for attachment
      local aAttAction<const> = aAttObjectData[iAction];
      if not UtilIsTable(aAttAction) then
        error(aObjInitData.NAME.."'s specified attachment id #"..iAttTypeId..
          " actdata for "..iAction.." invalid! "..tostring(aAttAction)) end;
      aObject.AA = aAttAction;
      -- Set object data
      local aAttDirection<const> = aAttAction[iDirection];
      if not UtilIsTable(aAttDirection) then
        error(aObjInitData.NAME.."'s specified attachment id #"..iAttTypeId..
          " dirdata for "..iAction.." > "..iDirection.." invalid! "..
          tostring(aAttDirection)) end;
      aObject.DA = aAttDirection;
      -- Get and check attachment starting sprite id
      local iAttSprIdBegin<const> = aAttDirection[1];
      if not UtilIsInteger(iAttSprIdBegin) then
        error(aObjInitData.NAME.."'s specified attachment id #"..iAttTypeId..
          " dirdata for "..iAction.."->"..iDirection..
          " missing starting sprite! "..tostring(iAttSprIdBegin)) end;
      aObject.S1A = iAttSprIdBegin;
      -- Get and check attachment ending sprite id
      local iAttSprIdEnd<const> = aAttDirection[2];
      if not UtilIsInteger(iAttSprIdEnd) then
        error(aObjInitData.NAME.."'s specified attachment id #"..iAttTypeId..
          " dirdata for "..iAction.."->"..iDirection..
          " missing starting sprite! "..tostring(iAttSprIdEnd)) end;
      aObject.S2A = iAttSprIdEnd;
      -- Get and set new attachment sprite
      local iAttSprite<const> = aObject.SA;
      if iAttSprite < iAttSprIdBegin or iAttSprite > iAttSprIdEnd then
        aObject.SA = iAttSprIdBegin end;
      -- Set optional offset according to attachment
      aObject.OFXA, aObject.OFYA =
        aAttDirection[3] or 0, aAttDirection[4] or 0;
    -- Set no attachment
    end
    -- Re-add flags according to lookup table
    aObject.F = aObject.F | (aAction.FLAGS or 0);
    -- Get optional sound id and optional pitch and if specified?
    local iSoundId = aAction.SOUND;
    if iSoundId then
      -- Check it
      if not UtilIsInteger(iSoundId) then
        error(aObjInitData.NAME.." dirdata for "..iAction.."->"..iDirection..
          " has invalid sound id! "..tostring(iSoundId)) end;
      -- Play the sound now with no panning
      PlaySoundAtObject(aObject, iSoundId);
    -- No sound id?
    else
      -- Check for random pitch sound and if specified?
      iSoundId = aAction.SOUNDRP;
      if iSoundId then
        -- Check it
        if not UtilIsInteger(iSoundId) then
          error(aObjInitData.NAME.." dirdata for "..iAction.."->"..iDirection..
            " has invalid random pitch sound id! "..tostring(iSoundId)) end;
        -- Play sound with random pitch
        PlaySoundAtObject(aObject, iSoundId, 0.975 + (random() % 0.05));
      end
    end
    -- Success
    return true;
  end
  -- Return real functions (initialised at the bottom)
  return SetAction;
end
-- Roll the dice to spawn treasure at the specified location --------------- --
local function RollTheDice(nX, nY)
  -- Get chance to reveal a gem
  local nChance = aTimerData.GEMCHANCE;
  -- Add up to double chance depending on depth
  if nY >= aTimerData.GEMDEPTHEXTRA then
    nChance = nChance + (((nY - aTimerData.GEMDEPTHEXTRA) /
      aTimerData.GEMDEPTHEXTRA) * nChance) end;
  -- 5% chance to spawn a treasure
  if random() > nChance then return end
  -- Spawn a random object from the treasure data array and return success
  return not not CreateObject(aDigTileData[random(#aDigTileData)], nX, nY);
end
-- Roll the dice to spawn treasure at the specified location --------------- --
local function SetObjectAndParentCounter(aObject, sWhat)
  -- Increase objects gem find count
  aObject[sWhat] = aObject[sWhat] + 1;
  -- And of the objects owner if it has one
  local aPlayer<const> = aObject.P;
  if aPlayer then aPlayer[sWhat] = aPlayer[sWhat] + 1 end;
end
-- Dig tile at specified position ------------------------------------------ --
local function DigTile(aObject)
  -- Initialise centre location of tile
  local DP, CP, CId, TId, BId, AId, LId, RId;
  -- Get dig tile data
  local function GetDigTileData()
    -- Get the tile id that the object is on now
    CId = aLevelData[1 + CP];
    -- Get the tile above and adjacent the object
    if DP >= iLLAbsW then
      TId = aLevelData[1 + (DP - iLLAbsW)] else TId = 0 end
    -- Get the tile below and adjacent to the object
    if DP < iLLAbs - iLLAbsW then
      BId = aLevelData[1 + (DP + iLLAbsW)] else BId = 0 end;
    -- Get the tile adjacent to the object
    AId = aLevelData[1 + DP];
    -- Get the tile left of the object
    if DP - 1 >= 0 then LId = aLevelData[1 + (DP - 1)] else LId = 0 end;
    -- Get the tile right of the object
    if DP + 1 < iLLAbs then RId = aLevelData[1 + DP + 1] else RId = 0 end;
  end
  -- Cache digging direction of object and if going left or up-left?
  local iDirection<const> = aObject.D;
  if iDirection == DIR.L or iDirection == DIR.UL then
    if iDirection == DIR.UL then
      CP = GetLevelOffsetFromObject(aObject, 8, 15) or 0;
    else CP = 0 end;
    DP = GetLevelOffsetFromObject(aObject, 5, 15) or 0;
    GetDigTileData();
    local TDLId<const>, TDTId<const> = aTileData[1 + LId], aTileData[1 + TId];
    if TDTId & aTileFlags.P ~= 0 or
      (TDLId & aTileFlags.W ~= 0 and TDLId & aTileFlags.ER ~= 0) or
      (TDTId & aTileFlags.W ~= 0 and TDTId & aTileFlags.EB ~= 0) then
      return false end;
  -- Going downright?
  elseif iDirection == DIR.DL then
    CP, DP = GetLevelOffsetFromObject(aObject, 8, 1) or 0,
             GetLevelOffsetFromObject(aObject, 5, 1) or 0;
    GetDigTileData();
    local TDBId<const>, TDLId<const>, TDTId<const> =
      aTileData[1 + BId], aTileData[1 + LId], aTileData[1 + TId];
    if TDTId & aTileFlags.P ~= 0 or
      (TDBId & aTileFlags.W ~= 0 and TDBId & aTileFlags.ET ~= 0) or
      (TDLId & aTileFlags.W ~= 0 and TDLId & aTileFlags.ER ~= 0) or
      (TDTId & aTileFlags.W ~= 0 and TDTId & aTileFlags.EB ~= 0) then
      return false end;
  -- Going right or upright?
  elseif iDirection == DIR.R or iDirection == DIR.UR then
    if iDirection == DIR.UR then
      CP = GetLevelOffsetFromObject(aObject, 8, 15) or 0;
    else CP = 0 end;
    DP = GetLevelOffsetFromObject(aObject, 10, 15) or 0;
    GetDigTileData();
    local TDTId<const>, TDRId<const> = aTileData[1 + TId], aTileData[1 + RId];
    if TDTId & aTileFlags.P ~= 0 or
      (TDRId & aTileFlags.W ~= 0 and TDRId & aTileFlags.EL ~= 0) or
      (TDTId & aTileFlags.W ~= 0 and TDTId & aTileFlags.EB ~= 0) then
      return false end;
  -- Going downright?
  elseif iDirection == DIR.DR then
    CP, DP = GetLevelOffsetFromObject(aObject, 8, 1) or 0,
             GetLevelOffsetFromObject(aObject, 10, 1) or 0;
    GetDigTileData();
    local TDBId<const>, TDRId<const>, TDTId<const> =
      aTileData[1 + BId], aTileData[1 + RId], aTileData[1 + TId];
    if TDTId & aTileFlags.P ~= 0 or
      (TDBId & aTileFlags.W ~= 0 and TDBId & aTileFlags.ET ~= 0) or
      (TDRId & aTileFlags.W ~= 0 and TDRId & aTileFlags.EL ~= 0) or
      (TDTId & aTileFlags.W ~= 0 and TDTId & aTileFlags.EB ~= 0) then
      return false end;
  -- Going down?
  elseif iDirection == DIR.D then
    CP, DP = 0, GetLevelOffsetFromObject(aObject, 8, 16) or 0;
    GetDigTileData();
    local TDLId<const>, TDTId<const>, TDRId<const>, TDBId<const> =
      aTileData[1 + LId], aTileData[1 + TId], aTileData[1 + RId],
      aTileData[1 + BId];
    if TDTId & aTileFlags.P ~= 0 or
      (TDBId & aTileFlags.W ~= 0 and TDBId & aTileFlags.ET ~= 0) or
      (TDLId & aTileFlags.W ~= 0 and TDLId & aTileFlags.ER ~= 0) or
      (TDRId & aTileFlags.W ~= 0 and TDRId & aTileFlags.EL ~= 0) then
      return false end;
  else return false end;
  -- Get digging data table
  local aDigDataItem<const> = aDigData[iDirection];
  if not aDigDataItem then return false end;
  -- Walk through all the digger data structs to find info about current tile
  for iI = 1, #aDigDataItem do
    -- Get dig data and data about the specific tile to check for
    local aDigItem<const> = aDigDataItem[iI];
    local FL<const>,   FO<const>,   FA<const>,   FB<const>,
          FC<const>,   TO<const>,   TA<const>,   TB<const> =
          aDigItem[8], aDigItem[1], aDigItem[2], aDigItem[3],
          aDigItem[4], aDigItem[5], aDigItem[6], aDigItem[7];
    -- Perform the checks
    if (FL & DF.MO == 0 or (FL & DF.MO ~= 0 and AId == FO)) and
       (FL & DF.MA == 0 or (FL & DF.MA ~= 0 and TId == FA)) and
       (FL & DF.MB == 0 or (FL & DF.MB ~= 0 and BId == FB)) and
       (FL & DF.MC == 0 or (FL & DF.MC ~= 0 and CId == FC)) then
      -- Terrain should change?
      if FL & DF.SO ~= 0 then
        -- Check ToOver and convert random shaft tiles
        local aDugData<const> = aDugRandShaftData[TO];
        if aDugData then AId = aDugData[random(#aDugData)];
        else AId = TO end;
        -- Successful dig should search for treasure and if successful? Then
        -- Increment the gem found counter for object and it's parent
        if FL & DF.OG ~= 0 and RollTheDice(aObject.X, aObject.Y) then
          SetObjectAndParentCounter(aObject, "GEM") end;
      end
      -- Set tiles if needed
      if FL & DF.SA ~= 0 then TId = TA end;
      if FL & DF.SB ~= 0 then BId = TB end;
      -- Set digger flags if needed
      if FL & DF.OB ~= 0 then aObject.F = aObject.F | OFL.BUSY end;
      if FL & DF.OI ~= 0 then aObject.F = aObject.F & ~OFL.BUSY end;
      -- If tile location is not at the top of the level. Update above tile
      if DP >= iLLAbsW then
        UpdateLevel(DP-iLLAbsW, TId) end;
      -- Update level
      UpdateLevel(DP, AId);
      -- If tile location is not at the bottom of the level. Update below tile
      if DP < iLLAbs-iLLAbsW then
        UpdateLevel(DP+iLLAbsW, BId) end;
      -- Dig was successful
      return true;
    end
  end
  -- Dig failed
  return false;
end
-- Set object health ------------------------------------------------------- --
local function AdjustObjectHealth(aVictimObj, iAmount, aCauseObj)
  -- Calculate new health amount and if still alive?
  local iNewHealth<const> = aVictimObj.H + iAmount;
  if iNewHealth > 0 then
    -- Clamp at a 100% if needed or update the objects new health
    if iNewHealth > 100 then aVictimObj.H = 100
                        else aVictimObj.H = iNewHealth end;
    -- Do not do anything else
    return;
  end;
  -- Object is dead so clamp health to zero or update the objects new health
  if iNewHealth < 0 then aVictimObj.H = 0 else aVictimObj.H = iNewHealth end;
  -- Kill object (Don't move this, for explosion stuff to work)
  SetAction(aVictimObj, ACT.DEATH, JOB.INDANGER, DIR.NONE);
  -- Remove jump and falling status from object
  local iFlags<const> = aVictimObj.F & ~(OFL.JUMPRISE|OFL.JUMPFALL);
  aVictimObj.F = iFlags;
  -- Get victim name
  local sVictim<const> = aVictimObj.OD.NAME..
    "["..aVictimObj.U.."] at X:"..aVictimObj.X.." Y:"..aVictimObj.Y;
  -- If caused by another object?
  if aCauseObj then
    -- Get causer name
    local sCauser<const> = aCauseObj.OD.NAME..
       "["..aCauseObj.U.."] at X:"..aCauseObj.X.." Y:"..aCauseObj.Y;
    -- Was victim a living thing?
    if iFlags & OFL.LIVING ~= 0 then
      -- increase their living kills count and log the kill
      CoreLog(sCauser.." killed "..sVictim.."!");
      SetObjectAndParentCounter(aCauseObj, "LK");
    -- Was victim an enemy?
    elseif iFlags & OFL.ENEMY ~= 0 then
      -- Increase their enemy kills count and log the kill
      CoreLog(sCauser.." destroyed enemy "..sVictim.."!");
      SetObjectAndParentCounter(aCauseObj, "EK");
    -- Anything else? Log the destruction
    else CoreLog(sCauser.." destroyed "..sVictim.."!") end;
  -- No killer and is living
  elseif iFlags & OFL.LIVING ~= 0 then CoreLog(sVictim.." died!");
  -- No killer? Log the destruction
  else CoreLog(sVictim.." was destroyed!") end;
  -- Object explodes on death?
  if aVictimObj.F & OFL.EXPLODE ~= 0 then
    -- Enumerate possible destruct positions again. We can't have the TERRAIN
    -- destruction checks in the above enumeration because of the recursive
    -- nature of the OBJECT destruction which would cause problems.
    for iExplodeIndex = 1, #aExplodeDirData do
      -- Get destruct adjacent position data
      local aCoordAdjust<const> = aExplodeDirData[iExplodeIndex];
      -- Clamp the centre tile position of the explosion for the level
      local iX<const>, iY<const> =
        (aVictimObj.X + 8) // 16 + aCoordAdjust[1],
        (aVictimObj.Y + 8) // 16 + aCoordAdjust[2];
      -- Calculate locate of tile and if in valid bounds?
      local iId, iLoc<const> = GetLevelDataFromAbsCoordinates(iX, iY);
      if iId then
        -- Get position
        local iPosX<const>, iPosY<const> = iX*16, iY*16;
        -- Compare against all objects
        for iObject = 1, #aObjects do
          -- Get target object data and if not the same object?
          local aTarget<const> = aObjects[iObject];
          if aTarget ~= aVictimObj then
            -- Get action and if target object...
            local iAction<const> = aTarget.A;
            if iAction ~= ACT.DEATH and        -- ...is not dying?
               iAction ~= ACT.PHASE and        -- *and* not phasing?
               IsSpriteCollide(476, iPosX, iPosY, -- *and* in explosion?
                 aTarget.S, aTarget.X+aTarget.OFX, aTarget.Y+aTarget.OFY) then
              AdjustObjectHealth(aTarget, -100, aCauseObj);
            end
          end
        end
        -- Get tile flags and if tile is destructible and not been cleared?
        local iTFlags = aTileData[1 + iId];
        if iTFlags & aTileFlags.D ~= 0 and iTFlags & aTileFlags.AD == 0 then
          -- Increase dug count
          SetObjectAndParentCounter(aVictimObj, "DUG");
          -- Roll the dice and spawn treasure and increase objects gem find
          -- count if found
          if RollTheDice(iX * 16, iY * 16) then
            SetObjectAndParentCounter(aVictimObj, "GEM") end;
          -- Tile blown does not contain water?
          if iTFlags & aTileFlags.W == 0 then
            -- Set cleared dug tile
            UpdateLevel(iLoc, 7);
            -- Test for flooding around the cleared tile
            for iFloodIndex = 1, #aExplodeDirData do
              -- Get flood test data and calculate location to test
              local aFloodTestItem<const> = aExplodeDirData[iFloodIndex];
              local iTLoc<const> = (iLoc + (aFloodTestItem[2] *
                iLLAbsW)) + aFloodTestItem[1];
              -- Get tile id and if valid
              iId = GetLevelDataFromLevelOffset(iTLoc);
              if iId then
                -- Get flags to test for and insert a new flood if found
                local iTFFlags<const> = aFloodTestItem[3];
                if aTileData[1 + iId] & iTFFlags == iTFFlags then
                  aFloodData[1 + #aFloodData] = { iTLoc, iTFFlags };
                end
              end
            end
          else
            -- Set cleared water tile
            UpdateLevel(iLoc, 247);
            -- Test for flood here with all edges exposed
            aFloodData[1 + #aFloodData] = { iLoc, aTileFlags.W|aTileFlags.EA };
          end
          -- Tile blown was firm ground?
          if iTFlags & aTileFlags.F ~= 0 then
            -- Get tile location above
            local iTLoc<const> = iLoc - iLLAbsW;
            -- Get tile id and if valid?
            iId = GetLevelDataFromLevelOffset(iTLoc);
            if iId then
              -- Get above tile flags and if is a gate?
              local iATFlags<const> = aTileData[1 + iId];
              if iATFlags & aTileFlags.G ~= 0 then
                -- Find gate at that position
                for iObjId = 1, #aObjects do
                  -- Get object and if it's a deployed gate? Get its absolute
                  -- location and if it's the same? Destroy the deployed gate.
                  local aVictimObj<const> = aObjects[iObjId];
                  if aVictimObj.ID == TYP.GATEB and
                    GetLevelOffsetFromObject(aVictimObj, 0, 0) == iTLoc then
                      AdjustObjectHealth(aVictimObj, -100, aCauseObj) end;
                end
                -- Is watered gate? Set watered cleared tile else normal clear
                if iATFlags & aTileFlags.W ~= 0 then UpdateLevel(iTLoc, 247);
                                                else UpdateLevel(iTLoc, 7) end;
                -- Check if removed gate would cause a flood
                aFloodData[1 + #aFloodData] = { iTLoc, aTileFlags.EA };
              -- Not a gate?
              else
                -- Is a supported tile that we should clear
                local iToTile<const> = aExplodeAboveData[iId];
                if iToTile then UpdateLevel(iTLoc, iToTile) end;
              end
            end
          end
        end
      end
    end
  end
  -- Drop all objects
  while aVictimObj.IS do DropObject(aVictimObj, aVictimObj.IS) end;
  -- Disable menu if object is selected and menu open
  if aActiveObject == aVictimObj and aContextMenu then SetContextMenu() end;
end
-- Render terrain ---------------------------------------------------------- --
local function RenderTerrain()
  -- Render the backdrop
  BlitSLT(texLev, texBg,
    -iLLAbsW + ((iLLAbsW - iPosX) / iLLAbsW * 64),
    -32 + ((iLLAbsH - iPosY) / iLLAbsH * 32));
  -- Calculate the X pixel position to draw at
  local iXdraw<const> = iStageL + iPixCenPosX;
  -- For each screen row to draw tile at
  for iY = 0, iTilesHeight do
    -- Calculate the Y position to grab from the level data
    local iYdest<const> = 1 + (iPosY + iY) * iLLAbsW;
    -- Calculate the Y pixel position to draw at
    local iYdraw<const> = iStageT + iPixCenPosY + (iY * 16);
    -- For each screen column to draw tile at, draw the tile from level data
    for iX = 0, iTilesWidth do
      BlitSLT(texLev, aLevelData[iYdest + iPosX + iX],
        iXdraw + (iX * 16), iYdraw);
    end
  end
end
-- Render shroud data ------------------------------------------------------ --
local function RenderShroud()
  -- Calculate the X pixel position to draw at
  local iXdraw<const> = iStageL + iPixCenPosX;
  -- Set shroud colour
  texSpr:SetCRGBA(aShroudColour[1], aShroudColour[2], aShroudColour[3], 0.975);
  -- For each screen row to draw tile at
  for iY = 0, iTilesHeight do
    -- Calculate the Y position to grab from the level data
    local iYdest<const> = 1 + (iPosY + iY) * iLLAbsW;
    -- Calculate the Y pixel position to draw at
    local iYdraw<const> = iStageT + iPixCenPosY + (iY * 16);
    -- For each screen column to draw tile at
    for iX = 0, iTilesWidth do
      -- Get shroud information at specified tile and draw it if theres data
      local aItem<const> = aShroudData[iYdest + iPosX + iX];
      if aItem[2] < 0xF then
        BlitSLT(texSpr, aItem[1], iXdraw + (iX * 16), iYdraw);
      end
    end
  end
  -- Restore shroud colour
  texSpr:SetCRGBA(1.0, 1.0, 1.0, 1.0);
end
-- Render all objects ------------------------------------------------------ --
local function RenderObjects()
  -- Calculate viewpoint position
  local nVPX<const>, nVPY<const> = iPixPosX - iStageL, iPixPosY - iStageT;
  -- For each object
  for iObjId = 1, #aObjects do
    -- Get object data
    local aObject<const> = aObjects[iObjId];
    -- Holds objects render position on-screen
    local iXX, iYY = aObject.X - nVPX + aObject.OFX,
                     aObject.Y - nVPY + aObject.OFY;
    BCBlit(aObject.S, iXX, iYY, iXX + 16, iYY + 16);
    -- Got an attachment? Draw it too!
    if aObject.STA then
      iXX, iYY = iXX + aObject.OFXA, iYY + aObject.OFYA;
      BCBlit(aObject.SA, iXX, iYY, iXX + 16, iYY + 16);
    end
  end
end
-- Render Interface -------------------------------------------------------- --
local function RenderInterface()
  -- Render shadows around ui parts at button
  RenderShadow(8, 216, 136, 232);
  RenderShadow(144, 216, 224, 232);
  RenderShadow(232, 216, 312, 232);
  -- Draw bottom left part, money and health backgrounds
  for iColumn = 0, 6 do
    BlitSLT(texSpr, 821 + iColumn, 8 + (iColumn * 16), 216) end;
  -- What object is selected?
  if aActiveObject then
    -- Which indicator to draw?
    local iStatusId;
    -- Object does not have an owner? Draw 'O' indicator above object to
    -- indicate only the program can control this.
    local aParent<const> = aActiveObject.P;
    if not aParent then iStatusId = 980;
    -- If object has an owner but this client is not that owner? Draw 'X'
    -- indicator above object to indicate only the owner can control this.
    elseif aParent ~= aActivePlayer then iStatusId = 976;
    -- Parent is me?
    else
      -- If object is busy? Draw 'Zz' indicator above object to indicate
      -- control is temporarily disabled
      if aActiveObject.F & OFL.BUSY ~= 0 then iStatusId = 984;
      -- 'v' is default, free to control this object
      else iStatusId = 988 end;
      -- Get health and if object has health?
      local iHealth<const> = aActiveObject.H;
      if iHealth > 0 then
        -- Is a digger?
        if aActiveObject.DI then
          -- Draw a pulsating heart
          BlitSLT(texSpr, 797 +
            (iGameTicks // (1 + (iHealth // 5))) % 4, 47, 216);
          -- Digger has inventory?
          if aActiveObject.IW > 0 then
            -- X position of object on UI and tile ID
            local iX = 0;
            -- For each inventory
            local aObjInv<const> = aActiveObject.I;
            for iObjIndex = 1, #aObjInv do
              -- Get object
              local aObj<const> = aObjInv[iObjIndex];
              -- Get inventory conversion id and if we got it then draw it
              local iObjConvId<const> = aObj.OD.HUDSPRITE;
              if iObjConvId then BlitSLT(texSpr, iObjConvId, 61 + iX, 218);
              -- Draw as resized sprite
              else BlitSLTRB(texSpr, aObj.S, 61 + iX, 218, 69 + iX, 226) end;
              -- Increase X position
              iX = iX + 8;
            end
          end
        end
        -- Draw health bar
        DrawHealthBar(iHealth, 2, 61, 227, 61, 229);
      end
    end
    -- Draw the indicator
    BlitSLT(texSpr, iGameTicks // 5 % 4 + iStatusId,
      iStageL + iPixCenPosX + aActiveObject.X - iPosX * 16,
      iStageT + iPixCenPosY + aActiveObject.Y - iPosY * 16 - 16);
  end
  -- Tile to draw
  local iTile;
  -- Draw digger buttons and activity
  for iDiggerId = 1, 5 do
    -- Pre-calculate Y position
    local iY<const> = iDiggerId * 16;
    -- Get digger data and if Digger is alive?
    local aDigger<const> = aActivePlayer.D[iDiggerId];
    if aDigger then
       -- Digger is selected?
      if aActiveObject and aDigger == aActiveObject then
        -- Show lightened up button
        BlitSLT(texSpr, 808 + iDiggerId, 128 + iY, 216)
        -- Object is jumping?
        if aActiveObject.F & OFL.JUMPMASK ~= 0 then iTile = 836;
        -- Not jumping?
        else
          -- Get Digger action and if stopped?
          local iObjAction<const> = aActiveObject.A;
          if iObjAction == ACT.STOP then iTile = 834;
          -- If fighting?
          elseif iObjAction == ACT.FIGHT then iTile = 840;
          -- If teleporting?
          elseif iObjAction == ACT.PHASE then iTile = 841;
          -- Something else?
          else
            -- Get Digger job and if home or inside the home?
            local iObjJob<const> = aActiveObject.J;
            if iObjJob == JOB.HOME or iObjAction == ACT.HIDE then iTile = 838;
            -- If searching for treasure?
            elseif iObjJob == JOB.SEARCH then iTile = 839;
            -- If walking or running?
            elseif iObjAction == ACT.WALK or
              iObjAction == ACT.RUN then iTile = 835;
            -- If digging?
            elseif iObjAction == ACT.DIG then iTile = 837 end;
          end
        end
      -- Show dimmed button
      else BlitSLT(texSpr, 803 + iDiggerId, 128 + iY, 216) end;
      -- Status tile to draw
      local iStatusTile;
      -- Digger is in danger?
      if aDigger.J == JOB.INDANGER then
        -- Every even second set a different blue indicator.
        if iGameTicks % 120 < 60 then iStatusTile = 831;
                                 else iStatusTile = 832 end;
      -- Digger is in impatient and every even second?
      elseif aDigger.JT >= aDigger.PW and
             iGameTicks % 120 < 60 then iStatusTile = 833;
      -- Not in danger but busy?
      elseif aDigger.F & OFL.BUSY ~= 0 then iStatusTile = 830;
      -- Not in danger, not busy but doing something?
      elseif aDigger.A ~= ACT.STOP then iStatusTile = 829;
      -- Not in danger, not busy and not doing something
      else iStatusTile = 828 end;
      -- Show activity indicator (78-84)
      BlitSLT(texSpr, iStatusTile, 128 + iY, 204);
    -- Digger is not alive! Show dimmed button
    else BlitSLT(texSpr, 803 + iDiggerId, 128 + iY, 216) end;
  end
  -- Get player and opponent money
  local iPlayerMoney<const>, iOpponentMoney<const> =
    aActivePlayer.M, aOpponentPlayer.M;
  -- Tile was set? Draw it
  if iTile then BlitSLT(texSpr, iTile, 120, 216);
  -- No tile was set
  else
    -- Set tile id based on diggers count
    local iATile, iOTile = 868 + aOpponentPlayer.DC, 874 + aActivePlayer.DC;
    -- Get monies and increase flag depending on who has more money
    if iPlayerMoney > iOpponentMoney then iOTile = iOTile + 1;
    elseif iPlayerMoney < iOpponentMoney then iATile = iATile + 1 end;
    -- Draw flags for both sides
    BlitSLT(texSpr, iATile, 120, 216);
    BlitSLT(texSpr, iOTile, 120, 216);
  end
  -- Animate player one's money
  if iAnimMoney ~= iPlayerMoney then
    -- Animated money over actual money?
    if iAnimMoney > iPlayerMoney then
      -- Decrement it
      iAnimMoney = iAnimMoney - ceil((iAnimMoney - iPlayerMoney) * 0.1);
      -- Update displayed money
      sMoney = format("%04u", min(9999, iAnimMoney));
      -- Red colour, draw money and reset colour
      fontLittle:SetCRGB(1, 0.75, 0.75);
      Print(fontLittle, 15, 220, sMoney);
      fontLittle:SetCRGB(1, 1, 1);
    -- Animated money under actual money? Increment
    elseif iAnimMoney < iPlayerMoney then
      -- Increment it
      iAnimMoney = iAnimMoney + ceil((iPlayerMoney - iAnimMoney) * 0.1);
      -- Update displayed money
      sMoney = format("%04u", min(9999, iAnimMoney));
      -- Green colour, draw money and reset colour
      fontLittle:SetCRGB(0.75, 1, 0.75);
      Print(fontLittle, 15, 220, sMoney);
      fontLittle:SetCRGB(1, 1, 1);
    -- No change so set white font
    else
      -- Reset colour and draw money
      fontLittle:SetCRGB(1, 1, 1);
      Print(fontLittle, 15, 220, sMoney);
    end
  -- Animated money/actual money is synced, display blue if > 9999
  elseif iPlayerMoney > 9999 then
    -- Set other colour and draw money
    fontLittle:SetCRGB(0.75, 0.75, 1);
    Print(fontLittle, 15, 220, sMoney);
  -- Normal display
  else
    -- Reset colour and draw money
    fontLittle:SetCRGB(1, 1, 1);
    Print(fontLittle, 15, 220, sMoney);
  end
  -- Draw utility button
  BlitSLT(texSpr, 814, 232, 216);
  -- Draw info screen
  fcbInfoScreenCallback();
  -- I context menu selected?
  if aContextMenuData then
    -- Get object busy flag
    local bBusy<const> = aActiveObject.F & OFL.BUSY ~= 0;
    -- Walk through it and test position
    for iMIndex = 1, #aContextMenuData do
      -- Get context menu item and draw it
      local aMItem<const> = aContextMenuData[iMIndex];
      BlitSLTRB(texSpr, aMItem[2], aMItem[4], aMItem[5], aMItem[6], aMItem[7]);
      -- Render a dim if object is busy and tile data says we should
      if aMItem[3] and bBusy then
        texSpr:SetCRGBA(1, 0, 0, 0.5);
        BlitSLTRB(texSpr, 1022, aMItem[4], aMItem[5], aMItem[6], aMItem[7]);
        texSpr:SetCRGBA(1, 1, 1, 1);
      end
    end
    -- Draw context menu shadow
    RenderShadow(iMenuLeft, iMenuTop, iMenuRight, iMenuBottom);
    -- If inventory selected and drop menu open?
    local aInventory<const> = aActiveObject.IS;
    if aInventory and aContextMenu == aMenuData[MNU.DROP] then
      -- Draw active inventory item and health
      BlitSLT(texSpr, aInventory.S, iMenuLeft+23, iMenuTop+4);
      fontTiny:SetCRGB(1, 1, 1);
      PrintR(fontTiny, iMenuRight-2, iMenuTop+24, aInventory.H.."%");
    end
  end
  -- Render tooltip
  RenderTip();
end
-- Render all screen elements ---------------------------------------------- --
local function RenderAll()
  RenderTerrain();
  RenderObjects();
  RenderShroud();
  RenderInterface();
end
-- Check object is in water at specified pixel height ---------------------- --
local function CheckObjectInWater(aObject, iY)
  -- Get tile at the specified position from object and return if water
  local iId<const> = GetLevelDataFromObject(aObject, 8, iY);
  return iId and aTileData[1 + iId] & aTileFlags.W ~= 0;
end
-- Proc object underwater -------------------------------------------------- --
local function CheckObjectUnderwater(aObject)
  -- Ignore if object isn't underwater
  if aObject.F & OFL.AQUALUNG ~= 0 then return end;
  -- If object is not in water
  if not CheckObjectInWater(aObject, 2) then
    -- Remove flag if set
    if aObject.F & OFL.INWATER ~= 0 then
      aObject.F = aObject.F & ~OFL.INWATER end
    -- Done
    return;
  end
  -- Add in water flag if not set.
  if aObject.F & OFL.INWATER == 0 then
    aObject.F = aObject.F | OFL.INWATER end;
  -- If object is a digger and it isn't in danger? Run!
  if aObject.F & OFL.DIGGER ~= 0 and aObject.J ~= JOB.INDANGER then
    SetAction(aObject, ACT.RUN, JOB.INDANGER, DIR.KEEPMOVE) end;
  -- Only reduce health once per four game ticks
  if aObject.AT % aObject.LC == 0 then AdjustObjectHealth(aObject, -1) end;
end
-- Animate object ---------------------------------------------------------- --
local function AnimateObject(aObject)
  -- If sprite timer and not reached speed limit?
  if aObject.ST < aObject.ANT then
    aObject.ST = aObject.ST + 1 return end;
  -- Sprite id not reached the limit yet? Next sprite
  if aObject.S < aObject.S2 then
    aObject.S, aObject.SA = aObject.S+1, aObject.SA+1;
  -- Can sprite reset?
  elseif aObject.F & OFL.NOANIMLOOP == 0 then
    -- Restart sprite number
    aObject.S, aObject.SA = aObject.S1, aObject.S1A;
    -- Do we play the sound for the animation again?
    if aObject.F & OFL.SOUNDLOOP ~= 0 then
      -- Check if theres a sound to play and play sound if there is
      local iSound = aObject.AD.SOUND;
      if iSound then PlaySoundAtObject(aObject, iSound);
      -- No non-repeating sound...
      else
        -- Check if we have a sound with random pitch and if we do?
        iSound = aObject.AD.SOUNDRP;
        if iSound then
          PlaySoundAtObject(aObject, iSound, 0.975 + (random() % 0.05));
        end
      end
    end
  end
  -- Reset sprite timer
  aObject.ST = 0;
end
-- Make object face another ------------------------------------------------ --
local function GetTargetDirection(aObject, aTarget)
  if aTarget.X < aObject.X then return DIR.L;
  else return DIR.R end;
end
-- Check if object is colliding with another ------------------------------- --
local function CheckObjectCollision(aObject)
  -- Walk objects list
  for iIndex = 1, #aObjects do
    -- Get target object and if target object...
    local aTarget<const> = aObjects[iIndex];
    if aTarget ~= aObject and                -- ...is not me?
       aTarget.F & OFL.DIGGER ~= 0 and       -- *and* target is a digger?
       aTarget.F & OFL.WATERBASED == 0 and   -- *and* target isn't water based?
       aObject.H > 0 and                     -- *and* source is alive?
       aTarget.H > 0 and                     -- *and* target is alive?
       aTarget.A ~= ACT.PHASE and            -- *and* target not teleporting?
       aTarget.A ~= ACT.HIDE and             -- *and* target not hidden?
       aObject.A ~= ACT.EATEN and            -- *and* source object not eaten?
       maskSpr:IsCollideEx(                  -- *and* target collides source?
         477, aObject.X, aObject.Y, maskSpr,
         477, aTarget.X, aTarget.Y) then
      -- If object can consume the object?
      if aObject.F & OFL.CONSUME ~= 0 then
        -- Kill egg
        AdjustObjectHealth(aObject, -100, aTarget);
        -- Eat digger and set it to busy
        SetAction(aTarget, ACT.EATEN, JOB.NONE, DIR.KEEP);
        -- This digger is selected by the client? Unset control menu
        if aActiveObject == aTarget then SetContextMenu() end;
        -- Don't need to test collision anymore since we killed the egg
        return;
      -- If target object is not eaten?
      elseif aTarget.A ~= ACT.EATEN then
        -- If object can phase the Digger? Phase target to another object
        if aObject.F & OFL.PHASEDIGGER ~= 0 then
          SetAction(aTarget, ACT.PHASE, JOB.PHASE, DIR.D);
        -- If object can heal the Digger? Increase health
        elseif aObject.F & OFL.HEALNEARBY ~= 0 then
          AdjustObjectHealth(aTarget, 1, aObject);
        -- If object can hurt the Digger?
        elseif aObject.F & OFL.HURTDIGGER ~= 0 then
          -- Object is stationary? Make me fight and face the digger
          if aObject.F & OFL.STATIONARY ~= 0 then
            SetAction(aObject, ACT.FIGHT, JOB.NONE,
              GetTargetDirection(aObject, aTarget));
          -- Change to objects direction if object moving parallel to Digger
          elseif aObject.F & OFL.PURSUEDIGGER ~= 0 then
            SetAction(aObject, ACT.KEEP, JOB.KEEP,
              GetTargetDirection(aObject, aTarget)) end;
          -- Target is not jumping?
          if aTarget.F & (OFL.JUMPRISE|OFL.JUMPFALL) == 0 then
            -- Digger isn't running? Make him run!
            if aTarget.A ~= ACT.RUN then
              SetAction(aTarget, ACT.RUN, JOB.INDANGER, DIR.LR);
            else
              SetAction(aTarget, ACT.KEEP, JOB.INDANGER, DIR.KEEP);
            end
          -- Target in danger
          else aTarget.J = JOB.INDANGER end;
          -- Reduce health
          AdjustObjectHealth(aTarget, -1, aObject);
        -- Object is dangerous and target is not jumping?
        elseif aObject.F & OFL.DANGEROUS ~= 0 then
          -- Target is not jumping?
          if aTarget.F & (OFL.JUMPRISE|OFL.JUMPFALL) == 0 then
            -- Digger isn't running?
            if aTarget.A ~= ACT.RUN then
              -- Digger not moving in any direction?
              if aTarget.D ~= DIR.NONE then
                SetAction(aTarget, ACT.RUN, JOB.INDANGER, DIR.KEEP);
              -- No direction? so run in opposite direction
              else SetAction(aTarget, ACT.RUN, JOB.INDANGER, DIR.LR) end;
            -- Object is not moving and direction set? Keep dir and set danger
            elseif aTarget.D ~= DIR.NONE then
              SetAction(aTarget, ACT.KEEP, JOB.INDANGER, DIR.KEEP);
            -- No direction? so run in opposite direction of object
            else SetAction(aTarget, ACT.RUN, JOB.INDANGER,
              GetTargetDirection(aTarget, aObject)) end;
          end
        -- Else if object...
        elseif aObject.F & OFL.DIGGER ~= 0 and -- Object is Digger?
           not aObject.FT and                  -- *and* has no fight target?
               aTarget.F & OFL.BUSY == 0 and   -- *and* target object not busy?
               aObject.F & OFL.BUSY == 0 and   -- *and* source object not busy?
               aObject.P ~= aTarget.P and      -- *and* not same owner?
               aTarget.A ~= ACT.JUMP and       -- *and* target not jumping
              (aObject.A == ACT.FIGHT or       -- *and* object is fighting?
               aObject.AT >= 30) then          -- *or* > 1/2 sec action timer
          -- Make us face the target
          SetAction(aObject, ACT.FIGHT, JOB.INDANGER,
            GetTargetDirection(aObject, aTarget));
          -- Fight and set objects fight target
          aObject.FT = aTarget;
          -- Target isn't fighting?
          if not aTarget.FT and aTarget.AT >= 30 then
            -- Make target fight the object
            SetAction(aTarget, ACT.FIGHT, JOB.INDANGER,
              GetTargetDirection(aTarget, aObject));
            -- Set targets fight target to this object
            aTarget.FT = aObject;
          end
        end
      -- Target is eaten? If object can phase the digger
      elseif aObject.F & OFL.PHASEDIGGER ~= 0 then
        -- Make eaten digger phase to some other object and troll it!
        SetAction(aTarget, ACT.PHASE, JOB.PHASE, DIR.DR);
      end
    end
  end
  -- Fight target was found?
  if aObject.FT then
    -- Still fighting?
    if aObject.A == ACT.FIGHT then
      -- Punch sprite?
      if aObject.ST == 1 then
        -- Deal damage equal to my strength
        AdjustObjectHealth(aObject.FT, aObject.STRP, aObject);
        if random() < 0.25 then PlaySoundAtObject(aObject, aSfxData.PUNCH) end;
      -- Kick sprite?
      elseif aObject.ST == 4 then
        -- Deal damage equal to my strength
        AdjustObjectHealth(aObject.FT, aObject.STRK, aObject);
        if random() < 0.25 then PlaySoundAtObject(aObject, aSfxData.KICK) end;
      end
      -- Make object run in opposite direction if object is...
      if aObject.H < 10 and            -- ...low on health?
         random() < aObject.IN then    -- *and* intelligent enough to run?
        SetAction(aObject, ACT.RUN, JOB.INDANGER, DIR.OPPOSITE) end;
    end
    -- Clear fight target
    aObject.FT = nil;
  -- No more fight targets so stop fighting if...
  elseif aObject.A == ACT.FIGHT and    -- ...object is fighting?
        (aObject.F & OFL.DIGGER ~= 0 or -- *and* object is a Digger?
         aObject.AT >= 360) then        -- *or* action time 360 frames?
    SetAction(aObject, ACT.STOP, JOB.INDANGER, DIR.KEEP);
  end
end
-- Object collides with an object which acts as terrain -------------------- --
local function IsCollidePlatform(aSrcObj, iX, iY)
  -- Ignore if not enough objects to compare
  if #aObjects <= 1 then return false end;
  -- If source object is a blocking platform too then we should use a
  -- different mask id.
  local iSrcMaskId;
  if aSrcObj.F & OFL.BLOCK ~= 0 then
    iSrcMaskId = 474 else iSrcMaskId = 478 end;
  -- For each object...
  for iObj = 1, #aObjects do
    -- Get target object to test with
    local aDstObj<const> = aObjects[iObj];
    -- If the target object set to block? If object isn't the target object?
    -- and the specified object collides with the target object? then yes!
    if aDstObj.F & OFL.BLOCK ~= 0 and aSrcObj ~= aDstObj and
      maskSpr:IsCollideEx(474, aDstObj.X, aDstObj.Y,
      maskSpr, iSrcMaskId, aSrcObj.X + iX, aSrcObj.Y + iY)
        then return true end;
  end
  -- No collision with any other object
  return false;
end
-- Object collides with background? ---------------------------------------- --
local function IsCollideX(aObject, nX)
  return maskZone:IsCollide(maskSpr, 478, aObject.X + nX, aObject.Y) or
    IsCollidePlatform(aObject, nX, 0) end;
local function IsCollideY(aObject, nY)
  return maskZone:IsCollide(maskSpr, 478, aObject.X, aObject.Y + nY) or
    IsCollidePlatform(aObject, 0, nY) end;
local function IsCollide(aObject, nX, nY)
  return maskZone:IsCollide(maskSpr, 478, aObject.X + nX, aObject.Y + nY) or
    IsCollidePlatform(aObject, nX, nY) end;
-- Object colliding with another object ------------------------------------ --
local function IsObjectCollide(aObject, aTarget)
  return maskSpr:IsCollideEx(aObject.S, aObject.X, aObject.Y,
    maskSpr, aTarget.S, aTarget.X, aTarget.Y) end;
-- Adjust object position -------------------------------------------------- --
local function AdjustPosX(aObject, nX)
  SetPositionX(aObject, aObject.X + nX);
  MoveOtherObjects(aObject, nX, 0);
end
local function AdjustPosY(aObject, nY)
  SetPositionY(aObject, aObject.Y + nY);
  MoveOtherObjects(aObject, 0, nY);
end
local function AdjustPos(aObject, nX, nY)
  SetPositionX(aObject, aObject.X + nX);
  SetPositionY(aObject, aObject.Y + nY);
  MoveOtherObjects(aObject, nX, nY);
end
-- Move object vertically -------------------------------------------------- --
local function MoveY(aObject, iY)
  -- Object can't move vertically? Stop the object
  if IsCollideY(aObject, iY) then
    SetAction(aObject, ACT.STOP, JOB.KEEP, DIR.KEEP);
  -- Object can move in requested direction
  else AdjustPosY(aObject, iY) end;
end
-- Move object horizontally ------------------------------------------------ --
local function MoveX(aObj, iX)
  -- Get object flags and if object is...
  local iFlags<const> = aObj.F;
  if iFlags & OFL.JUMPRISE ~= 0 or     -- Jumping (rising)?
     iFlags & OFL.JUMPFALL ~= 0 or     -- Jumping (falling)?
     iFlags & OFL.FLOATING ~= 0 then   -- Floating (water)?
    -- Object can move to next horizontal pixel? Move horizontally!
    if not IsCollideX(aObj, iX) then AdjustPosX(aObj, iX) end;
    -- Done
    return;
  end
  -- Try walking up to walking down a steep slope
  for iY = 2, -2, -1 do
    if not IsCollide(aObj, iX, iY) then AdjustPos(aObj, iX, iY) return end;
  end
  -- Ignore if falling
  if aObj.FD > 0 then return end;
  -- Get action to perform when object blocked
  local aBlockData<const> = aDigBlockData[aObj.J];
  -- Set action requested
  SetAction(aObj, aBlockData[1], aBlockData[2], aBlockData[3]);
end
-- Check for colliding objects and move them ------------------------------- --
local function InitMoveOtherObjects()
  -- Actual function
  local function MoveOtherObjects(aObject, nX, nY)
    -- If i'm not a platform then return
    if aObject.F & OFL.BLOCK == 0 then return end;
    -- For each object
    for iTargetIndex = 1, #aObjects do
      -- Get target object and if it...
      local aTarget<const> = aObjects[iTargetIndex];
      if aTarget ~= aObject and           -- ...target object isn't me?
         aTarget.F & OFL.BLOCK == 0 and   -- *and* target object doesn't block?
         aTarget.A ~= ACT.PHASE and       -- *and* is not phasing?
         aTarget.A ~= ACT.DEATH and       -- *and* is not dying?
         maskSpr:IsCollideEx(aObject.S,   -- *and* doesn't collide with object?
           aObject.X, aObject.Y, maskSpr, 478, aTarget.X, aTarget.Y) then
        -- Test for crushing damage. If...
        if nY >= 1 and                     -- ...falling from above?
           aObject.FD >= 1 and             -- *and* object isnt falling?
           aTarget.F & OFL.DEVICE == 0 and -- *and* target isn't a device?
           aTarget.FS == 1 then            -- *and* target isn't falling?
          AdjustObjectHealth(aTarget, -aObject.FD, aObject) end;
        -- Move that object too
        MoveX(aTarget, nX);
        MoveY(aTarget, nY);
        -- Prevent object from taking fall damage
        aTarget.FD, aTarget.FS = 0, 1;
      end
    end
  end
  -- Return actual function
  return MoveOtherObjects;
end
-- Create object function initialiser -------------------------------------- --
local function InitCreateObject()
  -- Direction table for AIFindTarget -------------------------------------- --
  local aFindTargetData<const> = {
    { DIR.UL,  DIR.U,  DIR.UR }, -- This is used for the AI.FIND(SLOW)
    { DIR.L, DIR.NONE,  DIR.R }, -- AI procedure. It's a lookup table for
    { DIR.DL,  DIR.D,  DIR.DR }  -- quick conversion from co-ordinates.
  };
  -- Picks a new target ---------------------------------------------------- --
  local function PickNewTarget(aObject)
    -- Holds potential targets
    local aTargets<const> = { };
    -- For each player...
    for iPlayer = 1, #aPlayers do
      -- Get player data and enumerate their diggers
      local aDiggers<const> = aPlayers[iPlayer].D;
      for iDiggerId = 1, #aDiggers do
        -- Get digger object and insert it in target list if a valid target
        local aDigger<const> = aDiggers[iDiggerId];
        if aDigger and aDigger.F & OFL.PHASETARGET ~= 0 then
          aTargets[1 + #aTargets] = aDigger;
        end
      end
    end
    -- Return if no targets found?
    if #aTargets == 0 then return end;
    -- Pick a random target and set it
    local aTarget<const> = aTargets[random(#aTargets)];
    aObject.T = aTarget;
    -- Initially move in direction of target
    SetAction(aObject, ACT.KEEP, JOB.KEEP,
      GetTargetDirection(aObject, aTarget));
    -- Return target
    return aTarget;
  end
  -- Get target change time
  local iTargetChangeTime<const> = aTimerData.TARGETTIME;
  -- Process find target logic --------------------------------------------- --
  local function AIFindTarget(aObject)
    -- Return if busy
    if aObject.F & OFL.BUSY ~= 0 then return end;
    -- Get target and if set?
    local aTarget = aObject.T;
    if aTarget then
      -- If target time elapsed?
      if aObject.AT >= iTargetChangeTime or
         aTarget.F & OFL.PHASETARGET == 0 then
        -- Set a new target and if we got one?
        local aNewTarget<const> = PickNewTarget(aObject);
        if aNewTarget then
          -- Get my unique ID
          local iUId<const> = aObject.U;
          -- Remove me from old targets list
          aTarget.TL[iUId] = nil;
          -- Add me to the new targets list
          aNewTarget.TL[iUId] = aObject;
          -- Set new target
          aTarget = aNewTarget;
        end
      end
    -- No target so...
    else
      -- Initialise a new target and if we did? Add me to targets pursuer list
      aTarget = PickNewTarget(aObject);
      if aTarget then aTarget.TL[aObject.U] = aObject else return end;
    end
    -- Variables for adjusted coordinates
    local iXA, iYA = 0, 0;
    -- This X is left of target X? Move right one pixel
    if aObject.X < aTarget.X then iXA = iXA + 1;
    -- X is right of target X? Move left one pixel
    elseif aObject.X > aTarget.X then iXA = iXA - 1 end;
    -- If we can move to requested horizontal position?
    -- Move to requested horizontal position
    if not IsCollideX(aObject, iXA) then AdjustPosX(aObject, iXA) end;
    -- This Y is left of target Y? Move down one pixel
    if aObject.Y < aTarget.Y then iYA = iYA + 1;
    -- Y is right of target Y? Move up one pixel
    elseif aObject.Y > aTarget.Y then iYA = iYA - 1 end;
    -- If we can move to requested vertical position?
    -- Move to requested vertical position
    if not IsCollideY(aObject, iYA) then AdjustPosY(aObject, iYA) end;
    -- Increment values for table lookup
    iXA, iYA = iXA + 2, iYA + 2;
    -- Direction changed? Change direction!
    local iDirection<const> = aFindTargetData[iYA][iXA]
    if aObject.D ~= iDirection then
      SetAction(aObject, ACT.KEEP, JOB.KEEP, iDirection);
    end
  end
  -- Process find target logic (slow --------------------------------------- --
  local function AIFindTargetSlow(aObject)
    -- Move closer to selected target every even action frame
    if aObject.AT % 2 == 0 then AIFindTarget(aObject) end;
  end
  -- Returns if object has sellable items----------------------------------- --
  local function ObjectHasValuables(aObject)
    -- Get object inventory and if we have items?
    local aInventory<const> = aObject.I;
    if #aInventory > 0 then
      -- Enumerate them...
      for iInvIndex = 1, #aInventory do
        -- Get object in inventory. If is sellable regardless of owner?
        local aInventoryObject<const> = aInventory[iInvIndex];
        if aInventoryObject.F & OFL.SELLABLE ~= 0 and
          CanSellGem(aInventoryObject.ID) then return true end;
      end
    end
    -- Nothing to sell
    return false;
  end
  -- If object can jump left then jump left -------------------------------- --
  local function ObjectTryJumpLeft(aObject)
    if IsCollide(aObject, -1, -2) and not IsCollide(aObject, -1, -16) then
      SetAction(aObject, ACT.JUMP, JOB.KEEP, DIR.KEEP) return true end;
    return false;
  end
  -- If object can jump right then jump right------------------------------- --
  local function ObjectTryJumpRight(aObject)
    if IsCollide(aObject, 1, -2) and not IsCollide(aObject, 1, -16) then
      SetAction(aObject, ACT.JUMP, JOB.KEEP, DIR.KEEP) return true end;
    return false;
  end
  -- Lookup table for jumping ---------------------------------------------- --
  local aJumpCheckFunctions<const> = {
    [DIR.UL] = ObjectTryJumpLeft, [DIR.UR] = ObjectTryJumpRight,
    [DIR.L]  = ObjectTryJumpLeft, [DIR.R]  = ObjectTryJumpRight,
    [DIR.DL] = ObjectTryJumpLeft, [DIR.DR] = ObjectTryJumpRight
  };
  -- Try to jump the object and return if we did --------------------------- --
  local function ObjectJumped(aObject)
    -- Return if digger is digging or digger has fall damage
    if aObject.J == JOB.DIG or aObject.FD > 0 then return false end;
    -- 50% chance to check to jump
    if random() < 0.5 then
      -- Check if direction is important and call the associated function
      local fcbJumpCheck<const> = aJumpCheckFunctions[aObject.D];
      if fcbJumpCheck then return fcbJumpCheck(aObject) end;
    end
    -- Object didn't jump
    return false;
  end
  -- Digger AI choices (Chances to change action per tick) ----------------- --
  local aAIData<const> = {
    -- Ai is stopped?
    [ACT.STOP] = {
      -- No job set?
      [JOB.NONE] = { [DIR.UL] = 0.02,  [DIR.U]    = 0.1,  [DIR.UR] = 0.02,
                     [DIR.L]  = 0.02,  [DIR.NONE] = 0.1,  [DIR.R]  = 0.02,
                     [DIR.DL] = 0.02,  [DIR.D]    = 0.02, [DIR.DR] = 0.02 },
      -- Job is to dig?
      [JOB.DIG] = { [DIR.UL] = 0.02,  [DIR.U]    = 0.02, [DIR.UR] = 0.02,
                    [DIR.L]  = 0.02,  [DIR.NONE] = 0.02, [DIR.R]  = 0.02,
                    [DIR.DL] = 0.02,  [DIR.D]    = 0.02, [DIR.DR] = 0.02 },
    -- Ai is walking?
    }, [ACT.WALK] = {
      -- Job is bouncing around?
      [JOB.BOUNCE] = { [DIR.UL] = 0.001, [DIR.UR] = 0.001,  [DIR.L] = 0.001,
                       [DIR.R]  = 0.001, [DIR.DL] = 0.02,   [DIR.D] = 0.002,
                       [DIR.DR] = 0.02 },
      -- Job is digging?
      [JOB.DIG] = { [DIR.UL] = 0.002, [DIR.UR] = 0.002,  [DIR.L]  = 0.001,
                    [DIR.R]  = 0.001, [DIR.DL] = 0.02,   [DIR.DR] = 0.05 },
      -- Job is digging down? (Very narrow time frame)
      [JOB.DIGDOWN] = { [DIR.D] = 0.95 },
      -- Job is searching for treasure?
      [JOB.SEARCH] = { [DIR.L] = 0.002, [DIR.R] = 0.002 },
    -- Ai is running?
    }, [ACT.RUN] = {
      -- Job is bouncing around?
      [JOB.BOUNCE] = { [DIR.L] = 0.01, [DIR.R] = 0.01 },
      -- Job is in danger?
      [JOB.INDANGER] = { [DIR.L] = 0.002, [DIR.R] = 0.002 },
    },
  };
  -- Fall check directions ------------------------------------------------- --
  local aAIFallCoordsCheck<const> = {
    [DIR.UL] = -1, [DIR.L]  = -1, [DIR.DL] = -1,
    [DIR.UR] =  1, [DIR.R]  =  1, [DIR.DR] =  1
  }
  -- Jump left check logic ------------------------------------------------- --
  local aAIWalkJumpGapLeftData<const>  = { -24, -12 };
  local aAIWalkJumpGapRightData<const> = {  24,  12 };
  local aAIRunJumpGapLeftData<const>   = { -48, -24 };
  local aAIRunJumpGapRightData<const>  = {  48,  24 };
  -- Jump logic ------------------------------------------------------------ --
  local aAIJumpGapLogic<const> = {
    [ACT.WALK] = {
      [DIR.UL] = aAIWalkJumpGapLeftData,  [DIR.L]  = aAIWalkJumpGapLeftData,
      [DIR.UR] = aAIWalkJumpGapRightData, [DIR.DL] = aAIWalkJumpGapLeftData,
      [DIR.R]  = aAIWalkJumpGapRightData, [DIR.DR] = aAIWalkJumpGapRightData
    },
    [ACT.RUN] = {
      [DIR.UL] = aAIRunJumpGapLeftData,  [DIR.L]  = aAIRunJumpGapLeftData,
      [DIR.UR] = aAIRunJumpGapRightData, [DIR.DL] = aAIRunJumpGapLeftData,
      [DIR.R]  = aAIRunJumpGapRightData, [DIR.DR] = aAIRunJumpGapRightData
    }
  };
  -- AI Digger phasing out ------------------------------------------------- --
  local function PhaseHome(aObject)
    -- Reset last dig time
    aObject.LDT = iGameTicks;
    -- Teleport home
    return SetAction(aObject, ACT.PHASE, JOB.PHASE, DIR.U);
  end
  -- AI jumping gap logic -------------------------------------------------- --
  local function CheckForJump(aObject)
    -- Get jump data depending on action and if we got any?
    local aDirData<const> = aAIJumpGapLogic[aObject.A];
    if aDirData then
      -- Get X check coords depending on direction and if we have them?
      local aXCheck<const> = aDirData[aObject.D];
      if aXCheck then
        -- This is the furthest point of the jump and if object...
        local iXFar<const> = aXCheck[1];
        if not IsCollide(aObject, iXFar, -2) and       -- Can go furthest
           not IsCollide(aObject, aXCheck[2], -14) and -- Highest point?
               IsCollide(aObject, iXFar, 13) then      -- Stable ground?
          -- Jump the gap!
          SetAction(aObject, ACT.JUMP, JOB.KEEP, DIR.KEEP);
          -- Success!
          return true;
        end
      end
    end
  end
  -- AI digger logic ------------------------------------------------------- --
  local function AIDiggerLogic(aObject)
    -- Return if busy or not falling
    if aObject.F & OFL.BUSY ~= 0 or aObject.F & OFL.FALL == 0 then return end;
    -- Create object virtual health and double it if not delicate
    local iHealth;
    if aObject.F & OFL.DELICATE == 0 then iHealth = aObject.H * 2;
                                     else iHealth = aObject.H end;
    -- Object is not falling yet?
    if aObject.FD == 0 then
      -- Grab fall check coord adjust
      local iAdjX<const> = aAIFallCoordsCheck[aObject.D];
      if iAdjX then
        -- For water checking as we have to adjust to X centre for it
        local iAdjXW<const>, iAdjY = iAdjX + 8, 1;
        -- Repeat virtual falling...
        repeat
          -- If Digger is not in water?
          if aObject.F & OFL.INWATER == 0 then
            -- Go in opposite direction if we would fall into water
            local iId<const> =
              GetLevelDataFromObject(aObject, iAdjXW, iAdjY);
            if iId then
              -- Get tile data and if its water or firm ground?
              local iTD<const> = aTileData[1 + iId];
              if iTD & aTileFlags.W ~= 0 then break end;
            end
          end
          -- If we collide with the background
          if IsCollide(aObject, iAdjX, iAdjY) then
            -- Check if intelligent enough to jump the gap
            if iAdjY >= 16 and
               random() >= aObject.IN and
               CheckForJump(aObject) then return end;
            -- Falling is safe
            goto FallingIsSafe;
          end
          -- Go down 5 pixels (which removes 1 health)
          iAdjY, iHealth = iAdjY + 5, iHealth - 1;
        -- ...until Digger virtually dies while virtually falling
        until iHealth <= 0;
        -- Do we have intelligence to check the gap?
        if random() >= aObject.IN and CheckForJump(aObject) then return end;
        -- Get last anti-wriggle timeout value and if we're under reset limit?
        local iAntiWriggleTime<const> = aObject.AW;
        if iGameTicks < iAntiWriggleTime then
          -- Get current wriggle count and if we've wriggled too much?
          local iAntiWriggleRemain<const> = aObject.AWR + 1;
          if iAntiWriggleRemain >= 10 then
            -- Reset anti-wriggle timeframe to another 5 seconds
            aObject.AW, aObject.AWR = iGameTicks + 300, 0;
            -- Phase home
            return PhaseHome(aObject);
          -- Set new wriggle count
          else aObject.AWR = iAntiWriggleRemain end;
        -- Still in the timeframe? Reset anti-wriggle timeframe to another 5 seconds
        else aObject.AW, aObject.AWR = iGameTicks + 300, 0 end;
        -- This fall would kill cause the digger harm so evade the fall.
        do return SetAction(aObject, ACT.KEEP, JOB.KEEP, DIR.OPPOSITE) end;
        -- Fall is 'safe'
        ::FallingIsSafe::
      end
      -- Teleport home to rest and sell items if these conditions are met...
      if ObjectIsAtHome(aObject) and -- Object is at their home point? *and*
        (aObject.IW > 0 or           -- (Digger is carrying something? *or*
         aObject.H < 75) and         --  Health is under 75%) *and*
         aObject.A == ACT.STOP and   -- Digger has stopped?
         aObject.D ~= DIR.R then     -- Digger hasn't teleported yet?
        return SetAction(aObject, ACT.PHASE, JOB.PHASE, DIR.R);
      end
      -- Stop the Digger if needed so it can heal a bit if...
      if random() < 0.001 and           -- Intelligent enough? (0.1%)
         aObject.H <= 25 and            -- Below quarter health?
         aObject.A ~= ACT.STOP and      -- Not stopped?
         aObject.J ~= JOB.INDANGER then -- Not in danger?
        return SetAction(aObject, ACT.STOP, JOB.NONE, DIR.NONE);
      end
      -- If object...
      if (((random() <= 0.01 and               -- *and* (1% chance?
            aObject.H < 50) or                 -- *and* Health under 50%)
           (random() <= 0.001 and              -- *or* (0.1% chance?
            aObject.H >= 50)) and              -- *and* Health over 50%)
          aObject.J == JOB.INDANGER and        -- Object is in danger?
          aObject.A ~= ACT.STOP) or            -- *and* moving?
         (random() <= 0.001 and                -- *or* (0.1% chance?)
          aObject.IW >= aObject.MI and         -- *and* Digger has full inv?
          ObjectHasValuables(aObject)) or      -- *and* has sellable items?)
         (random() <= 0.01 and                 -- *or* (1% chance?)
          iGameTicks - aObject.LDT >= 7200 and -- *and* Not dug for 2 mins?
          aObject.A == ACT.STOP) then          -- *and* not moving?)
        PhaseHome(aObject);                    -- Phase home
      end
      -- Wait longer if health is needed
      if aObject.H < 50 and        -- Below half health?
         aObject.A == ACT.STOP and -- Stopped?
         random() > 0.001 then     -- Very big chance? (0.1%)
        return;                    -- Do nothing else
      end
      -- Digger is walking?
      if aObject.A == ACT.WALK then
        -- Every 1/2 sec and digger isn't searching? Pick up any treasure!
        if iGameTicks % 30 == 0 and aObject.J ~= JOB.SEARCH then
          PickupObjects(aObject, true);
        -- Check for jump and return if we did
        elseif ObjectJumped(aObject) then return end;
      -- Return if running and we can jump
      elseif aObject.A == ACT.RUN and ObjectJumped(aObject) then return end;
      -- A 0.01% chance occurred each frame?
      if random() < 0.0001 then
        -- Get digger inventory and if we have inventory?
        local aInventory<const> = aObject.I;
        if #aInventory > 0 then
          -- Walk Digger inventory
          for iInvIndex = 1, #aInventory do
            -- Get inventory object and if it is not treasure?
            local aInvObj<const> = aInventory[iInvIndex];
            if aInvObj.F & OFL.TREASURE == 0 then
              -- Drop it and do not drop anything else
              DropObject(aObject, aInvObj);
              break;
            end
          end
        end
      end
      -- Get AI data for action and if we have it
      local aAIDataAction<const> = aAIData[aObject.A];
      if aAIDataAction then
        -- Get AI data for job and if we have it
        local aAIDataJob<const> = aAIDataAction[aObject.J];
        if aAIDataJob then
          -- Get chance to change job and if that chance is triggered?
          local nAIDataDirection<const> = aAIDataJob[aObject.D];
          if nAIDataDirection and random() <= nAIDataDirection then
            -- Set a random job
            return SetRandomJob(aObject);
          end
        end
      end
    -- Teleport home to safely regain health if falling would kill digger
    elseif aObject.FD >= iHealth and   -- Falling damage would kill? *and*
           random() >= aObject.IN then -- Intelligent enough to teleport?
      PhaseHome(aObject);
    end
  end
  -- AI random direction logic initialisation data ------------------------- --
  local aAIRandomLogicInitData<const> = { DIR.U, DIR.D, DIR.L, DIR.R };
  -- AI random direction logic movement data ------------------------------- --
  local aAIRandomLogicMoveData<const> = {
    -- --------------------------------------------------------------------- --
    -- Try to move in these directions first...
    --             TeX TeY     TeX TeY
    --             \_/ \_/     \_/ \_/
    -- --------------------------------------------------------------------- --
    -- When blocked then an alternative list of directions is provided...
    --   TeX TeY Direction  TeX TeY Direction  TeX TeY Direction
    --   \_/ \_/   \_/      \_/ \_/   \_/      \_/ \_/   \_/
    -- --------------------------------------------------------------------- --
    [DIR.U] = { { {  0, -2 }, {  0, -1 } }, -- Going up?
      { { -1, -1, DIR.U }, {  1, -1, DIR.U }, { -1,  0, DIR.L },
        {  1,  0, DIR.R }, {  0,  1, DIR.D } } },
    -- --------------------------------------------------------------------- --
    [DIR.D] = { { {  0,  2 }, {  0,  1 } }, -- Going down?
      { {  0,  1, DIR.D }, { -1,  1, DIR.D }, {  1,  1, DIR.D },
        { -1,  0, DIR.L }, {  1,  0, DIR.R }, {  0, -1, DIR.U } } },
    -- --------------------------------------------------------------------- --
    [DIR.L] = { { { -2,  0 }, { -1,  0 } }, -- Going left?
      { { -1,  0, DIR.L }, { -1, -1, DIR.L }, { -1,  1, DIR.L },
        {  0, -1, DIR.U }, {  0,  1, DIR.D }, {  1,  0, DIR.R } } },
    -- --------------------------------------------------------------------- --
    [DIR.R] = { { {  2,  0 }, {  1,  0 } }, -- Going right?
      { {  1,  0, DIR.R }, {  1, -1, DIR.R }, {  1,  1, DIR.R },
        {  0, -1, DIR.U }, {  0,  1, DIR.D }, { -1,  0, DIR.L } } }
    -- --------------------------------------------------------------------- --
  };
  -- AI random direction logic --------------------------------------------- --
  local function AIRandomLogic(aObject)
    -- Return if busy
    if aObject.F & OFL.BUSY ~= 0 then return end;
    -- Set new direction if object has no direction
    local iDirection = aObject.D;
    if iDirection == DIR.NONE then
      return SetAction(aObject, ACT.KEEP, JOB.KEEP,
        aAIRandomLogicInitData[random(#aAIRandomLogicInitData)]) end;
    -- Get direction
    local aDData<const> = aAIRandomLogicMoveData[iDirection];
    -- Try every possible combination but the last
    local aPDData<const> = aDData[1];
    for iI = 1, #aPDData do
      local aPDItem<const> = aPDData[iI];
      if not IsCollide(aObject, aPDItem[1], aPDItem[2]) then
        return AdjustPos(aObject, aPDItem[1], aPDItem[2]) end;
    end
    -- Blocked so we need to find a new direction to move in
    local aDirections<const> = { };
    -- Try every possible combination but the last
    local aPossibleDirections<const> = aDData[2];
    for iI = 1, #aPossibleDirections - 1 do
      local aPDData<const> = aPossibleDirections[iI];
      if not IsCollide(aObject, aPDData[1], aPDData[2]) then
        aDirections[1 + #aDirections] = aPDData[3] end;
    end
    -- If we have a possible direction then go in that direction
    if #aDirections ~= 0 then iDirection = aDirections[random(#aDirections)];
    -- No direction found
    else
      -- Try going back in the previous direction
      local aPDData<const> = aPossibleDirections[#aPossibleDirections];
      if not IsCollide(aObject, aPDData[1], aPDData[2]) then
        iDirection = aPDData[3];
      -- Can't even go back in the previous direction so this position is FAIL
      else iDirection = DIR.NONE end
    end
    -- Pick a new direction from eligible directions
    SetAction(aObject, ACT.KEEP, JOB.KEEP, iDirection);
  end
  -- Bigfoot AI data ------------------------------------------------------- --
  local aAIBigFootData<const> = {
    { ACT.WALK,  JOB.BOUNCE, DIR.L    }, -- Chance to walk left
    { ACT.WALK,  JOB.BOUNCE, DIR.R    }, -- Chance to walk right
    { ACT.PHASE, JOB.PHASE,  DIR.D    }, -- Chance to phase randomly
    { ACT.STOP,  JOB.NONE,   DIR.NONE }, -- Chance to stop
  };
  -- Bigfoot AI ------------------------------------------------------------ --
  local function AIBigfoot(aObject)
    -- Return if object is busy
    if aObject.F & OFL.BUSY ~= 0 then return end;
    -- Jump if we can
    if aObject.A == ACT.WALK and ObjectJumped(aObject) then return end;
    -- Every 1/2 sec. Try to pick up anything
    if iGameTicks % 30 == 0 then return PickupObjects(aObject, false) end;
    -- If ADHD hasn't set in yet? Just return
    if random() > 0.001 then return end;
    -- Get and set a random action
    local aActionData<const> = aAIBigFootData[random(#aAIBigFootData)];
    SetAction(aObject, aActionData[1], aActionData[2], aActionData[3]);
  end
  -- Basic AI roaming ------------------------------------------------------ --
  local function AIRoam(aObject)
    -- Return if busy
    if aObject.F & OFL.BUSY ~= 0 then return end;
    -- Direction to go in
    local iAdjX;
    if aObject.D == DIR.L then iAdjX = -1 else iAdjX = 1 end;
    -- Move if object can move in its current direction, or the target
    -- time exceeds to create a sudden direction change.
    if not IsCollideX(aObject, iAdjX) and
      random() > aTimerData.ROAMDIRCHANGE then
        AdjustPosX(aObject, iAdjX);
    -- Blocked so go in opposite direction
    else SetAction(aObject, ACT.KEEP, JOB.KEEP, DIR.OPPOSITE) end;
  end
  -- Basic AI roaming (slow) ----------------------------------------------- --
  local function AIRoamSlow(aObject)
    -- Return if busy
    if aObject.F & OFL.BUSY ~= 0 then return end;
    -- Move around every 4th frame
    if aObject.AT % 4 == 0 then AIRoam(aObject) end;
  end
  -- Basic AI roaming (normal) --------------------------------------------- --
  local function AIRoamNormal(aObject)
    -- Return if busy
    if aObject.F & OFL.BUSY ~= 0 then return end;
    -- Move around every odd frame
    if aObject.AT % 2 == 0 then AIRoam(aObject) end;
  end
  -- Tunneller ------------------------------------------------------------- --
  local function AITunneller(aObject)
    -- Ignore if the tunneller is not stopped and a rare random value occurs
    if random() >= 0.001 or aObject.F & OFL.BUSY ~= 0 then return end;
    -- Pick a direction to tunnel in or stop
    if random() < 0.5 then
      SetAction(aObject, ACT.WALK, JOB.DIG, DIR.LR);
    else
      SetAction(aObject, ACT.STOP, JOB.NONE, DIR.NONE);
    end
  end
  -- Corkscrew actions ----------------------------------------------------- --
  local aAICorkscrewActions<const> = {
    [ACT.STOP] = { [JOB.NONE] = {
      { 0.001, ACT.CREEP, JOB.NONE,    DIR.LR   },
      { 0.001, ACT.CREEP, JOB.DIGDOWN, DIR.TCTR } }
    }, [ACT.DIG] = { [JOB.DIGDOWN] = {
      { 0.01,  ACT.STOP,  JOB.NONE,    DIR.NONE },
      { 0.001, ACT.CREEP, JOB.NONE,    DIR.LR   } }
    }, [ACT.CREEP] = { [JOB.NONE] = {
      { 0.001, ACT.STOP,  JOB.NONE,    DIR.LR   },
      { 0.001, ACT.CREEP, JOB.DIGDOWN, DIR.TCTR } }
    } };
  -- Corkscrew ------------------------------------------------------------- --
  local function AICorkscrew(aObject)
    -- Ignore if object is busy
    if aObject.F & OFL.BUSY ~= 0 then return end;
    -- Get data for current action
    local aAIActionData<const> = aAICorkscrewActions[aObject.A];
    if not aAIActionData then return end;
    -- Get data for current job
    local aAIJobData<const> = aAIActionData[aObject.J];
    if not aAIJobData then return end;
    -- For each item
    for iIndex = 1, #aAIJobData do
      -- Get item and set new action if the specified chance occurs
      local aAction<const> = aAIJobData[iIndex];
      if random() < aAction[1] then
        return SetAction(aObject,
          aAction[2], aAction[3], aAction[4], aAction[5]);
      end
    end
  end
  -- Exploder -------------------------------------------------------------- --
  local function AIExploder(aObject)
    -- Ignore if a rare random value occurs or object is busy
    if random() > 0.001 or aObject.F & OFL.BUSY ~= 0 then return end;
    -- Get objects parent and return if there is none (should be impossible)
    local aParent<const> = aObject.P;
    if not aParent then return end;
    -- Get object sprite and position
    local iX<const>, iY<const> = aObject.X, aObject.Y;
    -- For each object
    for iIndex = 1, #aObjects do
      -- Get object and if both objects are within reaching distance?
      local aTarget<const> = aObjects[iIndex];
      if abs(aTarget.X - iX) < 16 and abs(aTarget.Y - iY) < 16 then
        -- Target must have a parent and is different to objects
        local aTParent<const> = aTarget.P;
        if aTParent and aTParent ~= aParent then
          -- Set off the object exploding
          SetAction(aObject, ACT.DYING, JOB.NONE, DIR.NONE);
        end
      end
    end
  end
  -- AI for train for rails ------------------------------------------------ --
  local function AITrain(aObject)
    -- Ignore if a rare random value occurs or object is busy
    if random() > 0.001 or aObject.F & OFL.BUSY ~= 0 then return end;
    -- Go left, right or stop
    if random() > 0.5 then
      SetAction(aObject, ACT.WALK, JOB.SEARCH, DIR.LR);
    else
      SetAction(aObject, ACT.STOP, JOB.SEARCH, DIR.NONE);
    end
  end
  -- AI for lift ----------------------------------------------------------- --
  local function AILift(aObject)
    -- Ignore if a rare random value occurs or object is busy
    if random() > 0.001 or aObject.F & OFL.BUSY ~= 0 then return end;
    -- Go up or down or stop
    if random() > 0.5 then
      SetAction(aObject, ACT.CREEP, JOB.NONE, DIR.UD);
    else
      SetAction(aObject, ACT.STOP, JOB.NONE, DIR.NONE);
    end
  end
  -- AI for inflatable boat ------------------------------------------------ --
  local function AIBoat(aObject)
    -- Ignore if a rare random value occurs or object is busy
    if random() > 0.001 or aObject.F & OFL.BUSY ~= 0 then return end;
    -- Go up or down or stop
    if random() > 0.5 then
      SetAction(aObject, ACT.CREEP, JOB.NONE, DIR.LR);
    else
      SetAction(aObject, ACT.STOP, JOB.NONE, DIR.NONE);
    end
  end
  -- AI for anything deployable -------------------------------------------- --
  local function AIDeploy(aObject)
    -- Ignore if a rare random value occurs or object is busy
    if random() > 0.0001 or aObject.F & OFL.BUSY ~= 0 then return end;
    -- Deploy the object
    SetAction(aObject, ACT.DEPLOY, JOB.NONE, DIR.NONE);
  end
  -- AI for flood gate ----------------------------------------------------- --
  local function AIGate(aObject)
    -- Ignore if a rare random value occurs or object is busy
    if random() > 0.00001 or aObject.F & OFL.BUSY ~= 0 then return end;
    -- Open or close the gate
    if random() < 0.5 then
      SetAction(aObject, ACT.OPEN, JOB.NONE, DIR.NONE);
    else
      SetAction(aObject, ACT.CLOSE, JOB.NONE, DIR.NONE);
    end
  end
  -- AI id to function list ------------------------------------------------ --
  local aAIFuncs<const> = {
    [AI.NONE]        = false,            [AI.DIGGER]   = AIDiggerLogic,
    [AI.RANDOM]      = AIRandomLogic,    [AI.FIND]     = AIFindTarget,
    [AI.FINDSLOW]    = AIFindTargetSlow, [AI.CRITTER]  = AIRoamNormal,
    [AI.CRITTERSLOW] = AIRoamSlow,       [AI.BIGFOOT]  = AIBigfoot,
    [AI.TUNNELER]    = AITunneller,      [AI.EXPLODER] = AIExploder,
    [AI.CORKSCREW]   = AICorkscrew,      [AI.TRAIN]    = AITrain,
    [AI.LIFT]        = AILift,           [AI.BOAT]     = AIBoat,
    [AI.DEPLOY]      = AIDeploy,         [AI.GATE]     = AIGate
  }; ----------------------------------------------------------------------- --
  local function CreateObject(iObjId, iX, iY, aParent)
    -- Check parameters
    if not UtilIsInteger(iObjId) then
      error("Object id integer invalid! "..tostring(iObjId)) end;
    if iObjId < 0 then error("Object id "..iObjId.." must be positive!") end;
    if not UtilIsInteger(iX) then
      error("X coord integer invalid! "..tostring(iX)) end;
    if iX < 0 then error("X coord "..iX.." must be positive!") end;
    if iX >= iLLPixW then
      error("Y coord "..iX.." limit is "..iLLPixW.."!") end;
    if not UtilIsInteger(iY) then
      error("Y coord integer invalid! "..tostring(iY)) end;
    if iY < 0 then error("X coord "..iY.." must be positive!") end;
    if iY >= iLLPixH then
      error("Y coord "..iY.." limit is "..iLLPixH.."!") end;
    -- If too many objects? Put warning in console and return!
    if #aObjects >= 100000 then
      return CoreWrite("Warning! Too many objects creating "..iObjId..
        " at X="..iX.." and Y="..iY.." with parent "..tostring(aParent).."!",
        9);
    end
    -- Get and test object information
    local aObjData<const> = aObjectData[iObjId];
    if not UtilIsTable(aObjData) then error("Object data for #"..
      iObjId.." not in objects lookup!") end;
    -- Get object name
    local sName<const> = aObjData.NAME
    if not UtilIsString(sName) then error("Object name for #"..
      iObjId.." not in object data table!") end;
    -- Get and test AI type
    local iAI<const> = aObjData.AITYPE;
    if not UtilIsInteger(iAI) then error("Invalid AI type #"..
      tostring(iAI).." for "..sName.."["..iObjId.."]!") end
    -- Increment unique object id number
    iUniqueId = iUniqueId + 1;
    -- Build new object array
    local aObject<const> = {
      A    = ACT.NONE,                   -- Object action (ACT.*
      AA   = false,                      -- Attachment action data
      AD   = { },                        -- Reference to action data
      AI   = iAI,                        -- Object AI procedure
      ANT  = aObjData.ANIMTIMER,         -- Animation timer
      AT   = 0,                          -- Action timer
      AX   = 0,                          -- Tile X position clamped to 16
      AY   = 0,                          -- Tile Y position clamped to 16
      CS   = not not aObjData[ACT.STOP], -- Object can stop?
      D    = aObjData.DIRECTION,         -- Direction object is going in
      DA   = false,                      -- Attachment direction data
      DD   = { },                        -- Reference to direction data
      DID  = aObjData.DIGDELAY,          -- Digging delay
      DUG  = 0,                          -- Successful dig count
      EK   = 0,                          -- Fiends killed
      F    = aObjData.FLAGS or 0,        -- Object flags (OFL.*)
      FD   = 0,                          -- Amount the object has fallen by
      FDD  = DIR.NONE,                   -- Last failed dig direction
      FS   = 1,                          -- Object falling speed
      GEM  = 0,                          -- Gems found
      H    = 100,                        -- Object health
      I    = { },                        -- Inventory for this object
      ID   = iObjId,                     -- Object id (TYP.*)
      IN   = aObjData.INTELLIGENCE,      -- Intelligence
      IS   = nil,                        -- Selected inventory item
      IW   = 0,                          -- Weight of inventory
      J    = JOB.NONE,                   -- Object job (JOB.*)
      JD   = { },                        -- Reference to job data
      JT   = 0,                          -- Job timer
      LC   = aObjData.LUNGS,             -- Lung capacity
      LDT  = iGameTicks,                 -- Last successful dig time
      LK   = 0,                          -- Living things killed
      OD   = aObjData,                   -- Object data table
      OFX  = 0, OFY  = 0,                -- Drawing offset
      OFXA = 0, OFYA = 0,                -- Attachment drawing offset
      P    = aParent,                    -- Parent of object
      PW   = 0,                          -- Patience warning
      PL   = 0,                          -- Patience limit
      S    = 0,                          -- Current sprite frame #
      S1   = 0,                          -- Start sprite frame #
      S1A  = 0,                          -- Start attachment sprite frame #
      S2   = 0,                          -- Ending sprite frame #
      S2A  = 0,                          -- Ending attachment sprite frame #
      SA   = 0,                          -- Current attachment sprite frame #
      SM   = aObjData.STAMINA,           -- Object stamina
      SMM1 = aObjData.STAMINA-1,         -- Object stamina minus one
      ST   = 0,                          -- Sprite animation timer
      STA  = aObjData.ATTACHMENT,        -- Object attachment id
      STR  = aObjData.STRENGTH,          -- Object strength
      STRK = -ceil(aObjData.STRENGTH/4), -- Object damage on kick
      STRP = -ceil(aObjData.STRENGTH/2), -- Object damage on punch
      SX   = iX,                         -- Object starting position
      SY   = iY,                         -- Object starting position
      TD   = { },                        -- Ignored teleport destinations
      TL   = { },                        -- Objects that are targeting this
      U    = iUniqueId,                  -- Unique id
      US   = aParent and aParent.US,     -- Automatically un-shroud?
      W    = aObjData.WEIGHT,            -- Carry amount / requirement
      X    = 0,                          -- Absolute X position
      Y    = 0,                          -- Absolute Y position
    };
    -- Is AI function specified and not a player controlled parent?
    if iAI ~= AI.NONE and (not aParent or aParent.AI) then
      -- Lookup AI function and check that it's a function
      local fcbAIFunc<const> = aAIFuncs[iAI];
      if not UtilIsFunction(fcbAIFunc) then
        error("Unknown AI #"..tostring(iAI).."! "..tostring(fcbAIFunc)) end;
      -- Valid function to set it to call every tick
      aObject.AIF = fcbAIFunc;
    end
    -- Set position of object
    SetPosition(aObject, iX, iY);
    -- Set default action (also sets default direction);
    SetAction(aObject, aObjData.ACTION, aObjData.JOB, aObjData.DIRECTION);
    -- Insert into main object array
    aObjects[1 + #aObjects] = aObject;
    -- Log creation of item
    CoreLog("Created object '"..sName.."'["..iObjId.."] at X:"..
      iX..",Y:"..iY.." in position #"..#aObjects.."!");
    -- Return object
    return aObject;
  end
  -- Return the actual function
  return CreateObject;
end
-- Proc object floating ---------------------------------------------------- --
local function CheckObjectFloating(aObject)
  -- Ignore if object doesn't float
  if aObject.F & OFL.FLOAT == 0 then return false end;
  -- Get tile position and get tile id from level data and return if not water
  if not CheckObjectInWater(aObject, 13) then
    -- Floating if the pixel below is water
    if not CheckObjectInWater(aObject, 14) then
      -- Remove floating flag and all fall back
      aObject.F = (aObject.F | OFL.FALL) & ~OFL.FLOATING;
      -- Not floating so can fall
      return false;
    end
   -- Tile is water?
  else
    -- Set floating flag and remove fall flag
    aObject.F = (aObject.F | OFL.FLOATING) & ~OFL.FALL;
    -- Rise
    MoveY(aObject, -1);
  end
  -- Object is floating
  return true;
end
-- Process phasing logic function ------------------------------------------ --
local function PhaseLogic()
  -- AI player entered trade centre logic
  local function AIEnterTradeCentreLogic(aObj)
    -- Hide the digger
    SetAction(aObj, ACT.HIDE, JOB.PHASE, DIR.R);
    -- Number of items sold
    local iItemsSold = 0;
    -- Get object inventory and if inventory held
    local aInventory<const> = aObj.I;
    if #aInventory == 0 then return end;
    -- Get owner of this object
    local aParent<const> = aObj.P;
    -- For each item in digger inventory. We have to use a while loop
    -- as we need to remove items from the inventory.
    local iObj = 1 while iObj <= #aInventory do
      -- Get the inventory object and if the gem is sellable or the
      -- object has a owner and doesn't belong to this objects owner?
      -- Then try to sell the item and if succeeded? Increment the
      -- items sold.
      local aInvObj<const> = aInventory[iObj];
      local aInvParent<const> = aInvObj.P;
      if (CanSellGem(aInvObj.ID) or
         (aInvParent and aInvParent ~= aParent)) and
        SellItem(aObj, aInvObj) then iItemsSold = iItemsSold + 1;
      -- Conditions fail so try next inventory item.
      else iObj = iObj + 1 end;
    end
    -- Get opponent player
    local iOpponentID;
    if aParent.ID == 1 then iOpponentID = 2 else iOpponentID = 1 end;
    local aOpponent<const> = aPlayers[iOpponentID];
    -- If object...
    if random() > aObj.IN and             -- Isn't intelligent?
       aParent.M > aOpponent.M + 400 then -- *or* Way more cash?
      -- Try to purchase something random to keep the scores fair
      BuyItem(aObj, aShopData[random(#aShopData)])
    end
    -- If items were sold? Check if any player won
    if iItemsSold > 0 then EndConditionsCheck() end;
  end
  -- Phasing home or to a Telepole logic
  local function PhaseHomeOrTelepoleLogic(aObj)
    -- Reduce health as a cost for teleporting
    if aObj.F & OFL.TPMASTER == 0 then AdjustObjectHealth(aObj, -5) end;
    -- Go home?
    local bGoingHome = true;
    -- Is teleport master?
    local bIsTeleMaster<const> = aObj.F & OFL.TPMASTER ~= 0;
    -- Get current teleport destinations
    local aDestinations<const> = aObj.TD;
    -- For each object
    for iObjDestIndex = 1, #aObjects do
      -- Get object
      local TO<const> = aObjects[iObjDestIndex];
      -- If object is a Telepole and object is owned by this object
      -- or object is a teleport master and Telepole status nominal?
      if TO.ID == TYP.TELEPOLE and
         (TO.P == aObj.P or bIsTeleMaster) and
         TO.A == ACT.STOP then
        -- Ignore Telepole?
        local bIgnoreTelepole = false;
        -- Enumerate teleport destinations...
        for IDI = 1, #aDestinations do
          -- Get destination and set true if we've been here before
          local aDestination<const> = aDestinations[IDI];
          if aDestination == TO then bIgnoreTelepole = true break end;
        end
        -- Don't ignore Telepole?
        if not bIgnoreTelepole then
          -- Teleport to this device
          SetPosition(aObj, TO.X, TO.Y);
          -- Re-phase back into stance
          SetAction(aObj, ACT.PHASE, JOB.NONE, DIR.NONE);
          -- Add it to ignore teleport destinations list for next time.
          aDestinations[1 + #aDestinations] = TO;
          -- Don't go home
          bGoingHome = false;
          -- Done
          break;
        end
      end
    end
    -- Going home?
    if bGoingHome == true then
      -- Clear objects ignore destination list
      for iTDIndex = #aDestinations, 1, -1 do
        remove(aDestinations, iTDIndex) end
      -- Set position of object to player's home
      SetPosition(aObj, aObj.P.HX, aObj.P.HY);
      -- Re-phase back into stance
      SetAction(aObj, ACT.PHASE, JOB.NONE, DIR.KEEP);
    end
  end
  -- Player entering trade centre logic
  local function PlayerEnterTradeCentreLogic(aObj)
    -- Disable status screens
    SelectInfoScreen();
    -- Set new active object to this one if it isn't already
    SelectObject(aObj);
    -- Now in trade centre
    SetAction(aObj, ACT.HIDE, JOB.PHASE, DIR.R);
    -- We don't want to hear sounds
    SetPlaySounds(false);
    -- Init lobby
    InitLobby(false, 1);
  end
  -- Phase to a random target logic
  local function PhaseRandomTargetLogic(aObj)
    -- Walk objects list and find candidate objects to teleport to
    local aCandObjs<const> = { };
    for iCandObjId = 1, #aObjects do
      -- Get object and if the object isn't this object and object is
      -- a valid phase target? Insert into valid phase targets list.
      local aCandObj<const> = aObjects[iCandObjId];
      if aCandObj ~= aObj and aCandObj.F & OFL.PHASETARGET ~= 0 then
        aCandObjs[1 + #aCandObjs] = aCandObj;
      end
    end
    -- Have candidate objects?
    if #aCandObjs > 0 then
      -- Pick random object from array
      local aCandObj<const> = aCandObjs[random(#aCandObjs)];
      -- Set this objects position to the object
      SetPosition(aObj, aCandObj.X, aCandObj.Y);
      -- Re-phase back into stance
      SetAction(aObj, ACT.PHASE, JOB.NONE, DIR.KEEP);
    -- Else if object has owner, teleport home
    elseif aObj.P then
      -- Set position of object to player's home
      SetPosition(aObj, aObj.P.HX, aObj.P.HY);
      -- Re-phase back into stance
      SetAction(aObj, ACT.PHASE, JOB.NONE, DIR.KEEP);
    -- No owner = no home, just de-phase
    else SetAction(aObj, ACT.STOP, JOB.NONE, DIR.KEEP) end;
  end
  -- Functions base on direction
  local aFunctions<const> = {
    [DIR.R]  = AIEnterTradeCentreLogic,
    [DIR.U]  = PhaseHomeOrTelepoleLogic,
    [DIR.UL] = PlayerEnterTradeCentreLogic,
    [DIR.D]  = PhaseRandomTargetLogic,
    [DIR.DR] = PhaseRandomTargetLogic
  };
  -- New function
  local function PhaseLogic(aObj)
    -- Object has finished phasing
    if aObj.J ~= JOB.PHASE then
      -- Object was teleported eaten? Respawn as eaten!
      if aObj.D == DIR.DR then SetAction(aObj, ACT.EATEN, JOB.NONE, DIR.LR);
      -- Object not eaten?
      else SetAction(aObj, ACT.STOP, JOB.NONE, DIR.KEEP) end;
      -- Done
      return;
    end
    -- If not demo mode and this object is selected and not parent
    if not bAIvsAI and aActiveObject == aObj and
      (not aObj.P or aObj.P ~= aActivePlayer) then
      -- Deselect it. Opponents are not allowed to see where they went!
      SelectObject();
    end
    -- Get and check logic function for phasing.
    local fcbPhaseLogic<const> = aFunctions[aObj.D];
    if not UtilIsFunction(fcbPhaseLogic) then
      error("Invalid phase logic function at "..aObj.D.."! "..
        tostring(fcbPhaseLogic)) end;
    -- Execute the phase logic
    fcbPhaseLogic(aObj);
  end
  -- Return actual function
  return PhaseLogic;
end
-- Apply object inventory perks -------------------------------------------- --
local function ApplyObjectInventoryPerks(aObject);
  -- Get objects inventory and return if no inventory
  local aInventory<const> = aObject.I;
  if #aInventory == 0 then return end;
  -- Enumerate each one. Have to use 'while' as inventory can disappear
  local iIndex = 1;
  while iIndex <= #aInventory do
    -- Get object in inventory and if item is first aid and holder is damaged?
    local aItem<const> = aInventory[iIndex];
    if aItem.ID == TYP.FIRSTAID and aObject.H < 100 then
      -- Increase holder's health and decrease first aid health
      AdjustObjectHealth(aObject, 1, aItem);
      AdjustObjectHealth(aItem, -1, aObject);
    end
    -- Item has health or couldn't drop object? Enumerate next item!
    if aItem.H > 0 or not DropObject(aObject, aItem) then
      iIndex = iIndex + 1 end;
  end
end
-- Check if object is falling ---------------------------------------------- --
local function CheckObjectFalling(aObject)
  -- If object...
  if not CheckObjectFloating(aObject) and -- ...is not floating?
         aObject.F & OFL.FALL ~= 0 and    -- *and* is supposed to fall?
     not IsCollideY(aObject, 1) then      -- *and* not blocked below?
    -- Start from fall speed pixels and count down to 1
    for iYAdj = aObject.FS, 1, -1 do
      -- No collision found with terrain?
      if not IsCollideY(aObject, iYAdj) then
        -- Move Y position down
        MoveY(aObject, iYAdj);
        -- Increase fall speed and clamp maximum speed to half a tile
        if aObject.FS < 8 then aObject.FS = aObject.FS + 1 end;
        -- increase fall damage
        aObject.FD = aObject.FD + 1;
        -- Still falling
        return true;
      end
      -- Collision detected, but we must find how many pixels exactly to fall
      -- by, so reduce the pixel count and try to find the exact value.
    end
  end
  -- We were falling?
  if aObject.FS > 1 then
    -- Reset fall speed
    aObject.FS = 1;
    -- If fall damage is set then object fell and now we must reduce its
    -- health
    local iDamage = aObject.FD;
    if iDamage > 0 then
      -- Object still has fall flag set and object fell >= 16 pixels
      if aObject.F & OFL.FALL ~= 0 and iDamage >= 5 then
        -- Object is delicate? Remove more health
        if aObject.F & OFL.DELICATE ~= 0 then iDamage = -iDamage;
        else iDamage = -(iDamage // 2) end;
        -- Reduce health
        AdjustObjectHealth(aObject, iDamage);
        -- Damage would reduce health < 10 %. Stop object moving
        local iHealth<const> = aObject.H;
        if iHealth > 0 and iHealth < 10 then
          SetAction(aObject, ACT.STOP, JOB.INDANGER, DIR.NONE);
        end
      end
      -- Reset fall damage;
      aObject.FD = 0;
    end
  end
  -- Can't fall (anymore)
  return false;
end
-- Process object movement logic ------------------------------------------- --
local function ProcessObjectMovement()
  -- Move object functions
  local function OBJMoveUp(aObj) MoveY(aObj, -1) end;
  local function OBJMoveDown(aObj) MoveY(aObj, 1) end;
  local function OBJMoveLeft(aObj) MoveX(aObj, -1) end;
  local function OBJMoveRight(aObj) MoveX(aObj, 1) end;
  -- Object move callbacks
  local aMoveFuncs<const> = {
    [DIR.U]  = OBJMoveUp,    [DIR.D] = OBJMoveDown, [DIR.NONE] = BlankFunction,
    [DIR.UL] = OBJMoveLeft,  [DIR.L] = OBJMoveLeft,  [DIR.DL] = OBJMoveLeft,
    [DIR.UR] = OBJMoveRight, [DIR.R] = OBJMoveRight, [DIR.DR] = OBJMoveRight
  };
  -- Train move data
  local aTrainMoveData<const> = {
    [DIR.L] = { 7, -1 }, [DIR.R] = { 9, 1 }, [DIR.NONE] = { 0, 0 },
  };
  -- Actual function
  local function ProcessObjectMovement(aObj)
    -- Object wants to dig down and object X position is in the middle of
    -- the tile? Make object dig down
    if aObj.J == JOB.DIGDOWN and aObj.X % 16 == 0 then
      SetAction(aObj, ACT.DIG, JOB.DIGDOWN, DIR.D);
    -- Object wants to enter the trading centre? Stop object
    elseif aObj.J == JOB.HOME and ObjectIsAtHome(aObj) then
      -- If object can't entre? Just stop it.
      if aObj.F & OFL.NOHOME ~= 0 then
        SetAction(aObj, ACT.STOP, JOB.NONE, DIR.NONE);
      -- Go into trade centre and if successful? Prevent diggers entering
      elseif SetAction(aObj, ACT.PHASE, JOB.PHASE, DIR.UL) then
        SetAllDiggersNoHome(aObj.P.D) end;
    -- Object is for rails only and train is not on track
    elseif aObj.F & OFL.TRACK ~= 0 then
      -- Get X pos adjust depending on direction
      local aTrainMoveItem<const> = aTrainMoveData[aObj.D];
      -- Get absolute tile position and if valid?
      local iLoc<const> = GetLevelOffsetFromObject(aObj, aTrainMoveItem[1], 0);
      if iLoc then
        -- Train on track? Move the train!
        if aTileData[1 + aLevelData[1 + iLoc]] & aTileFlags.T ~= 0 then
          MoveX(aObj, aTrainMoveItem[2]);
        -- Train not on track and was searching? Move in opposite direction.
        elseif aObj.J == JOB.SEARCH and aObj.AT > 0 then
          SetAction(aObj, ACT.KEEP, JOB.KEEP, DIR.OPPOSITE);
        -- Train was not moving so keep stopped
        else SetAction(aObj, ACT.STOP, JOB.NONE, DIR.NONE) end;
      end
    -- No other properties match?
    else
      -- If timer goes over 1 second and object is busy
      -- Unset busy flag as abnormal digging can make it stick
      if aObj.AT >= 60 and aObj.F & OFL.BUSY ~= 0 then
        aObj.F = aObj.F & ~OFL.BUSY end;
      -- Get function associated with direction and move appropriately. It is
      -- assumed that all directions are catered for thus no check required.
      aMoveFuncs[aObj.D](aObj);
    end
  end
  -- Return new function
  return ProcessObjectMovement;
end
-- Process object jump logic ----------------------------------------------- --
local function ProcessJumpLogic(aObj, aData, iLimit, iStep)
  -- More pixels to jump?
  local iActionTimer<const> = aObj.AT;
  if iActionTimer < #aData then
    -- Get amount to move by and ignore if not moving this frame
    local iYMove<const> = aData[1 + iActionTimer];
    if iYMove == 0 then return end;
    -- Check each pixel whilst jumping
    for iY = iYMove, iLimit, iStep do
      -- No collision? Move and return to continue to next frame
      if not IsCollideY(aObj, iY) then return AdjustPosY(aObj, iY) end;
    end
  end
  -- Can't move anymore so tell caller that
  return true;
end
-- Process object logic ---------------------------------------------------- --
local function ProcessObjects()
  -- Enumerate through all objects (while/do because they could be deleted)
  local iObjId = 1 while iObjId <= #aObjects do
    -- Get object data
    local aObj<const> = aObjects[iObjId];
    -- If AI function set, not dying and not phasing then call AI function!
    local fcbAI<const> = aObj.AIF;
    if fcbAI then fcbAI(aObj) end;
    -- If object can't fall or it finished falling and isn't floating?
    if not CheckObjectFalling(aObj) then
      -- Object is jumping?
      if aObj.F & OFL.JUMPRISE ~= 0 then
        -- Test for rising and if object has finished jumping?
        if ProcessJumpLogic(aObj, aJumpRiseData, -1, 1) then
          -- Remove rising and set falling flags
          aObj.F = (aObj.F | OFL.JUMPFALL) & ~OFL.JUMPRISE;
          -- Reset action timer
          aObj.AT = 0;
        end
      -- Object is falling
      elseif aObj.F & OFL.JUMPFALL ~= 0 then
        -- Test for falling and if object has finished falling?
        if ProcessJumpLogic(aObj, aJumpFallData, 1, -1) then
          -- Let object fall normally now and remove busy and falling flags
          aObj.F = (aObj.F | OFL.FALL) & ~(OFL.JUMPFALL | OFL.BUSY);
          -- Thus little tweak makes sure the user can't jump again by just
          -- modifying the fall speed as ACT.JUMP requires it to be 1.
          aObj.FS = 2;
        end
      end
      -- Object is...
      local iAction<const> = aObj.A;
      if iAction == ACT.DEATH and                   -- ...dead?
         aObj.AT >= aTimerData.DEADWAIT and         -- ...death timer exceeded?
         DestroyObject(iObjId, aObj) then goto EOO; -- ...object destroyed?
      -- Object is phasing and phase delay reached? Process phase destination
      elseif iAction == ACT.PHASE and aObj.AT >= aObj.OD.TELEDELAY then
        return PhaseLogic(aObj);
      -- Object is hidden and object is in the trade-centre?
      elseif iAction == ACT.HIDE and aObj.J == JOB.PHASE then
        -- Health at full?
        if aObj.H >= 100 then
          -- Re-appear the object if is not the player otherwise wait for the
          -- real player to exit the trade centre.
          if bAIvsAI or aObj.P ~= aActivePlayer then
            SetAction(aObj, ACT.PHASE, JOB.NONE, DIR.R) end;
        -- Health not full? Regenerate health
        elseif aObj.AT % 10 == 0 then AdjustObjectHealth(aObj, 1) end;
        -- Keep object from becoming impatient
        aObj.JT = 0;
      -- Object has been eaten
      elseif iAction == ACT.EATEN and aObj.AT >= aTimerData.MUTATEWAIT then
        -- Spawn alien and kill digger
        AdjustObjectHealth(aObj, -100,
          CreateObject(TYP.ALIEN, aObj.X, aObj.Y));
      -- Object is dying? Slowly drain it's health
      elseif iAction == ACT.DYING and aObj.AT % 6 == 0 then
        AdjustObjectHealth(aObj, -1);
      -- Object is creeping, walking and running? Limit FPS depending on action
      elseif (iAction == ACT.CREEP and aObj.AT % 4 == 0) or
             (iAction == ACT.WALK and aObj.AT % 2 == 0) or
              iAction == ACT.RUN then
        -- Process object movement logic
        ProcessObjectMovement(aObj);
      -- Object is digging and digging delay reached?
      elseif iAction == ACT.DIG and aObj.AT >= aObj.DID then
        -- Terrain dig was successful?
        if DigTile(aObj) then
          -- Get last dig action and if set?
          local iLast<const> = aObj.LA;
          if iLast then
            -- Continue to move in the direction
            SetAction(aObj, iLast, JOB.KEEP, DIR.KEEP);
            -- Remove the last action
            aObj.LA = nil;
          -- Impossible but stop the object's actions completely
          else SetAction(aObj, ACT.STOP, JOB.NONE, DIR.KEEP) end;
          -- Increase dig count
          SetObjectAndParentCounter(aObj, "DUG");
          -- Update dig time for AI
          aObj.LDT = iGameTicks;
        -- Not successful
        else
          -- Remove the last action if set
          aObj.LA = nil;
          -- Update failed dig direction
          aObj.FDD = aObj.D;
          -- Set impatient
          aObj.JT = aObj.PW;
          -- Stop the object's actions completely
          SetAction(aObj, ACT.STOP, JOB.NONE, DIR.KEEP);
        end;
      end
      -- Post action job process. Object search for other objects to pickup?
      if aObj.J == JOB.SEARCH and aObj.AT % aTimerData.PICKUPDELAY == 0 then
        -- Pickup nearest treasure
        PickupObjects(aObj, true);
      -- Object is in danger and danger timeout is reached?
      elseif aObj.J == JOB.INDANGER and
             aObj.AT >= aTimerData.DANGERTIMEOUT then
        -- Remove the objects job
        SetAction(aObj, ACT.KEEP, JOB.NONE, DIR.KEEP);
      end
      -- Object can regenerate health? Regenerate health!
      if aObj.F & OFL.REGENERATE ~= 0 and
         aObj.AT % aObj.SM == aObj.SMM1 then AdjustObjectHealth(aObj, 1) end;
    end
    -- If object is not phasing or dying?
    if aObj.A ~= ACT.PHASE and aObj.A ~= ACT.DEATH then
      -- Check object fighting
      CheckObjectCollision(aObj);
      -- Check if object is underwater
      CheckObjectUnderwater(aObj);
      -- Walk object's inventory
      ApplyObjectInventoryPerks(aObj);
    end
    -- Process animations
    AnimateObject(aObj);
    -- Increase action and job timer
    aObj.AT, aObj.JT = aObj.AT + 1, aObj.JT + 1;
    -- Process next object
    iObjId = iObjId + 1;
    -- Label for skipping to next object
    ::EOO::
  end
end
-- Game tick function ------------------------------------------------------ --
local function GameProc()
  -- Ignore if we're in slowdown mode
  if iGameTicks % iSlowDown ~= 0 then iGameTicks = iGameTicks + 1 return end;
  -- Process terrain animation if the frame animation timer ticks
  if iGameTicks % aTimerData.ANIMTERRAIN == 0 then
    -- For each screen row we are looking at
    for iY = 0, iScrTilesHm1 do
      -- Calculate the Y position to grab from the level data
      local iYdest<const> = (iPosY + iY) * iLLAbsW;
      -- For each screen column we are looking at
      for iX = 0, iScrTilesWm1 do
        -- Get absolute position on map
        local iPos<const> = iYdest + iPosX + iX;
        -- Get tile id and if tile is valid?
        local iTileId<const> = aLevelData[1 + iPos];
        if iTileId ~= 0 then
          -- Get tile flags and if flags say we should animate to next tile?
          local iFlags<const> = aTileData[1 + iTileId];
          if iFlags & aTileFlags.AB ~= 0 then
            aLevelData[1 + iPos] = iTileId + 1;
          -- Tile is end of animation so go back 3 sprites. This rule means
          -- that all animated terrain tiles must be 4 sprites.
          elseif iFlags & aTileFlags.AE ~= 0 then
            aLevelData[1 + iPos] = iTileId - 3 end;
        end
      end
    end
  end
  -- Process flood data if we have any flood data to process
  if #aFloodData > 0 then
    -- Until we've removed all the current entries
    for iRemaining = #aFloodData, 1, -1 do
      -- Get flood data and remove it from list
      local aFloodItem<const> = aFloodData[1];
      remove(aFloodData, 1);
      iRemaining = iRemaining - 1;
      -- Get position and flags of tile being flooded and if tile exposes left?
      local iTilePos<const>, iTileFlags<const> = aFloodItem[1], aFloodItem[2];
      if iTileFlags & aTileFlags.EL ~= 0 then
        -- Get information about the tile on the left and if valid
        local iPosition<const> = iTilePos - 1;
        local iTileId<const> = GetLevelDataFromLevelOffset(iPosition);
        if iTileId then
          -- Get file flags and if is water and the right edge is exposed?
          local iTileFlags = aTileData[1 + iTileId];
          if iTileFlags & aTileFlags.W == 0 and
             iTileFlags & aTileFlags.ER ~= 0 then
            -- If the tile is a flood gate tile?
            if iTileFlags & aTileFlags.G ~= 0 then
              -- Get transformation information about this floodgate tile
              local aFGDItem<const> = aFloodGateData[iTileId][1];
              -- Update the flooded gate tile
              aLevelData[1 + iPosition] = aFGDItem[1];
              -- Continue flooding if needed
              if aFGDItem[2] then
                aFloodData[1 + #aFloodData] = { iPosition, iTileFlags } end;
            -- Tile is not a flood gate tile?
            else
              -- Update tile to the same tile with water in it
              aLevelData[1 + iPosition] = iTileId + 240;
              -- Continue flooding if the left edge of the tile is exposed
              if iTileFlags & aTileFlags.EL ~= 0 then
                aFloodData[1 + #aFloodData] = { iPosition, iTileFlags } end;
            end
          end
        end
      end
      -- If tile flags exposed right?
      if iTileFlags & aTileFlags.ER ~= 0 then
        -- Get information about the tile on the right and if valid
        local iPosition<const> = iTilePos + 1;
        local iTileId<const> = GetLevelDataFromLevelOffset(iPosition);
        if iTileId then
          -- Get file flags and if is water and the left edge is exposed?
          local iTileFlags<const> = aTileData[1 + iTileId];
          if iTileFlags & aTileFlags.W == 0 and
             iTileFlags & aTileFlags.EL ~= 0 then
            -- If the tile is a flood gate tile?
            if iTileFlags & aTileFlags.G ~= 0 then
              -- Get transformation information about this floodgate tile
              local aFGDItem<const> = aFloodGateData[iTileId][2];
              -- Update the flooded gate tile
              aLevelData[1 + iPosition] = aFGDItem[1];
              -- Continue flooding if data requests it
              if aFGDItem[2] then
                aFloodData[1 + #aFloodData] = { iPosition, iTileFlags } end;
            -- Tile is not a flood gate tile?
            else
              -- Update tile to the same tile with water in it
              aLevelData[1 + iPosition] = iTileId + 240;
              -- Continue flooding if the left edge of the tile is exposed
              if iTileFlags & aTileFlags.ER ~= 0 then
                aFloodData[1 + #aFloodData] = { iPosition, iTileFlags } end;
            end
          end
        end
      end
      -- If tile flags exposed down?
      if iTileFlags & aTileFlags.EB ~= 0 then
        -- Get information about the tile below and if valid
        local iPosition<const> = iTilePos + iLLAbsW;
        local iTileId<const> = GetLevelDataFromLevelOffset(iPosition);
        if iTileId then
          -- Get file flags and if is water and the left edge is exposed?
          local iTileFlags<const> = aTileData[1 + iTileId];
          if iTileFlags & aTileFlags.W == 0 and
             iTileFlags & aTileFlags.ET ~= 0 then
            -- Update tile to the same tile with water in it and continue
            aLevelData[1 + iPosition] = iTileId + 240;
            aFloodData[1 + #aFloodData] = { iPosition, iTileFlags };
          end
        end
      end
    end
  end
  -- Process view port
  ProcessViewPort();
  -- Process object logic
  ProcessObjects();
  -- If a second has passed?
  if iGameTicks % 60 == 0 then
    -- Get player diggers and enumerate them
    local aDiggers<const> = aActivePlayer.D;
    for iDiggerId = 1, #aDiggers do
      -- Play warning sound for any digger in danger
      local aDigger<const> = aDiggers[iDiggerId];
      if aDigger and aDigger.J == JOB.INDANGER then
        PlayInterfaceSound(aSfxData.ERROR);
        break;
      end
    end
    -- Rotate gems in bank every five minutes
    if iGameTicks % 18000 == 0 then
      -- Move first gem to last gem
      aGemsAvailable[1 + #aGemsAvailable] = aGemsAvailable[1];
      remove(aGemsAvailable, 1);
    end
  end
  -- Increment game ticks processed count
  iGameTicks = iGameTicks + 1;
end
-- Select devices ---------------------------------------------------------- --
local function SelectDevice()
  -- For each object
  for iId = 1, #aObjects do
    -- Get object and if the object belongs to me and is device?
    local aObject<const> = aObjects[iId];
    if aActivePlayer == aObject.P and
       aObject.F & OFL.DEVICE ~= 0 then
      -- Remove and send to front of objects list
      remove(aObjects, iId);
      aObjects[1 + #aObjects] = aObject;
      -- Set as active object
      SelectObject(aObject);
      -- Success!
      return PlayInterfaceSound(aSfxData.CLICK);
    end
  end
  -- Failed? Play sound
  PlayInterfaceSound(aSfxData.ERROR);
end
-- Pause the game ---------------------------------------------------------- --
local function SelectPauseScreen() SelectInfoScreen() InitPause() end;
-- Show inventory screen --------------------------------------------------- --
local function SelectInventoryScreen() SelectInfoScreen(1) end;
-- Show location screen ---------------------------------------------------- --
local function SelectLocationScreen() SelectInfoScreen(2) end;
-- Show status screen ------------------------------------------------------ --
local function SelectStatusScreen() SelectInfoScreen(3) end;
-- Init the book ----------------------------------------------------------- --
local function SelectBook()
  -- Enumerate diggers
  local aDiggers<const> = aActivePlayer.D;
  for iDigger = 1, #aDiggers do
    -- Get digger data and if it's teleporting home or going home?
    local aDigger<const> = aDiggers[iDigger];
    if aDigger.F & OFL.NOHOME ~= 0 or aDigger.J == JOB.HOME then
      -- Play error sound effect and return
      return PlayInterfaceSound(aSfxData.ERROR);
    end
  end
  -- Clear any information screens
  SelectInfoScreen();
  -- Play sound effect to show the player clicked it
  PlayInterfaceSound(aSfxData.CLICK);
  -- Remove play sound function
  SetPlaySounds(false);
  -- Init the book
  InitBook(true);
end
-- Load level -------------------------------------------------------------- --
local function LoadLevel(iLId, sMusic, iKB, iRace1, bAI1, iRace2, bAI2,
  fcbNLogic, fcbNRender, iNHotSpotId, iSM1, iSM2)
  -- De-init/Reset current level
  DeInitLevel();
  -- Check and set default logic callback
  if fcbNLogic ~= nil then
    if not UtilIsFunction(fcbNLogic) then
      error("Logic function invalid! "..tostring(fcbNLogic)) end;
    fcbLogic = fcbNLogic;
  else fcbLogic = GameProc end;
  -- Check and set default render callback
  if fcbNRender ~= nil then
    if not UtilIsFunction(fcbNRender) then
      error("Render function invalid! "..tostring(fcbNRender)) end;
    fcbRender = fcbNRender;
  else fcbRender = RenderAll end;
  -- Initialise default hotspot id if not specified
  if not iNHotSpotId then iNHotSpotId = iHotSpotId end;
  -- Set default players if not set
  if not iRace1 then iRace1 = aGlobalData.gSelectedRace or TYP.DIGRANDOM end;
  if not bAI1 then bAI1 = false end;
  if not iRace2 then iRace2 = TYP.DIGRANDOM end;
  if not bAI2 then bAI2 = true end;
  -- Set FBU callback
  local function OnStageUpdated(...)
    -- Set new stage bounds
    iStageW, iStageH, iStageL, iStageT, iStageR, iStageB = ...;
    -- Set new limits based on frame buffer size
    iScrTilesW, iScrTilesH = ceil(iStageW / 16), ceil(iStageH / 16);
    -- Used in game so calculate them now to prevent unnecessary math
    iScrTilesWd2, iScrTilesHd2 = iScrTilesW // 2, iScrTilesH // 2;
    iScrTilesWd2p1, iScrTilesHd2p1 = iScrTilesWd2 + 1, iScrTilesHd2 + 1;
    iScrTilesWm1, iScrTilesHm1 = iScrTilesW - 1, iScrTilesH - 1;
    -- Level width minus viewport size
    iLLAbsWmVP, iLLAbsHmVP = iLLAbsW - iScrTilesW, iLLAbsH - iScrTilesH;
    iLLPixWmVP, iLLPixHmVP = iLLAbsWmVP * 16, iLLAbsHmVP * 16;
    -- Update viewport limits
    AdjustViewPortX(0);
    AdjustViewPortY(0);
  end
  RegisterFBUCallback("game", OnStageUpdated);
  -- Set level number and get data for it.
  local aLevelInfo;
  if UtilIsTable(iLId) then iLevelId, aLevelInfo = 1, iLId;
  elseif UtilIsInteger(iLId) then
    iLevelId, aLevelInfo = iLId, aLevelsData[iLId];
  else error("Invalid id '"..
    tostring(iLId).."' of type '"..type(iLId).."'!") end;
  if not UtilIsTable(aLevelInfo) then
    error("Invalid level data! "..tostring(aLevelInfo)) end;
  -- Get level type data and level type
  local aLevelTypeData<const> = aLevelInfo.t;
  local iLevelType<const> = aLevelTypeData.i;
  -- Set level name and level type name
  sLevelName, sLevelType = aLevelInfo.n, aLevelTypeData.n;
  -- Set shroud colour
  aShroudColour = aLevelTypeData.s;
  -- Holds required assets to set template to music or no music
  local aAssets;
  if sMusic then aAssets, aAssetsMusic[4].F = aAssetsMusic, sMusic;
  else aAssets = aAssetsNoMusic end;
  -- Update asset filenames to load
  local sFilePrefix<const> = "lvl/"..aLevelInfo.f;
  aAssets[1].F = sFilePrefix..".dat";
  aAssets[2].F = sFilePrefix;
  aAssets[3].F = aLevelTypeData.f;
  -- Level assets loaded function
  local function OnLoaded(aResources)
    -- Set texture handle
    texLev = aResources[3];
    -- Grab the background part
    texBg = TileA(texLev, 0, 256, 512, 512);
    -- Player starting positions
    local aPlayerStartData<const> = {
      { 195, 198, iRace1, bAI1 },   -- Player 1 start data
      { 199, 202, iRace2, bAI2 }    -- Player 2 start data
    };
    -- Create a blank mask
    maskZone = MaskCreateZero(sFilePrefix, iLLPixW, iLLPixH);
    -- Get minimum and maximum object id
    local iMinObjId<const>, iMaxObjId<const> = TYP.JENNITE, TYP.MAX;
    -- Player starting point data found
    local aPlayersFound<const> = { };
    -- For each row in the data file
    local binLevel<const> = aResources[1];
    for iY = 0, iLLAbsHm1 do
      -- Calculate precise Y position for object
      local iPreciseY<const> = iY * 16;
      -- Calculate row position in data file
      local iDataY<const> = iY * iLLAbsW;
      -- For each column in the data file
      for iX = 0, iLLAbsWm1 do
        -- Calculate position of tile
        local iPosition<const> = (iDataY + iX) * 2;
        -- Calculate precise X position for object
        local iPreciseX<const> = iX * 16;
        -- Get the 16-bit (little-endian) tile id from the terrain data at
        -- the current position and if it is not a clear tile?
        local iTerrainId<const> = binLevel:RU16LE(iPosition);
        if iTerrainId >= 0 and iTerrainId < #aTileData then
          -- Check if is a player
          for iPlayer = 1, #aPlayerStartData do
            -- Get player data and check for player starting position
            local aPlayerStartItem<const> = aPlayerStartData[iPlayer];
            if iTerrainId >= aPlayerStartItem[1] and
               iTerrainId <= aPlayerStartItem[2] then
              -- Get existing player data and if player exists?
              local aPlayerFound<const> = aPlayersFound[iPlayer];
              if aPlayerFound then
                -- Show map maker in console that the player exists
                CoreWrite("Warning! Player "..iPlayer..
                  " already exists! X="..iX..", Y="..iY..", Abs="..
                  iPosition..". Originally found at X="..aPlayerFound[1]..
                  ", Y="..aPlayerFound[2]..".", 9);
              -- Player doesn't exist? Set the new player
              else aPlayersFound[iPlayer] =
                { iX, iY, aPlayerStartItem[3], aPlayerStartItem[4] }
              end
            end
          end
          -- Draw the appropriate tile for the level bit mask
          maskZone:Copy(maskLev, iTerrainId, iPreciseX, iPreciseY);
          -- Insert into level data array
          aLevelData[1 + #aLevelData] = iTerrainId;
          -- Create entry for shroud data (sprite tile set number)
          aShroudData[1 + #aShroudData] = { 1022, 0x0 };
        -- Show error. Level could be corrupted
        else error("Error! Invalid tile "..iTerrainId.."/"..#aTileData..
          " at X="..iX..", Y="..iY..", Abs="..iPosition.."!") end;
      end
    end
    -- Make sure we got the correct amount of level tiles
    if #aLevelData < iLLAbs then
      error("Only "..#aLevelData.."/"..iLLAbs.." level tiles!") end;
    -- Make sure we found two players
    if #aPlayersFound ~= 2 then
      error("Only "..#aPlayersFound.."/2 players!") end;
    -- Fill border with 1's to prevent objects leaving the playfield
    maskZone:Fill(0, 0, iLLPixW, 1);
    maskZone:Fill(0, 0, 1, iLLPixH);
    maskZone:Fill(iLLPixWm1, 0, 1, iLLPixH);
    maskZone:Fill(0, iLLPixHm1, iLLPixW, 1);
    -- For each pre-positioned object
    local aLevelObj<const> = aResources[2];
    for iObjIndex = 1, #aLevelObj do
      -- Get object id at position and if it's interesting?
      local aObj<const> = aLevelObj[iObjIndex];
      local iObjId<const>, iX<const>, iY<const> = aObj[1], aObj[2], aObj[3];
      if iObjId < iMinObjId or iObjId >= iMaxObjId then
        error("Warning! Object id invalid! Id="..iObjIndex..", Item="..iObjId..
          ", X="..iX..", Y="..iY..", Max="..iMaxObjId..".");
      -- Object id is valid? Create the object and log error if failed
      elseif not CreateObject(iObjId, iX, iY) then
        -- Show map maker in console that the object id is invalid
        error("Warning! Couldn't create object! Id="..iObjIndex..
          ", Item="..iObjId..", X="..iX..", Y="..iY..".");
      end
    end
    -- Reset races available
    for iI = 1, #aRacesData do
      aRacesAvailable[1 + #aRacesAvailable] = aRacesData[iI] end;
    -- Create player for each starting position found
    for iPlayerId = 1, #aPlayersFound do
      local aPlayerData<const> = aPlayersFound[iPlayerId];
      CreatePlayer(aPlayerData[1], aPlayerData[2], iPlayerId,
                   aPlayerData[3], aPlayerData[4]);
    end
    -- Set player race and level if not set (gam_test used)
    if not aGlobalData.gSelectedRace then
      aGlobalData.gSelectedRace = aActivePlayer.R end;
    if not aGlobalData.gSelectedLevel then
      aGlobalData.gSelectedLevel = iLevelId end;
    -- Reset gems available
    local iGemStart<const> = random(#aDigTileData);
    for iId = 1, #aDigTileData do aGemsAvailable[1 + #aGemsAvailable] =
      aDigTileData[1 + ((iGemStart + iId) % #aDigTileData)] end;
    -- Play in-game music if requested
    if sMusic then PlayMusic(aResources[4], 0) end;
    -- Now we want to hear sounds if human player is set
    if bAI1 == false then SetPlaySounds(true) end;
    -- Computer is main player?
    if bAI1 == true then
      -- Set auto-respawn on all objects death
      for iI = 1, #aObjects do
        local aObject<const> = aObjects[iI];
        aObject.F = aObject.F | OFL.RESPAWN;
      end
    -- Set actual win limit
    end
    -- Set win limit (Credits will not set 'w' for no limit)
    iWinLimit = aLevelInfo.w;
    if iWinLimit then iWinLimit = iWinLimit.r end;
    if not iWinLimit then iWinLimit = aGlobalData.gCapitalCarried end;
    -- Do one tick at least or the fade will try to render with variables
    -- that haven't been initialised yet
    fcbLogic();
    -- Do fade then set requested game callbacks
    local function OnFadeIn()
      -- Key bank requested?
      if iKB then
        -- Use default keybank? Use users slowdown value else don't slowdown
        if iKB < 0 then iKB, iSlowDown = iKeyBankId, iSavedSlowDown;
                   else iSlowDown = 1 end;
        -- Set specified keybank
        SetKeys(true, iKB);
      -- No slow down
      else iSlowDown = 1 end;
      -- Set specified hot spot
      SetHotSpot(iNHotSpotId);
      -- Set requested callbacks
      SetCallbacks(fcbLogic, fcbRender);
      -- Add extra money if requested
      if iSM1 then aActivePlayer.M = aActivePlayer.M + iSM1 end
      if iSM2 then aOpponentPlayer.M = aOpponentPlayer.M + iSM2 end
      -- Check for win (test end/post-morten)
      EndConditionsCheck();
    end
    Fade(1, 0, 0.04, fcbRender, OnFadeIn, not not sMusic);
  end
  -- Load level graphics resources asynchronously
  LoadResources(sLevelName, aAssets, OnLoaded);
end
-- Continue game from book or lobby ---------------------------------------- --
local function InitContinueGame(bMusic)
  -- Post loaded
  local function PostLoaded()
    -- We want to hear sounds
    SetPlaySounds(true);
    -- Return control to main loop
    SetCallbacks(fcbLogic, fcbRender);
    -- Restore key bank keys and hot spots
    SetKeys(true, iKeyBankId);
    SetHotSpot(iHotSpotId);
    -- If no object originally sent or is not hidden then we're done
    if not aActiveObject or aActiveObject.A ~= ACT.HIDE then return end;
    -- Get active parent players diggers and enumerate their diggers
    local aDiggers<const> = aActiveObject.P.D;
    for iDiggerId = 1, #aDiggers do
      -- Get digger object and set it to go home again
      local aDigger<const> = aDiggers[iDiggerId];
      if aDigger then aDigger.F = aDigger.F & ~OFL.NOHOME end;
    end
    -- Make it reappear
    SetAction(aActiveObject, ACT.PHASE, JOB.NONE, DIR.NONE);
    -- Check end game conditions as might have won!
    EndConditionsCheck();
  end
  -- Music loaded
  local function OnLoaded(aResource)
    -- Resume game music
    PlayMusic(aResource[1], nil, 2);
    -- Post loaded functions
    PostLoaded();
  end
  -- If music reset required then load it
  if bMusic then
    return LoadResources("Continue", aAssetsContinue, OnLoaded) end;
  -- Run post loaded functions
  PostLoaded();
end
-- ------------------------------------------------------------------------- --
local function GetActiveObject() return aActiveObject end;
-- ------------------------------------------------------------------------- --
local function GetActivePlayer() return aActivePlayer end;
-- ------------------------------------------------------------------------- --
local function GetOpponentPlayer() return aOpponentPlayer end;
-- ------------------------------------------------------------------------- --
local function GetLevelInfo()
  return iLevelId, sLevelName, sLevelType, iWinLimit;
end
-- ------------------------------------------------------------------------- --
local function GetViewportData()
  return iPixPosX, iPixPosY, iPixPosTargetX, iPixPosTargetY, iPixCenPosX,
         iPixCenPosY, iPosX, iPosY, iAbsCenPosX, iAbsCenPosY, iViewportW,
         iViewportH;
end
-- When scripts have loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, aAssetsData, aCursorIdData;
  -- Get imports
  TYP, aLevelsData, LoadResources, aObjectData, ACT, JOB, DIR, aTimerData, AI,
    OFL, aDigTileData, PlayMusic, aTileData, aTileFlags, Fade, BCBlit,
    SetCallbacks, IsMouseInBounds, aDigData, BlitSLTRB, BlitSLT, DF, aSfxData,
    aJumpRiseData, aJumpFallData, GetMouseX, GetMouseY, PlayStaticSound,
    PlaySound, Print, PrintC, PrintR, aMenuData, MFL, MNU, InitBook,
    RenderFade, InitWin, InitWinDead, InitLose, InitLoseDead, InitPause,
    InitTNTMap, InitLobby, RegisterHotSpot, RegisterKeys, TileA, texSpr,
    fontLarge, fontLittle, fontTiny, aDigBlockData, aExplodeDirData, SetCursor,
    SetCursorPos, SetKeys, RegisterFBUCallback, GetTestMode, RenderShadow,
    RenderTip, SetHotSpot, SetTip, aRacesData, aDugRandShaftData,
    aFloodGateData, aTrainTrackData, aExplodeAboveData, maskLev, maskSpr,
    aGlobalData, aShopData, aAssetsData, aAIChoicesData, aCursorIdData,
    aShroudCircle, aShroudTileLookup =
      GetAPI("aObjectTypes", "aLevelsData", "LoadResources", "aObjectData",
        "aObjectActions", "aObjectJobs", "aObjectDirections", "aTimerData",
        "aAITypesData", "aObjectFlags", "aDigTileData", "PlayMusic",
        "aTileData", "aTileFlags", "Fade", "BCBlit", "SetCallbacks",
        "IsMouseInBounds", "aDigData", "BlitSLTRB", "BlitSLT", "aDigTileFlags",
        "aSfxData", "aJumpRiseData", "aJumpFallData", "GetMouseX", "GetMouseY",
        "PlayStaticSound", "PlaySound", "Print", "PrintC", "PrintR",
        "aMenuData", "aMenuFlags", "aMenuIds", "InitBook", "RenderFade",
        "InitWin", "InitWinDead", "InitLose", "InitLoseDead", "InitPause",
        "InitTNTMap", "InitLobby", "RegisterHotSpot", "RegisterKeys", "TileA",
        "texSpr", "fontLarge", "fontLittle", "fontTiny", "aDigBlockData",
        "aExplodeDirData", "SetCursor", "SetCursorPos", "SetKeys",
        "RegisterFBUCallback", "GetTestMode", "RenderShadow", "RenderTip",
        "SetHotSpot", "SetTip", "aRacesData", "aDugRandShaftData",
        "aFloodGateData", "aTrainTrackData", "aExplodeAboveData", "maskLevel",
        "maskSprites", "aGlobalData", "aShopData", "aAssetsData",
        "aAIChoicesData", "aCursorIdData", "aShroudCircle",
        "aShroudTileLookup");
  -- Make sure we have the correct number of level tiles
  local iMaskLev<const> = maskLev:Tiles();
  if iMaskLev ~= #aTileData then
    error("Got only "..iMaskLev.." of "..#aTileData.." mask level tiles!");
  end
  -- Make sure we have the correct number of sprite tiles
  local iMaskSpr<const> = maskSpr:Tiles();
  if iMaskSpr ~= #aTileData then
    error("Got only "..iMaskSpr.." of "..#aTileData.." mask sprite tiles");
  end
  -- Setup required assets
  local aAssetTerrain<const>, aAssetObject<const>, aAssetTexture<const> =
    aAssetsData.mapt, aAssetsData.mapo, aAssetsData.game;
  aAssetsMusic, aAssetsNoMusic, aAssetsContinue =
    { aAssetTerrain, aAssetObject, aAssetTexture, aAssetsData.gamem },
    { aAssetTerrain, aAssetObject, aAssetTexture },
    { aAssetsData.gamem };
  -- Get required sound effects
  local iSClick<const>, iSError<const>, iSSelect<const> =
    aSfxData.CLICK, aSfxData.ERROR, aSfxData.SELECT;
  -- Select digger if active
  local function SelectDigger(iDiggerId)
    local aDigger<const> = aActivePlayer.D[iDiggerId];
    if not aDigger then return PlayStaticSound(iSError) end;
    SelectObject(aDigger);
    PlayStaticSound(iSClick);
  end
  -- Select an adjacent digger
  local function SelectAdjacentDigger(iAmount)
    -- Find the object we selected first
    local aDiggers<const>, iCurrentDigger = aActivePlayer.D;
    for iI = 1, #aDiggers do
      if aActiveObject == aDiggers[iI] then iCurrentDigger = iI break end
    end
    -- No active digger? Find a digger we own
    if not iCurrentDigger then
      for iI = 1, #aDiggers do
        if aDiggers[iI] then iCurrentDigger = iI break end;
      end
    end
    -- Find currently active digger and return if not found
    if not iCurrentDigger then return PlayStaticSound(iSError) end;
    -- Walk through the next 4 diggers
    for iI = iCurrentDigger + iAmount,
        iCurrentDigger + (#aDiggers * iAmount),
        iAmount do
      -- Get next digger wrapped and if we have it?
      local aDigger<const> = aDiggers[1 + ((iI - 1) % #aDiggers)];
      if aDigger then
        -- Play success sound, select the object and return
        PlayStaticSound(iSClick);
        return SelectObject(aDigger);
      end
    end
    -- Error finding digger
    PlayStaticSound(iSError);
  end
  -- Select digger shortcuts
  local function SelectLastDigger() SelectAdjacentDigger(-1) end;
  local function SelectNextDigger() SelectAdjacentDigger(1) end;
  local function SetDiggerOne() SelectDigger(1) end;
  local function SetDiggerTwo() SelectDigger(2) end;
  local function SetDiggerThree() SelectDigger(3) end;
  local function SetDiggerFour() SelectDigger(4) end;
  local function SetDiggerFive() SelectDigger(5) end;
  -- Select digger shortcuts
  local function OnScroll(nX, nY)
    -- Scrolling down?
    if nY < 0 then
      -- Cycle to previous item if digger inventory menu open?
      if aContextMenu and aContextMenu == aMenuData[MNU.DROP] then
        CycleObjInventory(aActiveObject, -1);
      -- Else select the last digger
      else SelectLastDigger() end;
    -- Scrolling up?
    elseif nY > 0 then
      -- Cycle to next item if digger inventory menu open?
      if aContextMenu and aContextMenu == aMenuData[MNU.DROP] then
        CycleObjInventory(aActiveObject, 1);
      -- Else select the next digger
      else SelectNextDigger() end;
    end
  end
  -- Helper for digging
  local function GenericAction(iAction, iJob, iDirection)
    -- Return if object not selected or not mine or not busy.
    if not aActiveObject or aActiveObject.P ~= aActivePlayer or
      aActiveObject.F & OFL.BUSY ~= 0 then return end;
    -- Get object data and if requesting special movement detection?
    local aObjData<const> = aActiveObject.OD;
    if iAction == 0 then
      -- If object can walk?
      if aObjData[ACT.WALK] then
        -- If object can run?
        if aObjData[ACT.RUN] then
          -- Run if already walking
          if aActiveObject.A == ACT.WALK and aActiveObject.D == iDirection then
            iAction = ACT.RUN;
          -- Else keep to walking
          else iAction = ACT.WALK end
        -- Object can't run but can walk?
        else iAction = ACT.WALK end;
      -- If object can run? Set to run
      elseif aObjData[ACT.RUN] then iAction = ACT.RUN;
      -- If object can creep? Set to creep
      elseif aObjData[ACT.CREEP] then iAction = ACT.CREEP;
      -- Show error
      else return end;
    end
    -- Return if action, job and direction is not allowed
    local aKeyData<const> = aObjData.KEYS;
    if not aKeyData then return end;
    local aActData<const> = aKeyData[iAction];
    if not aActData then return end;
    local aJobData<const> = aActData[iJob];
    if not aJobData then return end;
    local aDirData<const> = aJobData[iDirection];
    if not aDirData then return end;
    -- Action allowed!
    return SetAction(aActiveObject, iAction, iJob, iDirection, true);
  end
  -- Special multi-function keys
  local function SpecialKey1()
    -- One of these is surely to work and fully checked
    return GenericAction(ACT.MAP, JOB.NONE, DIR.NONE) or
           GenericAction(ACT.OPEN, JOB.NONE, DIR.NONE) or
           GenericAction(ACT.DEPLOY, JOB.NONE, DIR.NONE) or
           GenericAction(ACT.DYING, JOB.NONE, DIR.NONE) or
           GenericAction(ACT.CREEP, JOB.NONE, DIR.U);
  end
  local function SpecialKey2()
    -- One of these is surely to work and fully checked
    return GenericAction(ACT.CLOSE, JOB.NONE, DIR.NONE) or
           GenericAction(ACT.CREEP, JOB.NONE, DIR.D);
  end
  -- Basic movement
  local function MoveLeft() GenericAction(0, JOB.NONE, DIR.L) end;
  local function MoveRight() GenericAction(0, JOB.NONE, DIR.R) end;
  local function MoveHome() GenericAction(0, JOB.HOME, DIR.HOME) end;
  local function MoveFind() GenericAction(0, JOB.SEARCH, DIR.LR) end;
  local function MoveJump() GenericAction(ACT.JUMP, JOB.KEEP, DIR.KEEP) end;
  local function MoveStop() GenericAction(ACT.STOP, JOB.NONE, DIR.NONE) end;
  -- Digging directions events
  local function DigUpLeft() GenericAction(0, JOB.DIG, DIR.UL) end;
  local function DigUpRight() GenericAction(0, JOB.DIG, DIR.UR) end;
  local function DigLeft() GenericAction(0, JOB.DIG, DIR.L) end;
  local function DigRight() GenericAction(0, JOB.DIG, DIR.R) end;
  local function DigDownLeft() GenericAction(0, JOB.DIG, DIR.DL) end;
  local function DigDownRight() GenericAction(0, JOB.DIG, DIR.DR) end;
  local function DigDown() GenericAction(0, JOB.DIGDOWN, DIR.TCTR) end;
  -- Drop or grab items?
  local function DropItems() GenericAction(ACT.DROP, JOB.KEEP, DIR.KEEP) end;
  local function GrabItems() GenericAction(ACT.GRAB, JOB.KEEP, DIR.KEEP) end;
  local function Teleport() GenericAction(ACT.PHASE, JOB.PHASE, DIR.U) end;
  -- Returns current pixel tile under mouse cursor
  local function GetTileUnderMouse()
    return UtilClampInt((iPosX * 16) + GetMouseX() - iStageL, 0, iLLPixWm1),
           UtilClampInt((iPosY * 16) + GetMouseY() - iStageT, 0, iLLPixHm1);
  end
  -- Spawn Jennite? (Cheat)
  local function SpawnJennite()
    if GetTestMode() then CreateObject(TYP.JENNITE, GetTileUnderMouse()) end;
  end
  -- Shroud reveal key? (Cheat)
  local function ShroudReveal()
    -- Ignore if not debug mode
    if not GetTestMode() then return end;
    -- Returns current absolute tile under mouse cursor
    local function GetAbsTileUnderMouse()
      local iX<const>, iY<const> = GetTileUnderMouse();
      return iX // 16, iY // 16;
    end
    -- Do it
    UpdateShroud(GetAbsTileUnderMouse());
  end
  -- Create explosion (Cheat)
  local function CauseExplosion()
    if GetTestMode() then
      AdjustObjectHealth(
        CreateObject(TYP.TNT, GetTileUnderMouse()), -100, aActiveObject);
    end
  end
  -- Slow down cvar
  local cvSlowDown;
  -- Toggle slow down event
  local function ToggleSlowDown()
    -- New value to set
    local iNewSlowDown;
    -- Toggle slow down
    if iSlowDown == 1 then iNewSlowDown = 2 else iNewSlowDown = 1 end;
    -- Set cvar to new value which also calls OnSlowDown()
    cvSlowDown:Integer(iNewSlowDown);
  end
  -- Register slow down variable
  local function OnSlowDown(sV)
    -- Covert string to number and return if invalid
    sV = tonumber(sV);
    if sV < 1 or sV > 2 then return false end;
    -- Set slow down and saved slow down value
    iSlowDown, iSavedSlowDown = sV, sV;
    -- Done
    return true;
  end
  -- Register the variable
  cvSlowDown = Variable.Register("gam_slowdown", 1,
    Variable.Flags.UINTEGERSAVE, OnSlowDown);
  -- Put variable 'anywhere' to stop it being GC'd
  aAssetTerrain.V = cvSlowDown;
  -- Move viewport
  local function ScrollH(iX) AdjustViewPortX(iX) iPixPosTargetX = iPosX*16 end;
  local function ScrollV(iY) AdjustViewPortY(iY) iPixPosTargetY = iPosY*16 end;
  local function ScrollUp() if GetTestMode() then ScrollV(-16) end end;
  local function ScrollDown() if GetTestMode() then ScrollV(16) end end;
  local function ScrollLeft() if GetTestMode() then ScrollH(-16) end end;
  local function ScrollRight() if GetTestMode() then ScrollH(16) end end;
  -- Repeated key events
  local aKeys<const>, aStates<const> = Input.KeyCodes, Input.States;
  local aScrollUp<const>, aScrollDown<const>, aScrollLeft<const>,
        aScrollRight<const>, aReveal<const> =
    { aKeys.HOME,      ScrollUp,     "igmsu", "SCROLL MAP UP (DEBUG)"    },
    { aKeys.END,       ScrollDown,   "igmsd", "SCROLL MAP DOWN (DEBUG)"  },
    { aKeys.DELETE,    ScrollLeft,   "igmsl", "SCROLL MAP LEFT (DEBUG)"  },
    { aKeys.PAGE_DOWN, ScrollRight,  "igmsr", "SCROLL MAP RIGHT (DEBUG)" },
    { aKeys.O,         ShroudReveal, "igsr",  "SHROUD REVEAL (DEBUG)"    };
  -- Setup keybank
  iKeyBankId = RegisterKeys("IN-GAME", {
    [aStates.PRESS] = {
      { aKeys.Q, DigUpLeft, "igddul", "DIG DIAGONALLY UP-LEFT" },
      { aKeys.R, DigUpRight, "igddur", "DIG DIAGONALLY UP-RIGHT" },
      { aKeys.A, DigLeft, "igdl", "DIG LEFT" },
      { aKeys.D, DigRight, "igdr", "DIG RIGHT" },
      { aKeys.Z, DigDownLeft, "igddl", "DIG DIAGONALLY DOWN-LEFT" },
      { aKeys.S, DigDown, "igdd", "DIG DOWN" },
      { aKeys.C, DigDownRight, "igddr", "DIG DIAGONALLY DOWN-RIGHT" },
      { aKeys.BACKSLASH, DropItems, "igdi", "DROP INVENTORY ITEM" },
      { aKeys.BACKSPACE, Teleport, "igt", "TELEPORT HOME OR TELEPOLE" },
      { aKeys.ENTER, GrabItems, "iggi", "GRAB COLLIDING ITEMS" },
      { aKeys.ESCAPE, SelectPauseScreen, "igp", "PAUSE THE GAME" },
      { aKeys.MINUS, SelectLastDigger, "igsld", "SELECT LAST DIGGER" },
      { aKeys.EQUAL, SelectNextDigger, "igsnd", "SELECT NEXT DIGGER" },
      { aKeys.F4, ToggleSlowDown, "igts", "TOGGLE SLOWDOWN" },
      { aKeys.F5, SelectInventoryScreen, "igshi", "SHOW DIGGER INVENTORY" },
      { aKeys.F6, SelectLocationScreen, "igshl", "SHOW DIGGER LOCATIONS" },
      { aKeys.F7, SelectStatusScreen, "igshs", "SHOW GAME STATUS" },
      { aKeys.F8, SelectBook, "igshb", "SHOW THE BOOK" },
      { aKeys.UP, MoveJump, "igj", "JUMP THE OBJECT" },
      { aKeys.DOWN, MoveStop, "igs", "STOP ALL ACTIVITY IF NOT BUSY" },
      { aKeys.LEFT, MoveLeft, "igml", "WALK OR RUN OBJECT LEFT" },
      { aKeys.RIGHT, MoveRight, "igmr", "WALK OR RUN OBJECT RIGHT" },
      { aKeys.F, MoveFind, "igft", "FIND TREASURE" },
      { aKeys.H, MoveHome, "igmh", "WALK OR RUN HOME" },
      { aKeys.LEFT_BRACKET, SpecialKey1, "igska",
          "DEPLOY, RAISE, TRIGGER OR VIEW THE DEVICE" },
      { aKeys.RIGHT_BRACKET, SpecialKey2, "igskb", "LOWER THE DEVICE" },
      { aKeys.N1, SetDiggerOne, "igsdon", "SELECT 1ST DIGGER"  },
      { aKeys.N2, SetDiggerTwo, "igsdtw", "SELECT 2ND DIGGER"  },
      { aKeys.N3, SetDiggerThree, "igsdth", "SELECT 3RD DIGGER"  },
      { aKeys.N4, SetDiggerFour, "igsdfo", "SELECT 4TH DIGGER"  },
      { aKeys.N5, SetDiggerFive, "igsdfi", "SELECT 5TH DIGGER" },
      { aKeys.J, SpawnJennite, "igsj", "SPAWN JENNITE (DEBUG)"  },
      { aKeys.P, CauseExplosion, "igce", "CAUSE EXPLOSION (DEBUG)" },
      { aKeys.SPACE, SelectDevice, "igcd", "CYCLE DEVICES" },
      aReveal, aScrollDown, aScrollLeft, aScrollRight, aScrollUp
    }, [aStates.REPEAT] = {
      aReveal, aScrollDown, aScrollLeft, aScrollRight, aScrollUp
    }
  });
  -- Get cursor ids
  local iCSelect<const> = aCursorIdData.SELECT;
  -- Object released on screen
  local function SelectObjectOnScreenDrag(iButton, iX, iY)
    -- Return if not right mouse button
    if iButton ~= 1 then return end;
    -- Drag menu if open
    if aContextMenu then UpdateMenuPosition(iX, iY) end;
  end
  -- Object released on screen
  local function SelectObjectOnScreenPress(iButton)
    -- If pause key or button pressed? Deselect the info screen and pause
    if iButton == 9 then return SelectPauseScreen() end;
    -- Left mouse button clicked?
    if iButton == 0 then
      -- We have context menu open and in bounds?
      if aContextMenuData and
         IsMouseInBounds(iMenuLeft, iMenuTop, iMenuRight, iMenuBottom) then
        -- Walk through it and test position
        for iMIndex = 1, #aContextMenuData do
          -- Get context menu item and if mouse is in bounds?
          local aMItem<const> = aContextMenuData[iMIndex];
          if IsMouseInBounds(aMItem[4], aMItem[5], aMItem[6], aMItem[7]) then
            -- If this item cannot be activate when busy? Play error sound
            if aMItem[3] and aActiveObject.F & OFL.BUSY ~= 0 then
              PlayStaticSound(iSError);
            -- Not busy?
            else
              -- Get menu data
              local aMData<const> = aMItem[1];
              -- New menu specified? Set new menu and play sound
              if aMData[3] ~= MNU.NONE then
                PlayStaticSound(iSSelect);
                SetContextMenu(aMData[3], false);
              -- New action specified?
              elseif aMData[4] ~= 0 and aMData[5] ~= 0 and aMData[6] ~= 0 then
                -- Play the click sound
                PlayStaticSound(iSSelect);
                -- Set the action and if failed? Play the error sound
                if not SetAction(aActiveObject,
                   aMData[4], aMData[5], aMData[6], true)
                  then PlayStaticSound(iSError) end;
              end
            end
            -- Blocked from doing anything else
            return;
          end
        end
      end
      -- Translate current mouse position to absolute level position
      local nMouseX<const>, nMouseY<const> = GetAbsMousePos();
      -- Walk through objects in backwards order. This is because objects are
      -- drawn from oldest to newest.
      for iIndex = #aObjects, 1, -1 do
        -- Get object, select object and return if mouse cursor touching it
        local aObject<const> = aObjects[iIndex];
        if IsSpriteCollide(479, nMouseX, nMouseY,
             aObject.S, aObject.X, aObject.Y) then
          SelectObject(aObject);
          return PlayStaticSound(iSSelect);
        end
      end
      -- Nothing found so deselect current object
      return SelectObject();
    end
    -- Right mouse button button or Joystick button 1 is held?
    if iButton == 1 then
      -- Right mouse button held down and menu open?
      if aContextMenu then UpdateMenuPositionAtMouseCursor();
      -- Is the right mouse button pressed? (Don't release the click).
      elseif aActiveObject then
        -- Get active objectmenu data
        local aObjContextMenu<const> = aActiveObject.OD.MENU;
        -- Object has menu and object belongs to active player and object isn't
        -- dead or eaten?
        if aObjContextMenu and
           aActiveObject.P == aActivePlayer and
           aActiveObject.A ~= ACT.DEATH and
           aActiveObject.A ~= ACT.EATEN then
          -- Object does belong to active player so play context menu sound and
          -- set the appropriate default menu for the object.
          PlayStaticSound(iSClick);
          SetContextMenu(aObjContextMenu, true);
        -- Object does not belong to active player? Play error sound
        else PlayStaticSound(iSError) end
      end
      -- Done
      return;
    end
  end
  -- Mouse hovering
  local function OnHover()
    -- We have context menu open and in bounds?
    if aContextMenuData and
       IsMouseInBounds(iMenuLeft, iMenuTop, iMenuRight, iMenuBottom) then
      -- Walk through it and test position
      for iMIndex = 1, #aContextMenuData do
        -- Get context menu item set tip if mouse is in bounds
        local aMItem<const> = aContextMenuData[iMIndex];
        if IsMouseInBounds(aMItem[4], aMItem[5],
                           aMItem[6], aMItem[7]) then
          return SetTip(aMItem[1][7]) end;
      end
    end
    -- Mouse isn't over anything interesting
    SetTip();
  end
  -- Setup hot spot data
  iHotSpotId = RegisterHotSpot({
    -- Digger money
    {   8, 216, 39, 16, 0, 0, "MONEY",       false, false },
    {  40, 216, 80, 16, 0, 0, "OBJECT INFO", false, false },
    { 120, 216, 16, 16, 0, 0, "JOB/PREDICT", false, false },
    -- Digger buttons
    { 144, 216, 16, 16, 0, iCSelect, "GO DIGGER 1", OnScroll, SetDiggerOne   },
    { 160, 216, 16, 16, 0, iCSelect, "GO DIGGER 2", OnScroll, SetDiggerTwo   },
    { 176, 216, 16, 16, 0, iCSelect, "GO DIGGER 3", OnScroll, SetDiggerThree },
    { 192, 216, 16, 16, 0, iCSelect, "GO DIGGER 4", OnScroll, SetDiggerFour  },
    { 208, 216, 16, 16, 0, iCSelect, "GO DIGGER 5", OnScroll, SetDiggerFive  },
    -- Utility buttons
    { 232, 216, 16, 16, 0, iCSelect, "NEXT DEVICE", OnScroll,
      SelectDevice },
    { 248, 216, 16, 16, 0, iCSelect, "INVENTORIES", OnScroll,
      SelectInventoryScreen },
    { 264, 216, 16, 16, 0, iCSelect, "LOCATIONS",   OnScroll,
      SelectLocationScreen },
    { 280, 216, 16, 16, 0, iCSelect, "GAME STATUS", OnScroll,
      SelectStatusScreen },
    { 296, 216, 16, 16, 0, iCSelect, "THE BOOK",    OnScroll,
      SelectBook },
    -- Anything else on the screen (too complecated to put here)
    { 0, 0, 0, 240, 3, 0, OnHover, OnScroll,
      { false, SelectObjectOnScreenPress, SelectObjectOnScreenDrag } },
  });
  -- Pre-initialisations of functions
  CreateObject = InitCreateObject();
  MoveOtherObjects = InitMoveOtherObjects();
  SetAction = InitSetAction();
  ProcessObjectMovement = ProcessObjectMovement();
  PhaseLogic = PhaseLogic();
  SelectInfoScreen = SelectInfoScreen();
  -- Register a console command to dump a level mask. I'm just going to sling
  -- this cvar handle in the terrain asset table so it doesn't get gc'd.
  local function DumpLevelMask(_, strFile)
    if maskZone then maskZone:Save(0, strFile or "mask") end;
  end
  aAssetTerrain.C = Command.Register("dump", 1, 2, DumpLevelMask);
end
-- Exports and imports ----------------------------------------------------- --
return { F = OnScriptLoaded, A = { AdjustObjectHealth = AdjustObjectHealth,
  AdjustViewPortX = AdjustViewPortX, AdjustViewPortY = AdjustViewPortY,
  BCBlit = BCBlit, BuyItem = BuyItem, CreateObject = CreateObject,
  DeInitLevel = DeInitLevel, DrawInfoFrameAndTitle = DrawInfoFrameAndTitle,
  EndConditionsCheck = EndConditionsCheck, GameProc = GameProc,
  GetAbsMousePos = GetAbsMousePos, GetActiveObject = GetActiveObject,
  GetActivePlayer = GetActivePlayer, GetGameTicks = GetGameTicks,
  GetLevelInfo = GetLevelInfo, GetOpponentPlayer = GetOpponentPlayer,
  GetViewportData = GetViewportData, HaveZogsToWin = HaveZogsToWin,
  InitContinueGame = InitContinueGame, IsSpriteCollide = IsSpriteCollide,
  LoadLevel = LoadLevel, LockViewPort = LockViewPort,
  ProcessViewPort = ProcessViewPort, RenderAll = RenderAll,
  RenderInterface = RenderInterface, RenderObjects = RenderObjects,
  RenderShroud = RenderShroud, RenderTerrain = RenderTerrain,
  SelectObject = SelectObject, SellSpecifiedItems = SellSpecifiedItems,
  SetPlaySounds = SetPlaySounds, TriggerEnd = TriggerEnd,
  UpdateShroud = UpdateShroud, aGemsAvailable = aGemsAvailable,
  aLevelData = aLevelData, aObjects = aObjects, aPlayers = aPlayers,
  aShroudData = aShroudData } };
-- ------------------------------------------------------------------------- --
end                                    -- End of 'InternalsScope' namespace
-- ------------------------------------------------------------------------- --
return HighPriorityVars();             -- Return high priority variables
-- End-of-File ============================================================= --
