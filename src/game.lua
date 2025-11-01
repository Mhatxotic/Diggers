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
  remove<const>, sin<const>, tostring<const>, unpack<const> =
    math.abs, math.ceil, error, math.floor, string.format, math.max,
    math.maxinteger, math.min, pairs, math.random, table.remove, math.sin,
    tostring, table.unpack;
-- Engine function aliases ------------------------------------------------- --
local CoreLog<const>, CoreWrite<const>, UtilClamp<const>, UtilClampInt<const>,
  UtilFlushArray<const>, UtilFlushArrays<const>, UtilFormatNumber<const>,
  UtilIsBoolean<const>, UtilIsFunction<const>, UtilIsInteger<const>,
  UtilIsString<const>, UtilIsTable<const>, UtilSign<const> =
    Core.Log, Core.WriteEx, Util.Clamp, Util.ClampInt, Util.FlushArray,
    Util.FlushArrays, Util.FormatNumber, Util.IsBoolean, Util.IsFunction,
    Util.IsInteger, Util.IsString, Util.IsTable, Util.Sign;
-- Diggers shared functions and data assigned later ------------------------ --
local ACT, AI, BlitSLT, BlitSLTRB, BlitSLTWH, CreateObject, DF, DIR,
  GetTestMode, InitBook, InitLobby, InitTNTMap, JOB, MFL, MNU,
  MoveOtherObjects, OFL, PlayInterfaceSound, PlaySound, PlaySoundAtObject,
  PlayStaticSound, Print, PrintC, PrintR, RenderFade, RenderShadow, RenderTip,
  SelectInfoScreen, SetAction, SetCursorPos, SetTip, TYP, aAIChoicesData,
  aDigBlockData, aDigTileData, aJumpFallData, aJumpRiseData, aLevelsData,
  aShopData, aShroudCircle, aShroudTileLookup, aTileData, fontLarge,
  fontLittle, fontTiny, iAnimNormal, iSavedSlowDown, iSlowDown, oDigData,
  oDugRandShaftData, oFloodGateData, oGlobalData, oMenuData, oObjectData,
  oSfxData, oTileFlags, texSpr;
-- Locals ------------------------------------------------------------------ --
local aContextMenu;                    -- Currently open context menu
local aContextMenuData;                -- Cached context menu positions data
local aDamageValues<const> = { };      -- Holds damage values
local aFloodData<const> = { };         -- Active tile flooding data
local aGemsAvailable<const> = { };     -- Gems available to be sold
local aLvlData<const> = { };           -- Current level data
local aObjs<const> = { };              -- Game objects list
local aPlayers<const> = { };           -- All the players in the game
local aRacesData;                      -- Races data (data.lua)
local aShroudData<const> = { };        -- Current level shroud data
local bAIvsAI;                         -- Is currently an AI vs AI game?
local fcbLogic, fcbRender, fcbEnd;     -- Current logic/render/end callbacks
local iGameTicks;                      -- Frames rendered for this level
local iHotSpotId;                      -- Current mouse hot spots id
local iKeyBankId;                      -- Current key bank activated
local iLvlId;                          -- Current level id selected
local iMenuBottom, iMenuLeft;          -- Menu position bottom/left bounds
local iMenuRight, iMenuTop;            -- Menu position top/right bounds
local iPlayerMoney, iOpponentMoney;    -- Cached player and opponent money
local iShroudColour;                   -- Current selected shroud colour
local iTileBg, texLev;                 -- Background tex id and lv tex handle
local iUniqueId;                       -- Current unique object id
local iWinLimit;                       -- Zogs needed to win this level
local maskLev, maskSpr, maskZone;      -- Level/sprite/zone bitmask handles
local oObjActive, oPlrActive;          -- Currently selected object and player
local oPlrOpponent;                    -- Reference to opposing player data
local sLvlName, sLvlType;              -- Level name and type strings
-- Viewport ---------------------------------------------------------------- --
local iAbsCenPosX, iAbsCenPosY;        -- Current viewport absolute centre pos
local iAbsPosX, iAbsPosY;              -- Current viewport absolute position
local iLLAbsHmVP, iLLAbsWmVP;          -- Maximum viewport tile position
local iLLPixHmVP, iLLPixWmVP;          -- Maximum viewport pixel position
local iPixCenPosX, iPixCenPosY;        -- Current viewport pixel centre pos
local iPixPosTargetX, iPixPosTargetY;  -- Current viewport animated pixel pos
local iPixPosX, iPixPosY;              -- Current viewport pixel position
local iScrTilesW, iScrTilesH;          -- Max horiz/vertical tiles on screen
local iScrTilesWd2, iScrTilesHd2;      -- " as above but divided by two
local iScrTilesWd2p1, iScrTilesHd2p1;  -- " as above but div by two plus one
local iScrTilesWm1, iScrTilesHm1;      -- " as above but minus one
local iStageB, iStageH, iStageL;       -- Fbo bottom/height/left bounds
local iStageR, iStageT, iStageW;       -- Fbo right/top/width bounds
local iTilesHeight, iTilesWidth;       -- Total tiles on screen
local iViewportH, iViewportW;          -- Current viewport width and height
local iViewportX, iViewportY;          -- Current viewport absolute position
-- Level limits ------------------------------------------------------------ --
local iLLAbsW<const>   = 128;               -- Total # of horizontal tiles
local iLLAbsH<const>   = 128;               -- Total # of vertical tiles
local iLLAbsWm1<const> = iLLAbsW - 1;       -- Horizontal tiles minus one
local iLLAbsHm1<const> = iLLAbsH - 1;       -- Vertical tiles minus one
local iLLAbs<const>    = iLLAbsW * iLLAbsH; -- Total # of tiles in level
local iLLAbsM1<const>  = iLLAbs - 1;        -- Total tiles minus one
local iLLAbsMLW<const> = iLLAbs - iLLAbsW;  -- Total tiles minus one row
local iLLPixW<const>   = iLLAbsW * 16;      -- Total # of horizontal pixels
local iLLPixH<const>   = iLLAbsH * 16;      -- Total # of vertical pixels
local iLLPixWm1<const> = iLLPixW - 1;       -- Total H pixels minus one
local iLLPixHm1<const> = iLLPixH - 1;       -- Total V pixels minus one
-- Other consts ------------------------------------------------------------ --
local iVPScrollThreshold<const> = 4;        -- Limit before centring viewport
-- Blank function ---------------------------------------------------------- --
local function BlankFunction() end;
-- Function to play a sound ------------------------------------------------ --
local function DoPlaySoundAtObject(oObj, iSfxId, nPitch)
  -- Check that object is in the players view
  local nX<const> = (oObj.X / 16.0) - iAbsPosX;
  if nX < -1.0 or nX > iScrTilesW then return end;
  local nY<const> = (oObj.Y / 16.0) - iAbsPosY;
  if nY < -1.0 or nY > iScrTilesH then return end;
  -- Play the sound and clamp the pan value as engine requires
  PlaySound(iSfxId, UtilClamp(-1.0 + ((nX / iScrTilesW) * 2.0), -1.0, 1.0),
    nPitch);
end
-- Enable or disable playing sounds ---------------------------------------- --
local function SetPlaySounds(bState)
  if bState then PlaySoundAtObject, PlayInterfaceSound =
    DoPlaySoundAtObject, PlayStaticSound;
  else PlaySoundAtObject, PlayInterfaceSound =
    BlankFunction, BlankFunction end;
end
-- Update viewport data ---------------------------------------------------- --
local function UpdateViewport(nPos, iTLMVPS, iTTD2, iTT, iTL)
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
local function SetViewportX(nX)
  iPixPosX, iPixCenPosX, iAbsPosX, iAbsCenPosX, iViewportW =
    UpdateViewport(nX, iLLPixWmVP, iScrTilesWd2, iScrTilesW, iLLAbsW);
  if iPixCenPosX < 0 then iTilesWidth = iScrTilesW;
                     else iTilesWidth = iScrTilesWm1 end;
  iViewportX = iPixPosX - iStageL;
end
-- Update vertical viewport data ------------------------------------------- --
local function SetViewportY(nY)
  iPixPosY, iPixCenPosY, iAbsPosY, iAbsCenPosY, iViewportH =
    UpdateViewport(nY, iLLPixHmVP, iScrTilesHd2,
      iScrTilesH, iLLAbsWm1);
  if iPixCenPosY < 0 then iTilesHeight = iScrTilesH;
                     else iTilesHeight = iScrTilesHm1 end;
  iViewportY = iPixPosY - iStageT;
end
-- Adjust viewport --------------------------------------------------------- --
local function AdjustViewportX(iX) SetViewportX(iPixPosX + iX) end;
local function AdjustViewportY(iY) SetViewportY(iPixPosY + iY) end;
local function AdjustViewport(iX, iY) AdjustViewportX(iX);
                                      AdjustViewportY(iY) end;
-- Update new viewport ----------------------------------------------------- --
local function SetViewport(iX, iY) SetViewportX(iX) SetViewportY(iY) end
-- Set instant focus on object horizontally -------------------------------- --
local function ScrollViewportTo(iX, iY)
  iPixPosTargetX, iPixPosTargetY =
    UtilClampInt(iX, 0, iLLAbsWmVP) * 16,
    UtilClampInt(iY, 0, iLLAbsHmVP) * 16;
end
-- Force viewport position without scrolling ------------------------------- --
local function ForceViewport() SetViewport(iPixPosTargetX, iPixPosTargetY) end;
-- Focus on object --------------------------------------------------------- --
local function ObjectFocus(oObj)
  -- Get object absolute position
  local iX<const>, iY<const> = oObj.AX, oObj.AY;
  -- Return if object is in the viewport
  if (iAbsPosX <= 0 or iX - iVPScrollThreshold >= iAbsPosX) and
     (iAbsPosX >= iLLAbsWmVP or iX + iVPScrollThreshold < iViewportW) and
     (iAbsPosY <= 0 or iY - iVPScrollThreshold >= iAbsPosY) and
     (iAbsPosY >= iLLAbsHmVP or iY + iVPScrollThreshold < iViewportH) then
    return;
  end
  -- Gradually scroll to this position centred on the object
  ScrollViewportTo(iX - iScrTilesWd2, iY - iScrTilesHd2);
  -- Return if we're not already off the end of the screen?
  if (abs(iX - iAbsCenPosX) <= iScrTilesWd2p1 and
      abs(iY - iAbsCenPosY) <= iScrTilesHd2p1) or bAIvsAI then return end;
  -- Set instant focus on object horizontally
  ForceViewport();
end
-- Set active object menu -------------------------------------------------- --
local function SetContextMenu(iId)
  -- Hide the menu?
  if not iId then aContextMenu, aContextMenuData = nil, nil return end;
  -- Get requested context menu and if it is a different context menu?
  aContextMenu = oMenuData[iId];
  if not UtilIsTable(aContextMenu) then
    error("Invalid menu data for "..iId.."! "..tostring(aContextMenu)) end;
end
-- Select an object -------------------------------------------------------- --
local function SelectObject(oObj, bNow, bCursor)
  -- Unset context menu if object changed
  if oObj ~= oObjActive then SetContextMenu() end;
  -- Set active object and remove menu if different object
  oObjActive = oObj;
  -- Return if no object to focus on
  if not oObj then return end;
  -- Have focus command?
  if bNow ~= nil then
    -- Get object absolute position
    local iX<const>, iY<const> = oObj.AX, oObj.AY;
    -- Scroll viewport to the object
    ScrollViewportTo(iX - iScrTilesWd2, iY - iScrTilesHd2);
    -- Now as in this instant?
    if bNow then ForceViewport();
    -- Now as in gradually? and also if not AI vs AI mode object is not in the
    -- viewport? Finish scroll now
    elseif not bAIvsAI and
      ((iAbsPosX > 0 and iX - iVPScrollThreshold < iAbsPosX) or
       (iAbsPosX < iLLAbsWmVP and iX + iVPScrollThreshold >= iViewportW) or
       (iAbsPosY > 0 and iY - iVPScrollThreshold < iAbsPosY) or
       (iAbsPosY < iLLAbsHmVP and iY + iVPScrollThreshold >= iViewportH)) then
      ForceViewport();
    end
  -- Focus on object
  else ObjectFocus(oObj) end;
  -- Done if we're not setting the cursor
  if not bCursor then return end;
  -- Set the cursor position
  SetCursorPos(oObj.X - iViewportX + oObj.OFX + 8,
               oObj.Y - iViewportY + oObj.OFY + 8);
end
-- Draw health bar --------------------------------------------------------- --
local function DrawHealthBar(iHealth, nDivisor, nLeft, nTop, nHeight)
  -- Go from white (100%) to orange (50%) to red (0%).
  texSpr:SetCRGB(1.0, min(iHealth, 50.0) / 50.0,
                      max(iHealth - 50.0, 0.0) / 50.0);
  BlitSLTWH(texSpr, 1022, nLeft, nTop, iHealth / nDivisor, nHeight);
  texSpr:SetCRGB(1.0, 1.0, 1.0);
end
-- Get zero based tile id at specified absolute location ------------------- --
local function GetLevelDataFromAbsCoordinates(iAbsX, iAbsY)
  -- Return if tile offset is invalid
  if iAbsX < 0 or iAbsX >= iLLAbsW or
     iAbsY < 0 or iAbsY >= iLLAbsH then return end;
  -- Calculate specified location and return it and the tile at that location
  local iLoc<const> = iAbsY * iLLAbsW + iAbsX;
  return aLvlData[1 + iLoc], iLoc;
end
-- Get zero based tile id at specified absolute location ------------------- --
local function GetLevelDataFromLevelOffset(iLoc)
  -- Get tile at specified location
  if iLoc >= 0 and iLoc < iLLAbs then return aLvlData[1 + iLoc] end;
end
-- Get tile at specified object offset pixels ------------------------------ --
local function GetLevelOffsetFromObject(oObj, iPixX, iPixY)
  -- Adjust pixel parameters to where the object is
  iPixX, iPixY = iPixX + oObj.X + oObj.OFX, iPixY + oObj.Y + oObj.OFY;
  -- Return location if the pixel location adjacent to the object is valid
  if iPixX >= 0 and iPixX < iLLPixW and iPixY >= 0 and iPixY < iLLPixH then
    return (iPixY // 16 * iLLAbsW) + (iPixX // 16) end;
end
-- Get zero based tile id at specified object ------------------------------ --
local function GetLevelDataFromObject(oObj, iPixX, iPixY)
  -- Return tile at specified location
  local iLoc<const> = GetLevelOffsetFromObject(oObj, iPixX, iPixY);
  if iLoc then return aLvlData[1 + iLoc], iLoc end;
end
-- Update level and level mask --------------------------------------------- --
local function UpdateLevel(iLoc, iTid)
  -- We assign 'iTid' directly to the level data so check it.
  if not UtilIsInteger(iTid) then
     error("Invalid level tile index!"..tostring(iTid)) end;
  -- Update level data with specified tile
  aLvlData[1 + iLoc] = iTid;
  -- Calculate pixel X and Y position from location
  local iX<const>, iY<const> = iLoc % iLLAbsW * 16, iLoc // iLLAbsW * 16;
  -- Update zone collision bit-mask
  maskZone:Copy(maskLev, iTid, iX, iY);
  -- This part will keep the 1 pixel barrier around the level
  if iLoc < iLLAbsW then
    -- Keep top-left corner barrier to stop objects going off screen
    if iLoc == 0 then
      maskZone:Fill(0, 0, 16, 1);
      maskZone:Fill(0, 0, 1, 16);
    -- Keep top-right corner barrier to stop objects going off screen
    elseif iLoc == iLLAbsWm1 then
      maskZone:Fill(iX - 16, 0, 16, 1);
      maskZone:Fill(iX - 1, 0, 1, 16);
    -- Top row
    else maskZone:Fill(iX, 0, iX + 16, 1) end;
  -- Bottom row?
  elseif iLoc >= iLLAbsMLW then
    -- Keep bottom-left corner barrier to stop objects going off screen
    if iLoc == iLLAbsMLW then
      maskZone:Fill(0, iY, 1, 16);
      maskZone:Fill(0, iY + 15, 16, 1);
    -- Keep bottom-right corner barrier to stop objects going off screen
    elseif iLoc == iLLAbsM1 then
      maskZone:Fill(iX + 15, iY, 1, 16);
      maskZone:Fill(iX, iY + 15, 16, 1);
    -- Bottom row?
    else maskZone:Fill(iX, iY + 15, 16, 1) end;
    -- Keep left side barrier to stop objects going off screen
  elseif iLoc % iLLAbsW == 0 then maskZone:Fill(0, iY, 1, iY + 16);
  -- Keep right side barrier to stop objects going off screen
  elseif iLoc % iLLAbsW == iLLAbsWm1 then
    maskZone:Fill(iX + 15, iY, 1, iY + 16);
  end
end
-- Can sell gem? ----------------------------------------------------------- --
local function CanSellGem(iTypeId)
  -- Check parameters
  if not UtilIsInteger(iTypeId) then
    error("Object not specified! "..tostring(iTypeId)) end;
  -- Jennites can always be sold
  if iTypeId == TYP.JENNITE then return true end;
  -- Not a Jennite so we need to check if it's a gem we can sell. If we can
  -- sell it? Then return success.
  for iGem = 1,3 do
    if aGemsAvailable[iGem] == iTypeId then return true end;
  end
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
    -- If the co-ordinates are not valid then skip
    if iX < 0 or iY < 0 or iX >= iLLAbsW or iY >= iLLAbsH then
      goto lContinue end;
    -- Get shroud flags and calc new flags data and continue skip if same
    local aShroudItem<const> = aShroudData[iY * iLLAbsW + iX + 1];
    local iOldFlags<const> = aShroudItem[2];
    local iNewFlags<const> = iOldFlags | aShroudCircleItem[3];
    if iOldFlags == iNewFlags then goto lContinue end;
    -- Lookup new tile id and if theres only one? Set first tile
    local aTiles<const> = aShroudTileLookup[1 + iNewFlags];
    if #aTiles == 1 then aShroudItem[1], aShroudItem[2] = aTiles[1], iNewFlags;
    -- More than one tile? Randomly select one
    else aShroudItem[1], aShroudItem[2] =
      aTiles[random(#aTiles)], iNewFlags end;
    -- Next shroud tile
    ::lContinue::
  end
end
-- Set object X position --------------------------------------------------- --
local function SetPositionX(oObj, iX)
  -- Calculate new absolute X position
  local iAX<const> = iX // 16;
  -- Update absolute and pixel position
  oObj.AX, oObj.X = iAX, iX;
  -- Update shroud if requested
  if oObj.US then UpdateShroud(iAX, oObj.AY) end;
  -- Refocus on object if needed
  if oObjActive == oObj then ObjectFocus(oObj) end;
end
-- Set object Y position --------------------------------------------------- --
local function SetPositionY(oObj, iY)
  -- Calculate new absolute Y position
  local iAY<const> = iY // 16;
  -- Update absolute and pixel position
  oObj.AY, oObj.Y = iAY, iY;
  -- Update shroud if requested
  if oObj.US then UpdateShroud(oObj.AX, iAY) end;
  -- Refocus on object if needed
  if oObjActive == oObj then ObjectFocus(oObj) end;
end
-- Set object X and Y position --------------------------------------------- --
local function SetPosition(oObj, iX, iY)
  -- Calculate new absolute X position
  local iAX<const>, iAY<const> = iX // 16, iY // 16;
  -- Update absolute and pixel position
  oObj.AX, oObj.X, oObj.AY, oObj.Y = iAX, iX, iAY, iY;
  -- Update shroud if requested
  if oObj.US then UpdateShroud(iAX, iAY) end;
  -- Refocus on object if needed
  if oObjActive == oObj then ObjectFocus(oObj) end;
end
-- Get win limit ----------------------------------------------------------- --
local function HaveZogsToWin(oPlr) return oPlr.M >= iWinLimit end;
-- Level end conditions check ---------------------------------------------- --
local function EndConditionsCheck()
  -- Chosen ending condition.
  local iCondition;
  -- Player has enough Zogs?
  if HaveZogsToWin(oPlrActive) then iCondition = 1;
  -- All the opponents Diggers have died?
  elseif oPlrOpponent.DC <= 0 then iCondition = 2;
  -- The opponent has enough Zogs?
  elseif HaveZogsToWin(oPlrOpponent) then iCondition = 3;
  -- All the players Diggers have died?.
  elseif oPlrActive.DC <= 0 then iCondition = 4;
  -- No condition.
  else iCondition = 0 end;
  -- Log condition.
  CoreLog("Game progress condition is currently code "..iCondition..".");
  -- Return if not finished yet.
  if iCondition == 0 then return false end;
  -- Call completion event. Caller should transition to something else.
  fcbEnd(iCondition);
  -- Game is ended.
  return true;
end
-- Find the item in the specified list and return its id ------------------- --
local function GetIndexForItem(tItem, aList)
  for iId = 1, #aList do if tItem == aList[iId] then return iId end end;
end
-- Destroy object ---------------------------------------------------------- --
local function DestroyObject(iObjId, oObj)
  -- We pass 'iObjId' to 'table.remove' so we need to check it.
  if not UtilIsInteger(iObjId) then
    error("Specified id is not an integer! "..tostring(iObjId)) end;
  -- Object respawns?
  if oObj.F & OFL.RESPAWN ~= 0 then
    -- Restore object health
    oObj.H = 100;
    -- Move back to objects starting position
    SetPosition(oObj, oObj.SX, oObj.SY);
    -- Get object data
    local oObjData<const> = oObj.OD;
    -- Restore object animation speed
    oObj.ANT = oObjData.ANIMTIMER;
    -- Respawn back in with originally specified criteria
    SetAction(oObj, oObjData.ACTION, oObjData.JOB, oObjData.DIRECTION);
    -- Done
    return;
  end
  -- Remove object from the global objects list
  remove(aObjs, iObjId);
  -- If pursuer had targets? Remove pursuer from targets pursuer list
  local oTarget<const> = oObj.T;
  if oTarget then oTarget.TL[oObj.U] = nil end;
  -- If selected object is this digger then disable the menu
  if oObjActive == oObj then SelectObject() end;
  -- Get digger id and return if it was not a Digger?
  local iDiggerId<const> = oObj.DI;
  if not iDiggerId then return end;
  -- Get player owner and mark it as dead and reduce players' digger count
  local oPlr<const> = oObj.P;
  oPlr.D[iDiggerId], oPlr.DC = false, oPlr.DC - 1;
  -- Remove pursuers and reset pursuer targets
  local oPursuers<const> = oObj.TL;
  for iUId, aPursuer in pairs(oPursuers) do
    aPursuer.T, oPursuers[iUId] = nil, nil;
  end
  -- Recheck ending conditions
  EndConditionsCheck();
end
-- Destroy object without knowing the object id ---------------------------- --
local function DestroyObjectUnknown(oObj)
  -- Check id specified
  if not UtilIsTable(oObj) then
    error("Invalid object specified! "..tostring(oObj)) end;
  -- Find the object and return failure if not found
  local iObjId<const> = GetIndexForItem(oObj, aObjs);
  if not iObjId then return false end;
  DestroyObject(iObjId, oObj);
  return true;
end
-- Add to inventory -------------------------------------------------------- --
local function AddToInventory(oObjOwner, oObjTake, iObjId)
  -- Check parameters
  if not UtilIsTable(oObjOwner) then
    error("Invalid owner object specified! "..tostring(oObjOwner)) end;
  -- Remove object and add requested object to owners inventory
  remove(aObjs, iObjId);
  local oObjOwnInv<const> = oObjOwner.I;
  oObjOwnInv[1 + #oObjOwnInv] = oObjTake;
  -- Add weight and set active inventory object to this object
  oObjOwner.IW, oObjOwner.IS = oObjOwner.IW + oObjTake.W, oObjTake;
  -- Set object that is now carrying this
  oObjTake.IP = oObjActive;
  -- Stop the taken object for inventory preview purposes
  SetAction(oObjTake, ACT.STOP, JOB.NONE, DIR.NONE);
  -- If item picked up was the active object then deselect it and its menu
  if oObjActive == oObjTake then SelectObject() end;
end
-- Drop Object ------------------------------------------------------------- --
local function DropObject(oObjOwner, oObjDrop)
  -- Return if object to drop is not specified
  if not oObjDrop then return end;
  -- Find index for object and return if object not found
  local oObjOwnInv<const> = oObjOwner.I;
  local iObjId<const> = GetIndexForItem(oObjDrop, oObjOwnInv);
  if not iObjId then return false end;
  -- Remove object from owner inventory
  remove(oObjOwnInv, iObjId);
  -- Set new position of object
  SetPosition(oObjDrop, oObjOwner.X, oObjOwner.Y);
  -- Add back to playfield
  aObjs[1 + #aObjs] = oObjDrop;
  -- Reduce carrying weight
  oObjOwner.IW = oObjOwner.IW - oObjDrop.W;
  -- Select next object
  oObjOwner.IS = oObjOwnInv[iObjId];
  -- Remove object inventory owner
  oObjOwnInv.IP = false;
  -- If now invalid select first object
  if not oObjOwner.IS then oObjOwner.IS = oObjOwnInv[1] end;
  -- Success!
  return true;
end
-- Sell an item ------------------------------------------------------------ --
local function SellItem(oObjOwner, aSellObj)
  -- Check parameters
  if not UtilIsTable(oObjOwner) then
    error("Invalid object specified! "..tostring(oObjOwner)) end;
  if not UtilIsTable(aSellObj) then
    error("Invalid inventory object specified! "..tostring(aSellObj)) end;
  -- Remove and destroy object from inventory and return if failed
  if not DropObject(oObjOwner, aSellObj) or
     not DestroyObjectUnknown(aSellObj) then return false end;
  -- Increment funds but deduct value according to damage
  local oParent<const> = oObjOwner.P;
  local nValue<const> = aSellObj.OD.VALUE / 2;
  local nDamage<const> = aSellObj.H / 100;
  local iValue<const> = floor(nValue * nDamage);
  local iValuePenalty<const> = floor(nValue) - iValue;
  local iMoney<const>, iAdded = oParent.M;
  -- If treasure?
  if aSellObj.F & OFL.TREASURE ~= 0 then
    -- Add value based on time
    oParent.GS = oParent.GS + 1;
    iAdded = iGameTicks // 18000;
    local iValueAdded<const> = iValue + iAdded;
    oParent.GI = oParent.GI + iValueAdded;
    oParent.M = iMoney + iValueAdded;
  -- No added value
  else iAdded, oParent.M = 0, iMoney + iValue end;
  -- Log the destruction
  CoreLog(oObjOwner.OD.NAME.." "..oObjOwner.DI.." sold "..aSellObj.OD.NAME..
    " for "..iValue.." Zogs (P:"..iValuePenalty..";A:"..iAdded..";"..
    iMoney..">"..oParent.M..")!");
  -- Sold
  return true;
end
-- Sprite collides with another sprite ------------------------------------- --
local function IsSpriteCollide(S1, X1, Y1, S2, X2, Y2)
  return maskSpr:IsCollideEx(S1, X1, Y1, maskSpr, S2, X2, Y2);
end
-- Pickup Objects ---------------------------------------------------------- --
local function PickupObjects(...)
  -- Real function
  local function DoPickupObjects(oObj, iAnd, iEqual)
    -- Get object strength
    local iStr<const>, iObjId = oObj.STR, 1;
    -- Continue point
    ::lContinue::
    -- Return if after the last object else get target object
    if iObjId > #aObjs then return false end;
    -- Get object and target flags and if...
    local oObjTarget<const> = aObjs[iObjId];
    local iTFlags = oObjTarget.F;
    if oObj ~= oObjTarget and         -- ...target object not same *or*
       iTFlags & iAnd == iEqual and   -- ...target property flags match? *and*
       #oObjTarget.I <= 0 and         -- ...target obj not has inventory *and*
       oObj.IW + oObjTarget.W <= iStr and -- ...not too heavy? *and*
       IsSpriteCollide(                   -- ...touching?
         oObj.S, oObj.X + oObj.OFX, oObj.Y + oObj.OFY, oObjTarget.S,
         oObjTarget.X + oObjTarget.OFX, oObjTarget.Y + oObjTarget.OFY) then
      -- Add to the inventory and return success
      AddToInventory(oObj, oObjTarget, iObjId);
      return true;
    end
    -- Goto next object
    iObjId = iObjId + 1;
    goto lContinue;
  end
  -- Set real function and return first call of it
  PickupObjects = DoPickupObjects;
  return DoPickupObjects(...);
end
-- Set a random action, job and direction ---------------------------------- --
local function SetRandomJob(oObj, bResetJobTimer)
  -- Select a random choice and failed direction matches?
  local aChoice = aAIChoicesData[random(#aAIChoicesData)];
  if aChoice[1] == oObj.FDD then aChoice = aChoice[2];
  -- We're not blocked from digging so try moving in that direction
  else aChoice = aChoice[3] end;
  -- Set new AI choice and return
  SetAction(oObj, aChoice[1], aChoice[2], aChoice[3], bResetJobTimer);
end
-- Object is at home ------------------------------------------------------- --
local function ObjectIsAtHome(oObj)
  -- Return if object is at the home point. A parent is assumed.
  local oPlr<const> = oObj.P;
  return oObj.X == oPlr.HX and oObj.Y == oPlr.HY;
end
-- Cycle object inventory -------------------------------------------------- --
local function CycleObjInventory(oObj, iDirection)
  -- Get object inventory and return failed if no inventory
  local aInv<const> = oObj.I;
  if #aInv == 0 then return false end;
  -- Enumerate inventory to find selected item
  local iInvIndex<const> = GetIndexForItem(oObj.IS, aInv);
  if not iInvIndex then return false end;
  -- Cycle object wrapping on low or high and return success
  oObj.IS = aInv[1 + (((iInvIndex - 1) + iDirection) % #aInv)];
  return true;
end
-- Prevent all diggers entering trade centre ------------------------------- --
local function SetAllDiggersNoHome(aDiggers)
  -- Get player data and enumerate their diggers
  for iDiggerId = 1, #aDiggers do
    -- Get digger object and stop it from going home
    local oDigger<const> = aDiggers[iDiggerId];
    if oDigger then oDigger.F = oDigger.F | OFL.NOHOME end;
  end
end
-- Set object action ------------------------------------------------------- --
local function InitSetAction()
  -- Frequently used variables --------------------------------------------- --
  local iAClose<const>, iAFight<const>, iAKeep<const>, iAOpen<const>,
    iAPhase<const>, iAStop<const>, iAWalk<const>, iDDown<const>, iDLeft<const>,
    iDNone<const>, iDOpposite<const>, iDRight<const>, iDUp<const>,
    iDUpLeft<const>, iFiBusy<const>, iFiFall<const>, iFiJump<const>,
    iFiNoSound<const>, iFBlock<const>, iFBusy<const>, iFImpatient<const>,
    iFJumpBusy<const>, iFJumpRiseBusy<const>, iFNoAIBusy<const>,
    iFNoHome<const>, iFNoSound<const>, iFPuAnyMask<const>, iFPuAnyEq<const>,
    iFRngSprite<const>, iFStaminaBoost<const>, iFTPMaster<const>,
    iJDigDown<const>, iJHome<const>, iJKeep<const>, iJNone<const>,
    iJPhase<const>, iSJump<const>, iTyGateB<const>, iTyLiftB<const> =
      ACT.CLOSE, ACT.FIGHT, ACT.KEEP, ACT.OPEN, ACT.PHASE, ACT.STOP, ACT.WALK,
      DIR.D, DIR.L, DIR.NONE, DIR.OPPOSITE, DIR.R, DIR.U, DIR.UL, OFL.iBUSY,
      OFL.iFALL, OFL.iJUMP, OFL.iNOSOUND, OFL.BLOCK, OFL.BUSY, OFL.IMPATIENT,
      OFL.JUMPBUSY, OFL.JUMPRISEBUSY, OFL.NOAIBUSY, OFL.NOHOME,
      OFL.NOSOUND, OFL.PUMANY, OFL.PUEANY, OFL.RNGSPRITE, OFL.STAMINABOOST,
      OFL.TPMASTER, JOB.DIGDOWN, JOB.HOME, JOB.KEEP, JOB.NONE, JOB.PHASE,
      oSfxData.JUMP, TYP.GATEB, TYP.LIFTB;
  -- Train track data tile translation lookup ------------------------------ --
  local oTrainTrackData<const> = {
    [  7] = 210, [ 95] = 210, [ 96] = 210, [171] = 210, [172] = 210,
    [150] = 149, [170] = 169, [247] = 450, [329] = 450, [330] = 450,
    [390] = 389, [410] = 409,
  };
  -- Deployment of train track --------------------------------------------- --
  local function DEPLOYTrack(oObj)
    -- Deploy success
    local bDeploySuccess = false;
    -- Check 5 tiles at object position and lay track
    for iTrackId = 0, 4 do
      -- Calculate absolute location of object and get tile id. Break if bad
      local iId, iLoc<const> =
        GetLevelDataFromObject(oObj, (iTrackId * 16) + 8, 15);
      if not iId then break end;
      -- Check if it's a tile we can convert and break if we can't
      iId = oTrainTrackData[iId];
      if not iId then break end;
      -- Get terrain tile id blow this tile and if we can deploy on this?
      if aTileData[1 + aLvlData[1 + iLoc + iLLAbsW]] & oTileFlags.F ~= 0 then
        -- Update level data
        UpdateLevel(iLoc, iId);
        -- Deployed successfully and continue
        bDeploySuccess = true;
      end
    end
    -- Deploy if succeeded
    return bDeploySuccess;
  end
  -- Deployment of flood gate ---------------------------------------------- --
  local function DEPLOYGate(oObj)
    -- Return failure if specified position is not firm ground
    local iId<const>, iLoc<const> = GetLevelDataFromObject(oObj, 8, 16);
    if not iId or aTileData[1 + iId] & oTileFlags.F == 0 then return false end;
    -- Get absolute position of tile
    local iAbsPos<const> = iLoc - iLLAbsW;
    -- Try to create an invisible gate sprite which has a gate mask sprite so
    -- the player can select it and return failure if we could not
    if not CreateObject(iTyGateB, iLoc % iLLAbsW * 16,
      iAbsPos // iLLAbsW * 16, oObj.P) then return false end;
    -- Update tile to a flood gate
    UpdateLevel(iAbsPos, 438);
    -- Success!
    return true;
  end
  -- Do actually deploy the lift ------------------------------------------- --
  local function LiftFindTop(oObj, iLoc, iBottom)
    -- Search for a buildable above ground surface
    for iTop = iLoc, iLLAbsW, -iLLAbsW do
      -- Get tile
      local iId<const> = aLvlData[1 + iTop];
      local iTileId<const> = aTileData[1 + iId];
      -- Try next tile if already been dug out
      if iTileId & oTileFlags.AD ~= 0 then goto lContinue end;
      -- Break if tile is not firm buildable ground
      if iTileId & oTileFlags.F == 0 then break end;
      -- Height check and if ok and creating an object went ok?
      -- Create lift object
      if iTop < iLLAbsW or iBottom - iTop < 384 or
        not CreateObject(iTyLiftB, (oObj.X + 8) // 16 * 16,
          (oObj.Y + 15) // 16 * 16, oObj.P) then break end;
      -- Draw cable from top to bottom
      UpdateLevel(iTop, 62);
      for iTop = iTop + iLLAbsW, iBottom - iLLAbsW, iLLAbsW do
        UpdateLevel(iTop, 189) end;
      UpdateLevel(iBottom, 190);
      -- We are fully deployed now so set success
      do return true end;
      -- Continue point
      ::lContinue::
    end
  end
  -- Deploy the lift ------------------------------------------------------- --
  local function DEPLOYLift(oObj)
    -- Calculate absolute location of object
    local iLoc<const> = GetLevelOffsetFromObject(oObj, 8, 0);
    if not iLoc then return false end;
    -- Search for a buildable ground surface
    for iBottom = iLoc, iLLAbsMLW, iLLAbsW do
      -- Get tile
      local iId<const> = aLvlData[1 + iBottom];
      local iTileId<const> = aTileData[1 + iId];
      -- Tile has not been dug
      if iTileId & oTileFlags.AD ~= 0 then goto lContinue end;
      -- Return failure if we're not on firm ground or checking the shaft
      -- upto the top couldn't be satisfied and built.
      if iTileId & oTileFlags.F == 0 or
        not LiftFindTop(oObj, iLoc, iBottom) then break end;
      -- Success
      do return true end;
      -- Continue point
      ::lContinue::
    end
    -- Failed to deploy
    return false;
  end
  -- Deployment lookup table ----------------------------------------------- --
  local oDeployments<const> = { [TYP.TRACK] = DEPLOYTrack,
                                [TYP.GATE]  = DEPLOYGate,
                                [TYP.LIFT]  = DEPLOYLift };
  -- Deploy specified device ----------------------------------------------- --
  local function ACTDeployObject(oObj)
    -- Get deploy function and if deployable? Destroy it and return success
    local fcbDeployFunc<const> = oDeployments[oObj.ID];
    return true, fcbDeployFunc and fcbDeployFunc(oObj) and
      DestroyObjectUnknown(oObj);
  end
  -- Jump requested? ------------------------------------------------------- --
  local function ACTJump(oObj)
    -- Return failure to jump if fighting
    if oObj.A == iAFight then return true, false end;
    -- Get object flags and return failure if...
    local iFlags<const> = oObj.F;
    if iFlags & iFJumpBusy ~= 0 or -- ...jumping or busy *or*
       oObj.FS ~= 1 or             -- ...falling *or*
       oObj.FD < 0 then            -- ...accumulating fall damage
      return true, false end;
    -- Remove fall flag and add busy and jumping flags
    oObj.F = (iFlags | iFJumpRiseBusy) & iFiFall;
    -- Play jump sound
    PlaySoundAtObject(oObj, iSJump);
    -- Reset action timer as jump lookup tables use this
    oObj.AT = 0;
    -- Jump succeeded
    return true, true;
  end
  -- Dying or eaten requested? --------------------------------------------- --
  local function ACTDeathOrEaten(oObj)
    -- Remove jump and fall flags or if the digger is jumping then busy will
    -- be unset and they will be able to instantly come out of phasing.
    oObj.F = oObj.F & iFiJump;
    -- Force normal timer speed for animation
    oObj.ANT = iAnimNormal;
    -- Continue execution of function
    return false;
  end
  -- Display map requested? ------------------------------------------------ --
  local function ACTDisplayMap()
    -- Remove play sound function
    SetPlaySounds(false);
    -- Display map
    InitTNTMap();
    -- Halt further execution of function
    return true, true;
  end
  -- Gate functions -------------------------------------------------------- --
  local aGATEOpenClosedNoFlood<const>, aGATEOpenClosedFlooded<const>,
    aGATECloseOpenedNoFlood<const>, aGATECloseOpenedFlooded<const> =
      { 438, oSfxData.GOPEN,  false }, { 439, oSfxData.GOPEN,  true  },
      { 434, oSfxData.GCLOSE, false }, { 437, oSfxData.GCLOSE, false };
  -- Gate actions level tile lookup table ---------------------------------- --
  local oGateActions<const> = {
    [iAOpen] = {
      [434] = aGATEOpenClosedNoFlood, [435] = aGATEOpenClosedFlooded,
      [436] = aGATEOpenClosedFlooded, [437] = aGATEOpenClosedFlooded
    },
    [iAClose] = {
      [438] = aGATECloseOpenedNoFlood, [439] = aGATECloseOpenedFlooded
    }
  };
  -- Open or close a gate -------------------------------------------------- --
  local function ACTOpenCloseGate(oObj, iAction)
    -- Get location at specified tile and return if id is invalid
    local iId<const>, iLoc<const> =
      GetLevelDataFromAbsCoordinates(oObj.AX, oObj.AY);
    if not iId then return true, false end;
    -- Check which action requested and return if bad action
    local oGateFuncs<const> = oGateActions[iAction];
    if not oGateFuncs then return true, false end;
    -- Get function for specified id and return if bad tile
    local aData<const> = oGateFuncs[iId];
    if not aData then return true, false end;
    -- Update level with specified id
    UpdateLevel(iLoc, aData[1]);
    -- Check for flood if requested
    if aData[3] then
      aFloodData[1 + #aFloodData] = { iLoc, aTileData[1 + iId] } end;
    -- Play requested sound effect
    PlaySoundAtObject(oObj, aData[2]);
    -- Success
    return true, true;
  end
  -- Drop inventory item or grab world item requested? --------------------- --
  local function ACTDropItem(oObj) return true, DropObject(oObj, oObj.IS) end;
  local function ACTGrabItem(oObj)
    return true, PickupObjects(oObj, iFPuAnyMask, iFPuAnyEq) end;
  -- Previous or next inventory item requested? ---------------------------- --
  local function ACTLastItem(oObj) return true, CycleObjInventory(oObj,-1) end;
  local function ACTNextItem(oObj) return true, CycleObjInventory(oObj, 1) end;
  -- Phase requested? ------------------------------------------------------ --
  local function ACTPhase(oObj, _, iJob, iDirection)
    -- Phasing home? Refuse action if not enough health
    local iFlags<const> = oObj.F;
    if iJob == iJPhase and iDirection == iDUp and oObj.H <= 5 and
      iFlags & iFTPMaster == 0 then return true, false end;
    -- Remove jump and fall flags or if the digger is jumping then busy will
    -- be unset and they will be able to instantly come out of phasing.
    oObj.F = iFlags & iFiJump;
    -- Continue function execution
    return false;
  end
  -- Dig requested? Save current action to restore when digging completes -- --
  local function ACTDig(oObj) oObj.LA = oObj.A return false end;
  -- Actions to perform depending on action. They return a boolean and if
  -- false then execution of the action continues, else the action is blocked
  -- from further processing and an additional boolean is returned of the
  -- success of that action (used by the the player interface).
  local oActions<const> = {
    [ACT.DEATH]  = ACTDeathOrEaten,  [ACT.DIG]  = ACTDig,
    [ACT.EATEN]  = ACTDeathOrEaten,  [ACT.MAP]  = ACTDisplayMap,
    [iAOpen]     = ACTOpenCloseGate, [iAClose]  = ACTOpenCloseGate,
    [ACT.DEPLOY] = ACTDeployObject,  [ACT.JUMP] = ACTJump,
    [ACT.GRAB]   = ACTGrabItem,      [ACT.DROP] = ACTDropItem,
    [ACT.NEXT]   = ACTNextItem,      [ACT.PREV] = ACTLastItem,
    [iAPhase]    = ACTPhase
  };
  -- Going left or right? -------------------------------------------------- --
  local function DIRLeftRight(_, iAction, iJob)
    -- 50% chance to go left?
    if random() < 0.5 then return iAction, iJob, iDLeft end;
    -- Else go right
    return iAction, iJob, iDRight;
  end
  -- Going up or down? ----------------------------------------------------- --
  local function DIRUpDown(_, iAction, iJob)
    -- 50% chance to go left?
    if random() < 0.5 then return iAction, iJob, iDUp end;
    -- Else go right
    return iAction, iJob, iDDown;
  end
  -- Going to centre of tile (to dig down)? -------------------------------- --
  local function DIRMoveToCentre(oObj, iAction, iJob, iDirection)
    -- Set direction so it heads to the centre of the tile
    if oObj.X % 16 - 8 < 0 then iDirection = iDLeft;
                           else iDirection = iDRight end;
    -- Return original parameters
    return iAction, iJob, iDirection;
  end
  -- Requested actions allowed --------------------------------------------- --
  local oPreserve<const> = { [iAKeep] = true, [ACT.RUN] = true,
    [iAWalk] = true };
  -- Actions allowed if keep object action requested ----------------------- --
  local oPreserveKeep<const> = { [ACT.RUN] = true, [iAWalk] = true };
  -- Move towards trade centre? -------------------------------------------- --
  local function DIRMoveHomeward(oObj, iAction, iJob)
    -- If going home isn't allowed? Not allow it to go home
    local bIsNoHome<const> = oObj.F & iFNoHome ~= 0;
    if iJob == iJHome and bIsNoHome then iJob = iJNone end;
    -- Preserve action but action not walking or running? Set object walking
    if not oPreserve[iAction] or
       (iAction == iAKeep and not oPreserveKeep[oObj.A]) then
      iAction = iAWalk end;
    -- Get current X position and home position
    local iX<const>, iHX<const> = oObj.X, oObj.P.HX;
    -- Go left or right if homeward is to the left or right respectively
    if iX < iHX then return iAction, iJob, iDRight end;
    if iX > iHX then return iAction, iJob, iDLeft end;
    -- At home pixel but if can't go inside then just stop
    if bIsNoHome then return iAStop, iJNone, iDNone end;
    -- Can go inside so prevent all Diggers entering trade centre
    SetAllDiggersNoHome(oObj.P.D);
    -- Phase inside the trade centre
    return iAPhase, iJPhase, iDUpLeft;
  end
  -- Keep original direction ----------------------------------------------- --
  local function DIRKeep(oObj, iAction, iJob) return iAction, iJob, oObj.D end;
  -- Opposite directions --------------------------------------------------- --
  local oOpposites<const> = {
    [iDUpLeft] = DIR.UR,   [iDLeft]  = iDRight, [DIR.DL] = DIR.DR,
    [DIR.UR]   = iDUpLeft, [iDRight] = iDLeft,  [DIR.DR] = DIR.DL;
  };
  -- Keep original direction if moving ------------------------------------- --
  local function DIRKeepIfMoving(oObj, iAction, iJob, iDirection)
    -- If going in a recognised moving direction? Don't change direction
    local iObjDir<const> = oObj.D;
    if oOpposites[iObjDir] then return iAction, iJob, iObjDir end;
    -- Set a random direction
    return DIRLeftRight(oObj, iAction, iJob, iDirection);
  end
  -- Go opposite direction ------------------------------------------------- --
  local function DIROpposite(oObj, iAction, iJob, iDirection)
    -- Set opposite direction or just go right
    iDirection = oOpposites[oObj.D] or iDRight;
    -- Return original parameters
    return iAction, iJob, iDirection;
  end
  -- Actions to perform depending on direction ----------------------------- --
  local oDirections<const> = {
    [DIR.LR]       = DIRLeftRight,    [DIR.TCTR]     = DIRMoveToCentre,
    [DIR.HOME]     = DIRMoveHomeward, [DIR.KEEP]     = DIRKeep,
    [DIR.KEEPMOVE] = DIRKeepIfMoving, [iDOpposite]   = DIROpposite,
    [DIR.UD]       = DIRUpDown,
  };
  -- Actions to ignore for job in danger function -------------------------- --
  local aActionsToIgnore<const> = { [ACT.DEATH] = true, [iAPhase] = true };
  -- Performed when object is in danger ------------------------------------ --
  local function JOBInDanger(oObj, iJob)
    -- Keep busy unset if not dead or phasing!
    if not aActionsToIgnore[oObj.A] then oObj.F = oObj.F & iFiBusy end;
    -- Return originally set job
    return iJob;
  end
  -- Keep existing job but don't dig down? --------------------------------- --
  local function JOBKeepNoDigDown(oObj, iJob)
    -- Get current job and is digging down? Remove job
    iJob = oObj.J;
    if iJob == iJDigDown then return iJNone end;
    -- Return object's current job
    return iJob;
  end
  -- Keep existing job ----------------------------------------------------- --
  local function JOBKeep(oObj, iJob) return oObj.J end;
  -- Actions to perform depending on job
  local oJobs<const> = {
    [JOB.INDANGER] = JOBInDanger,
    [JOB.KNDD]     = JOBKeepNoDigDown,
    [iJKeep]       = JOBKeep
  };
  -- Do set action function ------------------------------------------------ --
  local function SetAction(oObj, iAction, iJob, iDirection, bResetJobTimer)
    -- Check parameters
    if not UtilIsTable(oObj) then
      error("Invalid object table specified! "..tostring(oObj)) end;
    if not UtilIsInteger(iAction) then
      error("Invalid action integer specified! "..tostring(iAction)) end;
    if not UtilIsInteger(iJob) then
      error("Invalid job integer specified! "..tostring(iJob)) end;
    if not UtilIsInteger(iDirection) then
      error("Invalid direction integer specified! "..tostring(iDirection)) end;
    -- Get action function and if we have one?
    local fcbActionCallback<const> = oActions[iAction];
    if fcbActionCallback then
      -- Call the function and return results
      local bBlock, bResult =
        fcbActionCallback(oObj, iAction, iJob, iDirection);
      -- If callback said to block further execution return execution result
      if bBlock then return bResult end;
    end
    -- Get direction function and if we have one? Call it and set new args
    local fcbDirCallback<const> = oDirections[iDirection];
    if fcbDirCallback then iAction, iJob, iDirection =
      fcbDirCallback(oObj, iAction, iJob, iDirection) end;
    -- Get job function and if we have one? Call it and set new args
    local fcbJobCallback<const> = oJobs[iJob];
    if fcbJobCallback then iJob = fcbJobCallback(oObj, iJob) end;
    -- Get object data
    local oObjInitData<const> = oObj.OD;
    -- Compare action. Stop requested?
    if iAction == iAStop then
      -- Reset action timer if different from last action
      if iAction ~= oObj.A then oObj.AT = 0 end;
      -- If object can stop? Keep busy unset!
      if oObj.CS then oObj.F = oObj.F & iFiBusy;
      -- Can't stop? Set default action and move in opposite direction
      else return SetAction(oObj, oObjInitData.ACTION, iJKeep, iDOpposite) end;
    -- Keep existing job? Keep existing action!
    elseif iAction == iAKeep then iAction = oObj.A end;
    -- If object action is the same as before?
    if iAction == oObj.A then
      -- If job and direction is same as requested?
      if iJob == oObj.J and iDirection == oObj.D then
        -- Reset job timer if user initiated
        if bResetJobTimer then oObj.JT = 0 end;
        -- Success regardless
        return true;
      end
    -- New action requested? Reset action timer
    else oObj.AT = 0 end;
    -- Set new action, direction and job
    oObj.A, oObj.J, oObj.D = iAction, iJob, iDirection;
    -- Remove all flags that are related to object directional flags
    local iDirFlags<const> = oObj.AD.FLAGS or 0;
    oObj.F = oObj.F & ~iDirFlags;
    -- Set action data according to lookup table
    local oAction<const> = oObjInitData[iAction];
    if not UtilIsTable(oAction) then
      error(oObjInitData.NAME.." actdata for "..iAction..
        " not found!"..tostring(oAction)) end;
    oObj.AD = oAction;
    -- If object has patience?
    local iPatience<const> = oObj.PW;
    if iPatience then
      -- Object starts as impatient? Set impatient
      if iDirFlags & iFImpatient ~= 0 then oObj.JT = iPatience;
      -- Reset value if the user made this action
      elseif bResetJobTimer then oObj.JT = 0 end;
    -- Patience disabled
    else oObj.JT = 0 end;
    -- Set directional data according to lookup table
    local aDirection<const> = oAction[iDirection];
    if not UtilIsTable(aDirection) then
      error(oObjInitData.NAME.." dirdata for "..iAction.."->"..iDirection..
        " not found! "..tostring(aDirection)) end;
    oObj.DD = aDirection;
    -- Re-add flags and direction specific according to lookup table
    oObj.F = oObj.F | (oAction.FLAGS or 0);
    -- Set collision mask id if is a platform
    if oObj.F & iFBlock ~= 0 then oObj.M = 474 else oObj.M = 478 end;
    -- Get and check starting sprite id
    local iSprIdBegin<const> = aDirection[1];
    if not UtilIsInteger(iSprIdBegin) then
      error(oObjInitData.NAME.." dirdata for "..iAction.."->"..iDirection..
        " missing starting sprite! "..tostring(iSprIdBegin)) end;
    oObj.S1 = iSprIdBegin;
    -- Get and check ending sprite id
    local iSprIdEnd<const> = aDirection[2];
    if not UtilIsInteger(iSprIdEnd) then
      error(oObjInitData.NAME.." dirdata for "..iAction.."->"..iDirection..
        " missing starting sprite! "..tostring(iSprIdEnd)) end;
    oObj.S2 = iSprIdEnd;
    -- Set optional sprite draw offset
    oObj.OFX, oObj.OFY = aDirection[3] or 0, aDirection[4] or 0;
    -- Random tile requested?
    if oObj.F & iFRngSprite ~= 0 then
      -- Get random sprite id
      local iSprite<const> = random(0) % (iSprIdEnd - iSprIdBegin);
      -- Does a new animation id need to be set?
      -- Set first animation frame and reset animation timer
      oObj.S, oObj.ST = iSprIdBegin + iSprite, iSprite;
    -- No random tile requested
    else
      -- Get current sprite id and does a new animation id need to be set?
      local iSprite<const> = oObj.S;
      if iSprite < iSprIdBegin or iSprite > iSprIdEnd then
        -- Set first animation frame and reset animation timer
        oObj.S, oObj.ST = iSprIdBegin, 0;
      end
    end
    -- Get and check attachment id
    local iAttTypeId<const> = oObj.STA;
    if iAttTypeId then
      -- Check that its valid
      if not UtilIsInteger(iAttTypeId) then
        error(oObjInitData.NAME.."'s specified attachment id is invalid! "..
          tostring(iAttTypeId)) end;
      -- Get and check object data for attachment
      local aAttObjectData<const> = oObjectData[iAttTypeId];
      if not UtilIsTable(aAttObjectData) then
        error(oObjInitData.NAME.."'s specified attachment id #"..iAttTypeId..
          " is invalid! "..tostring(aAttObjectData)) end;
      -- Get and check action data for attachment
      local aAttAction<const> = aAttObjectData[iAction];
      if not UtilIsTable(aAttAction) then
        error(oObjInitData.NAME.."'s specified attachment id #"..iAttTypeId..
          " actdata for "..iAction.." invalid! "..tostring(aAttAction)) end;
      oObj.AA = aAttAction;
      -- Set object data
      local aAttDirection<const> = aAttAction[iDirection];
      if not UtilIsTable(aAttDirection) then
        error(oObjInitData.NAME.."'s specified attachment id #"..iAttTypeId..
          " dirdata for "..iAction.." > "..iDirection.." invalid! "..
          tostring(aAttDirection)) end;
      oObj.DA = aAttDirection;
      -- Get and check attachment starting sprite id
      local iAttSprIdBegin<const> = aAttDirection[1];
      if not UtilIsInteger(iAttSprIdBegin) then
        error(oObjInitData.NAME.."'s specified attachment id #"..iAttTypeId..
          " dirdata for "..iAction.."->"..iDirection..
          " missing starting sprite! "..tostring(iAttSprIdBegin)) end;
      oObj.S1A = iAttSprIdBegin;
      -- Get and check attachment ending sprite id
      local iAttSprIdEnd<const> = aAttDirection[2];
      if not UtilIsInteger(iAttSprIdEnd) then
        error(oObjInitData.NAME.."'s specified attachment id #"..iAttTypeId..
          " dirdata for "..iAction.."->"..iDirection..
          " missing starting sprite! "..tostring(iAttSprIdEnd)) end;
      oObj.S2A = iAttSprIdEnd;
      -- Get and set new attachment sprite
      local iAttSprite<const> = oObj.SA;
      if iAttSprite < iAttSprIdBegin or iAttSprite > iAttSprIdEnd then
        oObj.SA = iAttSprIdBegin end;
      -- Set optional offset according to attachment
      oObj.OFXA, oObj.OFYA = aAttDirection[3] or 0, aAttDirection[4] or 0;
    -- Set no attachment
    end
    -- Set AI function if forced no AI or busy.
    if oObj.F & iFNoAIBusy ~= 0 then oObj.AIF = BlankFunction;
                                else oObj.AIF = oObj.AIDF end;
    -- Stamina boost?
    if oObj.F & iFStaminaBoost ~= 0 then
      -- Enable stamina boost (heal faster)
      local iStaminaBoost<const> = oObjInitData.STAMINA // 8;
      oObj.SM, oObj.SMM1 = iStaminaBoost, iStaminaBoost - 1;
    -- Not enabled?
    else
      -- Use original values
      local iStamina<const> = oObjInitData.STAMINA;
      oObj.SM, oObj.SMM1 = iStamina, iStamina - 1;
    end
    -- If we're overriding the action sound?
    if oObj.F & iFNoSound ~= 0 then
      -- Remove the flag and return success
      oObj.F = oObj.F & iFiNoSound;
      return true;
    end
    -- Get optional sound id and optional pitch and if specified?
    local iSoundId = oAction.SOUND;
    if iSoundId then
      -- Check it
      if not UtilIsInteger(iSoundId) then
        error(oObjInitData.NAME.." dirdata for "..iAction.."->"..iDirection..
          " has invalid sound id! "..tostring(iSoundId)) end;
      -- Play the sound now with no panning
      PlaySoundAtObject(oObj, iSoundId);
    -- No sound id?
    else
      -- Check for random pitch sound and if specified?
      iSoundId = oAction.SOUNDRP;
      if iSoundId then
        -- Check it
        if not UtilIsInteger(iSoundId) then
          error(oObjInitData.NAME.." dirdata for "..iAction.."->"..iDirection..
            " has invalid random pitch sound id! "..tostring(iSoundId)) end;
        -- Play sound with random pitch
        PlaySoundAtObject(oObj, iSoundId, 0.975 + (random() % 0.05));
      end
    end
    -- Success
    return true;
  end
  -- Return real functions (initialised at the bottom)
  return SetAction;
end
-- Roll the dice to spawn treasure at the specified location --------------- --
local function RollTheDice(iX, iY)
  -- Get chance to reveal a gem. 2.5% base value.
  local nChance = 0.025;
  -- Depth to start adding chance to base value (half way down).
  local iDepth<const> = 1024;
  -- Add up to double chance depending on depth
  if iY >= iDepth then
    nChance = nChance + (((iY - iDepth) / iDepth) * nChance) end;
  -- 5% chance to spawn a treasure
  if random() > nChance then return end;
  -- Spawn a random object from the treasure data array and return success
  return CreateObject(aDigTileData[random(#aDigTileData)], iX, iY);
end
-- Roll the dice to spawn treasure at the specified location --------------- --
local function AdjObjParentStat(oObj, sWhat)
  -- Increase objects gem find count
  oObj[sWhat] = oObj[sWhat] + 1;
  -- And of the objects owner if it has one
  local oPlr<const> = oObj.P;
  if oPlr then oPlr[sWhat] = oPlr[sWhat] + 1 end;
end
-- Set object health (properly initialised at script init) ----------------- --
local function AdjustObjectHealth()
  -- Commonly accessed aliases
  local iADeath<const>, iAPhase<const>, iJInDanger<const>, iJNone<const>,
    iDNone<const>, iFiJump<const>, iFNoSound<const>, iTFWater<const>,
    iTFIndestructible<const>, iTFDestructable<const>, iTFArtificial<const>,
    iTFProtected<const>, iTFExposedAll<const>, iTFFirmGround<const>,
    iTypLiftB<const>, iTypFloodGate<const> =
      ACT.DEATH, ACT.PHASE, JOB.INDANGER, JOB.NONE, DIR.NONE, OFL.iJUMP,
      OFL.NOSOUND, oTileFlags.W, oTileFlags.I, oTileFlags.D, oTileFlags.AD,
      oTileFlags.P, oTileFlags.EA, oTileFlags.F, TYP.LIFTB, TYP.GATEB;
  -- Actually kill object
  local function KillObject(oTarget, oObjCause)
    AdjustObjectHealth(oTarget, -100, oObjCause);
  end
  -- Kill surrounding objects
  local function KillObjects(oObjVictim, oObjCause, iX, iY, iLoc)
    -- Get absolute position
    local iAX<const>, iAY<const> = iX * 16, iY * 16;
    -- Compare against all objects
    for iObjId = 1, #aObjs do
      -- Get target object data and if not the same object?
      local oTarget<const> = aObjs[iObjId];
      if oTarget ~= oObjVictim then
        -- Get action and if target object...
        local iAction<const> = oTarget.A;
        if iAction ~= iADeath and           -- ...is not dying?
           iAction ~= iAPhase and           -- *and* not phasing?
           IsSpriteCollide(476, iAX, iAY, -- *and* in explosion?
             oTarget.S, oTarget.X + oTarget.OFX, oTarget.Y + oTarget.OFY) then
          KillObject(oTarget, oObjCause) end;
      end
    end
  end
  -- Explode directions data
  local aExplodeDirData<const> = {
    -- X -- Y -- Flags -----              -- Order is important!
    {   0,  -1, iTFWater|oTileFlags.EB }, -- [Up] Flood if above exposed
    {  -1,   0, iTFWater|oTileFlags.ER }, -- [Left] Flood if left exposed
    {   0,   0, iTFWater               }, -- [Centre] No flooding check
    {   1,   0, iTFWater|oTileFlags.EL }, -- [Right] Flood if right exposed
    {   0,   1, iTFWater|oTileFlags.ET }, -- [Down] Flood if below exposed
  };
  -- Check for flooding surrounding the specified tile location
  local function CheckSurroundingFlooding(iLoc)
    -- Test for flooding around the cleared tile
    for iFloodIndex = 1, #aExplodeDirData do
      -- Get flood test data and calculate location to test
      local aFloodTestItem<const> = aExplodeDirData[iFloodIndex];
      local iTLoc<const> =
        (iLoc + (aFloodTestItem[2] * iLLAbsW)) + aFloodTestItem[1];
      -- Get tile id and if valid
      local iId<const> = GetLevelDataFromLevelOffset(iTLoc);
      if iId then
        -- Get flags to test for and insert a new flood if found
        local iTFFlags<const> = aFloodTestItem[3];
        if aTileData[1 + iId] & iTFFlags == iTFFlags then
          aFloodData[1 + #aFloodData] = { iTLoc, iTFFlags };
        end
      end
    end
  end
  -- Lift tiles which cause cascading clear effect
  local oLiftShaftTiles<const> = {
    -- Top          Cable          Bottom
    [ 62] = 62,     [189] = 7,     [190] = 190,
    -- Top (Water)  Cable (Water)  Bottom (Water)
    [302] = 302,    [429] = 247,   [430] = 430
  };
  -- Destroy lift shaft
  local function DestroyLiftShaft(oObjCause, iLoc, iStep)
    -- Restart point
    ::lTryAgain::
    -- Get tile id and return if invalid
    local iId<const> = GetLevelDataFromLevelOffset(iLoc);
    if not iId then return end;
    -- Check to see if this is a lift tile and return if invalid
    local iToTile<const> = oLiftShaftTiles[iId];
    if not iToTile then return end;
    -- Clear the shaft tile if tile is different. We won't clear the top or
    -- foundation to prevent escaping from blocked parts of the map.
    if iId ~= iToTile then UpdateLevel(iLoc, iToTile) end;
    -- Find gate at that position
    for iObjId = 1, #aObjs do
      -- Get object and if it's a deployed lift? Get its absolute location,
      -- and it's in the same place? Kill it if it's not killed already.
      local oObjLift<const> = aObjs[iObjId];
      if oObjLift.ID == iTypLiftB and
         oObjLift.A ~= iADeath and
         GetLevelOffsetFromObject(oObjLift, 0, 0) == iLoc then
        KillObject(oObjLift, oObjCause);
      end
    end
    -- Goto next specified row
    iLoc = iLoc + iStep;
    -- Try again until we can check no more
    goto lTryAgain;
  end
  -- Explode directions data
  local oExplodeAboveData<const> = {
    [ 88] =   7, -- Remove left end of track and set clear tile
    [ 91] =   7, -- Remove right end of track and set clear tile
    [149] = 150, -- Remove track from dug tile with light
    [169] = 170, -- Remove track from dug tile with forward beam
    [210] =   7, -- Remove track from dug tile beam backwards
    [328] = 247, -- Remove watered right end of track and set to cleared water
    [331] = 247, -- Remove watered left end of track and set to cleared water
    [389] = 390, -- Remove watered light and set to watered light
    [409] = 410, -- Remove watered beam forward and set to watered beam forward
    [450] = 247, -- Remove watered clear track and set to clear
  };
  -- Start destroying terrain
  local function DestroyTerrain(oObjVictim, iX, iY, iId, iLoc)
    -- Get tile flags
    local iTFlags<const> = aTileData[1 + iId];
    -- If we can show an explosion here?
    if iTFlags & iTFIndestructible == 0 then
      -- Create an explosion object here but don't use adjhealth to explode it
      local aObj<const> = CreateObject(TYP.TNT, iX*16, iY*16, oObjVictim.P)
      aObj.F, aObj.H = aObj.F | iFNoSound, 0;
      SetAction(aObj, iADeath, iJNone, iDNone);
    end
    -- Return if tile is not destructible and been cleared?
    if iTFlags & iTFDestructable == 0 or
       iTFlags & iTFArtificial ~= 0 then return end;
    -- If get tile above flags and return if below this tile is a protected
    -- platform?
    local iAId<const> = GetLevelDataFromAbsCoordinates(iX, iY - 1);
    if iAId and aTileData[1 + iAId] & iTFProtected ~= 0 then return end;
    -- Increase dug count
    AdjObjParentStat(oObjVictim, "DUG");
    -- Roll the dice and spawn treasure and increase objects gem find
    -- count if found and not protected ground.
    if RollTheDice(iX, iY) then AdjObjParentStat(oObjVictim, "GEM") end;
    -- If this was a lift tile?
    if oLiftShaftTiles[iId] then
      -- Destroy lift shaft upwards then downwards
      DestroyLiftShaft(oObjCause, iLoc, -iLLAbsW);
      DestroyLiftShaft(oObjCause, iLoc + iLLAbsW, iLLAbsW);
    end
    -- Tile blown does not contain water?
    if iTFlags & iTFWater == 0 then
      -- Set cleared dug tile
      UpdateLevel(iLoc, 7);
      -- Check for surrounding flooding
      CheckSurroundingFlooding(iLoc);
    -- Tile is in water
    else
      -- Set cleared water tile
      UpdateLevel(iLoc, 247);
      -- Test for flood here with all edges exposed
      aFloodData[1 + #aFloodData] = { iLoc, iTFWater|iTFExposedAll };
    end
    -- Return if tile blown was not firm ground
    if iTFlags & iTFFirmGround == 0 then return end;
    -- Get tile location above and return if not valid
    local iTLoc<const> = iLoc - iLLAbsW;
    local iId<const> = GetLevelDataFromLevelOffset(iTLoc);
    if not iId then return end;
    -- Get above tile flags and if is a gate?
    local iATFlags<const> = aTileData[1 + iId];
    if iATFlags & oTileFlags.G ~= 0 then
      -- Find gate at that position
      for iObjId = 1, #aObjs do
        -- Get object and if it's a deployed gate? Get its absolute
        -- location and if it's the same? Destroy the deployed
        -- gate.
        local oObjVictim<const> = aObjs[iObjId];
        if oObjVictim.ID == iTypFloodGate and
          GetLevelOffsetFromObject(oObjVictim, 0, 0) == iTLoc then
            KillObject(oObjVictim, oObjCause) end;
      end
      -- Is watered gate? Set watered cleared tile else normal
      -- clear
      if iATFlags & iTFWater ~= 0 then
        UpdateLevel(iTLoc, 247) else UpdateLevel(iTLoc, 7) end;
      -- Check if removed gate would cause a flood
      aFloodData[1 + #aFloodData] = { iTLoc, iTFExposedAll };
    -- Not a gate?
    else
      -- Is a supported tile that we should clear
      local iToTile<const> = oExplodeAboveData[iId];
      if iToTile then UpdateLevel(iTLoc, iToTile) end;
    end
  end
  -- Process explosion logic ----------------------------------------------- --
  local function ProcessExplosion(oObjVictim, oObjCause)
    -- Enumerate possible destruct positions again. We can't have the TERRAIN
    -- destruction checks in the above enumeration because of the recursive
    -- nature of the OBJECT destruction which would cause problems.
    for iExplodeIndex = 1, #aExplodeDirData do
      -- Get destruct adjacent position data
      local aCoordAdjust<const> = aExplodeDirData[iExplodeIndex];
      -- Clamp the centre tile position of the explosion for the level
      local iX<const>, iY<const> = (oObjVictim.X + 8) // 16 + aCoordAdjust[1],
                                   (oObjVictim.Y + 8) // 16 + aCoordAdjust[2];
      -- Calculate locate of tile and if in valid bounds?
      local iId, iLoc<const> = GetLevelDataFromAbsCoordinates(iX, iY);
      if not iId then goto lContinue end;
      -- Kill objects in this vicinity
      KillObjects(oObjVictim, oObjCause, iX, iY, iId, iLoc);
      -- Check for flooding
      DestroyTerrain(oObjVictim, iX, iY, iId, iLoc);
      -- Continue point
      ::lContinue::
    end
    -- Do not play the objects death animation
    oObjVictim.AT = 0xFFFF;
  end
  -- Create a damage value ------------------------------------------------- --
  local function CreateDamageValue(iAmount, oObj, oObjCause, nR, nG, nB)
    -- Return if caused by neutral damage and not by another object
    -- or the object is in someones inventory.
    if not GetTestMode() and ((not oObjCause and oObj.P ~= oPlrActive) or
       (oObjCause and not oObjCause.P) or oObj.IP) then return end;
    -- Add to the number value display
    aDamageValues[1 + #aDamageValues] = { oObj.X + oObj.OFX + 8,
      oObj.Y + oObj.OFY - 7, iAmount, nR, nG, nB, 1.0 };
  end
  -- Actual function that gets returned when initialised for first time ---- --
  local function AdjustObjectHealth(oObjVictim, iAmount, oObjCause)
    -- Calculate new health amount and if still alive?
    local iNewHealth<const> = oObjVictim.H + iAmount;
    if iNewHealth > 0 then
      -- Clamp at a 100% if needed or update the objects new health
      if iNewHealth > 100 then
        oObjVictim.H, iAmount = 100, 100 - oObjVictim.H;
      else oObjVictim.H = iNewHealth end;
      -- Health reduction?
      if iAmount < 0 then
        -- Add a damage value above the objects head
        CreateDamageValue(iAmount, oObjVictim, oObjCause, 1.0, 1.0, 1.0);
        -- If health is in danger? Indicator for in danger and not dead
        if iNewHealth <= 10 then return 1 end;
      -- Health increment?
      elseif iAmount > 0 then
        -- Add a damage value above the objects head
        CreateDamageValue(iAmount, oObjVictim, oObjCause, 1.0, 1.0, 0.25);
      end
      -- At a safe health still
      return 0;
    end
    -- Write killing value above objects head
    CreateDamageValue(iAmount, oObjVictim, oObjCause, 1.0, 0.0, 1.0);
    -- Object is dead so clamp health to zero or update the objects new health
    if iNewHealth < 0 then oObjVictim.H = 0 else oObjVictim.H = iNewHealth end;
    -- Kill object (Don't move this, for explosion stuff to work)
    SetAction(oObjVictim, iADeath, iJInDanger, iDNone);
    -- Remove jump and falling status from object
    local iFlags<const> = oObjVictim.F & iFiJump;
    oObjVictim.F = iFlags;
    -- Get victim name
    local sVictim<const> = oObjVictim.OD.NAME..
      "["..oObjVictim.U.."] at X:"..oObjVictim.X.." Y:"..oObjVictim.Y;
    -- If caused by another object?
    if oObjCause then
      -- Get causer name
      local sCauser<const> = oObjCause.OD.NAME..
         "["..oObjCause.U.."] at X:"..oObjCause.X.." Y:"..oObjCause.Y;
      -- Was victim a living thing?
      if iFlags & OFL.LIVING ~= 0 then
        -- increase their living kills count and log the kill
        CoreLog(sCauser.." killed "..sVictim.."!");
        AdjObjParentStat(oObjCause, "LK");
      -- Was victim an enemy?
      elseif iFlags & OFL.ENEMY ~= 0 then
        -- Increase their enemy kills count and log the kill
        CoreLog(sCauser.." destroyed enemy "..sVictim.."!");
        AdjObjParentStat(oObjCause, "EK");
      -- Anything else? Log the destruction
      else CoreLog(sCauser.." destroyed "..sVictim.."!") end;
    -- No killer and is living
    elseif iFlags & OFL.LIVING ~= 0 then CoreLog(sVictim.." died!");
    -- No killer? Log the destruction
    else CoreLog(sVictim.." was destroyed!") end;
    -- Object explodes on death? Cause an explosion!
    if oObjVictim.F & OFL.EXPLODE ~= 0 then
      ProcessExplosion(oObjVictim, oObjCause) end;
    -- Make victim drop all objects
    while oObjVictim.IS do DropObject(oObjVictim, oObjVictim.IS) end;
    -- Disable menu if object is selected and menu open
    if oObjActive == oObjVictim and aContextMenu then SetContextMenu() end;
    -- Object died
    return -1;
  end
  -- Return actual function
  return AdjustObjectHealth;
end
-- Render all screen elements ---------------------------------------------- --
local function RenderAll()
  -- Commonly accessed aliases --------------------------------------------- --
  local iAStop<const>, iFBusy<const>, iFJump<const>, iJInDanger<const> =
    ACT.STOP, OFL.BUSY, OFL.JUMP, JOB.INDANGER;
  -- Locals ---------------------------------------------------------------- --
  local aInfoScreenActiveItem;         -- Active screen item
  local fcbInfoScreen;                 -- Current info screen callback
  -- Draw specific digger inventory information ---------------------------- --
  local function DrawDiggerInventoryInformation(iDiggerId)
    -- Calculate Y position
    local nY<const> = iDiggerId * 33.0;
    -- Print id number of digger
    Print(fontLarge, 16.0, nY + 8.0, iDiggerId);
    -- Draw health bar background
    BlitSLTWH(texSpr, 1023, 24.0, nY + 31.0, 267.0, 2.0);
    -- Get Digger data and if it exists?
    local oDigger<const> = oPlrActive.D[iDiggerId];
    if oDigger then
      -- Draw digger health bar
      DrawHealthBar(oDigger.H, 0.375, 24.0, nY + 31.0, 2.0);
      -- Draw digger portrait
      BlitSLT(texSpr, oDigger.S, 31.0, nY + 8.0);
      -- Digger has items?
      if oDigger.IW > 0 then
        -- Get digger inventory and enumerate through it and draw it
        local aObjInvList<const> = oDigger.I;
        for iInvIndex = 1, #aObjInvList do
          BlitSLT(texSpr, aObjInvList[iInvIndex].S,
            iInvIndex * 16.0 + 32.0, nY + 8.0) end;
      -- No inventory. Print no inventory message
      else Print(fontTiny, 48.0, nY + 13.0, "NOT CARRYING ANYTHING") end;
      -- Draw weight and impatience
      PrintR(fontLittle, 308.0, nY + 4.0,
        format("%03u%%          %03u%%\n\z
                %03u%%         %05u\n\z
                %04u          %03u%%",
          oDigger.H, floor(oDigger.IW / oDigger.STR * 100.0),
          max(0, floor(oDigger.JT / oDigger.PL * 100.0)), oDigger.DUG,
          oDigger.GEM, ceil(oDigger.LDT / iGameTicks * 100.0)));
    -- Digger is dead
    else
      -- Draw grave icon
      BlitSLT(texSpr, 319, 31.0, nY + 8.0);
      -- Draw dead labels
      PrintR(fontLittle, 308.0, nY + 4.0,
        "---%          ---%\n\z
         ---%         -----\n\z
         ----          ---%");
    end
    -- Draw labels
    fontTiny:SetLSpacing(2.0);
    PrintR(fontTiny, 308.0, nY + 5.0,
      "HEALTH:             WEIGHT:        \n\z
       IMPATIENCE:         GROADS DUG:        \n\z
       GEMS FOUND:         EFFICIENCY:        ");
  end
  -- Render an information frame ------------------------------------------- --
  local function DrawInfoFrameAndTitle(iTileId)
    -- Draw the left part of the title bar
    BlitSLT(texSpr, 847, 8.0, 8.0);
    -- Draw the middle part of the title bar
    for nX = 24.0, 280.0, 16.0 do BlitSLT(texSpr, 848, nX, 8.0) end;
    -- Draw the right part of the title bar
    BlitSLT(texSpr, 849, 296.0, 8.0);
    -- Draw transparent backdrop
    RenderFade(0.75, 8.0, 32.0, 312.0, 208.0);
    -- Draw frame around transparent backdrop
    BlitSLT(texSpr, 850, 8.0, 32.0);
    for nX = 24.0, 280.0, 16.0 do BlitSLT(texSpr, 851, nX, 32.0) end;
    BlitSLT(texSpr, 852, 296.0, 32.0);
    for nY = 48.0, 176.0, 16.0 do
      BlitSLT(texSpr, 856, 8.0, nY);
      BlitSLT(texSpr, 858, 296.0, nY);
    end
    BlitSLT(texSpr, 853, 8.0, 192.0);
    for nX = 24.0, 280.0, 16.0 do BlitSLT(texSpr, 854, nX, 192.0) end;
    BlitSLT(texSpr, 855, 296.0, 192.0);
    -- Draw shadows
    RenderShadow(8.0, 8.0, 312.0, 24.0);
    RenderShadow(8.0, 32.0, 312.0, 208.0);
    -- Print the title bar text
    PrintC(fontLittle, 160.0, 12.0, iTileId);
  end
  -- Draw digger inventory ------------------------------------------------- --
  local function InfoScreenRenderInventory()
    -- Draw frame and title
    DrawInfoFrameAndTitle("DIGGER INVENTORY");
    -- Set tiny font colour and spacing
    fontTiny:SetCRGB(0.0, 0.75, 1.0);
    fontTiny:SetLSpacing(2.0);
    -- For each digger
    for iDiggerId = 1, #oPlrActive.D do
      DrawDiggerInventoryInformation(iDiggerId) end;
    -- Reset tiny font spacing
    fontTiny:SetLSpacing(0.0);
  end
  -- Draw specific digger information -------------------------------------- --
  local function DrawDiggerLocationInformation(iDiggerId)
    -- Calculate Y position
    local nY<const> = iDiggerId * 31.0;
    -- Print id number of digger
    Print(fontLarge, 16.0, nY + 8.0, iDiggerId);
    -- Draw colour key of digger
    BlitSLT(texSpr, 858 + iDiggerId, 31.0, nY + 11.0);
    -- Draw X and Y letters
    fontTiny:SetCRGB(0.0, 0.75, 1.0);
    Print(fontTiny, 64.0, nY + 8.0, "X:       Y:");
    -- Draw health bar background
    BlitSLTWH(texSpr, 1023, 24.0, nY + 30, 100.0, 2.0);
    -- Get digger and if it exists?
    local oDigger<const> = oPlrActive.D[iDiggerId];
    if oDigger then
      -- Draw digger health bar
      DrawHealthBar(oDigger.H, 1.0, 24.0, nY + 30.0, 2.0);
      -- Draw digger item data
      Print(fontLittle, 72.0, nY + 8.0,
        format("%04u  %04u\n\\%03u  \\%03u",
          oDigger.X, oDigger.Y, oDigger.AX, oDigger.AY));
      -- Draw digger portrait
      BlitSLT(texSpr, oDigger.S, 43.0, nY + 8.0);
      -- Draw position of digger
      BlitSLT(texSpr, 858 + iDiggerId, 141.0 + (oDigger.AX * 1.25),
        38.0 + (oDigger.AY * 1.25));
      -- Done
      return;
    -- Digger is dead
    end
    -- Draw grave icon
    BlitSLT(texSpr, 319, 43.0, nY + 8.0);
    -- Draw dashes for unavailable digger item data
    Print(fontLittle, 72.0, nY + 8.0, "----  ----\n\\---  \\---");
  end
  -- Draw digger locations ------------------------------------------------- --
  local function InfoScreenRenderLocations()
    -- Draw frame and title
    DrawInfoFrameAndTitle("DIGGER LOCATIONS");
    -- Draw map grid of level
    for nY = 37.0, 188.0, 15.0 do
      for nX = 141.0, 291.0, 15.0 do BlitSLT(texSpr, 864, nX, nY) end;
    end
    -- For each digger
    for iDiggerId = 1, #oPlrActive.D do
      DrawDiggerLocationInformation(iDiggerId) end;
  end
  -- Draw digger locations ------------------------------------------------- --
  local function InfoScreenRenderStatus()
    -- Draw frame and title
    DrawInfoFrameAndTitle("ZONE STATUS");
    -- Score for who is winning
    local iScoreAP, iScoreOP = 0, 0;
    -- Draw little labels first for rendering performance. Print level info
    Print(fontLittle, 16.0, 56.0, sLvlType.." TERRAIN");
    PrintR(fontLittle, 304.0, 56.0, "OPERATIONS TIME");
    local iPDiggers<const> = oPlrActive.DC;
    PrintC(fontLittle, 160.0, 88.0, "YOU HAVE "..iPDiggers.." OF "..
      #oPlrActive.D.." DIGGERS REMAINING");
    -- Draw who has the most diggers
    local iODiggers<const>, sDiggers = oPlrOpponent.DC;
    if iPDiggers > iODiggers then
      iScoreAP, sDiggers = iScoreAP + 1,
        "YOU HAVE MORE DIGGERS THEN YOUR OPPONENT";
    elseif iPDiggers < iODiggers then
      iScoreOP, sDiggers = iScoreOP + 1, "YOUR OPPONENT HAS MORE DIGGERS";
    else sDiggers = "YOU AND YOUR OPPONENT HAVE EQUAL DIGGERS" end;
    PrintC(fontLittle, 160.0, 96.0, sDiggers);
    -- Show who has mined the most terrain
    local iPDug, iODug<const> = oPlrActive.DUG, oPlrOpponent.DUG;
    PrintC(fontLittle, 160.0, 112.0, "YOU MINED "..
      UtilFormatNumber(oPlrActive.GEM, 0)..
      " GEMS AND "..UtilFormatNumber(iPDug, 0).." GROADS OF TERRAIN");
    local sMined;
    if iPDug > iODug then sMined = "YOU HAVE MINED THE MOST TERRAIN";
    elseif iPDug < iODug then
      sMined = "YOUR OPPONENT HAS MINED THE MOST TERRAIN";
    else sMined = "YOU AND YOUR OPPONENT HAVE MINED EQUAL TERRAIN" end;
    PrintC(fontLittle, 160.0, 120.0, sMined);
    -- Draw who has found the most gems
    local iPGems<const>, iOGems<const>, sGems =
      oPlrActive.GEM, oPlrOpponent.GEM;
    if iPGems > iOGems then sGems = "YOU HAVE FOUND THE MOST GEMS";
    elseif iPGems < iOGems then
      sGems = "YOUR OPPONENT HAS FOUND THE MOST GEMS";
    else sGems = "YOU AND YOUR OPPONENT HAVE FOUND EQUAL GEMS" end;
    PrintC(fontLittle, 160.0, 128.0, sGems);
    -- Draw who has the most zogs
    PrintC(fontLittle, 160.0, 146.0, "YOU HAVE RAISED "..
      UtilFormatNumber(iPlayerMoney, 0)..
      " OF "..iWinLimit.." ZOGS ("..
      UtilFormatNumber(iPlayerMoney / iWinLimit * 100, 0).."%)");
    local iPlayerMoney<const>, iOpponentMoney<const> =
      oPlrActive.M, oPlrOpponent.M;
    local sZogs;
    if iPlayerMoney > iOpponentMoney then
      iScoreAP, sZogs = iScoreAP + 1, "YOU HAVE THE MOST ZOGS";
    elseif iPlayerMoney < iOpponentMoney then
      iScoreOP, sZogs = iScoreOP + 1, "YOUR OPPONENT HAS MORE ZOGS";
    else sZogs = "YOU AND YOUR OPPONENT HAVE EQUAL ZOGS" end;
    PrintC(fontLittle, 160.0, 154.0, sZogs);
    PrintC(fontLittle, 160.0, 162.0, "RAISE "..
      UtilFormatNumber(iWinLimit-iPlayerMoney, 0).." MORE ZOGS TO WIN");
    -- Draw prediction
    local sPName<const>, sOName<const>, sWinning =
      oPlrActive.RD.NAME, oPlrOpponent.RD.NAME;
    if iScoreAP > iScoreOP then sWinning = sPName;
    elseif iScoreAP < iScoreOP then sWinning = sOName;
    else sWinning = "NOBODY" end;
    PrintC(fontLittle, 160.0, 178.0, "THE TRADE CENTRE HAS PREDICTED");
    -- Draw large labels now
    Print(fontLarge, 16.0, 40.0, sLvlName);
    PrintR(fontLarge, 304.0, 40.0, format("%02u:%02u:%02u",
      iGameTicks // 216000 % 24,
      iGameTicks // 3600 % 60,
      iGameTicks // 60 % 60));
    PrintC(fontLarge, 160.0, 72.0, sPName.." VS "..sOName);
    PrintC(fontLarge, 160.0, 186.0, sWinning.." IS WINNING");
  end
  -- Inventory button pressed?
  local aInfoScreenData<const> = {
    { 248.0, 216.0, 815, 816, InfoScreenRenderInventory },
    { 264.0, 216.0, 817, 818, InfoScreenRenderLocations },
    { 280.0, 216.0, 802, 803, InfoScreenRenderStatus },
    { 296.0, 216.0, 819, 820, BlankFunction }
  };
  -- Button disabled function ---------------------------------------------- --
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
        fontTiny:SetCRGB(1.0, 1.0, 1.0);
        fontLarge:SetCRGB(1.0, 1.0, 1.0);
        fontLittle:SetCRGB(1.0, 1.0, 1.0);
        -- Execute render function
        aInfoScreenItem[5]();
      -- Inactive so draw disabled button
      else BlitSLT(texSpr, aInfoScreenItem[3],
        aInfoScreenItem[1], aInfoScreenItem[2]) end;
    end
  end
  -- Button disabled function ---------------------------------------------- --
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
  -- Select info screen shared function ------------------------------------ --
  local function SelectInfoScreen(iScreen)
    -- Reset?
    if iScreen == nil then
      -- Disable it
      aInfoScreenActiveItem = nil;
      fcbInfoScreen = InfoScreenDisabled;
      -- Done
      return;
    end
    -- Check parameter
    if not UtilIsInteger(iScreen) or
           iScreen < 1 or
           iScreen > #aInfoScreenData then
      error("Invalid screen! "..tostring(iScreen)) end
    -- Play sound effect to show the player clicked it
    PlayInterfaceSound(oSfxData.CLICK);
    -- Get the screen info data and if we're already showing it?
    local aInfoScreenItem<const> = aInfoScreenData[iScreen];
    if aInfoScreenActiveItem == aInfoScreenItem then
      -- Disable it
      aInfoScreenActiveItem = nil;
      fcbInfoScreen = InfoScreenDisabled;
    -- We're not showing this one
    else
      -- Enable it
      aInfoScreenActiveItem = aInfoScreenItem;
      fcbInfoScreen = InfoScreenEnabled;
    end
  end
  -- Set disabled info screen callback ------------------------------------- --
  fcbInfoScreen = InfoScreenDisabled;
  -- Render terrain -------------------------------------------------------- --
  local function RenderTerrain()
    -- Render the backdrop
    BlitSLT(texLev, iTileBg,
      -iLLAbsW + ((iLLAbsW - iAbsPosX) / iLLAbsW * 64),
      -32 + ((iLLAbsH - iAbsPosY) / iLLAbsH * 32));
    -- Calculate the X pixel position to draw at
    local iXdraw<const> = iStageL + iPixCenPosX;
    -- For each screen row to draw tile at
    for iY = 0, iTilesHeight do
      -- Calculate the Y position to grab from the level data
      local iYdest<const> = 1 + (iAbsPosY + iY) * iLLAbsW;
      -- Calculate the Y pixel position to draw at
      local iYdraw<const> = iStageT + iPixCenPosY + (iY * 16);
      -- For each screen column to draw tile at, draw the tile from level data
      for iX = 0, iTilesWidth do
        BlitSLT(texLev, aLvlData[iYdest + iAbsPosX + iX],
          iXdraw + (iX * 16), iYdraw) end;
    end
  end
  -- Render all objects ---------------------------------------------------- --
  local function RenderObjects()
    -- For each object
    for iObjId = 1, #aObjs do
      -- Get object data
      local oObj<const> = aObjs[iObjId];
      -- Goto next object if object isn't in the viewport
      local iXX<const>, iYY<const> = oObj.X - iViewportX + oObj.OFX,
                                     oObj.Y - iViewportY + oObj.OFY;
      if min(iXX + 16, iStageR) <= max(iXX, iStageL) or
         min(iYY + 16, iStageB) <= max(iYY, iStageT) then goto lContinue end;
      -- Draw the object
      BlitSLT(texSpr, oObj.S, iXX, iYY);
      -- Goto next object if no attachment
      if not oObj.STA then goto lContinue end;
      -- Draw the attachment
      BlitSLT(texSpr, oObj.SA, iXX + oObj.OFXA, iYY + oObj.OFYA);
      -- Continue point
      ::lContinue::
    end
  end
  -- Render shroud data ---------------------------------------------------- --
  local function RenderShroud()
    -- Calculate the X pixel position to draw at
    local iXdraw<const> = iStageL + iPixCenPosX;
    -- Set shroud colour
    texSpr:SetCRGBAI(iShroudColour);
    -- For each screen row to draw tile at
    for iY = 0, iTilesHeight do
      -- Calculate the Y position to grab from the level data
      local iYdest<const> = 1 + (iAbsPosY + iY) * iLLAbsW;
      -- Calculate the Y pixel position to draw at
      local iYdraw<const> = iStageT + iPixCenPosY + (iY * 16);
      -- For each screen column to draw tile at
      for iX = 0, iTilesWidth do
        -- Get shroud information at specified tile and draw it if theres data
        local aItem<const> = aShroudData[iYdest + iAbsPosX + iX];
        if aItem[2] < 0xF then
          BlitSLT(texSpr, aItem[1], iXdraw + (iX * 16), iYdraw) end;
      end
    end
    -- Restore normal sprite colour
    texSpr:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  end
  -- Render control context menu ------------------------------------------- --
  local function RenderContextMenu()
    -- Get object busy flag
    local bBusy<const> = oObjActive.F & iFBusy ~= 0;
    -- Walk through it and test position
    for iMIndex = 1, #aContextMenuData do
      -- Get context menu item and draw it
      local aMItem<const> = aContextMenuData[iMIndex];
      BlitSLTRB(texSpr, aMItem[2], aMItem[4], aMItem[5], aMItem[6],
        aMItem[7]);
      -- Goto next button if button is disabled
      if not aMItem[3] or not bBusy then goto lContinue end;
      -- Render a dim over object
      texSpr:SetCRGBA(1.0, 0.0, 0.0, 0.5);
      BlitSLTRB(texSpr, 1022, aMItem[4], aMItem[5], aMItem[6], aMItem[7]);
      texSpr:SetCRGBA(1.0, 1.0, 1.0, 1.0);
      -- Continue point
      ::lContinue::
    end
    -- Draw context menu shadow
    RenderShadow(iMenuLeft, iMenuTop, iMenuRight, iMenuBottom);
    -- If inventory selected and drop menu open?
    local aObjInvList<const> = oObjActive.IS;
    if not aObjInvList or aContextMenu ~= oMenuData[MNU.DROP] then return end;
    -- Draw active inventory item and health
    BlitSLT(texSpr, aObjInvList.S, iMenuLeft + 23, iMenuTop + 4);
    fontTiny:SetCRGB(1.0, 1.0, 1.0);
    PrintR(fontTiny, iMenuRight - 2, iMenuTop + 24, aObjInvList.H.."%");
  end
  -- Animate money value --------------------------------------------------- --
  local iAnimMoney, sMoney = 0, ""; -- Animated and formatted money value
  local function AnimateMoney()
    -- Animated money is different from current actual money
    if iAnimMoney ~= iPlayerMoney then
      -- Animated money over actual money?
      if iAnimMoney > iPlayerMoney then
        -- Decrement it
        iAnimMoney = iAnimMoney - ceil((iAnimMoney - iPlayerMoney) * 0.1);
        -- Update displayed money
        sMoney = min(9999, iAnimMoney);
        -- Red colour, draw money and reset colour
        fontLittle:SetCRGB(1.0, 0.75, 0.75);
        PrintR(fontLittle, 41, 220, sMoney);
        fontLittle:SetCRGB(1.0, 1.0, 1.0);
        -- Done
        return;
      end
      -- Animated money under actual money? Increment
      if iAnimMoney < iPlayerMoney then
        -- Increment it
        iAnimMoney = iAnimMoney + ceil((iPlayerMoney - iAnimMoney) * 0.1);
        -- Update displayed money
        sMoney = min(9999, iAnimMoney);
        -- Green colour, draw money and reset colour
        fontLittle:SetCRGB(0.75, 1.0, 0.75);
        PrintR(fontLittle, 41, 220, sMoney);
        fontLittle:SetCRGB(1.0, 1.0, 1.0);
        -- Done
        return;
      end
      -- Reset colour and draw money
      fontLittle:SetCRGB(1.0, 1.0, 1.0);
      PrintR(fontLittle, 41, 220, sMoney);
      -- Done
      return;
    end
    -- Animated money/actual money is synced, display blue if > 9999
    if iPlayerMoney > 9999 then
      -- Set other colour and draw money
      fontLittle:SetCRGB(0.75, 0.75, 1.0);
      PrintR(fontLittle, 41, 220, sMoney);
      -- Done
      return;
    end
    -- Reset colour and draw money
    fontLittle:SetCRGB(1.0, 1.0, 1.0);
    PrintR(fontLittle, 41, 220, sMoney);
  end
  -- Render damage values -------------------------------------------------- --
  local function RenderDamageValues()
    -- Can't use 'for do' because we delete them
    local iIndex = 1 repeat
      -- Get next damage value
      local aDamageValue<const> = aDamageValues[iIndex];
      -- Calculate position relative to the viewport
      local iXX<const>, iYY<const> =
        aDamageValue[1] - iViewportX, aDamageValue[2] - iViewportY;
      -- If the damage value is in view?
      if min(iXX + 16, iStageR) <= max(iXX, iStageL) or
         min(iYY + 16, iStageB) <= max(iYY, iStageT) then goto lNoRender end;
      -- Set colour of it
      fontTiny:SetCRGBA(aDamageValue[4], aDamageValue[5],
        aDamageValue[6], aDamageValue[7]);
      -- Draw the text
      PrintC(fontTiny, iXX, iYY, aDamageValue[3]);
      -- Continue point because the damage value is not in the view port
      ::lNoRender::
      -- Reduce Y gradually
      if iGameTicks % 4 == 0 then aDamageValue[2] = aDamageValue[2] - 1 end;
      -- Reduce alpha gradually and delete it if hidden else setup next id
      aDamageValue[7] = aDamageValue[7] - 0.02;
      if aDamageValue[7] <= 0.0 then remove(aDamageValues, iIndex);
      else iIndex = iIndex + 1 end;
    -- Until we've processed all the values this frame
    until iIndex > #aDamageValues;
    -- Restore alpha on tiny font
    fontTiny:SetCA(1.0);
  end
  -- Draw status area ------------------------------------------------------ --
  local function DrawStatusArea()
    -- Draw bottom left part, money and health backgrounds
    for iColumn = 0, 6 do
      BlitSLT(texSpr, 821 + iColumn, 8 + (iColumn * 16), 216) end;
  end
  -- Draw flags to say who is winning -------------------------------------- --
  local function DrawFlags()
    -- Set tile id based on diggers count
    local iATile, iOTile = 868 + oPlrOpponent.DC, 874 + oPlrActive.DC;
    -- Get monies and increase flag depending on who has more money
    if iPlayerMoney > iOpponentMoney then iOTile = iOTile + 1;
    elseif iPlayerMoney < iOpponentMoney then iATile = iATile + 1 end;
    -- Draw flags for both sides
    BlitSLT(texSpr, iATile, 120, 216);
    BlitSLT(texSpr, iOTile, 120, 216);
  end
  -- Digger activity indicator --------------------------------------------- --
  local oActionsP1<const>, oJobsP2<const>, oActionsP3<const> = {
    [ACT.STOP] = 834, [ACT.FIGHT] = 840, [ACT.PHASE] = 841, [ACT.HIDE] = 838
  }, {
    [JOB.HOME] = 838, [JOB.SEARCH] = 839
  }, {
    [ACT.WALK] = 835, [ACT.RUN] = 835, [ACT.DIG] = 837
  };
  -- Render Interface ------------------------------------------------------ --
  local function RenderInterface()
    -- Render damage values
    if #aDamageValues > 0 then RenderDamageValues() end;
    -- Get player and opponent money
    iPlayerMoney, iOpponentMoney = oPlrActive.M, oPlrOpponent.M;
    -- Render shadows around ui parts and buttons
    RenderShadow(8.0, 216.0, 136.0, 232.0);
    RenderShadow(144.0, 216.0, 224.0, 232.0);
    RenderShadow(232.0, 216.0, 312.0, 232.0);
    -- Making sure all the hud elements are drawn in order while not having to
    -- do the same checks on objects more than once is tricky, so be careful
    -- when modifying this routine. Is an object selected?
    if oObjActive then
      -- Which indicator to draw?
      local oPlayer<const>, iStatusId, iTile = oObjActive.P;
      -- Is my object?
      if oPlayer == oPlrActive then
        -- If object is busy? Draw 'Zz' indicator above object to indicate
        -- control is temporarily disabled
        if oObjActive.F & iFBusy ~= 0 then iStatusId = 984;
        -- 'v' is default, free to control this object
        else iStatusId = 988 end;
        -- Object is jumping?
        if oObjActive.F & iFJump ~= 0 then iTile = 836;
        -- Not jumping? Look up activity instead
        else iTile = oActionsP1[oObjActive.A] or
                     oJobsP2[oObjActive.J] or
                     oActionsP3[oObjActive.A] end;
      -- Opponent player so draw flags and set 'X' indicator
      elseif oPlayer == oPlrOpponent then iStatusId = 976;
      -- Neutral player so draw flags and set 'O' indicator
      else iStatusId = 980 end;
      -- Draw the indicator
      BlitSLT(texSpr, iGameTicks // 5 % 4 + iStatusId,
        iStageL + iPixCenPosX + oObjActive.X - iAbsPosX * 16,
        iStageT + iPixCenPosY + oObjActive.Y - iAbsPosY * 16 - 16);
      -- Draw status area
      DrawStatusArea();
      -- If my player (the only duplicated check we can't do anything about)
      if oPlayer == oPlrActive then
        -- Get animated health
        local iAnimatedHealth<const> = oObjActive.HA;
        -- Get health and if object has health?
        local iHealth<const> = oObjActive.H;
        if iHealth > 0 then
          -- Is a digger?
          if oObjActive.DI then
            -- Draw a pulsating heart
            BlitSLT(texSpr, 797 +
              (iGameTicks // (1 + (iHealth // 5))) % 4, 47.0, 216.0);
            -- Digger has inventory?
            if oObjActive.IW > 0 then
              -- X position of object on UI and tile ID
              local nX = 0;
              -- For each inventory
              local aObjInv<const> = oObjActive.I;
              for iObjIndex = 1, #aObjInv do
                -- Get object
                local oObj<const> = aObjInv[iObjIndex];
                -- Get inventory conversion id and if we got it then draw it
                local iObjConvId<const> = oObj.OD.HUDSPRITE;
                if iObjConvId then
                  BlitSLT(texSpr, iObjConvId, 61.0 + nX, 218.0);
                -- Draw as resized sprite
                else BlitSLTWH(texSpr, oObj.S, 61.0 + nX, 218.0, 8.0, 8.0) end;
                -- Increase X position
                nX = nX + 8.0;
              end
            end
          end
          -- Animated health is higher than digger health?
          if iHealth < iAnimatedHealth then
            -- Draw animated health bar
            texSpr:SetCRGBA(0.0, 0.0, 0.0, 1.0);
            BlitSLTWH(texSpr, 1022, 61.0, 227.0, iAnimatedHealth / 2, 2.0);
            texSpr:SetCRGB(1.0, 1.0, 1.0);
            -- Decrease animated health
            oObjActive.HA = iAnimatedHealth - 1;
          -- Set animated health and don't draw otherwise
          elseif iAnimatedHealth < iHealth then oObjActive.HA = iHealth end;
          -- Draw health bar
          DrawHealthBar(iHealth, 2.0, 61.0, 227.0, 2.0);
        -- Else if health under animated health
        elseif iAnimatedHealth > 0 then
          -- Draw animated health bar
          texSpr:SetCRGBA(0.0, 0.0, 0.0, 1.0);
          BlitSLTWH(texSpr, 1022, 61.0, 227.0, iAnimatedHealth / 2, 2.0);
          texSpr:SetCRGB(1.0, 1.0, 1.0);
          -- Decrease animated health
          oObjActive.HA = iAnimatedHealth - 1;
        end
      end
      -- Tile was Set? Draw flags instead else draw flags
      if iTile then BlitSLT(texSpr, iTile, 120.0, 216.0) else DrawFlags() end;
    -- No object selected so draw status area and flags
    else DrawStatusArea() DrawFlags() end;
    -- Draw digger buttons and activity
    for iDiggerId = 1, 5 do
      -- Pre-calculate Y position
      local nY<const> = 16.0 * iDiggerId;
      -- Get digger data and if Digger is alive?
      local oDigger<const> = oPlrActive.D[iDiggerId];
      if oDigger then
         -- Digger is selected?
        if oDigger == oObjActive then
          -- Show lightened up button
          BlitSLT(texSpr, 808 + iDiggerId, 128.0 + nY, 216.0)
        -- Show dimmed button
        else BlitSLT(texSpr, 803 + iDiggerId, 128.0 + nY, 216.0) end;
        -- Status tile to draw
        local iStatusTile;
        -- Digger is in danger?
        if oDigger.J == iJInDanger then
          -- Every even second set a different blue indicator.
          if iGameTicks % 120 < 60 then iStatusTile = 831;
                                   else iStatusTile = 832 end;
        -- Digger is in impatient and every even second?
        elseif oDigger.JT >= oDigger.PW and
               iGameTicks % 120 < 60 then iStatusTile = 833;
        -- Not in danger but busy?
        elseif oDigger.F & iFBusy ~= 0 then iStatusTile = 830;
        -- Not in danger, not busy but doing something?
        elseif oDigger.A ~= iAStop then iStatusTile = 829;
        -- Not in danger, not busy and not doing something
        else iStatusTile = 828 end;
        -- Show activity indicator (78-84)
        BlitSLT(texSpr, iStatusTile, 128.0 + nY, 204.0);
      -- Digger is not alive! Show dimmed button
      else BlitSLT(texSpr, 803 + iDiggerId, 128.0 + nY, 216.0) end;
    end
    -- Animate main player money
    AnimateMoney();
    -- Draw device select utility button
    BlitSLT(texSpr, 814, 232.0, 216);
    -- Draw info screen
    fcbInfoScreen();
    -- Render context menu if selected
    if aContextMenuData then RenderContextMenu() end;
    -- Render tooltip
    RenderTip();
  end
  -- Actual function
  local function RenderAll()
    -- Render all terrain
    RenderTerrain();
    -- Render all game objects
    RenderObjects();
    -- Render shroud overlay
    RenderShroud();
    -- Render user interface
    RenderInterface();
  end
  -- Return shared functions
  return RenderAll, RenderTerrain, RenderObjects, RenderShroud,
    RenderInterface, SelectInfoScreen;
end
-- Object collides with an object which acts as terrain -------------------- --
local function IsCollidePlatform(oObjSrc, iX, iY)
  -- Get source mask id (different if blocking)
  local iSrcMask<const> = oObjSrc.M;
  -- For each object...
  for iObjId = 1, #aObjs do
    -- Get target object to test with
    local oObjDst<const> = aObjs[iObjId];
    -- If the target object set to block? If object isn't the target object?
    -- and the specified object collides with the target object? then yes!
    if oObjDst.F & OFL.BLOCK ~= 0 and oObjSrc ~= oObjDst and
      maskSpr:IsCollideEx(474, oObjDst.X, oObjDst.Y,
      maskSpr, iSrcMask, oObjSrc.X + iX, oObjSrc.Y + iY)
        then return true end;
  end
  -- No collision with any other object
  return false;
end
-- Object collides with background horizontally? --------------------------- --
local function IsCollideX(oObj, nX)
  return maskZone:IsCollide(maskSpr, 478, oObj.X + nX, oObj.Y) or
    IsCollidePlatform(oObj, nX, 0) end;
-- Object collides with background vertically? ----------------------------- --
local function IsCollideY(oObj, nY)
  return maskZone:IsCollide(maskSpr, 478, oObj.X, oObj.Y + nY) or
    IsCollidePlatform(oObj, 0, nY) end;
-- Object collides with background horizontally or vertically? ------------- --
local function IsCollide(oObj, nX, nY)
  return maskZone:IsCollide(maskSpr, 478, oObj.X + nX, oObj.Y + nY) or
    IsCollidePlatform(oObj, nX, nY) end;
-- Object colliding with another object ------------------------------------ --
local function IsObjectCollide(oObj, oTarget)
  return maskSpr:IsCollideEx(oObj.S, oObj.X, oObj.Y, maskSpr, oTarget.S,
    oTarget.X, oTarget.Y) end;
-- Adjust object position -------------------------------------------------- --
local function AdjustPosX(oObj, nX)
  -- Move object and other objects horizontally
  SetPositionX(oObj, oObj.X + nX);
  MoveOtherObjects(oObj, nX, 0);
end
-- Adjust object position vertically --------------------------------------- --
local function AdjustPosY(oObj, nY)
  -- Move object and other objects vertically
  SetPositionY(oObj, oObj.Y + nY);
  MoveOtherObjects(oObj, 0, nY);
end
-- Adjust object position horizontally or vertically ----------------------- --
local function AdjustPos(oObj, nX, nY)
  -- Move object and other objects horizontally or vertically
  SetPosition(oObj, oObj.X + nX, oObj.Y + nY);
  MoveOtherObjects(oObj, nX, nY);
end
-- Move object vertically -------------------------------------------------- --
local function MoveY(oObj, iY)
  -- Object can't move vertically? Stop the object
  if IsCollideY(oObj, iY) then SetAction(oObj, ACT.STOP, JOB.KEEP, DIR.KEEP);
  -- Object can move in requested direction
  else AdjustPosY(oObj, iY) end;
end
-- Move object horizontally ------------------------------------------------ --
local function MoveX(oObj, iX)
  -- if object is jumping or floating?
  if oObj.F & OFL.JUMPFLOAT ~= 0 then
    -- Object can move to next horizontal pixel? Move horizontally!
    if not IsCollideX(oObj, iX) then AdjustPosX(oObj, iX) end;
    -- Done
    return;
  end
  -- Ignore if falling
  if oObj.FD < 0 then return end;
  -- Try walking down a slope
  if not IsCollide(oObj, iX, 2) and
         IsCollide(oObj, iX, 3) then AdjustPos(oObj, iX, 2) return end;
  if not IsCollide(oObj, iX, 1) and
         IsCollide(oObj, iX, 2) then AdjustPos(oObj, iX, 1) return end;
  -- Try just walking
  if not IsCollideX(oObj, iX) then AdjustPosX(oObj, iX) return end;
  -- Try walking up a slope
  if not IsCollide(oObj, iX, -1) then AdjustPos(oObj, iX, -1) return end;
  if not IsCollide(oObj, iX, -2) then AdjustPos(oObj, iX, -2) return end;
  -- Get action to perform when object blocked
  local aBlockData<const> = aDigBlockData[oObj.J];
  -- Set action requested if we can
  SetAction(oObj, aBlockData[1], aBlockData[2], aBlockData[3]);
end
-- Check for colliding objects and move them ------------------------------- --
local function InitMoveOtherObjects()
  -- Common variables
  local iFBlock<const>, iFDevice<const> = OFL.BLOCK, OFL.DEVICE;
  -- Objects can't be moved if they are set to any of these actions
  local aIgnoredActions<const> = {
    [ACT.DEATH] = true, [ACT.HIDE] = true, [ACT.PHASE] = true,
  };
  -- Actual function
  local function MoveOtherObjects(oObj, iX, iY)
    -- If i'm not a platform then nothing to do here
    if oObj.F & iFBlock == 0 then return end;
    -- For each target object
    for iTObjId = 1, #aObjs do
      -- Not a potential target if...
      local oTarget<const> = aObjs[iTObjId];
      local iTFlags<const> = oTarget.F;
      if iTFlags & iFBlock ~= 0 or       -- ...target object blocks?
         oTarget == oObj or              -- *or* target object is me?
         not maskSpr:IsCollideEx(oObj.S, -- *or* src collides with target?
           oObj.X, oObj.Y, maskSpr, 478, oTarget.X, oTarget.Y) or
         aIgnoredActions[oTarget.A] then -- *or* target action is ignored?
        goto lContinue end;
      -- If...
      if iY >= 1 and                 -- ...falling from above?
         oObj.FD < 0 and             -- *and* is falling?
         iTFlags & iFDevice == 0 and -- *and* target isn't a device?
         oTarget.FS == 1 then        -- *and* target isn't falling?
        -- Target takes crushing damage.
        AdjustObjectHealth(oTarget, oObj.FD, oObj);
        -- Don't continuously take the same damage falling damage.
        oObj.FD = -1;
      end
      -- Move that object too
      if iX ~= 0 then MoveX(oTarget, iX) end;
      if iY ~= 0 then MoveY(oTarget, iY) end;
      -- Prevent object from taking fall damage
      oTarget.FD, oTarget.FS = 0, 1;
      -- Continue to next target label
      ::lContinue::
    end
  end
  -- Return actual function
  return MoveOtherObjects;
end
-- Make object face another ------------------------------------------------ --
local function GetTargetDirection(oObj, oTarget)
  if oTarget.X < oObj.X then return DIR.L;
  else return DIR.R end;
end
-- Create object function initialiser -------------------------------------- --
local function InitCreateObject()
  -- Frequently used variables --------------------------------------------- --
  local iADying<const>, iAJump<const>, iAKeep<const>, iAPhase<const>,
    iAStop<const>, iDDown<const>, iDKeep<const>, iDNone<const>,
    iDOpposite<const>, iDRight<const>, iDUp<const>, iJDig<const>,
    iJInDanger<const>, iJKeep<const>, iJNone<const>, iJPhase<const>,
    iJSearch<const>, iFDelicate<const>, iFFall<const>, iFInWater<const>,
    iFPhaseTarget<const>, iFPuMAny<const>, iFPuMGems<const>, iFPuEAny<const>,
    iFPuEGems<const>, iFSellable<const>, iFTreasure<const>, iARest<const>,
    iTFWater<const> =
      ACT.DYING, ACT.JUMP, ACT.KEEP, ACT.PHASE, ACT.STOP, DIR.D, DIR.KEEP,
      DIR.NONE, DIR.OPPOSITE, DIR.R, DIR.U, JOB.DIG, JOB.INDANGER, JOB.KEEP,
      JOB.NONE, JOB.PHASE, JOB.SEARCH, OFL.DELICATE, OFL.FALL, OFL.INWATER,
      OFL.PHASETARGET, OFL.PUMANY, OFL.PUMGEMS, OFL.PUEANY, OFL.PUEGEMS,
      OFL.SELLABLE, OFL.TREASURE, ACT.REST, oTileFlags.W;
  -- Direction table for AIFindTarget -------------------------------------- --
  local aFindTargetData<const> = {
    { DIR.UL --[[ -1,-1 --]], false --[[ 0,-1 --]],  DIR.UR --[[ 1,-1 --]] },
    { DIR.L  --[[ -1, 0 --]], false --[[ 0, 0 --]], iDRight --[[ 1, 0 --]] },
    { DIR.DL --[[ -1, 1 --]], false --[[ 0, 1 --]],  DIR.DR --[[ 1, 1 --]] }
  };
  -- Picks a new target ---------------------------------------------------- --
  local function PickNewTarget(oObj)
    -- Holds potential targets
    local aTargets<const> = { };
    -- For each player...
    for iPlayer = 1, #aPlayers do
      -- Get player data and enumerate their diggers
      local aDiggers<const> = aPlayers[iPlayer].D;
      for iDiggerId = 1, #aDiggers do
        -- Get digger object and insert it in target list if a valid target
        local oDigger<const> = aDiggers[iDiggerId];
        if oDigger and oDigger.F & iFPhaseTarget ~= 0 then
          aTargets[1 + #aTargets] = oDigger;
        end
      end
    end
    -- Return if no targets found?
    if #aTargets == 0 then return end;
    -- Pick a random target and set it
    local oTarget<const> = aTargets[random(#aTargets)];
    oObj.T = oTarget;
    -- Initially move in direction of target
    SetAction(oObj, iAKeep, iJKeep, GetTargetDirection(oObj, oTarget));
    -- Return target
    return oTarget;
  end
  -- Process find target logic --------------------------------------------- --
  local function AIFindTarget(oObj)
    -- Get target and if set?
    local oTarget = oObj.T;
    if oTarget then
      -- If target time elapsed (30 seconds of game time) or target action not
      -- currently a phase target?
      if oObj.AT >= 1800 + random(1800) or oTarget.F & iFPhaseTarget == 0 then
        -- Reset object action timer since SetAction only resets if a different
        -- action is set.
        oObj.AT = 0;
        -- Set a new target and if we got one?
        local oNewTarget<const> = PickNewTarget(oObj);
        if oNewTarget then
          -- Get my unique ID
          local iUId<const> = oObj.U;
          -- Remove me from old targets list
          oTarget.TL[iUId] = nil;
          -- Add me to the new targets list
          oNewTarget.TL[iUId] = oObj;
          -- Set new target
          oTarget = oNewTarget;
        -- Could not pick a new target
        else return end;
      end
    -- No target so...
    else
      -- Initialise a new target and if we did? Add me to targets pursuer list
      oTarget = PickNewTarget(oObj);
      if oTarget then oTarget.TL[oObj.U] = oObj else return end;
    end
    -- Move towards the target if we can
    local iXA<const> = UtilSign(oTarget.X - oObj.X);
    if iXA ~= 0 and not IsCollideX(oObj, iXA) then AdjustPosX(oObj, iXA) end;
    local iYA<const> = UtilSign(oTarget.Y - oObj.Y);
    if iYA ~= 0 and not IsCollideY(oObj, iYA) then AdjustPosY(oObj, iYA) end;
    -- Return if no direction change
    local iDirection<const> = aFindTargetData[iYA + 2][iXA + 2];
    if not iDirection or oObj.D == iDirection then return end;
    -- Update the new direction
    SetAction(oObj, iAKeep, iJKeep, iDirection);
  end
  -- Process find target logic (slow --------------------------------------- --
  local function AIFindTargetSlow(oObj)
    -- Move closer to selected target every even action frame
    if oObj.AT % 2 == 0 then AIFindTarget(oObj) end;
  end
  -- Returns if object has sellable items----------------------------------- --
  local function ObjectHasValuables(oObj)
    -- Get object inventory and if we have items?
    local aObjInvList<const> = oObj.I;
    if #aObjInvList <= 0 then return false end;
    -- Enumerate them...
    for iInvIndex = 1, #aObjInvList do
      -- Get object in inventory. If is sellable regardless of owner?
      local oObjInv<const> = aObjInvList[iInvIndex];
      if oObjInv.F & iFSellable ~= 0 and
         CanSellGem(oObjInv.ID) then return true end;
    end
    -- Nothing to sell
    return false;
  end
  -- AI Digger phasing out ------------------------------------------------- --
  local function PhaseHome(oObj)
    -- Reset last dig time
    oObj.LDT = iGameTicks;
    -- Teleport home
    return SetAction(oObj, iAPhase, iJPhase, iDUp);
  end
  -- Simulate jumping function --------------------------------------------- --
  local function SimulateJumpLogic(oObj, iAdjX, iAnimAmount, aJumpData, iStep)
    -- Copy simulated action timer. We use it to move the object horizontally
    local iActionTimer = oObj.AT;
    -- Repeat until we've run out of data
    for iJumpId = 0, #aJumpData - 1 do
      -- Get amount to move by and if we do move?
      local iYMove = aJumpData[1 + iJumpId];
      if iYMove == 0 then goto lNoMove end;
      -- Repeat for each pixel...
      repeat
        -- This jump process is abandoned if we're blocked by the ceiling
        if not IsCollideY(oObj, iYMove) then
          -- Move Y position
          oObj.Y = oObj.Y + iYMove;
          -- Do not move Y again for now until the next simulated frame
          goto lNoMove;
        end
        -- Try next pixel
        iYMove = iYMove + iStep;
      -- ...until we've tested every pixel
      until iYMove == 0;
      -- Obviously blocked so move horizontally for the last time
      if iActionTimer % iAnimAmount == 0 and
         not IsCollideX(oObj, iAdjX) then oObj.X = oObj.X + iAdjX end;
      -- Jump aborted
      do return end;
      -- Label to skip Y moving
      ::lNoMove::
      -- Get action timer and move if it is time to move.
      if iActionTimer % iAnimAmount == 0 and
         not IsCollideX(oObj, iAdjX) then oObj.X = oObj.X + iAdjX end;
      -- Increment simulated action timer
      iActionTimer = iActionTimer + 1;
    end
    -- Jump successful but caller doesn't need to know this
  end
  -- Jump check logic ------------------------------------------------------ --
  --                              Move Timer/XAdj/Centre position for water
  local aAIWalkJumpGapLeftData<const>  = { 2, -1, 7 }; -- ACT.WALK+DIR.L/DL/UL
  local aAIWalkJumpGapRightData<const> = { 2,  1, 8 }; -- ACT.WALK+DIR.R/DR/UR
  local aAIRunJumpGapLeftData<const>   = { 1, -1, 7 }; -- ACT.RUN+DIR.L/DL/UL
  local aAIRunJumpGapRightData<const>  = { 1,  1, 8 }; -- ACT.RUN+DIR.R/DR/UR
  -- Jump logic ------------------------------------------------------------ --
  local oAIJumpLogic<const> = {
    [ACT.WALK] = {
      [DIR.UL]  = aAIWalkJumpGapLeftData,  [DIR.L]  = aAIWalkJumpGapLeftData,
      [DIR.UR]  = aAIWalkJumpGapRightData, [DIR.DL] = aAIWalkJumpGapLeftData,
      [iDRight] = aAIWalkJumpGapRightData, [DIR.DR] = aAIWalkJumpGapRightData
    },
    [ACT.RUN] = {
      [DIR.UL]  = aAIRunJumpGapLeftData,  [DIR.L]  = aAIRunJumpGapLeftData,
      [DIR.UR]  = aAIRunJumpGapRightData, [DIR.DL] = aAIRunJumpGapLeftData,
      [iDRight] = aAIRunJumpGapRightData, [DIR.DR] = aAIRunJumpGapRightData
    }
  };
  -- Returns if object is in the water ------------------------------------- --
  local function ObjectInWaterXY(oObj, iX, iY)
    -- Return false if position isn't invalid or flags not in the water
    local iId<const> = GetLevelDataFromObject(oObj, iX, iY);
    return iId and aTileData[1 + iId] & iTFWater ~= 0;
  end
  -- Returns if object is in the water ------------------------------------- --
  local function ObjectInWater(oObj, iY)
    return ObjectInWaterXY(oObj, 8, iY) end;
  -- AI jumping gap logic -------------------------------------------------- --
  local function TryJumpGap(oObj, iAdjX, iAdjXW, iAnimAmount, nHealthLimit,
    iOldX, iOldY, bGapIsWater)
    -- Calculate bottom Y pixel of fall and reset object position
    local iYGap = oObj.Y - iOldY;
    oObj.X, oObj.Y = iOldX, iOldY;
    -- Ignore if fall is below 14 pixels
    if iYGap < 14 then return end;
    -- If not intelligent enough, hints to the caller to change direction
    if random() < oObj.IN then return false end;
    -- Simulate rising and falling
    SimulateJumpLogic(oObj, iAdjX, iAnimAmount, aJumpRiseData,  1);
    SimulateJumpLogic(oObj, iAdjX, iAnimAmount, aJumpFallData, -1);
    -- Repeat...
    repeat
      -- Bad jump if we encountered water
      if ObjectInWaterXY(oObj, iAdjXW, 14) then break end;
      -- If we collide with the background if we go down more?
      if IsCollideY(oObj, 14) then
        -- Find absolute stable ground
        while not IsCollideY(oObj, 1) do oObj.Y = oObj.Y + 1 end;
        -- If object would land on lower ground and gap isn't water?
        if oObj.Y > iOldY and not bGapIsWater then
          -- Calculate bottom pixel of gap and abort jump if we landed lower
          -- than the gap bottom or the gap between where we'd land if we just
          -- fell and the place where we just jumped to is <= eight pixels.
          iYGap = iOldY + iYGap;
          if oObj.Y >= iYGap or iYGap - oObj.Y <= 8 then break end;
        end
        -- Restore original position adjusted and return if action was set.
        oObj.X, oObj.Y = iOldX, iOldY;
        return SetAction(oObj, iAJump, iJKeep, iDKeep);
      end
      -- Move object down. Bitmask sprite is 14px high.
      oObj.Y = oObj.Y + 14;
    -- ...until too much health would be lost for this jump to work
    until (oObj.Y - iOldY) // 8 >= nHealthLimit;
    -- Restore original properties as if nothing happened
    oObj.X, oObj.Y = iOldX, iOldY;
  end
  -- Search for obstacles or gaps and try to jump them --------------------- --
  local function ObjectJumped(oObj)
    -- Get jump gap data for action and if return if no action data
    local oActionData<const> = oAIJumpLogic[oObj.A];
    if not oActionData then return end;
    -- Get jump gap data for direction and return if no direction data
    local oDirData<const> = oActionData[oObj.D];
    if not oDirData then return end;
    -- Cache some variables
    local iAnimAmount<const>, -- Move at this action timer
          iAdjX<const>,       -- X adjustment
          iAdjXW<const>,      -- Water X tile adjustment
          nHealthLimit        -- Maximum amount of HP reduction
       = oDirData[1], oDirData[2], oDirData[3], oObj.H - 10;
    -- Double health limit if the object has more strength
    if oObj.F & iFDelicate == 0 then nHealthLimit = nHealthLimit * 2.0 end;
    -- Save position, action timer and flags
    local iOldX<const>, iOldY<const> = oObj.X, oObj.Y;
    -- If object cannot move to the adjacent pixel anymore?
    if (IsCollide(oObj, iAdjX, -1) and IsCollide(oObj, iAdjX, 0)) or
       -- *or* the path forks off above and below?
       (IsCollide(oObj, iAdjX, -2) and
        not IsCollide(oObj, 0, -2) and
        not IsCollide(oObj, iAdjX, -16)) then
      -- Return if...
      if oObj.H < 10.0 or                 -- ...health too low or...
         random() < oObj.IN or            -- ...not intelligent enough...
         oObj.J == iJDig then return end; -- ...or about to dig.
      -- Simulate rising and falling
      SimulateJumpLogic(oObj, iAdjX, iAnimAmount, aJumpRiseData,  1);
      SimulateJumpLogic(oObj, iAdjX, iAnimAmount, aJumpFallData, -1);
      -- Start from fall speed pixels and count down to 1
      repeat
        -- Bad jump if we landed in water
        if ObjectInWaterXY(oObj, iAdjXW, 14) then break end;
        -- If we collide with the background if we go down more?
        if IsCollideY(oObj, 14) then
          -- Find a stable ground
          while not IsCollideY(oObj, 1) do oObj.Y = oObj.Y + 1 end;
          -- Jump successful if jumped and landed higher or landing higher than
          -- the gap else the gap is lower so not jumping.
          if oObj.Y < iOldY or oObj.X ~= iOldX then
            -- Restore original position adjusted and return if action was set
            oObj.X, oObj.Y = iOldX, iOldY;
            return SetAction(oObj, iAJump, iJKeep, iDKeep);
          end
          -- Bottom of jump at bad position so go in opposite direction
          break;
        end
        -- Increase Y position and fall damage. We go at 14 pixels each time as
        -- the bitmask sprite is 14 pixels high.
        oObj.Y = oObj.Y + 14;
      -- ...until too much health would be lost for this jump to work
      until (oObj.Y - iOldY) // 8 >= nHealthLimit;
      -- Restore original properties as if nothing happened
      oObj.X, oObj.Y = iOldX, iOldY;
      -- Do not execute any more AI code this frame.
      return true;
    end
    -- Repeat virtual falling...
    repeat
      -- Continue until we find the bottom of the gap
      if IsCollide(oObj, iAdjX, 14) then
        -- Check for absolute pixel of the bottom of ground
        while not IsCollide(oObj, iAdjX, 1) do oObj.Y = oObj.Y + 1 end;
        -- Check if in water and if in water then gap is water
        local bInWater<const>, bGapIsWater = oObj.F & iFInWater ~= 0;
        if bInWater then bGapIsWater = true;
        -- Not in water but check if bottom of gap is in water
        else bGapIsWater = ObjectInWaterXY(oObj, iAdjXW, 2) end;
        -- Try to see if we can jump the gap and return success if succeeded
        local vResult<const> = TryJumpGap(oObj, iAdjX, iAdjXW, iAnimAmount,
          nHealthLimit, iOldX, iOldY, bGapIsWater);
        -- Return success if a jump would clear the gap
        if vResult then return true end;
        -- If gap is water and we're not in water?
        if (bGapIsWater and not bInWater) or
          -- *or* if the jump failed because the object isn't intelligent
          -- enough then check to see if the object is intelligent enough to
          -- avoid the gap.
          (vResult == false and random() >= oObj.IN) then break end;
        -- Fall down
        return false;
      end
      -- Increase Y position and fall damage. We go at 14 pixels each time as
      -- the bitmask sprite is 14 pixels high.
      oObj.Y = oObj.Y + 14;
    -- ...until too much health would be lost for this jump to work
    until (oObj.Y - iOldY) // 8 >= nHealthLimit;
    -- Restore original position
    oObj.X, oObj.Y = iOldX, iOldY;
    -- Get last anti-wiggle timeout value and if under reset limit?
    local iAntiWiggleTime<const> = oObj.AW;
    if iGameTicks < iAntiWiggleTime then
      -- Get current wiggle count and if we've wiggled too much?
      local iAntiWiggleRemain<const> = oObj.AWR + 1;
      if iAntiWiggleRemain >= 10 then
        -- Reset anti-wiggle timeframe to another 5 seconds
        oObj.AW, oObj.AWR = iGameTicks + 300, 0;
        -- Phase home if have parent
        if oObj.P and PhaseHome(oObj) then return true end;
        -- Go to a random object
        return SetAction(oObj, iAPhase, iJPhase, iDDown);
      -- Set new wiggle count
      else oObj.AWR = iAntiWiggleRemain end;
    -- Still in the timeframe? Reset anti-wiggle time to another 5 sec
    else oObj.AW, oObj.AWR = iGameTicks + 300, 0 end;
    -- This fall would kill cause the digger harm so evade the fall.
    return SetAction(oObj, iAKeep, iJKeep, iDOpposite);
  end
  -- Digger AI choices (Chances to change action per frame) ---------------- --
  local oAIData<const> = {
    -- Ai is currently stopped?
    [iAStop] = {
      -- No job currently set? (1%)
      [iJNone] = { [DIR.UL] = 0.01, [iDUp]   = 0.01, [DIR.UR]  = 0.01,
                   [DIR.L]  = 0.01, [iDNone] = 0.01, [iDRight] = 0.01,
                   [DIR.DL] = 0.01, [iDDown] = 0.01, [DIR.DR]  = 0.01 },
      -- Job is currently to dig? (1%)
      [iJDig] = { [DIR.UL] = 0.01, [DIR.U]  = 0.01, [DIR.UR]  = 0.01,
                  [DIR.L]  = 0.01, [iDNone] = 0.01, [iDRight] = 0.01,
                  [DIR.DL] = 0.01, [iDDown] = 0.01, [DIR.DR]  = 0.01 },
    -- Ai is currently walking?
    }, [ACT.WALK] = {
      -- Job is currently bouncing around? (0.1%)
      [JOB.BOUNCE] = { [DIR.UL]  = 0.001, [DIR.UR] = 0.001, [DIR.L] = 0.001,
                       [iDRight] = 0.001, [DIR.DL] = 0.001, [DIR.D] = 0.001,
                       [DIR.DR]  = 0.001 },
      -- Job is already digging? (0.1% or 5% if going down)
      [iJDig] = { [DIR.UL]  = 0.001, [DIR.UR] = 0.001, [DIR.L]  = 0.001,
                  [iDRight] = 0.001, [DIR.DL] = 0.05,  [DIR.DR] = 0.05 },
      -- Job is digging down? (95% chance due to very narrow time frame)
      [JOB.DIGDOWN] = { [DIR.D] = 0.95 },
      -- Job is searching for treasure? (0.2%)
      [iJSearch] = { [DIR.UL]  = 0.002, [DIR.UR] = 0.002, [DIR.L] = 0.002,
                     [iDRight] = 0.002, [DIR.DL] = 0.002, [DIR.D] = 0.002,
                     [DIR.DR]  = 0.002 },
    -- Ai is currently running?
    }, [ACT.RUN] = {
      -- Job is currently bouncing around? (1%)
      [JOB.BOUNCE] = { [DIR.UL]  = 0.01, [DIR.UR] = 0.01, [DIR.L] = 0.01,
                       [iDRight] = 0.01, [DIR.DL] = 0.01, [DIR.D] = 0.01,
                       [DIR.DR]  = 0.01 },
      -- Job is currently in danger? (0.2%)
      [iJInDanger] = { [DIR.UL]  = 0.002, [DIR.UR] = 0.002, [DIR.L] = 0.002,
                       [iDRight] = 0.002, [DIR.DL] = 0.002, [DIR.D] = 0.002,
                       [DIR.DR]  = 0.002 },
    }
  };
  -- Pickup objects or just gems ------------------------------------------- --
  local function AIPickupOrDrop(oObj, iEqual)
    -- 95% chance to pickup gems only
    if random() >= 0.05 then
      return PickupObjects(oObj, iFPuMGems, iFPuEGems) end;
    -- 5% chance to pickup gems or items
    if PickupObjects(oObj, iFPuMAny, iFPuEAny) then return true end;
    -- Get digger inventory and return if no inventory or 95% chance to ignore.
    local aObjInvList<const> = oObj.I;
    if #aObjInvList == 0 then return end;
    -- Pick a random object and try to drop it if properties match
    local oObjInv<const> = aObjInvList[random(#aObjInvList)];
    return oObjInv.F & iFTreasure == iEqual and DropObject(oObj, oObjInv);
  end
  -- Digger AI logic ------------------------------------------------------- --
  local function AIDiggerLogic(oObj)
    -- Return if not falling or already falling
    if oObj.F & iFFall == 0 or oObj.FD < 0 then return end;
    -- If the following conditions are met...
    if ObjectIsAtHome(oObj) and -- Object is at their home point? *and*
      (oObj.IW > 0 or           -- (Digger is carrying something? *or*
       oObj.H < 75) and         --  Health is under 75%) *and*
       oObj.A == iAStop and     -- Digger has stopped?
       oObj.D ~= iDRight then   -- Digger hasn't teleported yet?
      -- Teleport home to rest and sell items
      SetAction(oObj, iAPhase, iJPhase, iDRight);
      -- Nothing else to do whilst teleporting
      return;
    end
    -- Return if object jumped
    if ObjectJumped(oObj) then return end;
    -- Generate a random number for this digger for this frame
    local nRandom<const> = random();
    -- Stop the Digger if needed so it can heal a bit if...
    if nRandom < 0.001 and       -- Intelligent enough? (0.1%)
       oObj.H <= 25 and          -- *and* Below quarter health?
       oObj.A ~= iAStop and      -- *and* Not stopped?
       oObj.J ~= iJInDanger then -- Not in danger?
      -- If the object can rest then they can rest and heal faster
      if oObj.OD[iARest] and nRandom >= oObj.IN then
        SetAction(oObj, iARest, iJNone, iDNone);
      -- Go home and rest
      else SetAction(oObj, iAStop, iJNone, iDNone) end;
      -- Nothing else to do in this frame
      return;
    end
    -- If the following conditions are met?
    if (((nRandom <= 0.01 and             -- Low 1% chance?
          oObj.H < 50) or                 -- *and* Health under 50%?
         (nRandom <= 0.001 and            -- *or* (0.1% chance?
          oObj.H >= 50)) and              -- *and* Health over 50%?
        oObj.J == iJInDanger and          -- *and* object is in danger?
        oObj.A ~= iAStop) or              -- *and* moving?
       (nRandom <= 0.001 and              -- *or* (0.1% chance?)
        oObj.IW >= oObj.MI and            -- *and* Digger has full inv?
        ObjectHasValuables(oObj)) or      -- *and* has sellable items?)
       (nRandom <= 0.01 and               -- *or* (1% chance?)
        iGameTicks - oObj.LDT >= 7200 and -- *and* Not dug for 2 mins?
        oObj.A == iAStop) then            -- *and* stopped?
      -- Teleport home
      PhaseHome(oObj);
      -- Nothing else to do in this frame
      return;
    end
    -- Return if...
    if (oObj.H < 50 and                -- ...below half health?
        oObj.A == iAStop and           -- *and* stopped?
        nRandom > 0.001) or            -- *and* very low 0.1% chance?
        (oObj.J ~= iJSearch and        -- *or* Digger not searching?
         oObj.AT % 10 == 1 and         -- *and* once every 10 frames?
         nRandom >= oObj.IN and        -- *and* intelligent enough?
         AIPickupOrDrop(oObj, 0)) then -- *and* pickup or drop?
      return end;
    -- Return if no data for current action
    local oAIDataAction<const> = oAIData[oObj.A];
    if not oAIDataAction then return end;
    -- Return if no data for specified job
    local oAIDataJob<const> = oAIDataAction[oObj.J];
    if not oAIDataJob then return end;
    -- Return if no chance to change job
    local nAIDataDirection<const> = oAIDataJob[oObj.D];
    if not nAIDataDirection or nRandom >= nAIDataDirection then return end;
    -- Set a new job
    SetRandomJob(oObj);
  end
  -- AI random direction logic initialisation data ------------------------- --
  local aAIRandomLogicInitData<const> = { iDUp, iDDown, DIR.L, iDRight };
  -- AI random direction logic movement data ------------------------------- --
  local oAIRandomLogicMoveData<const> = {
    -- -- (1st line) Try to move in these directions first... -------------- --
    --              TeX  TeY    TeX  TeY
    --               \/  \/      \/  \/
    -- -- (2nd line) When blocked then an alt list of directions provided... --
    --   TeX  TeY Direction   TeX  TeY Direction   TeX  TeY Direction
    --    \/  \/  \/           \/  \/  \/           \/  \/  \/
    [iDUp] = { { {  0, -2 }, {  0, -1 } }, -- Going up?
      { { -1, -1, DIR.U   }, {  1, -1, DIR.U   }, { -1,  0, DIR.L },
        {  1,  0, iDRight }, {  0,  1, iDDown  } } },
    [iDDown] = { { {  0,  2 }, {  0,  1 } }, -- Going down?
      { {  0,  1, iDDown  }, { -1,  1, iDDown  }, {  1,  1, iDDown },
        { -1,  0, DIR.L   }, {  1,  0, iDRight }, {  0, -1, DIR.U } } },
    [DIR.L] = { { { -2,  0 }, { -1,  0 } }, -- Going left?
      { { -1,  0, DIR.L   }, { -1, -1, DIR.L   }, { -1,  1, DIR.L   },
        {  0, -1, iDUp    }, {  0,  1, iDDown  }, {  1,  0, iDRight } } },
    [iDRight] = { { {  2,  0 }, {  1,  0 } }, -- Going right?
      { {  1,  0, iDRight }, {  1, -1, iDRight }, {  1,  1, iDRight },
        {  0, -1, iDUp    }, {  0,  1, iDDown  }, { -1,  0, DIR.L   } } }
  };
  -- AI random direction logic --------------------------------------------- --
  local function AIRandomLogic(oObj)
    -- Set new direction if object has no direction
    local iDirection = oObj.D;
    if iDirection == iDNone then
      return SetAction(oObj, iAKeep, iJKeep,
        aAIRandomLogicInitData[random(#aAIRandomLogicInitData)]) end;
    -- Get direction
    local aDData<const> = oAIRandomLogicMoveData[iDirection];
    -- Try every possible combination but the last
    local aPDData<const> = aDData[1];
    for iI = 1, #aPDData do
      local aPDItem<const> = aPDData[iI];
      if not IsCollide(oObj, aPDItem[1], aPDItem[2]) then
        return AdjustPos(oObj, aPDItem[1], aPDItem[2]) end;
    end
    -- Blocked so we need to find a new direction to move in
    local oDirections<const> = { };
    -- Try every possible combination but the last
    local aPossibleDirections<const> = aDData[2];
    for iI = 1, #aPossibleDirections - 1 do
      local aPDData<const> = aPossibleDirections[iI];
      if not IsCollide(oObj, aPDData[1], aPDData[2]) then
        oDirections[1 + #oDirections] = aPDData[3] end;
    end
    -- If we have a possible direction then go in that direction
    if #oDirections ~= 0 then iDirection = oDirections[random(#oDirections)];
    -- No direction found
    else
      -- Try going back in the previous direction
      local aPDData<const> = aPossibleDirections[#aPossibleDirections];
      if not IsCollide(oObj, aPDData[1], aPDData[2]) then
        iDirection = aPDData[3];
      -- Can't even go back in the previous direction so this position is FAIL
      else iDirection = iDNone end
    end
    -- Pick a new direction from eligible directions
    SetAction(oObj, iAKeep, iJKeep, iDirection);
  end
  -- Troll AI data --------------------------------------------------------- --
  local aAITrollActionData<const> = {
    { ACT.WALK, JOB.BOUNCE, DIR.LR }, -- Chance to walk left or right
    { ACT.RUN,  JOB.BOUNCE, DIR.LR }, -- Chance to run left or right
    { iAPhase,  iJPhase,    iDDown }, -- Chance to phase randomly
    { iAStop,   iJNone,     iDNone }, -- Chance to just stop and chill
  };
  -- Troll AI -------------------------------------------------------------- --
  local function AITroll(oObj)
    -- Return if...
    if oObj.F & iFFall == 0 or             -- ...*or* or not allowed to fall...
       oObj.FD < 0 or                      -- ...*or* already falling...
       ObjectJumped(oObj) then return end; -- ...*or* we jumped.
    -- Every 60 game frames (a second). Try to pick up gems with a
    -- 5% chance to pickup devices as well and if no objects were picked up
    -- then another 5% chance to drop a piece of inventory.
    if iGameTicks % 60 == 0 and random() < 0.25 and
       AIPickupOrDrop(oObj, iFTreasure) then return end;
    -- If ADHD hasn't set in yet? Just return
    if random() > 0.001 then return end;
    -- Get and set a random action
    local oActionData<const> = aAITrollActionData[random(#aAITrollActionData)];
    SetAction(oObj, oActionData[1], oActionData[2], oActionData[3]);
  end
  -- Basic AI roaming ------------------------------------------------------ --
  local function AIRoam(oObj)
    -- Direction to go in
    local iAdjX;
    if oObj.D == DIR.L then iAdjX = -1 else iAdjX = 1 end;
    -- Move if object can move in its current direction, or the target
    -- doesn't have a 0.25% chance to change direction each frame?
    if not IsCollideX(oObj, iAdjX) and
       random() > 0.0025 then AdjustPosX(oObj, iAdjX) return end;
    -- Blocked so go in opposite direction
    SetAction(oObj, iAKeep, iJKeep, iDOpposite);
  end
  -- Basic AI roaming (slow) ----------------------------------------------- --
  local function AIRoamSlow(oObj)
    -- Move around every 4th frame
    if oObj.AT % 4 == 0 then AIRoam(oObj) end;
  end
  -- Fish bobbing up and down (slow) --------------------------------------- --
  local function AIFish(oObj)
    -- Move only around every 4th frame
    if oObj.AT % 4 ~= 0 then return end;
    -- Roam horizontally as normal
    AIRoam(oObj);
    -- Calculate a bobbing up and down movements
    local iAdjY<const> = max(-2, min(2, floor(sin(oObj.AT * 0.1) * 2 + 0.5)));
    -- Return if we can't move in the requested direction
    if IsCollideY(oObj, iAdjY) then return end
    -- Move Y axis if moving is in the water
    if ObjectInWater(oObj, iAdjY) then AdjustPosY(oObj, iAdjY); end;
    -- Chance to reset action timer which briefly alters the fish Y axis.
    if random() < 0.01 then oObj.AT = random(100) end;
  end
  -- Basic AI roaming (normal) --------------------------------------------- --
  local function AIRoamNormal(oObj)
    -- Move around every odd frame
    if oObj.AT % 2 == 0 then AIRoam(oObj) end;
  end
  -- Corkscrew actions ----------------------------------------------------- --
  local oAICorkscrewActions<const> = {
    [iAStop] = { [iJNone] = {
      { 0.001, ACT.CREEP, iJNone,      DIR.LR   },
      { 0.001, ACT.CREEP, JOB.DIGDOWN, DIR.TCTR } }
    }, [ACT.DIG] = { [JOB.DIGDOWN] = {
      { 0.01,  iAStop,    iJNone,      iDNone   },
      { 0.001, ACT.CREEP, iJNone,      DIR.LR   } }
    }, [ACT.CREEP] = { [iJNone] = {
      { 0.001, iAStop,    iJNone,      DIR.LR   },
      { 0.001, ACT.CREEP, JOB.DIGDOWN, DIR.TCTR } }
    } };
  -- Corkscrew ------------------------------------------------------------- --
  local function AICorkscrew(oObj)
    -- Get data for current action
    local oAIActionData<const> = oAICorkscrewActions[oObj.A];
    if not oAIActionData then return end;
    -- Get data for current job
    local aAIJobData<const> = oAIActionData[oObj.J];
    if not aAIJobData then return end;
    -- For each item
    for iIndex = 1, #aAIJobData do
      -- Get item and set new action if the specified chance occurs
      local oAction<const> = aAIJobData[iIndex];
      if random() < oAction[1] then
        return SetAction(oObj, oAction[2], oAction[3], oAction[4], oAction[5]);
      end
    end
  end
  -- Exploder -------------------------------------------------------------- --
  local function AIExploder(oObj)
    -- 0.1% chance to trigger this explosive if not already busy
    if random() > 0.001 then return end;
    -- Get objects parent and return if there is none (should be impossible)
    local oParent<const> = oObj.P;
    if not oParent then return end;
    -- Get object sprite and position
    local iX<const>, iY<const>, iObjId = oObj.X, oObj.Y, 1;
    -- Continue point
    ::lContinue::
    -- Done if out of objects to check
    if iObjId > #aObjs then return end;
    -- If target belongs to me or object not near it?
    local oTarget<const> = aObjs[iObjId];
    if abs(oTarget.X - iX) >= 16 or abs(oTarget.Y - iY) >= 16 or
       oTarget.P == oParent then
      -- Check next object
      iObjId = iObjId + 1;
      goto lContinue;
    end
    -- Set off the object exploding
    SetAction(oObj, iADying, iJNone, iDNone);
  end
  -- Generic choices function ---------------------------------------------- --
  local function AIChoice(oObj, nChance, aChoices)
    if random() > nChance then return end;
    SetAction(oObj, unpack(aChoices[random(#aChoices)]));
  end
  -- Tunneller ------------------------------------------------------------- --
  local aTunnelChoices<const> =
    { { ACT.WALK, iJDig, DIR.LR }, { iAStop, iJNone, iDNone } };
  local function AITunneller(oObj) AIChoice(oObj, 0.001, aTunnelChoices) end;
  -- AI for train for rails ------------------------------------------------ --
  local aTrainChoices<const> =
    { { ACT.WALK, iJSearch, DIR.LR }, { iAStop, iJNone, iDNone } };
  local function AITrain(oObj) AIChoice(oObj, 0.001, aTrainChoices) end;
  -- AI for lift ----------------------------------------------------------- --
  local aLiftChoices<const> =
    { { ACT.CREEP, iJNone, DIR.UD }, { iAStop, iJNone, iDNone } };
  local function AILift(oObj) AIChoice(oObj, 0.001, aLiftChoices) end;
  -- AI for inflatable boat ------------------------------------------------ --
  local aBoatChoices<const> =
    { { ACT.CREEP, iJNone, DIR.LR }, { iAStop, iJNone, iDNone } };
  local function AIBoat(oObj) AIChoice(oObj, 0.001, aBoatChoices) end;
  -- AI for anything deployable -------------------------------------------- --
  local function AIDeploy(oObj)
    -- 0.1% chance to deply the object else deploy the object
    if random() > 0.001 then return end;
    SetAction(oObj, ACT.DEPLOY, iJNone, iDNone);
  end
  -- AI for flood gate ----------------------------------------------------- --
  local aGateChoices<const> =
    { { ACT.OPEN, iJNone, iDNone }, { ACT.CLOSE, iJNone, iDNone } };
  local function AIGate(oObj) AIChoice(oObj, 0.00001, aGateChoices) end;
  -- Data for below AICreepStop function ----------------------------------- --
  local oCreepStopMoves<const> = {
    [ACT.CREEP] = { 0.005, { iAStop,    iJKeep, iDKeep } },
    [iAStop]    = { 0.025, { ACT.CREEP, iJKeep, DIR.LR } }
  };
  -- AI for sometimes stopping and resuming -------------------------------- --
  local function AICreepStop(oObj)
    -- Set new action if matching action and specified chance occurs
    local aAction<const> = oCreepStopMoves[oObj.A];
    if not aAction or random() >= aAction[1] then return end;
    SetAction(oObj, unpack(aAction[2]));
  end
  -- AI id to function list ------------------------------------------------ --
  local aAIFuncs<const> = {
    [AI.BOAT]      = AIBoat,           [AI.CORKSCREW]   = AICorkscrew,
    [AI.CREEPSTOP] = AICreepStop,      [AI.CRITTERSLOW] = AIRoamSlow,
    [AI.CRITTER]   = AIRoamNormal,     [AI.DEPLOY]      = AIDeploy,
    [AI.DIGGER]    = AIDiggerLogic,    [AI.EXPLODER]    = AIExploder,
    [AI.FINDSLOW]  = AIFindTargetSlow, [AI.FIND]        = AIFindTarget,
    [AI.FISH]      = AIFish,           [AI.GATE]        = AIGate,
    [AI.LIFT]      = AILift,           [AI.NONE]        = false,
    [AI.RANDOM]    = AIRandomLogic,    [AI.TRAIN]       = AITrain,
    [AI.TROLL]     = AITroll,          [AI.TUNNELER]    = AITunneller,
  };
  -- Actual create object function ----------------------------------------- --
  local function CreateObject(iTypeId, iX, iY, oParent)
    -- Check parameters
    if not UtilIsInteger(iTypeId) then
      error("Object id integer invalid! "..tostring(iTypeId)) end;
    if iTypeId < 0 then error("Object id "..iTypeId.." must be positive!") end;
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
    if #aObjs >= 500 then
      CoreWrite("Warning! Too many objects creating "..iTypeId.." at X="..iX..
        " and Y="..iY.." with parent "..tostring(oParent).."!", 9);
      return false;
    end
    -- Get and test object information
    local oObjData<const> = oObjectData[iTypeId];
    if not UtilIsTable(oObjData) then error("Object data for #"..
      iTypeId.." not in objects lookup!") end;
    -- Get object name
    local sName<const> = oObjData.NAME
    if not UtilIsString(sName) then error("Object name for #"..
      iTypeId.." not in object data table!") end;
    -- Get and test AI type
    local iAI<const> = oObjData.AITYPE;
    if not UtilIsInteger(iAI) then error("Invalid AI type #"..
      tostring(iAI).." for "..sName.."["..iTypeId.."]!") end
    -- Increment unique object id number
    iUniqueId = iUniqueId + 1;
    -- Build new object array
    local oObj<const> = {
      A    = false,                      -- Object action (ACT.*)
      AA   = false,                      -- Attachment action data
      AD   = { },                        -- Reference to action data
      AI   = iAI,                        -- Object AI procedure
      AIF  = false,                      -- Active AI function
      AIDF = false,                      -- Default AI function
      ANT  = oObjData.ANIMTIMER,         -- Animation timer
      AT   = 0,                          -- Action timer
      AX   = 0,     AY   = 0,            -- Tile position
      AW   = 0,                          -- Anti-wiggle timeout
      AWR  = 0,                          -- Anti-wiggle remain
      CS   = not not oObjData[ACT.STOP], -- Object can stop?
      D    = false,                      -- Direction to go in (DIR.*)
      DA   = false,                      -- Attachment direction data
      DD   = { },                        -- Reference to direction data
      DID  = oObjData.DIGDELAY,          -- Digging delay
      DUG  = 0,                          -- Successful dig count
      EK   = 0,                          -- Fiends killed
      F    = oObjData.FLAGS or 0,        -- Object flags (OFL.*)
      FD   = 0,                          -- Amount the object has fallen by
      FDD  = DIR.NONE,                   -- Last failed dig direction
      FS   = 1,                          -- Object falling speed
      GEM  = 0,                          -- Gems found
      H    = 100,                        -- Object health
      I    = { },                        -- Inventory for this object
      ID   = iTypeId,                    -- Object id (TYP.*)
      IN   = oObjData.INTELLIGENCE,      -- Intelligence
      IP   = false,                      -- Object carrying this object
      IS   = nil,                        -- Selected inventory item
      IW   = 0,                          -- Weight of inventory
      J    = false,                      -- Object job (JOB.*)
      JD   = { },                        -- Reference to job data
      JT   = 0,                          -- Job timer
      LC   = oObjData.LUNGS or 1,        -- Lung capacity
      LDT  = iGameTicks,                 -- Last successful dig time
      LK   = 0,                          -- Living things killed
      M    = false,                      -- Mask id for IsCollidePlatform()
      OD   = oObjData,                   -- Object data table
      OFX  = 0,     OFY  = 0,            -- Drawing offset
      OFXA = 0,     OFYA = 0,            -- Attachment drawing offset
      P    = oParent,                    -- Parent of object
      PW   = 0,                          -- Patience warning
      PL   = 0,                          -- Patience limit
      S    = 0,                          -- Current sprite frame #
      S1   = 0,     S1A  = 0,            -- Start sprite frame# (+attachment)
      S2   = 0,     S2A  = 0,            -- Ending sprite frame# (+attachment)
      SA   = 0,                          -- Current attachment sprite frame #
      SM   = false, SMM1 = false,        -- Object stamina (+minus 1)
      ST   = 0,                          -- Sprite animation timer
      STA  = oObjData.ATTACHMENT,        -- Object attachment id
      STR  = oObjData.STRENGTH,          -- Object strength
      SX   = iX,    SY   = iY,           -- Object starting position
      TD   = { },                        -- Ignored teleport destinations
      TL   = { },                        -- Objects that are targeting this
      U    = iUniqueId,                  -- Unique id
      US   = oParent and oParent.US,     -- Automatically un-shroud?
      W    = oObjData.WEIGHT,            -- Carry amount / requirement
      X    = 0,     Y    = 0             -- Absolute pixel position
    };
    -- Add animated health value if our object
    if oParent and oPlrActive == oParent then oObj.HA = oObj.H end;
    -- Is AI function specified and not a player controlled parent?
    if iAI ~= AI.NONE and (not oParent or oParent.AI) then
      -- Lookup AI function and check that it's a function
      local fcbAIFunc<const> = aAIFuncs[iAI];
      if not UtilIsFunction(fcbAIFunc) then
        error("Unknown AI #"..tostring(iAI).."! "..tostring(fcbAIFunc)) end;
      -- Valid function to set it to call every tick
      oObj.AIDF = fcbAIFunc;
    -- No AI function
    else oObj.AIDF = BlankFunction end;
    -- Set position of object
    SetPosition(oObj, iX, iY);
    -- Set default action (also sets default direction);
    SetAction(oObj, oObjData.ACTION, oObjData.JOB, oObjData.DIRECTION);
    -- Insert into main object array
    aObjs[1 + #aObjs] = oObj;
    -- Log creation of item
    CoreLog("Created object '"..sName.."'["..iTypeId.."] at X:"..iX..
      ",Y:"..iY.." in position #"..#aObjs.."!");
    -- Return object
    return oObj;
  end
  -- Return the actual function
  return CreateObject;
end
-- Buy an item ------------------------------------------------------------- --
local function BuyItem(oObj, iItemId)
  -- Get object data and value of object
  local oObjData<const> = oObjectData[iItemId];
  local iValue<const> = oObjData.VALUE;
  -- Get objects owner and owner money
  local oParent<const> = oObj.P;
  local iParentMoney<const> = oParent.M;
  -- Not enough money?
  if iValue > iParentMoney then return 1 end;
  -- Can't carry any more?
  if oObj.IW + oObjData.WEIGHT > oObj.STR then return 2 end;
  -- Create the object and return if we can't
  local aObjInv<const> = CreateObject(iItemId, oObj.X, oObj.Y, oParent);
  if not aObjInv then return 3 end;
  -- Add to inventory
  AddToInventory(oObj, aObjInv, #aObjs);
  -- Reduce money
  oParent.M = iParentMoney - iValue;
  -- Total purchases plus one
  oParent.PUR = oParent.PUR + 1;
  -- Log the purchase
  CoreLog(oObj.OD.NAME.." "..oObj.DI.." purchased "..oObjData.NAME..
    " for "..iValue.." Zogs ("..iParentMoney..">"..oParent.M..")!");
  -- Success
  return 4;
end
-- Main logic tick procedures ---------------------------------------------- --
local function GameProc()
  -- Commonly accessed aliases --------------------------------------------- --
  local iADeath<const>, iAEaten<const>, iAFight<const>, iAHide<const>,
    iAKeep<const>, iAPhase<const>, iARun<const>, iAStop<const>, iAWalk<const>,
    iDDown<const>, iDDownRight<const>, iDKeep<const>, iDKeepMoving<const>,
    iDLeftRight<const>, iDNone<const>, iDOpposite<const>, iDRight<const>,
    iDUpRight<const>, iFAquaLung<const>, iFBusy<const>, iFConsume<const>,
    iFDangerous<const>, iFDelicate<const>, iFDigger<const>, iFDigBusy<const>,
    iFDigWBase<const>, iFFall<const>, iFFloat<const>, iFFloating<const>,
    iFHealNearby<const>, iFHurtDigger<const>, iFInWater<const>, iFiFall<const>,
    iFiFloating<const>, iFiInWater<const>, iFiJumpFallBusy<const>,
    iFiJumpRise<const>, iFJumping<const>, iFJumpFall<const>, iFJumpRise<const>,
    iFPhaseDigger<const>, iFPhaseTarget<const>, iFPuGemMask<const>,
    iFPuGemEq<const>, iFPursueDigger<const>, iFRegenerate<const>,
    iFStationary<const>, iFTPMaster<const>, iFWaterBased<const>,
    iJDigDown<const>, iJInDanger<const>, iJKeep<const>, iJNone<const>,
    iJPhase<const>, iJSearch<const>, iSError<const>, iTDeadWait<const>,
    iTyFirstAid<const>, iTyTelepole<const>, iTFW<const>, iTFP<const>,
    iTFEL<const>, iTFER<const>, iTFEB<const>, iTFET<const>,
    iTFAnimateBegin<const>, iTFAnimateEnd<const> =
      ACT.DEATH, ACT.EATEN, ACT.FIGHT, ACT.HIDE, ACT.KEEP, ACT.PHASE, ACT.RUN,
      ACT.STOP, ACT.WALK, DIR.D, DIR.DR, DIR.KEEP, DIR.KEEPMOVE, DIR.LR,
      DIR.NONE, DIR.OPPOSITE, DIR.R, DIR.UR, OFL.AQUALUNG, OFL.BUSY,
      OFL.CONSUME, OFL.DANGEROUS, OFL.DELICATE, OFL.DIGGER, OFL.DGRBUSY,
      OFL.DGRWB, OFL.FALL, OFL.FLOAT, OFL.FLOATING, OFL.HEALNEARBY,
      OFL.HURTDIGGER, OFL.INWATER, OFL.iFALL, OFL.iFLOATING, OFL.iINWATER,
      OFL.iJUMPFALLBUSY, OFL.iJUMPRISE, OFL.JUMP, OFL.JUMPFALL, OFL.JUMPRISE,
      OFL.PHASEDIGGER, OFL.PHASETARGET, OFL.PUMGEMS, OFL.PUEGEMS,
      OFL.PURSUEDIGGER, OFL.REGENERATE, OFL.STATIONARY, OFL.TPMASTER,
      OFL.WATERBASED, JOB.DIGDOWN, JOB.INDANGER, JOB.KEEP, JOB.NONE, JOB.PHASE,
      JOB.SEARCH, oSfxData.ERROR, 600, TYP.FIRSTAID, TYP.TELEPOLE,
      oTileFlags.W, oTileFlags.P, oTileFlags.EL, oTileFlags.ER, oTileFlags.EB,
      oTileFlags.ET, oTileFlags.AB, oTileFlags.AE;
  -- == TILE DIGGING LOGIC ================================================= --
  -- Storage for certain positions and tile ids relative to the object
  local iDP,   -- Vertical position at objects feet
        iCP,   -- Vertical position at objects waist height
        iTId,  -- Tile id the object is on now
        iTIdA, -- Tile id above the object is on now
        iTIdC, -- Tile id the object is on now (centre pixel position)
        iTIdB, -- Tile id below the object is on now
        iTIdL, -- Tile id left of the object is on now
        iTIdR; -- Tile id right of the object is on now
  -- Get dig tile data
  local function GetDigTileData()
    -- Get the tile id that the object is on now
    iTIdC = aLvlData[1 + iCP];
    -- Get the tile above and adjacent the object
    if iDP >= iLLAbsW then iTIdA = aLvlData[1 + (iDP - iLLAbsW)];
                      else iTIdA = 0 end
    -- Get the tile below and adjacent to the object
    if iDP < iLLAbs - iLLAbsW then iTIdB = aLvlData[1 + (iDP + iLLAbsW)];
                              else iTIdB = 0 end;
    -- Get the tile adjacent to the object
    iTId = aLvlData[1 + iDP];
    -- Get the tile left of the object
    if iDP - 1 >= 0 then iTIdL = aLvlData[1 + (iDP - 1)] else iTIdL = 0 end;
    -- Get the tile right of the object
    if iDP + 1 < iLLAbs then iTIdR = aLvlData[1 + iDP + 1] else iTIdR = 0 end;
  end
  -- Moving left or up-left?
  local function DigDirectionLeftOrUpleft(oObj)
    -- Get tile at objects feet
    iDP = GetLevelOffsetFromObject(oObj, 5, 15) or 0;
    GetDigTileData();
    local iFDL<const>, iFDT<const> =
      aTileData[1 + iTIdL], aTileData[1 + iTIdA];
    if iFDT & iTFP ~= 0 or
      (iFDL & iTFW ~= 0 and iFDL & iTFER ~= 0) or
      (iFDT & iTFW ~= 0 and iFDT & iTFEB ~= 0) then return false end;
    return true;
  end
  -- Moving left or up-left?
  local function DigDirectionUpLeft(oObj)
    -- Get tile at objects waist
    iCP = GetLevelOffsetFromObject(oObj, 8, 15) or 0;
    return DigDirectionLeftOrUpleft(oObj);
  end
  -- Digging left?
  local function DigDirectionLeft(oObj)
    -- Tile at objects waist not required
    iCP = 0;
    return DigDirectionLeftOrUpleft(oObj);
  end
  -- Digging down-left?
  local function DigDirectionDownLeft(oObj)
    -- Get tile at objects hands and feet
    iCP, iDP = GetLevelOffsetFromObject(oObj, 8, 1) or 0,
               GetLevelOffsetFromObject(oObj, 5, 1) or 0;
    GetDigTileData();
    local iFDB<const>, iFDL<const>, iFDT<const> =
      aTileData[1 + iTIdB], aTileData[1 + iTIdL], aTileData[1 + iTIdA];
    if iFDT & iTFP ~= 0 or
      (iFDB & iTFW ~= 0 and iFDB & iTFET ~= 0) or
      (iFDL & iTFW ~= 0 and iFDL & iTFER ~= 0) or
      (iFDT & iTFW ~= 0 and iFDT & iTFEB ~= 0) then return false end;
    return true;
  end
  -- Digging right or up-right?
  local function DigDirectionRightOrUpright(oObj)
    -- Get tile at objects feet
    iDP = GetLevelOffsetFromObject(oObj, 10, 15) or 0;
    GetDigTileData();
    local iFDT<const>, iFDR<const> =
      aTileData[1 + iTIdA], aTileData[1 + iTIdR];
    if iFDT & iTFP ~= 0 or
      (iFDR & iTFW ~= 0 and iFDR & iTFEL ~= 0) or
      (iFDT & iTFW ~= 0 and iFDT & iTFEB ~= 0) then return false end;
    return true;
  end
  -- Digging up-right
  local function DigDirectionUpRight(oObj)
    -- Get tile at objects waist
    iCP = GetLevelOffsetFromObject(oObj, 8, 15) or 0;
    return DigDirectionRightOrUpright(oObj);
  end
  -- Digging right or up-right?
  local function DigDirectionRight(oObj)
    -- Tile at objects waist not required
    iCP = 0;
    return DigDirectionRightOrUpright(oObj);
  end
  -- Digging down-right?
  local function DigDirectionDownRight(oObj)
    -- Get tile at objects waist and feet
    iCP, iDP = GetLevelOffsetFromObject(oObj, 8, 1) or 0,
               GetLevelOffsetFromObject(oObj, 10, 1) or 0;
    GetDigTileData();
    local iFDB<const>, iFDR<const>, iFDT<const> =
      aTileData[1 + iTIdB], aTileData[1 + iTIdR], aTileData[1 + iTIdA];
    if iFDT & iTFP ~= 0 or
      (iFDB & iTFW ~= 0 and iFDB & iTFET ~= 0) or
      (iFDR & iTFW ~= 0 and iFDR & iTFEL ~= 0) or
      (iFDT & iTFW ~= 0 and iFDT & iTFEB ~= 0) then return false end;
    return true;
  end
  -- Digging down?
  local function DigDirectionDown(oObj)
    -- Get tile at objects waist and feet
    iCP, iDP = 0, GetLevelOffsetFromObject(oObj, 8, 16) or 0;
    GetDigTileData();
    local iFDL<const>, iFDT<const>, iFDR<const>, iFDB<const> =
      aTileData[1 + iTIdL], aTileData[1 + iTIdA], aTileData[1 + iTIdR],
      aTileData[1 + iTIdB];
    if iFDT & iTFP ~= 0 or
      (iFDB & iTFW ~= 0 and iFDB & iTFET ~= 0) or
      (iFDL & iTFW ~= 0 and iFDL & iTFER ~= 0) or
      (iFDR & iTFW ~= 0 and iFDR & iTFEL ~= 0) then return false end;
    return true;
  end
  -- Do the dig
  local function DoDig(oObj, aSubDigItem)
    -- Terrain should change?
    local iTOS<const>, iFlags<const> = aSubDigItem[4], aSubDigItem[7];
    if iTOS then
      -- Check ToOver and convert random shaft tiles
      local aDugData<const> = oDugRandShaftData[iTOS];
      if aDugData then iTId = aDugData[random(#aDugData)];
      else iTId = iTOS end;
      -- Successful dig should search for treasure and if successful?
      -- Then increment the gem found counter for object and parent.
      if iFlags & DF.OG ~= 0 and RollTheDice(oObj.X, oObj.Y) then
        AdjObjParentStat(oObj, "GEM") end;
    end
    -- Set tiles if needed
    local iTAS<const> = aSubDigItem[5];
    if iTAS then iTIdA = iTAS end;
    local iTBS<const> = aSubDigItem[6];
    if iTBS then iTIdB = iTBS end;
    -- Set digger flags if needed
    if iFlags & DF.OB ~= 0 then oObj.F = oObj.F | OFL.BUSY end;
    if iFlags & DF.OI ~= 0 then oObj.F = oObj.F & OFL.iBUSY end;
    -- Update above tile if tile location if we can
    if iDP >= iLLAbsW then UpdateLevel(iDP - iLLAbsW, iTIdA) end;
    -- Update level
    UpdateLevel(iDP, iTId);
    -- Update below tile if tile location if we can
    if iDP < iLLAbs - iLLAbsW then UpdateLevel(iDP + iLLAbsW, iTIdB) end;
    -- Dig was successful
    return true;
  end
  -- Direction possibilities
  local oDirectionRequirements<const> = {
    [DIR.UL]      = DigDirectionUpLeft,   [iDUpRight] = DigDirectionUpRight,
    [DIR.L]       = DigDirectionLeft,     [iDRight]   = DigDirectionRight,
    [DIR.DL]      = DigDirectionDownLeft, [iDDown]    = DigDirectionDown,
    [iDDownRight] = DigDirectionDownRight
  };
  -- Actual dig tile function
  local function DigTile(oObj)
    -- Cache digging direction of object and if going left or up-left?
    local iDirection<const> = oObj.D;
    -- Return if no dig data for direction
    local fcbDirection<const> = oDirectionRequirements[iDirection];
    if not fcbDirection or not fcbDirection(oObj) then return false end;
    -- Get digging data table
    local aDigDataItem<const> = oDigData[iDirection];
    if not aDigDataItem then return false end;
    -- Walk through all the digger data structs to find info about current tile
    for iDigDataIndex = 1, #aDigDataItem do
      -- Get dig data and data about the specific tile to check for and if the
      -- adjacent tile id the object is at matches?
      local aDigItem<const> = aDigDataItem[iDigDataIndex];
      if iTId ~= aDigItem[1] then goto lNextDdItem end;
      -- Go through all the sub-possibilities
      for iDigDataSubIndex = 2, #aDigItem do
        -- Get sub-data, always assumed to be a table
        local aSubDigItem<const> = aDigItem[iDigDataSubIndex];
        -- Skip if the tile above the object isn't matched
        local iMTIdA<const> = aSubDigItem[1];
        if iMTIdA and iTIdA ~= iMTIdA then goto lNextSddItem end;
        -- Skip if the tile below the object isn't matched
        local iMTIdB<const> = aSubDigItem[2];
        if iMTIdB and iTIdB ~= iMTIdB then goto lNextSddItem end;
        -- Skip if the tile the object is on isn't matched
        local iMTIdC<const> = aSubDigItem[3];
        if iMTIdC and iTIdC ~= iMTIdC then goto lNextSddItem end;
        -- We can dig now and return if successful.
        if DoDig(oObj, aSubDigItem) then return true end;
        -- Continue mark
        ::lNextSddItem::
      end
      -- Continue mark
      ::lNextDdItem::
    end
    -- Dig failed
    return false;
  end
  -- == PHASE LOGIC ======================================================== --
  -- AI player entered trade centre logic ---------------------------------- --
  local function AIEnterTradeCentreLogic(oObj)
    -- Hide the digger
    SetAction(oObj, iAHide, iJPhase, iDRight);
    -- Get owner of this object
    local oParent<const> = oObj.P;
    -- Get the lowest amount of money a player has
    local iLowest, oOpponent = maxinteger;
    for iPlayerId = 1, #aPlayers do
      local oPlr<const> = aPlayers[iPlayerId];
      if oPlr ~= oParent then
        local iMoney<const> = oPlr.M;
        if iMoney < iLowest then oOpponent, iLowest = oPlr, iMoney end;
      end
    end
    -- If object is intelligent enough and a random number based on the money
    -- gap and the money to win?
    if random() >= oObj.IN and
       random() < (oParent.M - oOpponent.M) / iWinLimit / 4.0 then
      -- Try to purchase something random to keep the scores fair if objects
      -- owner has more money than the lowest player?
      BuyItem(oObj, aShopData[random(#aShopData)]);
    end
    -- Get object inventory and return if no inventory held
    local aObjInvList<const> = oObj.I;
    if #aObjInvList == 0 then return end;
    -- Number of items sold
    local iItemsSold = 0;
    -- Repeat for each item in digger inventory...
    local iObjId = 1 repeat
      -- Get the inventory object and if the gem is sellable or the
      -- object has a owner and doesn't belong to this objects owner?
      -- Then try to sell the item and if succeeded? Increment the
      -- items sold.
      local oObjInv<const> = aObjInvList[iObjId];
      local oParentInv<const> = oObjInv.P;
      if (CanSellGem(oObjInv.ID) or
         (oParentInv and oParentInv ~= oParent)) and
        SellItem(oObj, oObjInv) then iItemsSold = iItemsSold + 1;
      -- Conditions fail so try next inventory item.
      else iObjId = iObjId + 1 end;
    -- ...until we've enumerated the whole inventory.
    until iObjId > #aObjInvList;
    -- If items were sold? Check if any player won
    if iItemsSold > 0 and EndConditionsCheck() then return true end;
  end
  -- Take away phase health ------------------------------------------------ --
  local function UnphaseBegin(oObj, iDCommand)
    -- Is not teleport master and health reduction put the object in danger?
    if oObj.F & iFTPMaster == 0 and AdjustObjectHealth(oObj, -5) == 1 then
      -- Re-phase back into stance whilst in danger
      SetAction(oObj, iAPhase, iJInDanger, iDCommand);
      -- Re-phase back into stance
    else SetAction(oObj, iAPhase, iJNone, iDCommand) end;
  end
  -- Phasing home or to a Telepole logic ----------------------------------- --
  local function PhaseHomeOrTelepoleLogic(oObj)
    -- Go home?
    local bGoingHome = true;
    -- Get current teleport destinations
    local aDestinations<const> = oObj.TD;
    -- For each object
    for iObjDestIndex = 1, #aObjs do
      -- Get object
      local oTarget<const> = aObjs[iObjDestIndex];
      -- If object is a Telepole and object is owned by this object
      -- or object is a teleport master and Telepole status nominal?
      if oTarget.ID == iTyTelepole and
        (oTarget.P == oObj.P or oObj.F & iFTPMaster ~= 0) and
         oTarget.A == iAStop then
        -- Ignore Telepole?
        local bIgnoreTelepole = false;
        -- Enumerate teleport destinations...
        for IDI = 1, #aDestinations do
          -- Get destination and set true if we've been here before
          local oObjDest<const> = aDestinations[IDI];
          if oObjDest == oTarget then bIgnoreTelepole = true break end;
        end
        -- Don't ignore Telepole?
        if not bIgnoreTelepole then
          -- Teleport to this device
          SetPosition(oObj, oTarget.X, oTarget.Y);
          -- Take away health and restore object visibility
          UnphaseBegin(oObj, iDNone);
          -- Add it to ignore teleport destinations list for next time.
          aDestinations[1 + #aDestinations] = oTarget;
          -- Don't go home
          bGoingHome = false;
          -- Done
          break;
        end
      end
    end
    -- Return if not going home
    if not bGoingHome then return end;
    -- Clear objects ignore destination list
    UtilFlushArray(aDestinations);
    -- Set position of object to player's home
    local oPlrParent<const> = oObj.P;
    if oPlrParent then SetPosition(oObj, oPlrParent.HX, oPlrParent.HY) end;
    -- Take away health if not have teleportation enhancement
    UnphaseBegin(oObj, iDKeep);
  end
  -- Player entering trade centre logic ------------------------------------ --
  local function PlayerEnterTradeCentreLogic(oObj)
    -- Disable status screens
    SelectInfoScreen();
    -- Set new active object to this one if it isn't already
    SelectObject(oObj);
    -- Now in trade centre
    SetAction(oObj, iAHide, iJPhase, iDUpRight);
    -- We don't want to hear sounds
    SetPlaySounds(false);
    -- Init lobby
    InitLobby(false, 1);
  end
  -- Phase to a random target logic ---------------------------------------- --
  local function PhaseRandomTargetLogic(oObj)
    -- Walk objects list and find candidate objects to teleport to
    local aCandObjs<const> = { };
    for iCandObjId = 1, #aObjs do
      -- Get object and if the object isn't this object and object is
      -- a valid phase target? Insert into valid phase targets list.
      local aCandObj<const> = aObjs[iCandObjId];
      if aCandObj ~= oObj and aCandObj.F & iFPhaseTarget ~= 0 then
        aCandObjs[1 + #aCandObjs] = aCandObj;
      end
    end
    -- Have candidate objects?
    if #aCandObjs > 0 then
      -- Pick random object from array
      local aCandObj<const> = aCandObjs[random(#aCandObjs)];
      -- Set this objects position to the object
      SetPosition(oObj, aCandObj.X, aCandObj.Y);
      -- Re-phase back into stance
      SetAction(oObj, iAPhase, iJNone, iDKeep);
    -- Else if object has owner, teleport home
    elseif oObj.P then
      -- Set position of object to player's home
      SetPosition(oObj, oObj.P.HX, oObj.P.HY);
      -- Re-phase back into stance
      SetAction(oObj, iAPhase, iJNone, iDKeep);
    -- No owner = no home, just de-phase
    else SetAction(oObj, iAStop, iJNone, iDKeep) end;
  end
  -- Functions base on direction ------------------------------------------- --
  local oPhaseFunctions<const> = {
    [iDRight]     = AIEnterTradeCentreLogic,
    [DIR.U]       = PhaseHomeOrTelepoleLogic,
    [DIR.UL]      = PlayerEnterTradeCentreLogic,
    [iDDown]      = PhaseRandomTargetLogic,
    [iDDownRight] = PhaseRandomTargetLogic
  };
  -- == MAIN OBJECT LOGIC ================================================== --
  -- Object died? ---------------------------------------------------------- --
  local function ACTDeath(oObj)
    -- Return if not dead yet
    if oObj.AT < iTDeadWait then return end;
    -- Kill the object
    oObj.K = true;
    -- Skip object
    return true;
  end
  -- Object phasing? ------------------------------------------------------- --
  local function ACTPhase(oObj)
    -- Return if not phase time yet
    if oObj.AT < oObj.OD.TELEDELAY then return end;
    -- Reset object action timer since phasing again won't reset it and will
    -- instantly respawn the object
    oObj.AT = 0;
    -- Cache current direction as this direction controls where the object is
    -- going to teleport to (see the above 'oPhaseFunctions' table).
    local iDirection<const> = oObj.D;
    -- Object has finished phasing
    if oObj.J ~= iJPhase then
      -- Object was teleported eaten? Respawn as eaten!
      if iDirection == iDDownRight then
        SetAction(oObj, iAEaten, iJNone, iDLeftRight);
      -- Object not eaten? The object will reappear normally
      else SetAction(oObj, iAStop, iJNone, iDKeep) end;
      -- Done
      return false;
    end
    -- If not demo mode and this object is selected
    if not bAIvsAI and oObjActive == oObj then
      -- Not main players object? Deselect it so it cannot be tracked
      local oPlr<const> = oObj.P;
      if not oPlr or oPlr ~= oPlrActive then SelectObject() end;
    end
    -- Run function
    return oPhaseFunctions[iDirection](oObj);
  end
  -- Hiding? (trade centre) ------------------------------------------------ --
  local function ACTHide(oObj)
    -- Return if job wasn't to phase
    if oObj.J ~= iJPhase then return end;
    -- Health at full?
    if oObj.H >= 100 then
      -- Re-appear the object if is not the player otherwise wait for the
      -- real player to exit the trade centre.
      if oObj.D ~= iDUpRight then
        SetAction(oObj, iAPhase, iJNone, iDRight) end;
    end
    -- Keep object from becoming impatient
    oObj.JT = 0;
  end
  -- Eaten? ---------------------------------------------------------------- --
  local function ACTEaten(oObj)
    -- Return if not mutated into alien yet (60 seconds of game time).
    if oObj.AT < 3600 then
      -- Chance to gradually reduce health (1%) to give odds of object dying
      if random() < 0.01 then AdjustObjectHealth(oObj, -1) end;
      -- Done for now
      return;
    end
    -- Spawn mutant and kill digger
    local oMutant<const> = CreateObject(TYP.MUTANT, oObj.X, oObj.Y);
    if oMutant then AdjustObjectHealth(oObj, -100, oMutant);
    -- Couldn't spawn it so reset action timer to try again later
    else oObj.AT = 0 end;
  end
  -- Dying? (Explosives) returns true when exploded ------------------------ --
  local function ACTDying(oObj)
    return oObj.AT % 6 == 5 and AdjustObjectHealth(oObj, -1) == -1;
  end
  -- Move object functions ------------------------------------------------- --
  local function OBJMoveUp(oObj) MoveY(oObj, -1) end;
  local function OBJMoveDown(oObj) MoveY(oObj, 1) end;
  local function OBJMoveLeft(oObj) MoveX(oObj, -1) end;
  local function OBJMoveRight(oObj) MoveX(oObj, 1) end;
  -- Object move callbacks ------------------------------------------------- --
  local oMoveFuncs<const> = {
    [DIR.U]       = OBJMoveUp,     [iDDown]  = OBJMoveDown,
    [iDNone]      = BlankFunction, [DIR.UL]  = OBJMoveLeft,
    [DIR.L]       = OBJMoveLeft,   [DIR.DL]  = OBJMoveLeft,
    [iDUpRight]   = OBJMoveRight,  [iDRight] = OBJMoveRight,
    [iDDownRight] = OBJMoveRight
  };
  -- Train move data ------------------------------------------------------- --
  local oTrainMoveData<const> = {
    [DIR.L] = { 7, -1 }, [iDRight] = { 9, 1 }, [iDNone] = { 0, 0 },
  };
  -- Run procedure --------------------------------------------------------- --
  local function ACTRun(oObj)
    -- Object wants to dig down and object X position is in the middle of
    -- the tile?
    if oObj.J == iJDigDown and oObj.X % 16 == 0 then
      -- Make object dig down
      SetAction(oObj, ACT.DIG, iJDigDown, iDDown);
      -- Done
      return;
    end
    -- Object wants to enter the trading centre? Stop object
    if oObj.J == JOB.HOME and ObjectIsAtHome(oObj) then
      -- If object can't enter? Just stop it.
      if oObj.F & OFL.NOHOME ~= 0 then
        SetAction(oObj, iAStop, iJNone, iDNone);
      -- Go into trade centre and if successful? Prevent diggers entering
      elseif SetAction(oObj, iAPhase, iJPhase, DIR.UL) then
        SetAllDiggersNoHome(oObj.P.D) end;
      -- Done
      return;
    end
    -- Object is for rails only and train is not on track
    if oObj.F & OFL.TRACK ~= 0 then
      -- Get X pos adjust depending on direction
      local aTrainMoveItem<const> = oTrainMoveData[oObj.D];
      -- Get absolute tile position and if valid?
      local iLoc<const> = GetLevelOffsetFromObject(oObj, aTrainMoveItem[1], 0);
      if not iLoc then return end;
      -- Train on track? Move the train!
      if aTileData[1 + aLvlData[1 + iLoc]] & oTileFlags.T ~= 0 then
        MoveX(oObj, aTrainMoveItem[2]);
      -- Train not on track and was searching? Move in opposite direction.
      elseif oObj.J == iJSearch and oObj.AT > 0 then
        SetAction(oObj, iAKeep, iJKeep, iDOpposite);
      -- Train was not moving so keep stopped
      else SetAction(oObj, iAStop, iJNone, iDNone) end;
      -- Done
      return;
    end
    -- Unset busy flag as abnormal digging can make it stick for every one
    -- second of game time and object is busy.
    if oObj.AT >= 60 and
       oObj.F & iFBusy ~= 0 then oObj.F = oObj.F & OFL.iBUSY end;
    -- Get function associated with direction and move appropriately. It is
    -- assumed that all directions are catered for thus no check required.
    oMoveFuncs[oObj.D](oObj);
  end
  -- Walk procedure -------------------------------------------------------- --
  local function ACTWalk(oObj)
    -- Return if walk time not reached yet
    if oObj.AT % 2 ~= 0 then return end;
    -- Process movement
    ACTRun(oObj);
  end
  -- Creep procedure ------------------------------------------------------- --
  local function ACTCreep(oObj)
    -- Return if creep time not reached yet
    if oObj.AT % 4 ~= 0 then return end;
    -- Process movement
    ACTRun(oObj);
  end
  -- Digging procedure ----------------------------------------------------- --
  local function ACTDig(oObj)
    -- Return if digging time not reached yet
    if oObj.AT < oObj.DID then return end;
    -- Terrain dig was successful?
    if DigTile(oObj) then
      -- Get last dig action and if set?
      local iLast<const> = oObj.LA;
      if iLast then
        -- Continue to move in the direction
        SetAction(oObj, iLast, iJKeep, iDKeep);
        -- Remove the last action
        oObj.LA = nil;
      -- Impossible but stop the object's actions completely
      else SetAction(oObj, iAStop, iJNone, iDKeep) end;
      -- Increase dig count
      AdjObjParentStat(oObj, "DUG");
      -- Update dig time for AI
      oObj.LDT = iGameTicks;
      return;
    end
    -- Remove the last action, update failed dig direction and set impatient
    oObj.LA, oObj.FDD, oObj.JT = nil, oObj.D, oObj.PW;
    -- Stop the object's actions completely
    SetAction(oObj, iAStop, iJNone, iDKeep);
  end
  -- Resting procedure ----------------------------------------------------- --
  local function ACTRest(oObj)
    -- Reset action if finished resting
    if oObj.H >= 100 then SetAction(oObj, iAStop, iJNone, iDNone) end;
  end
  -- Action lookup table --------------------------------------------------- --
  local oOnGroundActions<const> = {
    [ACT.CREEP] = ACTCreep, [iADeath]  = ACTDeath, [ACT.DIG] = ACTDig,
    [ACT.DYING] = ACTDying, [iAEaten]  = ACTEaten, [iAHide]  = ACTHide,
    [iAPhase]   = ACTPhase, [ACT.REST] = ACTRest,  [iARun]   = ACTRun,
    [ACT.WALK]  = ACTWalk
  };
  -- Actions to ignore when checking collisions ---------------------------- --
  local oCollisionIgnoredActions<const> =
    { [iAPhase] = true, [iAHide] = true, [iADeath] = true, [iAEaten] = true };
  -- Fighting frame data (there's 5 frames in each fight animation) -------- --
  local aFightData<const> = { [2] = oSfxData.KICK, [4] = oSfxData.PUNCH };
  -- Process object jump logic --------------------------------------------- --
  local function ProcessJumpLogic(oObj, aData, iLimit, iStep)
    -- Return if there are no more pixels to move
    local iActionTimer<const> = oObj.AT;
    if iActionTimer >= #aData then return true end;
    -- Return if we're not moving in this frame
    local iYMove<const> = aData[1 + iActionTimer];
    if iYMove == 0 then return end;
    -- Check each pixel whilst jumping
    for iY = iYMove, iLimit, iStep do
      -- No collision? Move and return to continue to next frame
      if not IsCollideY(oObj, iY) then AdjustPosY(oObj, iY) return end;
    end
    -- Rise or fall aborted so make sure caller knows
    return true;
  end
  -- Check object is in water at specified pixel height -------------------- --
  local function CheckObjectInWater(oObj, iY)
    -- Get tile at the specified position from object and return if water
    local iId<const> = GetLevelDataFromObject(oObj, 8, iY);
    return iId and aTileData[1 + iId] & iTFW ~= 0;
  end
  -- Actions that are ignored when checking for obj collisions and water --- --
  local oIgnoreCollideActions<const> = { [iAPhase] = true, [iADeath] = true };
  -- Main game tick function ----------------------------------------------- --
  local function GameProc()
    -- Check if we need to horizontally scroll the viewport and if we do?
    local iDifference = iPixPosTargetX - iPixPosX;
    if iDifference ~= 0 then
      -- Check if we need to vertically scroll the viewport and if we do?
      local iDifferenceY<const> = iPixPosTargetY - iPixPosY
      if iDifferenceY ~= 0 then
        -- Scroll the viewport both horizontally and vertically
        AdjustViewport(UtilSign(iDifference) * ceil(abs(iDifference) / 16),
                       UtilSign(iDifferenceY) * ceil(abs(iDifferenceY) / 16));
      -- Scroll the viewport horizontally only
      else AdjustViewportX(UtilSign(iDifference) *
        ceil(abs(iDifference) / 16)) end;
    -- We don't need to scroll the viewport horizontally?
    else
      -- Check if we need to vertically scroll the viewport and if we do?
      iDifference = iPixPosTargetY - iPixPosY
      if iDifference ~= 0 then
        -- Scroll the viewport vertically only
        AdjustViewportY(UtilSign(iDifference) * ceil(abs(iDifference) / 16));
      end
    end
    -- Ignore if we're in slowdown mode
    if iGameTicks % iSlowDown ~= 0 then iGameTicks = iGameTicks + 1 return end;
    -- For every 1/6th of a game second we can process terrain animations
    if iGameTicks % 10 == 0 then
      -- For each screen row we are looking at
      for iY = 0, iScrTilesHm1 do
        -- Calculate the Y position to grab from the level data. The extra 1
        -- takes care of the 1-indexed array limitation.
        local iYdest<const> = (iAbsPosY + iY) * iLLAbsW + iAbsPosX + 1;
        -- For each screen column we are looking at
        for iX = 0, iScrTilesWm1 do
          -- Get tile position and get tile id and if tile is not air?
          local iPos<const> = iYdest + iX;
          local iTileId<const> = 1 + aLvlData[iPos];
          if iTileId ~= 1 then
            -- Get tile flags and if flags say we should animate to next tile?
            local iFlags<const> = aTileData[iTileId];
            if iFlags & iTFAnimateBegin ~= 0 then aLvlData[iPos] = iTileId;
            -- Tile is end of animation so go back 3 sprites. This rule means
            -- that all animated terrain tiles must be 4 sprites.
            elseif iFlags & iTFAnimateEnd ~= 0 then
              aLvlData[iPos] = iTileId - 4 end;
          end
        end
      end
    end
    -- If we have flood data to process?
    if #aFloodData > 0 then
      -- Get flood item
      local aFloodItem<const> = aFloodData[1];
      -- Remove from global list
      remove(aFloodData, 1);
      -- Get position and tile flags being flooded and if tile exposes left?
      local iTilePos<const>, iTileFlags<const> = aFloodItem[1], aFloodItem[2];
      -- If tile flags are exposed to the left?
      if iTileFlags & oTileFlags.EL ~= 0 then
        -- Get information about the tile on the left and skip if invalid
        local iPosition<const> = iTilePos - 1;
        local iTileId<const> = GetLevelDataFromLevelOffset(iPosition);
        if not iTileId then goto lFloodLeftDone end;
        -- Get file flags and skip if is not water and right edge is not
        -- exposed.
        local iTileFlags<const> = aTileData[1 + iTileId];
        if iTileFlags & oTileFlags.W ~= 0 or
           iTileFlags & oTileFlags.ER == 0 then goto lFloodLeftDone end;
        -- If the tile is a flood gate tile?
        if iTileFlags & oTileFlags.G ~= 0 then
          -- Get transformation information about this floodgate tile
          local aFGDItem<const> = oFloodGateData[iTileId][1];
          -- Update the flooded gate tile
          aLvlData[1 + iPosition] = aFGDItem[1];
          -- Continue flooding if needed
          if aFGDItem[2] then
            aFloodData[1 + #aFloodData] = { iPosition, iTileFlags } end;
          -- Done
          goto lFloodLeftDone;
        end
        -- Update tile to the same tile with water in it
        aLvlData[1 + iPosition] = iTileId + 240;
        -- Continue flooding if the left edge of the tile is exposed
        if iTileFlags & oTileFlags.EL ~= 0 then
          aFloodData[1 + #aFloodData] = { iPosition, iTileFlags } end;
        -- Finished checking for flood on left
        ::lFloodLeftDone::
      end
      -- If tile flags are exposed to the right?
      if iTileFlags & oTileFlags.ER ~= 0 then
        -- Get information about the tile on the right and skip if invalid
        local iPosition<const> = iTilePos + 1;
        local iTileId<const> = GetLevelDataFromLevelOffset(iPosition);
        if not iTileId then goto lFloodRightDone end;
        -- Get file flags and if is water and the left edge is exposed?
        local iTileFlags<const> = aTileData[1 + iTileId];
        if iTileFlags & oTileFlags.W ~= 0 or
           iTileFlags & oTileFlags.EL == 0 then goto lFloodRightDone end;
        -- If the tile is a flood gate tile?
        if iTileFlags & oTileFlags.G ~= 0 then
          -- Get transformation information about this floodgate tile
          local aFGDItem<const> = oFloodGateData[iTileId][2];
          -- Update the flooded gate tile
          aLvlData[1 + iPosition] = aFGDItem[1];
          -- Continue flooding if data requests it
          if aFGDItem[2] then
            aFloodData[1 + #aFloodData] = { iPosition, iTileFlags } end;
          -- Done
          goto lFloodRightDone;
        end
        -- Update tile to the same tile with water in it
        aLvlData[1 + iPosition] = iTileId + 240;
        -- Continue flooding if the left edge of the tile is exposed
        if iTileFlags & oTileFlags.ER ~= 0 then
          aFloodData[1 + #aFloodData] = { iPosition, iTileFlags } end;
        -- Finished checking for flood on right
        ::lFloodRightDone::
      end
      -- If tile flags are exposed below?
      if iTileFlags & oTileFlags.EB ~= 0 then
        -- Get information about the tile below and skip if not valid
        local iPosition<const> = iTilePos + iLLAbsW;
        local iTileId<const> = GetLevelDataFromLevelOffset(iPosition);
        if not iTileId then goto lFloodBottomDone end;
        -- Get file flags and skip if is not water or the top edge not
        -- exposed?
        local iTileFlags<const> = aTileData[1 + iTileId];
        if iTileFlags & oTileFlags.W ~= 0 or
           iTileFlags & oTileFlags.ET == 0 then goto lFloodBottomDone end;
        -- Update tile to the same tile with water in it and continue
        aLvlData[1 + iPosition] = iTileId + 240;
        aFloodData[1 + #aFloodData] = { iPosition, iTileFlags };
        -- Finished checking for flood on bottom
        ::lFloodBottomDone::
      end
    end
    -- Have any objects?
    if #aObjs > 0 then
      -- Object index
      local iObjId = 1;
      -- Label for jumping straight back to processing the object index
      ::lTop::
      -- Get the object at the specified index
      local oObj<const> = aObjs[iObjId];
      -- Call AI function. Blank function if object doesn't have AI
      oObj.AIF(oObj);
      -- If object is floating?
      if oObj.F & iFFloat ~= 0 then
        -- Get tile position and get tile id from level and return if not water
        if not CheckObjectInWater(oObj, 13) then
          -- Floating if the pixel below is water
          if not CheckObjectInWater(oObj, 14) then
            -- Remove floating flag and all fall back
            oObj.F = (oObj.F | iFFall) & iFiFloating;
            -- Not floating so can fall
            goto lFallCheck;
          end
        -- Is in water?
        else
          -- Set floating flag and remove fall flag
          oObj.F = (oObj.F | iFFloating) & iFiFall;
          -- Rise
          MoveY(oObj, -1);
        end
        -- Object is still floating so skip falling procedure
        goto lImpact;
      end
      -- Check for fall
      ::lFallCheck::
      -- If object is falling?
      if oObj.F & iFFall ~= 0 then
        -- Start from fall speed pixels
        local iYAdj = oObj.FS;
        goto lContinueGroundCheck;
        -- Decrement each pixel to check by one
        ::lNextPixelGroundCheck:: iYAdj = iYAdj - 1;
        -- Starting or continue point
        ::lContinueGroundCheck::
        -- Until we no longer find a floor collision
        if iYAdj < 1 then goto lImpact end;
        -- No collision found with terrain?
        if IsCollideY(oObj, iYAdj) then goto lNextPixelGroundCheck end;
        -- Move Y position down
        MoveY(oObj, iYAdj);
        -- Get fall speed
        local iFallSpeed<const> = oObj.FS;
        -- Increase fall speed and clamp maximum speed to half a tile
        if iFallSpeed < 8 then oObj.FS = iFallSpeed + 1 end;
        -- increase fall damage
        oObj.FD = oObj.FD - iFallSpeed;
        -- Still falling
        goto lFallingDone;
      end
      -- Label to end falling
      ::lImpact::
      -- Reset fall speed
      oObj.FS = 1;
      -- Processing fall damage
      do
        -- Get fall damage and skip if there isn't any
        local iDamage = oObj.FD;
        if iDamage >= 0 then goto lDamageDone end;
        -- Reset fall damage
        oObj.FD = 0;
        -- No damage if fell 10 pixels or less
        if iDamage >= -10 then goto lDamageDone end;
        -- Damage is 1 per 8 pixels, return if still no damage
        iDamage = iDamage // 8;
        -- Skip if object flags snuck in removing the fall flag during falling
        local iFlags<const> = oObj.F;
        if iFlags & iFFall == 0 then goto lDamageDone end;
        -- Object is delicate? Remove more health
        if iFlags & iFDelicate ~= 0 then iDamage = iDamage;
                                    else iDamage = iDamage // 2 end;
        -- Reduce health and stop object if fell too much
        if AdjustObjectHealth(oObj, iDamage) == 1 then
          SetAction(oObj, iAStop, iJInDanger, iDNone) end;
      end
      -- Skipped taking damage
      ::lDamageDone::
      -- Object is jumping?
      if oObj.F & iFJumpRise ~= 0 then
        -- If object has finished jumping?
        if ProcessJumpLogic(oObj, aJumpRiseData, -1, 1) then
          -- Remove rising and set falling flags
          oObj.F = (oObj.F | iFJumpFall) & iFiJumpRise;
          -- Reset action timer
          oObj.AT = 0;
        end
      -- Object is falling and finished falling?
      elseif oObj.F & iFJumpFall ~= 0 and
             ProcessJumpLogic(oObj, aJumpFallData, 1, -1) then
        -- Let object fall normally now and remove busy and falling flags
        oObj.F = (oObj.F | iFFall) & iFiJumpFallBusy;
        -- Thus little tweak makes sure the user can't jump again by just
        -- modifying the fall speed as ACT.JUMP requires it to be 1.
        oObj.FS = 2;
      end
      -- Check physics for current action
      do
        -- Get behaviour function for current action if returns true?
        local fcbAction<const> = oOnGroundActions[oObj.A];
        if fcbAction and fcbAction(oObj) then
          -- If object is to be destroyed, do it then goto next object
          if oObj.K then DestroyObject(iObjId, oObj) goto lObjNextNoInc end;
          -- Skip processing rest of objects
          goto lObjNext;
        end
      end
      -- Pickup objects if searching and every 1/6th of a second of game time
      if oObj.J == iJSearch and oObj.AT % 10 == 0 then
        PickupObjects(oObj, iFPuGemMask, iFPuGemEq);
      -- If object is in danger and danger timeout is reached?
      elseif oObj.J == iJInDanger and oObj.AT >= iTDeadWait then
        -- The action timer must be reset which SetAction() might not if the
        -- requested action is already active so if the object suddenly gets
        -- put in danger again, it will be instantly cleared.
        oObj.AT = 0;
        -- Object is running? Start walking instead but clear job unset
        -- danger flag.
        if oObj.A == iARun then SetAction(oObj, iAWalk, iJNone, iDKeep);
        -- Keep action and direction but clear job unsetting danger
        else SetAction(oObj, iAKeep, iJNone, iDKeep) end;
      end
      -- Regenerate health if object regenerates health
      if oObj.F & iFRegenerate ~= 0 and
         oObj.AT % oObj.SM == oObj.SMM1 then AdjustObjectHealth(oObj, 1) end;
      -- Skipped falling
      ::lFallingDone::
      -- Skip checking object collisions and water checks with certain actions
      if oIgnoreCollideActions[oObj.A] then goto lObjFrozen end;
      -- Do we have more than one object? Check object collision logic.
      -- Warning: This scope needs optimising if we can. It is EXTREMELY slow
      -- meaning this only lets us add up to around 300 objects per level.
      if #aObjs > 1 then
        -- Initialise object id and begin scanning targets
        local iObjId = 1;
        goto lContinue;
        -- Restart point to increment object id
        ::lRestart::
        iObjId = iObjId + 1;
        -- If we've run out of targets to check?
        ::lContinue::
        if iObjId > #aObjs then
          -- Fight target was found? Process the fight and clear fight target
          local oFTarget<const> = oObj.FT;
          if oFTarget then
            -- If not fighting and we're still on the same sprite tile?
            if oObj.A ~= iAFight or oObj.S == oObj.FN then
              -- Clear fight target
              oObj.FT = nil;
              -- Done checking collisions
              goto lCollisionDone;
            end
            -- This routine cant happen again in this sprite frame
            oObj.FN = oObj.S;
            -- Return if this frame is important or a chance to miss
            local iSound<const> = aFightData[oObj.S % 5];
            if not iSound or random() < 0.25 then goto lCollisionDone end;
            -- Generate random damage relative to the strength of the digger
            local iDamage = oObj.STRF - random(3);
            -- If digger is intelligent enough and target isn't then double
            -- damage!
            if random() >= oObj.IN and
               random() < oFTarget.IN then iDamage = iDamage * 2 end;
            -- Play the sound with a random pitch
            PlaySoundAtObject(oFTarget, iSound, 0.9 + (random() % 0.1));
            -- Adjust health and skip if still in good health, died or not
            -- intelligent enough to run away from opponent.
            if AdjustObjectHealth(oFTarget, iDamage, oObj) <= 0 or
               random() < oObj.IN then goto lCollisionDone end;
            -- Run in opposite direction
            SetAction(oObj, iARun, iJInDanger, iDOpposite);
            -- Done checking collisions
            goto lCollisionDone;
          end
          -- Return if not fighting or object isn't a digger and timer under
          -- six seconds.
          if oObj.A ~= iAFight or
             (oObj.F & iFDigger == 0 and oObj.AT < 360) then
            goto lCollisionDone end;
          -- Stop fighting
          SetAction(oObj, iAStop, iJInDanger, iDKeep);
          -- Done checking collisions
          goto lCollisionDone;
        end
        -- Return if target is object or object dead or target dead
        local oTarget<const> = aObjs[iObjId];
        if oTarget == oObj then goto lRestart end;
        -- Get target flags and skip if target not a digger or is water based
        local iTFlags<const> = oTarget.F;
        if iTFlags & iFDigWBase ~= iFDigger then goto lRestart end;
        -- Get target object action and skip if target has ignored action
        local iTAction<const> = oTarget.A;
        if oCollisionIgnoredActions[iTAction] then goto lRestart end;
        -- Get source object action and skip if target not colliding with obj
        if not maskSpr:IsCollideEx(477, oObj.X, oObj.Y, maskSpr, 477,
          oTarget.X, oTarget.Y) then goto lRestart end;
        -- Get source object flags and if object can consume the object?
        local iFlags<const> = oObj.F;
        if iFlags & iFConsume == 0 then goto lCantConsumeDigger end
        -- Kill consumer
        AdjustObjectHealth(oObj, -100, oTarget);
        -- Eat digger and set it to busy
        SetAction(oTarget, iAEaten, iJKeep, iDKeep);
        -- This digger is selected by the client? Unset control menu
        if oObjActive == oTarget then SetContextMenu() end;
        -- Test next object
        goto lRestart;
        -- Object cannot consume the digger if we get here
        ::lCantConsumeDigger::
        -- Skip if object can't hase the Digger
        if iFlags & iFPhaseDigger == 0 then goto lCantPhaseDigger end;
        -- Phase target to another object
        SetAction(oTarget, iAPhase, iJPhase, iDDown);
        -- Test next object
        goto lRestart;
        -- Object cannot phase the digger if we get here
        ::lCantPhaseDigger::
        -- Skip if object can't heal the Digger
        if iFlags & iFHealNearby == 0 then goto lCantHealDigger end;
        -- Increase health
        AdjustObjectHealth(oTarget, 1, oObj);
        -- Test next object
        goto lRestart;
        -- Object cannot heal the digger if we get here
        ::lCantHealDigger::
        -- Skip if object cannot hurt the Digger
        if iFlags & iFHurtDigger == 0 then goto lNoHurtDigger end;
        -- Object is stationary? Make me fight and face the digger
        if iFlags & iFStationary ~= 0 then
          SetAction(oObj, iAFight, iJNone,
            GetTargetDirection(oObj, oTarget));
        -- Change to objects direction if object moving parallel to Digger
        elseif iFlags & iFPursueDigger ~= 0 then
          SetAction(oObj, iAKeep, iJKeep,
            GetTargetDirection(oObj, oTarget)) end;
        -- Target is not jumping?
        if iTFlags & iFJumping == 0 then
          -- If target action isn't running? Run opposite direction
          if iTAction ~= iARun then
            SetAction(oTarget, iARun, iJInDanger,
              GetTargetDirection(oObj, oTarget));
          -- Already running so make sure danger is set
          else SetAction(oTarget, iARun, iJInDanger, iDKeepMoving) end;
        -- Jumping so bypass SetAction() and set object in danger
        else oTarget.J = iJInDanger end;
        -- Reduce health
        AdjustObjectHealth(oTarget, -1, oObj);
        -- Test next object
        goto lRestart;
        -- Object cannot hurt the digger if we get here
        ::lNoHurtDigger::
        -- Skip if object is not dangerous
        if iFlags & iFDangerous == 0 then goto lNotDangerous end;
        -- If target isn't jumping?
        if iTFlags & iFJumping == 0 then
          -- If target action isn't running? Run opposite direction
          if iTAction ~= iARun then
            SetAction(oTarget, iARun, iJInDanger,
              GetTargetDirection(oObj, oTarget));
          -- Already running so keep moving
          else SetAction(oTarget, iARun, iJInDanger, iDKeepMoving) end;
        -- Jumping so bypass SetAction() and set object in danger
        else oTarget.J = iJInDanger end;
        -- Test next object
        goto lRestart;
        -- Object is not dangerous to the digger if we get here
        ::lNotDangerous::
        -- Return if object...
        if iFlags & iFDigBusy ~= iFDigger or -- ...is not a Digger or busy?
           iTFlags & iFBusy ~= 0 or          -- *or* target object busy?
           iTAction == iAJump or             -- *or* target jumping
           oObj.FT or                        -- *or* has a fight target?
           oObj.P == oTarget.P or            -- *or* same owner?
           (oObj.A ~= iAFight and            -- *or* object not fighting?
            oObj.AT < 30) then               -- *and* < 1/2 sec action timer
          goto lRestart end;
        -- Make us face the target
        SetAction(oObj, iAFight, iJInDanger,
          GetTargetDirection(oObj, oTarget));
        -- Fight and set objects fight target
        oObj.FT = oTarget;
        -- Return if target is fighting or not time to fight yet?
        if oTarget.FT or oTarget.AT < 30 then goto lRestart end;
        -- Make target fight the object
        SetAction(oTarget, iAFight, iJInDanger,
          GetTargetDirection(oTarget, oObj));
        -- Set targets fight target to this object
        oTarget.FT = oObj;
        -- Test next object
        goto lRestart;
      end
      -- Skipped checking collision logic
      ::lCollisionDone::
      -- In or out of water check
      do
        -- Get object flags
        local iFlags<const> = oObj.F;
        -- If object is not in water
        if not CheckObjectInWater(oObj, 2) then
          -- Remove in water flag if set
          if iFlags & iFInWater ~= 0 then oObj.F = iFlags & iFiInWater end
          -- Ignore if object is not water based
          if iFlags & iFWaterBased == 0 then goto lUnderwaterDone end;
          -- Only reduce health once per water breathing amount
          if oObj.AT % oObj.LC == 0 then AdjustObjectHealth(oObj, -1) end;
          -- Done
          goto lUnderwaterDone;
        end
        -- Add in water flag if not set.
        if iFlags & iFInWater == 0 then oObj.F = iFlags | iFInWater end;
        -- Ignore if object can breath underwater
        if iFlags & iFAquaLung ~= 0 then goto lUnderwaterDone end;
        -- If object is a digger and it isn't in danger? Run!
        if iFlags & iFDigger ~= 0 and oObj.J ~= iJInDanger then
          SetAction(oObj, iARun, iJInDanger, iDKeepMoving) end;
        -- Only reduce health once per four game ticks
        if oObj.AT % oObj.LC == 0 then AdjustObjectHealth(oObj, -1) end;
      end
      -- Skipped checking object underwater
      ::lUnderwaterDone::
      -- Apply any inventory perks the object has
      do
        -- Get objects inventory and skip if no inventory
        local aObjInv<const> = oObj.I;
        if #aObjInv == 0 then goto lObjFrozen end;
        -- Repeat over each inventory item. Have to use repeat/until with
        -- deletions.
        local iObjInvItemIndex = 1 repeat
          -- Get object in inventory and if item is first aid, holder damaged
          -- and object is intelligent enough to use it?
          local oObjInvItem<const> = aObjInv[iObjInvItemIndex];
          if oObjInvItem.ID == iTyFirstAid and oObj.H < 100 and
             random() >= oObj.IN then
            -- Increase holder's health and decrease first aid health
            AdjustObjectHealth(oObj, 1, oObjInvItem);
            AdjustObjectHealth(oObjInvItem, -1, oObj);
          end
          -- Item has health or couldn't drop object? Enumerate next item!
          if oObjInvItem.H > 0 or not DropObject(oObj, oObjInvItem) then
            iObjInvItemIndex = iObjInvItemIndex + 1 end;
        -- Until there is no more inventory to process
        until iObjInvItemIndex > #aObjInv;
      end
      -- Skipped checking collision, water and inventory logic
      ::lObjFrozen::
      -- Process object animations
      do
        -- If sprite timer and not reached speed limit?
        if oObj.ST < oObj.ANT then
          -- Increment sprite timer
          oObj.ST = oObj.ST + 1;
          -- Done for now
          goto lObjAnimateDone;
        end
        -- Reset sprite timer
        oObj.ST = 0;
        -- Sprite id not reached the sprite limit yet
        if oObj.S < oObj.S2 then
          -- Increment sprite and attachment number
          oObj.S, oObj.SA = oObj.S + 1, oObj.SA + 1;
          -- Done for now
          goto lObjAnimateDone;
        end
        -- Done if sprite can't reset
        if oObj.F & OFL.NOANIMLOOP ~= 0 then goto lObjAnimateDone end;
        -- Restart sprite number
        oObj.S, oObj.SA = oObj.S1, oObj.S1A;
        -- Done if we're not playing the sound for the animation reset
        if oObj.F & OFL.SOUNDLOOP == 0 then goto lObjAnimateDone end;
        -- Check if theres a sound to play and if there is?
        local iSound = oObj.AD.SOUND;
        if iSound then
          -- Play the requested sound
          PlaySoundAtObject(oObj, iSound);
          -- Done for now
          goto lObjAnimateDone;
        end
        -- Check if theres a sound with random pitch to play and if there is?
        iSound = oObj.AD.SOUNDRP;
        if iSound then
          -- Play the requested sound with random pitch
          PlaySoundAtObject(oObj, iSound, 1.0 + (random() % 0.1 - 0.05));
          -- Done for now
          goto lObjAnimateDone;
        end
      end
      -- Skipped animating object
      ::lObjAnimateDone::
      -- Increase action and job timer
      oObj.AT, oObj.JT = oObj.AT + 1, oObj.JT + 1;
      -- Label for when needing to jump to the next object
      ::lObjNext::
      -- Process next object
      iObjId = iObjId + 1;
      -- Label for when needing to jump to the next object without incrementing
      ::lObjNextNoInc::
      -- Jump to the next object if theres still more
      if iObjId <= #aObjs then goto lTop end;
    end
    -- If a second of game time has passed?
    if iGameTicks % 60 == 0 then
      -- Get player diggers and enumerate them
      local aDiggers<const> = oPlrActive.D;
      for iDiggerId = 1, #aDiggers do
        -- Get digger and if digger is alive and job is in danger?
        local oDigger<const> = aDiggers[iDiggerId];
        if oDigger and oDigger.J == iJInDanger then
          -- Play warning sound
          PlayInterfaceSound(iSError);
          -- But only once
          break;
        end
      end
      -- If at a five minute interval?
      if iGameTicks % 18000 ~= 0 then
        -- Rotate gems in bank and move first gem to last gem
        aGemsAvailable[1 + #aGemsAvailable] = aGemsAvailable[1];
        remove(aGemsAvailable, 1);
      end
    end
    -- Increment game ticks processed count
    iGameTicks = iGameTicks + 1;
  end
  -- Return actual game proc function
  return GameProc;
end
-- When scripts have loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI, _, oAPI)
  -- Functions and variables used in this scope only
  local AdjustViewportNoScroll<const>, GetTileUnderMouse<const>,
    InitPause<const>, IsMouseInBounds<const>, RegisterHotSpot<const>,
    RegisterKeys<const>, SetCursor<const>, oCursorIdData<const> =
      GetAPI("AdjustViewportNoScroll", "GetTileUnderMouse", "InitPause",
        "IsMouseInBounds", "RegisterHotSpot", "RegisterKeys", "SetCursor",
        "oCursorIdData");
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
  -- Frequently used integers
  local iAClose<const>, iACreep<const>, iADeploy<const>, iADrop<const>,
    iADying<const>, iAGrab<const>, iAJump<const>, iAMap<const>, iAOpen<const>,
    iAPhase<const>, iARun<const>, iAStop<const>, iAWalk<const>,
    iCSelect<const>, iDDown<const>, iDDownLeft<const>, iDDownRight<const>,
    iDHome<const>, iDKeep<const>, iDLeft<const>, iDLeftRight<const>,
    iDNone<const>, iDRight<const>, iDTileCentre<const>, iDUp<const>,
    iDUpLeft<const>, iDUpRight<const>, iFBusy<const>, iFDevice<const>,
    iFNoHome<const>, iJDig<const>, iJDigDown<const>, iJHome<const>,
    iJKeep<const>, iJNone<const>, iJPhase<const>, iJSearch<const>,
    iMDrop<const>, iMNone<const>, iSClick<const>, iSError<const>,
    iSSelect<const>, iTyJennite<const>, iTyTNT<const> =
      ACT.CLOSE, ACT.CREEP, ACT.DEPLOY, ACT.DROP, ACT.DYING, ACT.GRAB,
      ACT.JUMP, ACT.MAP, ACT.OPEN, ACT.PHASE, ACT.RUN, ACT.STOP, ACT.WALK,
      oCursorIdData.SELECT, DIR.D, DIR.DL, DIR.DR, DIR.HOME, DIR.KEEP, DIR.L,
      DIR.LR, DIR.NONE, DIR.R, DIR.TCTR, DIR.U, DIR.UL, DIR.UR, OFL.BUSY,
      OFL.DEVICE, OFL.NOHOME, JOB.DIG, JOB.DIGDOWN, JOB.HOME, JOB.KEEP,
      JOB.NONE, JOB.PHASE, JOB.SEARCH, MNU.DROP, MNU.NONE, oSfxData.CLICK,
      oSfxData.ERROR, oSfxData.SELECT, TYP.JENNITE, TYP.TNT;
  -- Select digger if active
  local function SelectDigger(iDiggerId)
    local oDigger<const> = oPlrActive.D[iDiggerId];
    if not oDigger then return PlayStaticSound(iSError) end;
    SelectObject(oDigger, false);
    PlayStaticSound(iSClick);
  end
  -- Select an adjacent digger
  local function SelectAdjacentDigger(iAmount)
    -- Find the object we selected first
    local aDiggers<const>, iCurrentDigger = oPlrActive.D;
    for iI = 1, #aDiggers do
      if oObjActive == aDiggers[iI] then iCurrentDigger = iI break end
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
      local oDigger<const> = aDiggers[1 + ((iI - 1) % #aDiggers)];
      if oDigger then
        -- Play success sound, select the object and return
        PlayStaticSound(iSClick);
        return SelectObject(oDigger, false);
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
      if aContextMenu and aContextMenu == oMenuData[iMDrop] then
        CycleObjInventory(oObjActive, -1);
      -- Else select the last digger
      else SelectLastDigger() end;
    -- Scrolling up?
    elseif nY > 0 then
      -- Cycle to next item if digger inventory menu open?
      if aContextMenu and aContextMenu == oMenuData[iMDrop] then
        CycleObjInventory(oObjActive, 1);
      -- Else select the next digger
      else SelectNextDigger() end;
    end
  end
  -- Helper for digging
  local function GenericAction(iAction, iJob, iDirection)
    -- Return if object not selected or not mine or not busy.
    if not oObjActive or oObjActive.P ~= oPlrActive or
      oObjActive.F & iFBusy ~= 0 then return end;
    -- Get object data and if requesting special movement detection?
    local oObjData<const> = oObjActive.OD;
    if iAction == 0 then
      -- If object can walk?
      if oObjData[iAWalk] then
        -- If object can run?
        if oObjData[iARun] then
          -- Run if already walking
          if oObjActive.A == iAWalk and oObjActive.D == iDirection then
            iAction = iARun;
          -- Else keep to walking
          else iAction = iAWalk end
        -- Object can't run but can walk?
        else iAction = iAWalk end;
      -- If object can run? Set to run
      elseif oObjData[iARun] then iAction = iARun;
      -- If object can creep? Set to creep
      elseif oObjData[iACreep] then iAction = iACreep;
      -- Show error
      else return end;
    end
    -- Return if action, job and direction is not allowed
    local oKeyData<const> = oObjData.KEYS;
    if not oKeyData then return end;
    local oActData<const> = oKeyData[iAction];
    if not oActData then return end;
    local oJobData<const> = oActData[iJob];
    if not oJobData then return end;
    local oDirData<const> = oJobData[iDirection];
    if not oDirData then return end;
    -- Action allowed!
    return SetAction(oObjActive, iAction, iJob, iDirection, true);
  end
  -- Special multi-function keys
  local function SpecialKey1()
    -- One of these is surely to work and fully checked
    return GenericAction(iAMap, iJNone, iDNone) or
           GenericAction(iAOpen, iJNone, iDNone) or
           GenericAction(iADeploy, iJNone, iDNone) or
           GenericAction(iADying, iJNone, iDNone) or
           GenericAction(iACreep, iJNone, iDUp);
  end
  local function SpecialKey2()
    -- One of these is surely to work and fully checked
    return GenericAction(iAClose, iJNone, iDNone) or
           GenericAction(iACreep, iJNone, iDDown);
  end
  -- Basic movement
  local function MoveLeft() GenericAction(0, iJNone, iDLeft) end;
  local function MoveRight() GenericAction(0, iJNone, iDRight) end;
  local function MoveHome() GenericAction(0, iJHome, iDHome) end;
  local function MoveFind() GenericAction(0, iJSearch, iDLeftRight) end;
  local function MoveJump() GenericAction(iAJump, iJKeep, iDKeep) end;
  local function MoveStopJob() GenericAction(iAStop, iJKeep, iDNone) end;
  local function MoveStop() GenericAction(iAStop, iJNone, iDNone) end;
  -- Digging directions events
  local function DigUpLeft() GenericAction(0, iJDig, iDUpLeft) end;
  local function DigUpRight() GenericAction(0, iJDig, iDUpRight) end;
  local function DigLeft() GenericAction(0, iJDig, iDLeft) end;
  local function DigRight() GenericAction(0, iJDig, iDRight) end;
  local function DigDownLeft() GenericAction(0, iJDig, iDDownLeft) end;
  local function DigDownRight() GenericAction(0, iJDig, iDDownRight) end;
  local function DigDown() GenericAction(0, iJDigDown, iDTileCentre) end;
  -- Drop or grab items?
  local function DropItems() GenericAction(iADrop, iJKeep, iDKeep) end;
  local function GrabItems() GenericAction(iAGrab, iJKeep, iDKeep) end;
  local function Teleport() GenericAction(iAPhase, iJPhase, iDUp) end;
  -- Spawn Jennite? (Cheat)
  local function SpawnJennite()
    if GetTestMode() then CreateObject(iTyJennite, GetTileUnderMouse()) end;
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
    if not GetTestMode() then return end
    AdjustObjectHealth(CreateObject(iTyTNT,
      GetTileUnderMouse()), -100, oObjActive);
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
  -- Register the variable and put it in API to stop it from being GC'd
  cvSlowDown = Variable.Register("gam_slowdown", 1,
    Variable.Flags.UINTEGERSAVE, OnSlowDown);
  oAPI.cvSlowDown = cvSlowDown;
  -- Move viewport
  local function ScrollH(iX) AdjustViewportX(iX)
    iPixPosTargetX = iAbsPosX * 16 end;
  local function ScrollV(iY) AdjustViewportY(iY)
    iPixPosTargetY = iAbsPosY * 16 end;
  local function ScrollUp() if GetTestMode() then ScrollV(-16) end end;
  local function ScrollDown() if GetTestMode() then ScrollV(16) end end;
  local function ScrollLeft() if GetTestMode() then ScrollH(-16) end end;
  local function ScrollRight() if GetTestMode() then ScrollH(16) end end;
  -- Repeated key events
  local oKeys<const>, oStates<const> = Input.KeyCodes, Input.States;
  local aScrollUp<const>, aScrollDown<const>, aScrollLeft<const>,
        aScrollRight<const>, aReveal<const> =
    { oKeys.HOME,      ScrollUp,     "igmsu", "SCROLL MAP UP (DEBUG)"    },
    { oKeys.END,       ScrollDown,   "igmsd", "SCROLL MAP DOWN (DEBUG)"  },
    { oKeys.DELETE,    ScrollLeft,   "igmsl", "SCROLL MAP LEFT (DEBUG)"  },
    { oKeys.PAGE_DOWN, ScrollRight,  "igmsr", "SCROLL MAP RIGHT (DEBUG)" },
    { oKeys.O,         ShroudReveal, "igsr",  "SHROUD REVEAL (DEBUG)"    };
  -- Select device
  local function SelectDevice()
    -- For each object
    for iId = 1, #aObjs do
      -- Get object and if the object belongs to me and is device?
      local oObj<const> = aObjs[iId];
      if oPlrActive == oObj.P and oObj.F & iFDevice ~= 0 then
        -- Remove and send to front of objects list
        remove(aObjs, iId);
        aObjs[1 + #aObjs] = oObj;
        -- Set as active object
        SelectObject(oObj, false);
        -- Success!
        return PlayInterfaceSound(iSClick);
      end
    end
    -- Failed? Play sound
    PlayInterfaceSound(iSError);
  end
  -- Pause the game
  local function SelectPauseScreen() SelectInfoScreen() InitPause() end;
  -- Show inventory screen
  local function SelectInventoryScreen() SelectInfoScreen(1) end;
  -- Show location screen
  local function SelectLocationScreen() SelectInfoScreen(2) end;
  -- Show status screen
  local function SelectStatusScreen() SelectInfoScreen(3) end;
  -- Init the book
  local function SelectBook()
    -- Enumerate diggers
    local aDiggers<const> = oPlrActive.D;
    for iDigger = 1, #aDiggers do
      -- Get digger data and if it's teleporting home or going home?
      local oDigger<const> = aDiggers[iDigger];
      if oDigger and (oDigger.F & iFNoHome ~= 0 or oDigger.J == iJHome) then
        -- Play error sound effect and return
        return PlayInterfaceSound(oSfxData.ERROR);
      end
    end
    -- Book screen selected (for icon)
    SelectInfoScreen(4);
    -- Play sound effect to show the player clicked it
    PlayInterfaceSound(oSfxData.CLICK);
    -- Remove play sound function
    SetPlaySounds(false);
    -- Init the book
    InitBook(true);
  end
  -- Setup keybank
  iKeyBankId = RegisterKeys("IN-GAME", {
    [oStates.PRESS] = {
      { oKeys.Q, DigUpLeft, "igddul", "DIG DIAGONALLY UP-LEFT" },
      { oKeys.E, DigUpRight, "igddur", "DIG DIAGONALLY UP-RIGHT" },
      { oKeys.A, DigLeft, "igdl", "DIG LEFT" },
      { oKeys.D, DigRight, "igdr", "DIG RIGHT" },
      { oKeys.Z, DigDownLeft, "igddl", "DIG DIAGONALLY DOWN-LEFT" },
      { oKeys.S, DigDown, "igdd", "DIG DOWN" },
      { oKeys.X, MoveStopJob, "igsa", "STOP MOVING AND CLEAR JOB" },
      { oKeys.C, DigDownRight, "igddr", "DIG DIAGONALLY DOWN-RIGHT" },
      { oKeys.BACKSLASH, DropItems, "igdi", "DROP INVENTORY ITEM" },
      { oKeys.BACKSPACE, Teleport, "igt", "TELEPORT HOME OR TELEPOLE" },
      { oKeys.ENTER, GrabItems, "iggi", "GRAB COLLIDING ITEMS" },
      { oKeys.ESCAPE, SelectPauseScreen, "igp", "PAUSE THE GAME" },
      { oKeys.MINUS, SelectLastDigger, "igsld", "SELECT LAST DIGGER" },
      { oKeys.EQUAL, SelectNextDigger, "igsnd", "SELECT NEXT DIGGER" },
      { oKeys.F4, ToggleSlowDown, "igts", "TOGGLE SLOWDOWN" },
      { oKeys.F5, SelectInventoryScreen, "igshi", "TOGGLE DIGGER INVENTORY" },
      { oKeys.F6, SelectLocationScreen, "igshl", "TOGGLE DIGGER LOCATIONS" },
      { oKeys.F7, SelectStatusScreen, "igshs", "TOGGLE GAME STATUS" },
      { oKeys.F8, SelectBook, "igshb", "TOGGLE THE BOOK" },
      { oKeys.UP, MoveJump, "igj", "JUMP THE OBJECT" },
      { oKeys.DOWN, MoveStop, "igs", "STOP MOVING BUT KEEP JOB" },
      { oKeys.LEFT, MoveLeft, "igml", "WALK OR RUN OBJECT LEFT" },
      { oKeys.RIGHT, MoveRight, "igmr", "WALK OR RUN OBJECT RIGHT" },
      { oKeys.F, MoveFind, "igft", "FIND TREASURE" },
      { oKeys.H, MoveHome, "igmh", "WALK OR RUN HOME" },
      { oKeys.LEFT_BRACKET, SpecialKey1, "igska",
          "DEPLOY, RAISE, TRIGGER OR VIEW THE DEVICE" },
      { oKeys.RIGHT_BRACKET, SpecialKey2, "igskb", "LOWER THE DEVICE" },
      { oKeys.N1, SetDiggerOne, "igsdon", "SELECT 1ST DIGGER"  },
      { oKeys.N2, SetDiggerTwo, "igsdtw", "SELECT 2ND DIGGER"  },
      { oKeys.N3, SetDiggerThree, "igsdth", "SELECT 3RD DIGGER"  },
      { oKeys.N4, SetDiggerFour, "igsdfo", "SELECT 4TH DIGGER"  },
      { oKeys.N5, SetDiggerFive, "igsdfi", "SELECT 5TH DIGGER" },
      { oKeys.J, SpawnJennite, "igsj", "SPAWN JENNITE (DEBUG)"  },
      { oKeys.P, CauseExplosion, "igce", "CAUSE EXPLOSION (DEBUG)" },
      { oKeys.SPACE, SelectDevice, "igcd", "CYCLE DEVICES" },
      aReveal, aScrollDown, aScrollLeft, aScrollRight, aScrollUp
    }, [oStates.REPEAT] = {
      aReveal, aScrollDown, aScrollLeft, aScrollRight, aScrollUp,
--    { oKeys.J, SpawnJennite, "igsj2", "SPAWN JENNITE (DEBUG)"  },
    }
  });
  -- Update object menu position
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
        iX,      iY,               -- Menu render start position X and Y
        iX + 16, iY + 16           -- Menu render end position X and Y
      };
      -- Increment tile position and wrap the
      iX = iX + 16;
      if iX >= iMenuRight then iX, iY = iMenuLeft, iY + 16 end;
    end
  end
  -- Object released on screen
  local function SelectObjectOnScreenDrag(iButton, iX, iY, iDragX, iDragY)
    -- Return if not right mouse button
    if iButton ~= 1 then return end;
    -- Drag menu if open
    if aContextMenu then return UpdateMenuPosition(iX, iY) end;
    -- Return if not test mode
    if not GetTestMode() then return end;
    -- Move the level to how the mouse is dragging
    AdjustViewportNoScroll(iDragX, iDragY);
  end
  -- Left mouse button / Joystick button 1 pressed function
  local function OnButton0Pressed(iX, iY)
    -- We have context menu open and in bounds?
    if aContextMenuData and
       IsMouseInBounds(iMenuLeft, iMenuTop, iMenuRight, iMenuBottom) then
      -- Walk through it and test position
      for iMIndex = 1, #aContextMenuData do
        -- Get context menu item and if mouse is in bounds?
        local aMItem<const> = aContextMenuData[iMIndex];
        if IsMouseInBounds(aMItem[4], aMItem[5], aMItem[6], aMItem[7]) then
          -- If this item cannot be activate when busy? Play error sound
          if aMItem[3] and oObjActive.F & iFBusy ~= 0 then
            PlayStaticSound(iSError);
          -- Not busy?
          else
            -- Get menu data and if new menu specified?
            local aMData<const> = aMItem[1];
            if aMData[3] ~= iMNone then
              -- Set new menu and play sound
              PlayStaticSound(iSSelect);
              SetContextMenu(aMData[3]);
              UpdateMenuPosition(iMenuLeft, iMenuTop);
            -- New action specified?
            elseif aMData[4] ~= 0 and aMData[5] ~= 0 and aMData[6] ~= 0 then
              -- Play the click sound
              PlayStaticSound(iSSelect);
              -- Set the action and if failed? Play the error sound
              if not SetAction(oObjActive,
                 aMData[4], aMData[5], aMData[6], true)
                then PlayStaticSound(iSError) end;
            end
          end
          -- Blocked from doing anything else.
          return;
        end
      end
      -- The mouse cursor was in the bounds of the context menu so we don't
      -- need to check anything else.
      return;
    end
    -- Translate current mouse position to absolute level position
    iX, iY = iViewportX + iX, iViewportY + iY;
    -- Walk through objects in backwards order. This is because objects are
    -- drawn from oldest to newest.
    for iObjId = #aObjs, 1, -1 do
      -- Get object, select object and return if mouse cursor touching it
      local oObj<const> = aObjs[iObjId];
      if IsSpriteCollide(479, iX, iY, oObj.S, oObj.X, oObj.Y) then
        SelectObject(oObj, false);
        return PlayStaticSound(iSSelect);
      end
    end
    -- Nothing found so deselect current object
    SelectObject();
  end
  -- Right mouse button / Joystick button 2 pressed function
  local oNoMenuActions<const> = { [ACT.DEATH] = true, [ACT.EATEN] = true };
  local function OnButton1Pressed(iX, iY)
    -- Right mouse button held down and menu open?
    if aContextMenu then return UpdateMenuPosition(iX, iY) end;
    -- Return if there is no active object or we can't open its menu
    if not oObjActive then return end;
    -- Get active objectmenu data and return if object doesn't have a menu,
    -- isn't our object, is dead or eaten.
    local aObjContextMenu<const> = oObjActive.OD.MENU;
    if not aObjContextMenu or oObjActive.P ~= oPlrActive or
       oNoMenuActions[oObjActive.A] then return end;
    -- Object does belong to active player so play context menu sound and
    -- set the appropriate default menu for the object.
    PlayStaticSound(iSClick);
    SetContextMenu(aObjContextMenu);
    UpdateMenuPosition(iX, iY);
  end
  -- Button callbacks
  local oButtonCallbacks<const> = {
    [0] = OnButton0Pressed, [1] = OnButton1Pressed, [9] = SelectPauseScreen,
  };
  -- Object released on screen
  local function SelectObjectOnScreenPress(iButton, ...)
    -- Find callback function
    local fcbFunc<const> = oButtonCallbacks[iButton];
    if fcbFunc then fcbFunc(...) end;
  end
  -- Mouse hovering
  local function OnHover()
    -- Return if no context menu or mouse cursor not in context menu bounds
    if not aContextMenuData or
       not IsMouseInBounds(iMenuLeft, iMenuTop, iMenuRight, iMenuBottom) then
      goto lNoButton end;
    -- Walk through it and test position
    for iMIndex = 1, #aContextMenuData do
      -- Get context menu item set tip if mouse is in bounds
      local aMItem<const> = aContextMenuData[iMIndex];
      if IsMouseInBounds(aMItem[4], aMItem[5], aMItem[6], aMItem[7]) then
        return SetTip(aMItem[1][7]) end;
    end
    -- No valid button was found
    ::lNoButton::
    -- Mouse isn't over anything interesting
    SetTip();
  end
  -- Mouse pressed over inventory?
  local function DropItem(iIId)
    -- Ignore if no active object select or object is not ours
    if not oObjActive or oObjActive.P ~= oPlrActive then return end;
    -- Return if inventory object is invalid
    local oObjInv<const> = oObjActive.I[iIId];
    if not oObjInv then return end;
    -- Drop the object and if successful?
    if DropObject(oObjActive, oObjInv) then
      -- Play sound if successful
      PlayStaticSound(iSSelect);
      -- Tell hotspot manager to reexecute the focus function
      return true;
    end
    -- Error occured
    PlayStaticSound(iSError);
  end
  -- Mouse hovering over inventory?
  local function OnItemHover(iIId)
    -- If we have an active object and player owns it
    if oObjActive and oObjActive.P == oPlrActive then
      -- Get id and if we have that inventory item?
      local oObjInv<const> = oObjActive.I[iIId];
      if oObjInv then
        -- Item is droppable so show that this is clickable
        SetCursor(iCSelect);
        -- Show item id to drop
        return SetTip("DROP ITEM "..iIId);
      end
    end
    -- Nothing interesting so just report inventory
    SetTip("INVENTORY");
  end
  -- On inventory mouse hover and click drop functions
  local function OnItemHover1() OnItemHover(1) end;
  local function DropItem1() return DropItem(1) end;
  local function OnItemHover2() OnItemHover(2) end;
  local function DropItem2() return DropItem(2) end;
  local function OnItemHover3() OnItemHover(3) end;
  local function DropItem3() return DropItem(3) end;
  local function OnItemHover4() OnItemHover(4) end;
  local function DropItem4() return DropItem(4) end;
  local function OnItemHover5() OnItemHover(5) end;
  local function DropItem5() return DropItem(5) end;
  local function OnItemHover6() OnItemHover(6) end;
  local function DropItem6() return DropItem(6) end;
  local function OnItemHover7() OnItemHover(7) end;
  local function DropItem7() return DropItem(7) end;
  -- Setup hot spot data
  iHotSpotId = RegisterHotSpot({
    -- Digger quick inventory drop area
    {  61, 218, 8, 8, 0, 0, OnItemHover1, OnScroll, DropItem1 },
    {  69, 218, 8, 8, 0, 0, OnItemHover2, OnScroll, DropItem2 },
    {  77, 218, 8, 8, 0, 0, OnItemHover3, OnScroll, DropItem3 },
    {  85, 218, 8, 8, 0, 0, OnItemHover4, OnScroll, DropItem4 },
    {  93, 218, 8, 8, 0, 0, OnItemHover5, OnScroll, DropItem5 },
    { 101, 218, 8, 8, 0, 0, OnItemHover6, OnScroll, DropItem6 },
    { 109, 218, 8, 8, 0, 0, OnItemHover7, OnScroll, DropItem7 },
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
    { 232, 216, 16, 16, 0, iCSelect, "NEXT DEVICE", OnScroll, SelectDevice },
    { 248, 216, 16, 16, 0, iCSelect, "INVENTORIES", OnScroll,
      SelectInventoryScreen },
    { 264, 216, 16, 16, 0, iCSelect, "LOCATIONS",   OnScroll,
      SelectLocationScreen },
    { 280, 216, 16, 16, 0, iCSelect, "GAME STATUS", OnScroll,
      SelectStatusScreen },
    { 296, 216, 16, 16, 0, iCSelect, "THE BOOK",    OnScroll, SelectBook },
    -- Anything else on the screen (too complecated to put here)
    { 0, 0, 0, 240, 3, 0, OnHover, OnScroll,
      { false, SelectObjectOnScreenPress, SelectObjectOnScreenDrag } },
  });
  -- Register a console command to dump level mask and keep it safe in API.
  local CommandRegister<const> = Command.Register;
  local function ConCmdDumpLevelMask(_, strFile)
    -- Only dump level mask if the level is loaded
    if maskZone then maskZone:Save(0, strFile or sLvlName) end;
  end
  oAPI.cmdDump = CommandRegister("dump", 1, 2, ConCmdDumpLevelMask);
  -- Register a console command to spawn any object (except digger)
  local function ConCmdSpawnObject(_, strId)
    -- Return if there is no level loaded
    if not GetTestMode() or not maskZone then return end;
    -- Get and check type
    local iType<const> = floor(tonumber(strId));
    if iType <= TYP.QUARRIOR or iType >= TYP.MAX then return end;
    -- Spawn the object under the mouse cursor
    CreateObject(iType, GetTileUnderMouse());
  end
  oAPI.cmdSpawn = CommandRegister("spawn", 1, 2, ConCmdSpawnObject);
end
-- Pre-initialisation ------------------------------------------------------ --
local function OnPreInitAPI(GetAPI)
  -- Some engine function aliases required in the scope
  local MaskCreateZero<const> = Mask.CreateZero;
  -- Shared variables only needed in this scope
  local Fade<const>, GetMouseX<const>, GetMouseY<const>, InitLose<const>,
    InitLoseDead<const>, InitWin<const>, InitWinDead<const>,
    LoadResources<const>, PlayMusic<const>, RegisterFBUCallback<const>,
    SetCallbacks<const>, SetHotSpot<const>, SetKeys<const>, TileA<const>,
    oTileIdToPlayer<const>, oAssetsData<const> =
      GetAPI("Fade", "GetMouseX", "GetMouseY", "InitLose", "InitLoseDead",
        "InitWin", "InitWinDead", "LoadResources", "PlayMusic",
        "RegisterFBUCallback", "SetCallbacks", "SetHotSpot", "SetKeys",
        "TileA", "oTileIdToPlayer", "oAssetsData");
  -- Get and assign outer imports
  TYP, aLevelsData, oObjectData, ACT, JOB, DIR, AI, OFL, aDigTileData,
    aTileData, oTileFlags, oDigData, BlitSLTRB, BlitSLTWH, BlitSLT, DF,
    GetTestMode, oSfxData, aJumpRiseData, aJumpFallData, iAnimNormal,
    PlayStaticSound, PlaySound, Print, PrintC, PrintR, oMenuData, MFL, MNU,
    InitBook, RenderFade, InitTNTMap, InitLobby, texSpr, fontLarge, fontLittle,
    fontTiny, aDigBlockData, SetCursorPos, RenderShadow, RenderTip, SetTip,
    aRacesData, oDugRandShaftData, oFloodGateData, maskLev, maskSpr,
    oGlobalData, aShopData, aAIChoicesData, aShroudCircle, aShroudTileLookup =
      GetAPI("oObjectTypes", "aLevelsData", "oObjectData", "oObjectActions",
        "oObjectJobs", "oObjectDirections", "aAITypesData",
        "aObjectFlags", "aDigTileData", "aTileData", "oTileFlags",
        "oDigData", "BlitSLTRB", "BlitSLTWH", "BlitSLT", "aDigTileFlags",
        "GetTestMode", "oSfxData", "aJumpRiseData", "aJumpFallData",
        "iAnimNormal", "PlayStaticSound", "PlaySound", "Print", "PrintC",
        "PrintR", "oMenuData", "oMenuFlags", "oMenuIds", "InitBook",
        "RenderFade", "InitTNTMap", "InitLobby", "texSpr", "fontLarge",
        "fontLittle", "fontTiny", "aDigBlockData", "SetCursorPos",
        "RenderShadow", "RenderTip", "SetTip", "aRacesData",
        "oDugRandShaftData", "oFloodGateData", "maskLevel",
        "maskSprites", "oGlobalData", "aShopData", "aAIChoicesData",
        "aShroudCircle", "aShroudTileLookup");
  -- Setup required assets for LoadLevel() and InitContinueGame().
  local oAssetTerrain<const>, oAssetObject<const>, oAssetTexture<const> =
    oAssetsData.mapt, oAssetsData.mapo, oAssetsData.game;
  local aAssetsMusic<const>, aAssetsNoMusic<const>, aAssetsContinue<const> =
    { oAssetTerrain, oAssetObject, oAssetTexture, oAssetsData.gamem },
    { oAssetTerrain, oAssetObject, oAssetTexture },
    { oAssetsData.gamem };
  -- Pre-initialisations of functions which required data from another module.
  AdjustObjectHealth, CreateObject, GameProc, MoveOtherObjects, SetAction =
    AdjustObjectHealth(), InitCreateObject(), GameProc(),
      InitMoveOtherObjects(), InitSetAction();
  -- Get render functions
  local RenderTerrain, RenderObjects, RenderShroud, RenderInterface;
  RenderAll, RenderTerrain, RenderObjects, RenderShroud,
    RenderInterface, SelectInfoScreen = RenderAll();
  -- Lock viewport to top left --------------------------------------------- --
  local function LockViewport() ScrollViewportTo(0, 0) ForceViewport() end;
  -- Returns current pixel tile under mouse cursor
  local function GetTileUnderMouse()
    return UtilClampInt(iPixPosX + GetMouseX() - iStageL, 0, iLLPixWm1),
           UtilClampInt(iPixPosY + GetMouseY() - iStageT, 0, iLLPixHm1);
  end
  -- Get mouse position on level ------------------------------------------- --
  local function GetAbsMousePos()
    return iViewportX + GetMouseX(), iViewportY + GetMouseY();
  end
  -- Return game ticks ----------------------------------------------------- --
  local function GetGameTicks() return iGameTicks end;
  -- Return the current active object -------------------------------------- --
  local function GetActiveObject() return oObjActive end;
  -- Return the current active player -------------------------------------- --
  local function GetActivePlayer() return oPlrActive end;
  -- Return the current opponent player ------------------------------------ --
  local function GetOpponentPlayer() return oPlrOpponent end;
  -- Return information about the game viewport ---------------------------- --
  local function GetViewportData()
    return iPixPosX, iPixPosY, iPixPosTargetX, iPixPosTargetY, iPixCenPosX,
           iPixCenPosY, iAbsPosX, iAbsPosY, iAbsCenPosX, iAbsCenPosY,
           iViewportW, iViewportH, iViewportX, iViewportY;
  end
  -- AI player override patience logic (LoadLevel()) ----------------------- --
  local iARest<const>, iDNone<const>, iJNone<const> =
    ACT.REST, DIR.NONE, JOB.NONE;
  local function AIPatienceLogic(oObj)
    -- Return if Digger is not at impatience limit?
    if oObj.JT < oObj.PL then return end;
    -- If have rest ability? (25% chance to execute). Use it and return
    if oObj.OD[iARest] and random() < 0.25 then
      return SetAction(oObj, iARest, iJNone, iDNone) end;
    -- Do something casual
    SetRandomJob(oObj, true);
  end
  -- Continue game from book or lobby -------------------------------------- --
  local function InitContinueGame(bMusic)
    -- Make sure there is no info screen selected
    SelectInfoScreen();
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
      if not oObjActive or oObjActive.A ~= ACT.HIDE then return end;
      -- Get active parent players diggers and enumerate their diggers
      local aDiggers<const> = oObjActive.P.D;
      for iDiggerId = 1, #aDiggers do
        -- Get digger object and set it to go home again
        local oDigger<const> = aDiggers[iDiggerId];
        if oDigger then oDigger.F = oDigger.F & OFL.iNOHOME end;
      end
      -- Make it reappear. Direction prevents AI from re-entering
      SetAction(oObjActive, ACT.PHASE, JOB.NONE, DIR.R);
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
  -- Sell all available items of specified type ---------------------------- --
  local function SellSpecifiedItems(oObj, iItemId)
    -- Check parameters
    if not UtilIsInteger(iItemId) then
      error("Item type not specified! "..tostring(iItemId)) end;
    -- Get digger inventory and return if no items
    local aObjInv<const> = oObj.I;
    if #aObjInv == 0 then return -1 end;
    -- Something sold?
    local iItemsSold = 0;
    local iInvId = 1 while iInvId <= #aObjInv do
      -- Get object and if is a matching type and we can sell and we sold it?
      local oObjInv<const> = aObjInv[iInvId];
      local iTypeId<const> = oObjInv.ID;
      if iTypeId == iItemId and
         CanSellGem(iTypeId) and
         SellItem(oObj, oObjInv) then
        -- Sold something
        iItemsSold = iItemsSold + 1;
      -- Not sellable solid so increment inventory index
      else iInvId = iInvId + 1 end;
    end
    -- Return if we sold something
    return iItemsSold;
  end
  -- De-init the level ----------------------------------------------------- --
  local function DeInitLevel()
    -- Unset FBU callback
    RegisterFBUCallback("game");
    -- De-init information screen
    SelectInfoScreen();
    -- Dereference loaded assets for garbage collector
    iTileBg, texLev, maskZone = nil, nil, nil;
    -- Flush specified tables whilst keeping the actual tables
    UtilFlushArrays(aObjs, aPlayers, aFloodData, aGemsAvailable,
      aLvlData, aShroudData, aDamageValues);
    -- Reset positions and other variables
    iPixPosTargetX, iPixPosTargetY, iPixPosX, iPixPosY, iGameTicks, iLvlId,
      iWinLimit, sMoney, iUniqueId, fcbLogic, fcbRender, fcbEnd =
        0, 0, 0, 0, 0, nil, nil, nil, 0, nil, nil, nil;
    -- Reset active objects, menus and players
    oPlrActive, oPlrOpponent = nil, nil;
    -- Remove active object and menu data
    SelectObject();
    -- We don't want to hear sounds
    SetPlaySounds(false);
  end
  -- Set FBU callback ------------------------------------------------------ --
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
    AdjustViewport(0, 0);
  end
  -- Create a player ------------------------------------------------------- --
  local function CreatePlayer(iPlrId, iX, iY, iRaceId, bIsAI)
    -- Players diggers and number of diggers to create
    local aDiggers<const>, iNumDiggers<const> = { }, 5;
    -- Calculate home point
    local iHomeX, iHomeY<const> = iX * 16 - 2, iY * 16 + 32;
    -- Get object data for race
    local aRaceData<const> = oObjectData[iRaceId];
    if not UtilIsTable(aRaceData) then
      error("Invalid race data for "..iRaceId.."! "..
        tostring(aRaceData)) end;
    -- Build player data object
    local oPlr<const> = {
      AI  = bIsAI,                 -- Set AI status
      D   = aDiggers,              -- List of diggers
      DC  = iNumDiggers,           -- Diggers count
      DUG = 0,                     -- Dirt dug
      EK  = 0,                     -- Enemies killed (OFL.ENEMY)
      GEM = 0,                     -- Gems found
      GS  = 0,                     -- Gems sold
      PUR = 0,                     -- Purchases made
      GI  = 0,                     -- Total income
      M   = 100,                   -- Money
      R   = iRaceId,               -- Race type (TYP.*)
      I   = iPlrId,                -- Player index
      LK  = 0,                     -- Lifeforms killedV (OFL.LIVING)
      HX  = iHomeX,                -- Home point X position
      HY  = iHomeY,                -- Home point Y position
      SX  = (iX - 1) * 16,         -- Adjust home point X
      SY  = (iY + 2) * 16,         -- Adjust home point Y
      RD  = aRaceData              -- Race data
    };
    -- If this is player one?
    if iPlrId == 1 then
      -- Set active player
      oPlrActive = oPlr;
      -- Is not AI?
      if not bIsAI then
        -- Set to un-shroud the players' objects
        oPlr.US = true;
        -- Add capital carried and reset its value
        oPlrActive.M = oPlrActive.M + oGlobalData.gCapitalCarried;
        oGlobalData.gCapitalCarried = 0;
      -- Is AI vs AI? Set to un-shroud the players' objects
      elseif bAIvsAI then oPlr.US = true end;
      -- Set viewpoint on this player and synchronise
      ScrollViewportTo(iX - iScrTilesWd2p1, iY - iScrTilesHd2 + 3);
      ForceViewport();
    -- Set opponent player
    else oPlrOpponent = oPlr end;
    -- Adjust starting X co-ordinate for first Digger at the trade centre
    iHomeX = iHomeX - 16;
    -- Get weight of treasure
    local iMaxInventory<const> = aRaceData.STRENGTH;
    -- For each digger of the player
    for iDiggerId = 1, iNumDiggers do
      -- Create a new digger
      local oDigger<const> = CreateObject(iRaceId, iHomeX, iHomeY, oPlr);
      if oDigger then
        -- Add fighting value. The 2 is as we use random() to randomise it.
        oDigger.STRF = -(oDigger.STR - 2);
        -- Digger is not AI?
        if not bIsAI then
          -- Override actual computer AI function with minimal AI function.
          oDigger.AI, oDigger.AIF, oDigger.AIDF =
            AI.PATIENCE, AIPatienceLogic, AIPatienceLogic;
          -- Set and verify patience warning value
          local iPatience = oDigger.OD.PATIENCE;
          if not UtilIsInteger(iPatience) then
            error("Digger "..iDiggerId.." of player "..oPlr.I..
              "has no patience warning value!") end;
          -- Randomise patience by +/- 25%
          local iOffset = random(floor(iPatience * 0.25));
          if random() < 0.5 then iOffset = -iOffset end;
          iPatience = iPatience + iOffset;
          oDigger.PW = iPatience;
          -- Digger will stray between 30-60 seconds of impatience
          oDigger.PL = iPatience + 1800 + random(1800);
        -- Is AI?
        else
          -- Set maximum treasure items to carry (for AI)
          oDigger.MI = iMaxInventory;
          -- Initialise Digger AI anti-wiggle system
          oDigger.AW, oDigger.AWR = 0, 0;
          -- Infinite patience
          oDigger.PW, oDigger.PL = maxinteger, maxinteger;
        end;
        -- Set Digger id
        oDigger.DI = iDiggerId;
        -- Insert into Digger list
        aDiggers[1 + #aDiggers] = oDigger;
      -- Failed so show map maker in console that the object id is invalid
      else CoreWrite("Warning! Digger "..iDiggerId..
        " not created for player "..iPlrId.."! Id="..iRaceId..", X="..iX..
        ", Y="..iY..".", 9) end;
      -- Increment home point X position
      iHomeX = iHomeX + 5;
    end
    -- Add player data to players array
    aPlayers[1 + #aPlayers] = oPlr;
    -- Log creation of item
    CoreLog("Created player "..iPlrId.." as '"..oObjectData[iRaceId].NAME..
      "'["..iRaceId.."] at AX:"..iX..",AY:"..iY.." in position #"..
      #aPlayers.."!");
    -- Return the player
    return oPlr;
  end
  -- Populate level with objects from metadata ----------------------------- --
  local iMinObjId<const>, iMaxObjId<const> = TYP.JENNITE, TYP.MAX;
  local function PopulateLevelWithObjects(aMetadata);
    -- For each pre-defined object in level metadata
    for iObjIndex = 1, #aMetadata do
      -- Get object id at position and if it's interesting?
      local aObj<const> = aMetadata[iObjIndex];
      local iObjId<const>, iX<const>, iY<const> = aObj[1], aObj[2], aObj[3];
      if iObjId < iMinObjId or iObjId >= iMaxObjId then
        error("Warning! Object id invalid! Id="..iObjIndex..", Item="..
          iObjId..", X="..iX..", Y="..iY..", Max="..iMaxObjId..".");
      -- Object id is valid? Create the object and log error if failed
      elseif not CreateObject(iObjId, iX, iY) then
        -- Show map maker in console that the object id is invalid
        error("Warning! Couldn't create object! Id="..iObjIndex..
          ", Item="..iObjId..", X="..iX..", Y="..iY..".");
      end
    end
  end
  -- Build a level from asset and return players found --------------------- --
  local aPlrExpected<const> = { };
  local function BuildLevel(asLevel)
    -- Create a blank mask with the specified level name
    maskZone = MaskCreateZero(asLevel:Name(), iLLPixW, iLLPixH);
    -- Player starting point data list
    local aPlrsFound<const> = { };
    -- For each row in the data file
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
        -- the current position and show error if it is not a valid tile
        local iTerrainId<const> = asLevel:RU16LE(iPosition);
        if iTerrainId < 0 or iTerrainId >= #aTileData then
          error("Error! Invalid tile "..iTerrainId.."/"..#aTileData..
                    " at X="..iX..", Y="..iY..", Abs="..iPosition.."!") end;
        -- Check if is a player start position and if it is?
        local iPlayer<const> = oTileIdToPlayer[iTerrainId];
        if iPlayer then
          -- Get existing player data and show error if already exists
          local aPlayerFound<const> = aPlrsFound[iPlayer];
          if aPlayerFound then
            error("Error! Player "..iPlayer..
              " already exists! X="..iX..", Y="..iY..", Abs="..
              iPosition..". Originally found at X="..aPlayerFound[1]..
              ", Y="..aPlayerFound[2]..".") end;
          -- Player doesn't exist? Set the new player
          local aPlrRaceItem<const> = aPlrExpected[iPlayer];
          aPlrsFound[iPlayer] = { iX, iY, aPlrRaceItem[1],
            aPlrRaceItem[2], iPlayer };
        -- Is a flood gate?
        elseif iTerrainId >= 434 and iTerrainId <= 439 then
          -- Create a flood gate here with no owner
          if not CreateObject(TYP.GATEB, iX * 16, iY * 16) then
            error("Error! Flood gate could not be created! X="..iX..
              ", Y="..iY..", Abs="..iPosition..".") end;
        end
        -- Draw the appropriate tile for the level bit mask
        maskZone:Copy(maskLev, iTerrainId, iPreciseX, iPreciseY);
        -- Insert into level data array
        aLvlData[1 + #aLvlData] = iTerrainId;
        -- Create entry for shroud data (sprite tile set number)
        aShroudData[1 + #aShroudData] = { 1022, 0x0 };
      end
    end
    -- Make sure we got the correct amount of level tiles
    if #aLvlData < iLLAbs then
      error("Only "..#aLvlData.."/"..iLLAbs.." level tiles!") end;
    -- Make sure we found two players
    if #aPlrsFound ~= 2 then
      error("Only "..#aPlrsFound.."/2 players!") end;
    -- Fill border with 1's to prevent objects leaving the playfield
    maskZone:Fill(0, 0, iLLPixW, 1);
    maskZone:Fill(0, 0, 1, iLLPixH);
    maskZone:Fill(iLLPixWm1, 0, 1, iLLPixH);
    maskZone:Fill(0, iLLPixHm1, iLLPixW, 1);
    -- Return players found
    return aPlrsFound;
  end
  -- Reasons for game ending and their corresponding functions ------------- --
  local aEndReasons<const> = {
    -- [1] Player raised the money    [2] All the opponents digger died
    InitWin,                          InitWinDead,
    -- [3] Opponent raised the money  [4] All the players diggers died
    InitLose,                         InitLoseDead
  };
  -- Trigger an ending procedure ------------------------------------------- --
  local function TriggerEnd(iReason)
    aEndReasons[iReason](iLvlId, oPlrActive, oPlrOpponent);
  end
  -- Load level ------------------------------------------------------------ --
  local function LoadLevel(iLId, sMusic, iKB, iRace1, bAI1, iRace2, bAI2,
    fcbNLogic, fcbNRender, fcbNEnd, iNHotSpotId, iSM1, iSM2, bRespawn, fcbInit)
    -- De-init/Reset current level
    DeInitLevel();
    -- Setup player 1 parameters. We force the race that was originally
    -- selected by the player if it is set.
    if iRace1 == nil then
      iRace1 = oGlobalData.gSelectedRace or TYP.DIGRANDOM end;
    if bAI1 == nil then bAI1 = false end;
    if not UtilIsBoolean(bAI1) then
      error("Player 1 AI boolean of type '"..type(bAI1).."' invalid!") end;
    aPlrExpected[1] = { iRace1, bAI1 };
    -- Setup player 2 parameters
    if iRace2 == nil then
      iRace2 = TYP.DIGRANDOM end;
    if bAI2 == nil then bAI2 = true end;
    if not UtilIsBoolean(bAI2) then
      error("Player 2 AI boolean of type '"..type(bAI2).."' invalid!") end;
    aPlrExpected[2] = { iRace2, bAI2 };
    -- Prepare a modifiable table of races available for selection
    local aRacesAvailable<const>, oRacesTaken<const> = { }, { };
    for iI = 1, #aRacesData do
      aRacesAvailable[1 + #aRacesAvailable] = aRacesData[iI] end;
    -- Resolve race ids for players requesting actual race ids first
    for iPlrId = 1, #aPlrExpected do
      -- Get player start data and requested start race and if not random?
      local aPlrStartItem<const> = aPlrExpected[iPlrId];
      local iTypeId<const> = aPlrStartItem[1];
      if iTypeId ~= TYP.DIGRANDOM then
        -- Make sure id valid
        if not UtilIsInteger(iTypeId) then
          error("Player "..iPlrId.." race of type '"..type(iTypeId)..
            "' invalid!") end;
        if iTypeId < TYP.FTARG or iTypeId > TYP.QUARRIOR then
          error("Invalid player "..iPlrId.." race id of "..iTypeId.."!") end;
        -- Check to make sure the race id isnt taken
        local iPlrTaken<const> = oRacesTaken[iTypeId];
        if iPlrTaken then
          error("Race "..iRaceId.." for player "..iPlrId.." already taken \z
            by player "..iPlrTaken) end;
        -- Check to make sure a race is available
        if #aRacesAvailable == 0 then
          error("No more races available for manual race selection of \z
            player "..iPlrId.."!") end;
        -- Repeat...
        local iRaceId = 1;
        repeat
          -- If type in race id matches requested type id?
          if aRacesAvailable[iRaceId] == iTypeId then
            -- Remove type from races available
            remove(aRacesAvailable, iRaceId);
            -- Mark race as taken
            oRacesTaken[iTypeId] = iPlrId;
            -- Selection confirmed
            aPlrStartItem[3] = iTypeId;
            -- Done
            goto lContinue;
          end
          -- Next race id
          iRaceId = iRaceId + 1;
        -- ...until no more races available
        until iRaceId > #aRacesAvailable;
        -- Invalid type (impossible)
        error("Type "..iTypeId.." not found for "..iPlrId.."!");
        -- Continue point
        ::lContinue::
      end
    end
    -- Resolve race ids for players requesting random race ids
    for iPlrId = 1, #aPlrExpected do
      -- Get player start data and requested start race and if random?
      local aPlrStartItem<const> = aPlrExpected[iPlrId];
      local iRaceId = aPlrStartItem[1];
      if iRaceId == TYP.DIGRANDOM then
        -- Check to make sure a race is available
        if #aRacesAvailable == 0 then
          error("No more races available for automatic selection!") end;
        -- Pick a random race index
        iRaceId = random(#aRacesAvailable);
        -- Convert race index id to object type index id and check it
        local iTypeIdSelected<const> = aRacesAvailable[iRaceId];
        if not UtilIsInteger(iTypeIdSelected) then
          error("Auto race selection "..iRaceId.." not available!") end;
        -- Selection confirmed
        aPlrStartItem[1] = iTypeIdSelected;
        -- Remove the race available
        remove(aRacesAvailable, iRaceId);
        -- Mark race as taken
        oRacesTaken[iTypeIdSelected] = iPlrId;
      end
    end
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
    -- Check end trigger function
    if fcbNEnd ~= nil then
      if not UtilIsFunction(fcbNEnd) then
        error("Ending function invalid! "..tostring(fcbNEnd)) end;
      fcbEnd = fcbNEnd;
    else fcbEnd = TriggerEnd end;
    -- Check init trigger function
    if fcbInit ~= nil then
      if not UtilIsFunction(fcbInit) then
        error("Init function invalid! "..tostring(fcbInit)) end;
    else fcbInit = BlankFunction end;
    -- Initialise default hotspot id if not specified
    if not iNHotSpotId then iNHotSpotId = iHotSpotId end;
    -- Set FBU callback
    RegisterFBUCallback("game", OnStageUpdated);
    -- Set level number and get data for it.
    local oLvlInfo;
    if UtilIsTable(iLId) then iLvlId, oLvlInfo = 1, iLId;
    elseif UtilIsInteger(iLId) then
      iLvlId, oLvlInfo = iLId, aLevelsData[iLId];
    else error("Invalid id '"..
      tostring(iLId).."' of type '"..type(iLId).."'!") end;
    if not UtilIsTable(oLvlInfo) then
      error("Invalid level data! "..tostring(oLvlInfo)) end;
    -- Get level type data and level type
    local oLvlTypeData<const> = oLvlInfo.t;
    local iLvlType<const> = oLvlTypeData.i;
    -- Set level name and level type name
    sLvlName, sLvlType = oLvlInfo.n, oLvlTypeData.n;
    -- Set shroud colour
    iShroudColour = oLvlTypeData.s;
    -- Holds required assets to set template to music or no music
    local aAssets;
    if sMusic then aAssets, aAssetsMusic[4].F = aAssetsMusic, sMusic;
    else aAssets = aAssetsNoMusic end;
    -- Update asset filenames to load
    local sFilePrefix<const> = "lvl/"..oLvlInfo.f;
    aAssets[1].F = sFilePrefix..".dat";
    aAssets[2].F = sFilePrefix;
    aAssets[3].F = oLvlTypeData.f;
    -- Level assets loaded function
    local function OnLoaded(aResources)
      -- Set texture handle
      texLev = aResources[3];
      -- Grab the background part
      iTileBg = TileA(texLev, 0, 256, 512, 512);
      -- Build level mask and players list
      local aPlrsFound = BuildLevel(aResources[1]);
      -- Populate level with objects from table of metadata loaded externally
      PopulateLevelWithObjects(aResources[2]);
      -- If both players are AI?
      if bAI1 and bAI2 then
        -- AI vs AI mode
        bAIvsAI = true;
        -- A randomised version of randomised players
        local aPlrsFoundRand<const> = { };
        -- Repeat...
        repeat
          -- Get a random player
          local iId<const> = random(#aPlrsFound);
          -- Assign it to the randomised players list
          aPlrsFoundRand[1 + #aPlrsFoundRand] = aPlrsFound[iId];
          -- Remove original player
          remove(aPlrsFound, iId);
        -- ...until all players processed
        until #aPlrsFound == 0;
        -- Assign new players found
        aPlrsFound = aPlrsFoundRand;
      -- Not AI vs AI mode
      else bAIvsAI = false end;
      -- Create players and objects for players found
      for iPlrId = 1, #aPlrsFound do
        -- Get player found
        local aPlrFound<const> = aPlrsFound[iPlrId];
        -- Extract real player id
        local iRealId<const> = aPlrFound[#aPlrFound];
        remove(aPlrFound);
        -- Create the player and set the real player id
        CreatePlayer(iPlrId, unpack(aPlrFound)).RI = iRealId;
      end
      -- Set player race and level if not set (gam_test used)
      if not oGlobalData.gSelectedRace then
        oGlobalData.gSelectedRace = oPlrActive.R end;
      if not oGlobalData.gSelectedLevel then
        oGlobalData.gSelectedLevel = iLvlId end;
      -- Play in-game music if requested
      if sMusic then PlayMusic(aResources[4], 0) end;
      -- If AI vs AI is set?
      if bAIvsAI then
        -- Add respawn to all level defined objects
        local iFRespawn<const> = OFL.RESPAWN;
        for iObjId = 1, #aObjs do
          local oObj<const> = aObjs[iObjId];
          oObj.F = oObj.F | iFRespawn;
        end
      -- We want to hear sounds if a human player is set
      else SetPlaySounds(true) end;
      -- Set extra money if requested
      if iSM1 then oPlrActive.M = oPlrActive.M + iSM1 end
      if iSM2 then oPlrOpponent.M = oPlrOpponent.M + iSM2 end
      -- Respawn flag set?
      if bRespawn then
         -- Set auto-respawn on all objects death
         for iI = 1, #aObjs do
           local oObj<const> = aObjs[iI];
           oObj.F = oObj.F | OFL.RESPAWN;
         end
      end
      -- Set win limit (Credits will not set 'w' meaning no limit)
      iWinLimit = oLvlInfo.w;
      if iWinLimit then iWinLimit = iWinLimit.r + oGlobalData.gCapitalCarried;
                   else iWinLimit = maxinteger end;
      -- Reset gems available
      local iGemStart<const> = random(#aDigTileData);
      for iId = 1, #aDigTileData do aGemsAvailable[1 + #aGemsAvailable] =
        aDigTileData[1 + ((iGemStart + iId) % #aDigTileData)] end;
      -- Execute caller initialisation function
      fcbInit(iLvlId, sLvlName, sLvlType, iWinLimit);
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
        -- Check for win (test end/post-morten)
        EndConditionsCheck();
      end
      -- Fade in to main game
      Fade(1.0, 0.0, 0.04, fcbRender, OnFadeIn, not not sMusic);
    end
    -- Load level graphics resources asynchronously
    LoadResources(sLvlName, aAssets, OnLoaded);
  end
  -- Ajust viewport and don't scroll to it --------------------------------- --
  local function AdjustViewportNoScroll(iX, iY)
    AdjustViewport(-iX, -iY);
    iPixPosTargetX, iPixPosTargetY = iPixPosX, iPixPosY;
  end
  -- Return rest of the API functions which needed external data ----------- --
  return { AdjustViewportNoScroll = AdjustViewportNoScroll,
    DeInitLevel = DeInitLevel, GameProc = GameProc,
    GetAbsMousePos = GetAbsMousePos, GetActiveObject = GetActiveObject,
    GetActivePlayer = GetActivePlayer, GetGameTicks = GetGameTicks,
    GetOpponentPlayer = GetOpponentPlayer,
    GetTileUnderMouse = GetTileUnderMouse, GetViewportData = GetViewportData,
    InitContinueGame = InitContinueGame, LoadLevel = LoadLevel,
    LockViewport = LockViewport, RenderAll = RenderAll,
    RenderInterface = RenderInterface, RenderObjects = RenderObjects,
    RenderShroud = RenderShroud, RenderTerrain = RenderTerrain,
    SellSpecifiedItems = SellSpecifiedItems, TriggerEnd = TriggerEnd };
end
-- Exports and imports ----------------------------------------------------- --
return { F = OnScriptLoaded, I = OnPreInitAPI, A = {
  AdjustViewportX = AdjustViewportX, AdjustViewportY = AdjustViewportY,
  BuyItem = BuyItem, CreateObject = CreateObject,
  DrawHealthBar = DrawHealthBar, EndConditionsCheck = EndConditionsCheck,
  HaveZogsToWin = HaveZogsToWin, IsSpriteCollide = IsSpriteCollide,
  SelectObject = SelectObject, SetPlaySounds = SetPlaySounds,
  UpdateShroud = UpdateShroud, aGemsAvailable = aGemsAvailable,
  aLvlData = aLvlData, aObjs = aObjs, aPlayers = aPlayers,
  aShroudData = aShroudData } };
-- End-of-File ============================================================= --
