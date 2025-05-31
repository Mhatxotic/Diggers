-- END.LUA ================================================================= --
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
local abs<const>, error<const>, floor<const>, tostring<const> =
  math.abs, error, math.floor, tostring;
-- M-Engine function aliases ----------------------------------------------- --
local UtilFormatNumber<const>, UtilIsBoolean<const>, UtilIsInteger<const>,
  UtilIsString<const>, UtilIsTable<const> = Util.FormatNumber, Util.IsBoolean,
    Util.IsInteger, Util.IsString, Util.IsTable;
-- Diggers function and data aliases --------------------------------------- --
local BlitSLTWHA, Fade, GetGameTicks, InitPost, InitScore, LoadResources,
  PlayMusic, PlayStaticSound, PrintC, RenderFade, RenderObjects, RenderTerrain,
  SetCallbacks, SetHotSpot, SetKeys, aGemsAvailable, aGlobalData, aObjects,
  aShroudData, fontLarge;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Assets required
      aCollections,                    -- All texts
      aLinesBottom,                    -- Bottom lines of texts
      aLinesCentre,                    -- Centre lines of texts
      aLinesTop,                       -- Top lines of texts
      aLoseAssets,                     -- Lose assets data
      aWinAssets,                      -- Win assets data
      fcbOnFadeIn,                     -- Function to call when faded in
      iDeadCost,                       -- Death duties total
      iDeviceId,                       -- Object flag for device
      iEndTexId,                       -- End tile id chosen from texture
      iGameTicks,                      -- Total game ticks
      iGameTime,                       -- Total game time
      iKeyBankLoseId,                  -- Lose screen key bank id
      iKeyBankWinResultId,             -- Win screen result key bank id
      iKeyBankWinStatusId,             -- Win screen game status bank id
      iHotSpotLoseId,                  -- Lose screen hot spot id
      iHotSpotWinResultId,             -- Win screen result hot spot id
      iHotSpotWinStatusId,             -- Win screen game status hot spot id
      iLevelId,                        -- Level that was completed
      iSSelect,                        -- Select sound effect
      iSalary,                         -- Salary paid total
      nFade, nScale,                   -- Fade amounts
      texEnd;                          -- End texture
-- Mark positive colour or negative ---------------------------------------- --
local function Green(iValue) return "\rcff7fff7f"..iValue.."\rr" end;
local function Red(iValue) return "\rcffff7f7f"..iValue.."\rr" end;
local function Colourise(iValue)
  if iValue >= 0 then return Green(UtilFormatNumber(iValue, 0));
  else return Red(UtilFormatNumber(iValue, 0)) end;
end
-- Function to help make lines data ---------------------------------------- --
local function MakeLine(aDest, sMsg)
  -- Chosen X pixel and callback to scroll in
  local iX, fCb;
  -- Id would be even?
  if #aDest % 2 == 0 then
    -- Function to gradually scroll the message in from the left
    local function Increase(iX)
      -- Clamp (don't include 160 or we'll get a FP error)
      if iX >= 159 then return 160;
      -- Move the message right
      else return iX + abs(-160 + iX) * 0.1 end;
    end
    -- Set the X pixel and callback
    iX, fCb = -160, Increase;
  -- Id would be odd?
  else
    -- Function to gradually scroll the message in from the right
    local function Decrease(iX)
      -- Clamp (don't include 160 or we'll get a FP error)
      if iX < 161 then return 160;
      -- Move the message left
      else return iX - (iX - 160) * 0.1 end;
    end
    -- Set the X pixel and callback
    iX, fCb = 480, Decrease;
  end
  -- Insert into chosen lines
  aDest[1 + #aDest] = { iX, aDest.Y + (#aDest * 16), fCb, sMsg };
end
-- Proc a collection of lines ---------------------------------------------- --
local function ProcCollection(aCollection)
  for iLineId = 1, #aCollection do
    local aItem<const> = aCollection[iLineId];
    aItem[1] = aItem[3](aItem[1]);
  end
end
-- Draw a collection of lines ---------------------------------------------- --
local function DrawCollection(aCollection)
  fontLarge:SetCRGBA(1, 1, 1, 1);
  for iLineId = 1, #aCollection do
    local aItem<const> = aCollection[iLineId];
    PrintC(fontLarge, aItem[1], aItem[2], aItem[4]);
  end
end
-- Render end function ----------------------------------------------------- --
local function RenderEnd()
  -- Render terrain and objects
  RenderTerrain();
  RenderObjects();
  -- Render animated fade
  RenderFade(nFade);
  -- Draw ending graphic
  local nScale<const> = nFade * 2;
  texEnd:SetCA(nScale);
  BlitSLTWHA(texEnd, iEndTexId, 160, 120, 159 * nScale, 95 * nScale, nScale);
  -- Set font colour and draw lines
  for iCollectionId = 1, #aCollections do
    DrawCollection(aCollections[iCollectionId]);
  end
end
-- Goto map post mortem ---------------------------------------------------- --
local function GoPostMortem()
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Load music and when finished execute the win assets handler
  InitPost(iLevelId);
end
-- Render win information screen ------------------------------------------- --
local function RenderWinInfo()
  -- Render terrain and objects
  RenderTerrain();
  RenderObjects();
  -- Fade backdrop
  RenderFade(0.5);
  -- Draw centre lines
  DrawCollection(aLinesCentre);
end
-- Proc win information screen --------------------------------------------- --
local function ProcWinInfo()
  -- Fade in elements
  if nFade < 0.5 then nFade = nFade + 0.01;
  -- Fade complete?
  elseif nFade >= 0.5 then
    -- Set game status creen key binds and hot spot
    SetKeys(true, iKeyBankWinStatusId);
    SetHotSpot(iHotSpotWinStatusId);
    -- Clear animation procedure and set wait to click
    SetCallbacks(nil, RenderWinInfo);
  end
  -- Draw centre lines
  ProcCollection(aLinesCentre);
end
-- Set game status page ---------------------------------------------------- --
local function GoWinGameStatus()
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Build data for centre lines
  MakeLine(aLinesCentre,
    Colourise(aGlobalData.gBankBalance).." IN BANK");
  MakeLine(aLinesCentre,
    Colourise(aGlobalData.gPercentCompleted).."% COMPLETED");
  MakeLine(aLinesCentre, "RAISE "..
    Colourise(aGlobalData.gZogsToWinGame - aGlobalData.gBankBalance)..
    " MORE");
  MakeLine(aLinesCentre, "ZOGS TO WIN THE GAME");
  MakeLine(aLinesCentre,
    "(REQUIRED: "..Colourise(aGlobalData.gZogsToWinGame)..")");
  -- We're going to reuse this value just as an input blocking timer
  nFade = 0;
  -- Dereference the ending texture
  texEnd = nil
  -- Set no keys and wait hot spot until animation finished
  SetKeys(true);
  SetHotSpot();
  -- Show win information screen
  SetCallbacks(ProcWinInfo, RenderWinInfo);
end
-- Set game status page ---------------------------------------------------- --
local function GoLoseScore()
  -- Play sound
  PlayStaticSound(iSSelect);
  -- On fade out
  local function OnFadeOut()
    -- Dereference the ending texture
    texEnd = nil
    -- Init score screen
    InitScore();
  end
  -- Failed? Restart the level!
  Fade(0, 1, 0.04, RenderEnd, OnFadeOut, true);
end
-- Proc end function ------------------------------------------------------- --
local function ProcBankAnimateEnd()
  -- Animate centre lines
  ProcCollection(aLinesCentre);
end
-- Proc end function ------------------------------------------------------- --
local function ProcAnimateEnd()
  -- Fade in elements
  if nFade < 0.5 then nFade = nFade + 0.01;
  -- Fade complete?
  elseif nFade >= 0.5 then
    -- Clamp fade
    nFade = 0.5;
    -- The zone was won? Clear animation proc and set input win
    fcbOnFadeIn();
  end
  -- Alter animation
  for iCollectionId = 1, #aCollections do
    ProcCollection(aCollections[iCollectionId]);
  end
end
-- Calculate capital carried ----------------------------------------------- --
local function GetCapitalCarried()
  -- Capital value
  local nCapitalValue = 0;
  -- Check object and sell it if it's a device
  local function SellDevice(aObj, nDivisor)
    -- Failed if not a device
    if aObj.F & iDeviceId == 0 then return end;
    -- Add capital value (25% value minus current quality)
    nCapitalValue = nCapitalValue +
      (aObj.OD.VALUE / nDivisor) * (aObj.H / 100);
  end
  -- Enumerate all game objects
  for iObjIndex = 1, #aObjects do
    -- Get object and if it is owned by the active player?
    local aObj<const> = aObjects[iObjIndex];
    if aActivePlayer == aObj.P then
      -- If object is a device? Add 25% of it's value minus quality because
      -- it cost's money to recover the device. :-)
      SellDevice(aObj, 4);
      -- Get object's inventory and sell it all 50% of it's value since the
      -- object or digger is already carrying the item.
      local aObjInv<const> = aObj.I;
      for iInvIndex = 1, #aObjInv do SellDevice(aObjInv[iInvIndex], 2) end;
    end
  end
  -- Return value
  return floor(nCapitalValue);
end
-- Calculate exploration count --------------------------------------------- --
local function GetExploration()
  -- Exploration amount to return
  local iExploration = 0;
  -- Enumerate shroud data and add one for every fully revealed tile
  for iI = 1, #aShroudData do
    if aShroudData[iI][2] == 0xF then iExploration = iExploration + 1 end;
  end
  -- Return amount
  return iExploration;
end
-- On faded in win --------------------------------------------------------- --
local function OnFadedInWin()
  -- Set game status screen keybinds and hot spot
  SetKeys(true, iKeyBankWinResultId);
  SetHotSpot(iHotSpotWinResultId);
  -- Clear animation procedure and set wait to click
  SetCallbacks(nil, RenderEnd);
end
-- On faded in lose ------------------------------------------------------- --
local function OnFadedInLose()
  -- Set game status creen keybinds
  SetKeys(true, iKeyBankLoseId);
  SetHotSpot(iHotSpotLoseId);
  -- Clear animation procedure and set wait to click
  SetCallbacks(nil, RenderEnd);
end
-- On loaded event function ------------------------------------------------ --
local function OnAssetsLoaded(aResources, aActivePlayer, aOpponentPlayer, sMsg)
  -- Keep waiting cursor for animation
  SetHotSpot();
  -- Play End music
  PlayMusic(aResources[2]);
  -- Load texture
  texEnd = aResources[1];
  -- Get capital carried
  aGlobalData.gCapitalCarried = GetCapitalCarried();
  -- Get cost of digger deaths
  local iPRemain<const> = aActivePlayer.DC;
  local iPDeaths<const> = #aActivePlayer.D - iPRemain;
  aGlobalData.gTotalDeaths = aGlobalData.gTotalDeaths + iPDeaths
  iDeadCost, iSalary = iPDeaths * 65, iPRemain * 30;
  -- Add enemy kills
  local iPKills<const> = aActivePlayer.EK;
  aGlobalData.gTotalEnemyKills = aGlobalData.gTotalEnemyKills + iPKills;
  -- Add homicides of opponent playerss
  aGlobalData.gTotalHomicides = aGlobalData.gTotalHomicides + aActivePlayer.LK;
  -- Calculate exploration amount
  aGlobalData.gTotalExploration =
    aGlobalData.gTotalExploration + GetExploration();
  -- Get game ticks and time
  iGameTicks = GetGameTicks();
  iGameTime = iGameTicks // 3600;
  -- Add data
  aGlobalData.gTotalGemsFound =
    aGlobalData.gTotalGemsFound + aActivePlayer.GEM;
  aGlobalData.gTotalGemsSold =
    aGlobalData.gTotalGemsSold + aActivePlayer.GS;
  aGlobalData.gTotalCapital =
    aGlobalData.gTotalCapital + aGlobalData.gCapitalCarried;
  aGlobalData.gTotalTimeTaken =
    aGlobalData.gTotalTimeTaken + iGameTicks // 60;
  aGlobalData.gTotalIncome =
    aGlobalData.gTotalIncome + aActivePlayer.GI;
  aGlobalData.gTotalDug =
    aGlobalData.gTotalDug + aActivePlayer.DUG;
  aGlobalData.gTotalPurchases =
    aGlobalData.gTotalPurchases + aActivePlayer.PUR;
  aGlobalData.gBankBalance =
    aGlobalData.gBankBalance + (aActivePlayer.M - iDeadCost - iSalary);
  aGlobalData.gPercentCompleted =
    floor(aGlobalData.gBankBalance / aGlobalData.gZogsToWinGame * 100);
  -- Make lines data with initial Y position
  aLinesTop, aLinesBottom, aLinesCentre = { Y=12 }, { Y=180 }, { Y=80 };
  -- Array holding top and bottom datas which are drawn together
  aCollections = { aLinesTop, aLinesBottom };
  -- Build data for top three lines
  MakeLine(aLinesTop, sMsg);
  MakeLine(aLinesTop, "OPPONENT HAD "..Green(aOpponentPlayer.M).." ZOGS");
  MakeLine(aLinesTop, "GAME TIME WAS "..Green(iGameTime).." MINS");
  -- Build data for bottom three lines
  MakeLine(aLinesBottom,
    Green(aGlobalData.gCapitalCarried).." CAPITAL CARRIED");
  MakeLine(aLinesBottom, Red(iSalary).." SALARY PAID");
  MakeLine(aLinesBottom, Red(iDeadCost).." DEATH DUTIES");
  -- Fade amount
  nFade, nScale = 0, 0;
  -- Change render procedures
  SetCallbacks(ProcAnimateEnd, RenderEnd);
end
-- Initialise the lose screen ---------------------------------------------- --
local function InitEnd(iLId, aAP, aOP, aIR, iETId, sMsg)
  -- Check parameters
  if not UtilIsInteger(iLId) then
    error("Invalid level id specified! "..tostring(iLId)) end;
  if iLId <= 0 then error("Specify positive level id, not "..iLId.."!") end;
  if not UtilIsTable(aAP) then
    error("Invalid active player table! "..tostring(aAP)) end;
  if not UtilIsTable(aOP) then
    error("Invalid opponent player table! "..tostring(aOP)) end;
  if not UtilIsTable(aIR) then
    error("Invalid resources table! "..tostring(aIR)) end;
  if not UtilIsInteger(iETId) then
    error("Invalid texture id integer! "..tostring(iETId)) end;
  if not UtilIsString(sMsg) then
    error("Invalid message string! "..tostring(sMsg)) end;
  -- Set level id
  iLevelId = iLId;
  -- Set tile id to use
  iEndTexId = iETId;
  -- Set callback
  if aIR[1] then fcbOnFadeIn = OnFadedInWin else fcbOnFadeIn = OnFadedInLose end;
  -- Load level ending resources
  LoadResources("ZoneEnd", aIR[2], OnAssetsLoaded, aAP, aOP, sMsg);
end
-- ------------------------------------------------------------------------- --
local function InitLoseDead(iLId, aP, aOP)
  InitEnd(iLId, aP, aOP, aLoseAssets, 0, "ALL YOUR DIGGERS DIED") end;
local function InitWinDead(iLId, aP, aOP)
  InitEnd(iLId, aP, aOP, aWinAssets,  1, "YOUR OPPONENT IS DEAD") end;
local function InitWin(iLId, aP, aOP)
  InitEnd(iLId, aP, aOP, aWinAssets,  2, "YOU RAISED THE CASH") end;
local function InitLose(iLId, aP, aOP)
  InitEnd(iLId, aP, aOP, aLoseAssets, 3, "YOUR OPPONENT WON") end;
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, aAssetsData, aCursorIdData,
    aObjectFlags, aSfxData;
  -- Grab imports
  BlitSLTWHA, Fade, GetGameTicks, InitPost, InitScore, LoadResources,
    PlayMusic, PlayStaticSound, PrintC, RegisterHotSpot, RegisterKeys,
    RenderFade, RenderObjects, RenderTerrain, SetCallbacks, SetHotSpot,
    SetKeys, aAssetsData, aCursorIdData, aGemsAvailable, aGlobalData,
    aObjectFlags, aObjects, aSfxData, aShroudData, fontLarge =
      GetAPI("BlitSLTWHA", "Fade", "GetGameTicks", "InitPost", "InitScore",
        "LoadResources", "PlayMusic", "PlayStaticSound", "PrintC",
        "RegisterHotSpot", "RegisterKeys", "RenderFade", "RenderObjects",
        "RenderTerrain", "SetCallbacks", "SetHotSpot", "SetKeys",
        "aAssetsData", "aCursorIdData", "aGemsAvailable", "aGlobalData",
        "aObjectFlags", "aObjects", "aSfxData", "aShroudData", "fontLarge");
  -- Setup assets required
  local aEndAssets<const> = aAssetsData.post;
  aWinAssets = { true, { aEndAssets, aAssetsData.scenem } };
  aLoseAssets = { false, { aEndAssets, aAssetsData.losem } };
  -- Register keybinds
  local aKeys<const>, aStates<const> = Input.KeyCodes, Input.States;
  local iPress<const> = aStates.PRESS;
  iKeyBankLoseId = RegisterKeys("IN-GAME LOSE", {
    [iPress] = { { aKeys.ESCAPE, GoLoseScore, "iglets", "EXIT TO SCORES" } }
  });
  local iEnter<const> = aKeys.ENTER;
  local sName<const> = "IN-GAME WIN";
  iKeyBankWinResultId = RegisterKeys(sName, {
    [iPress] = { { iEnter, GoWinGameStatus, "igwc", "CONTINUE" } }
  });
  iKeyBankWinStatusId = RegisterKeys(sName, {
    [iPress] = { { iEnter, GoPostMortem, "igwpm", "POST MORTEM" } }
  });
  -- Get object flag device id for calculating capital carried
  iDeviceId = aObjectFlags.DEVICE;
  -- Set sound effect ids
  iSSelect = aSfxData.SELECT;
  -- Set cursor ids
  local iCOK<const>, iCExit<const> = aCursorIdData.OK, aCursorIdData.EXIT;
  -- Register hot spots
  iHotSpotLoseId = RegisterHotSpot({
    { 0, 0, 0, 240, 3, iCExit, false, false, GoLoseScore }
  });
  iHotSpotWinResultId = RegisterHotSpot({
    { 0, 0, 0, 240, 3, iCOK, false, false, GoWinGameStatus }
  });
  iHotSpotWinStatusId = RegisterHotSpot({
    { 0, 0, 0, 240, 3, iCOK, false, false, GoPostMortem }
  });
end
-- Exports and imports ----------------------------------------------------- --
return { F = OnScriptLoaded, A = { InitWin = InitWin,
  InitWinDead = InitWinDead, InitLose = InitLose,
  InitLoseDead = InitLoseDead } };
-- End-of-File ============================================================= --
