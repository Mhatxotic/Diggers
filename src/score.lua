-- SCORE.LUA =============================================================== --
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
local unpack<const>, error<const>, pairs<const>, ipairs<const>, max<const>,
  min<const>, sin<const>, cos<const>, tostring<const>, maxinteger<const>,
  mininteger<const> =
    table.unpack, error, pairs, ipairs, math.max, math.min, math.sin, math.cos,
    tostring, math.maxinteger, math.mininteger;
-- M-Engine function aliases ----------------------------------------------- --
local CoreTime<const>, UtilFormatNumber<const>, UtilIsInteger<const>,
  UtilIsString<const> = Core.Time, Util.FormatNumber, Util.IsInteger,
  Util.IsString;
-- Diggers function and data aliases --------------------------------------- --
local BlitLT, BlitSLTWH, BlitSLT, Fade, InitTitle, LoadResources, PlayMusic,
  PlayStaticSound, Print, PrintC, PrintR, RegisterFBUCallback, aGlobalData,
  RenderFade, SetCallbacks, SetHotSpot, SetKeys, fontLittle, fontTiny, texSpr;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Assets required
      aTotals,                         -- Score categories
      iCExit, iCWait,                  -- Cursor ids
      iColourIndex,                    -- Current transparency
      iBarY,                           -- Bars position
      iHotSpotId,                  -- Hot spot id on scores tallied
      iKeyBankId,                      -- Key bank id
      iSSelect,                        -- Select sound effect id
      iStageL,                         -- Stage left position
      iScoreItem,                      -- Score for current item
      iTotalId,                        -- Currently active line
      iTotalScore,                     -- Total score
      nWidth, nAspect, nHeight,        -- Logo positioning
      nWidthN, nHeightN, nLX1, nRX1,   -- Logo positioning
      strScoreC,                       -- Stringified category score
      strScore,                        -- Stringified grand score
      texTitle;                        -- Title textures
-- Statics ----------------------------------------------------------------- --
local sTitleText<const> = "GAME OVER -- HOW WELL DID YOU DO?";
local aRanks<const> = {
  {  maxinteger, "Hacker"       }, {  0x80000000, "Cheater"      },
  {     1200000, "Grand Master" }, {     1100000, "Master"       },
  {     1000000, "Professional" }, {      900000, "Genius"       },
  {      800000, "Expert"       }, {      700000, "Advanced"     },
  {      600000, "Intermediate" }, {      500000, "Adept"        },
  {      400000, "Amateur"      }, {      300000, "Apprentice"   },
  {      200000, "Novice"       }, {      100000, "Beginner"     },
  {           0, "Newbie"       }, { -0x80000000, "Slug"         },
  {  mininteger, "Cheater"      }
};
-- Draw animated logos ----------------------------------------------------- --
local function DrawLogos()
  -- Don't draw anything if in 4:3 mode
  if iStageL >= 0 then return end;
  -- Draw right moving down and left moving up logogs
  local nLX = (CoreTime() * 100) % 240;
  local nLY = -nLX;
  local nRH = nHeight + nLY;
  texTitle:SetCA(0.25);
  BlitSLTWH(texTitle, 1, nLX1,-240+nLX, nWidth,  nHeight);
  BlitSLTWH(texTitle, 1, nLX1,     nLX, nWidth,  nHeight);
  BlitSLTWH(texTitle, 1, nLX1, 240+nLX, nWidth,  nHeight);
  BlitSLTWH(texTitle, 1, nRX1,     nRH, nWidthN, nHeightN);
  BlitSLTWH(texTitle, 1, nRX1, 240+nRH, nWidthN, nHeightN);
  BlitSLTWH(texTitle, 1, nRX1, 480+nRH, nWidthN, nHeightN);
  -- Draw left moving down and right moving up logogs
  nLX = -nLX;
  nLY = -nLY - 240;
  nRH = nHeight + nLY;
  BlitSLTWH(texTitle, 1, nLX1,-240+nLX, nWidth,  nHeight);
  BlitSLTWH(texTitle, 1, nLX1,     nLX, nWidth,  nHeight);
  BlitSLTWH(texTitle, 1, nLX1, 240+nLX, nWidth,  nHeight);
  BlitSLTWH(texTitle, 1, nRX1,     nRH, nWidthN, nHeightN);
  BlitSLTWH(texTitle, 1, nRX1, 240+nRH, nWidthN, nHeightN);
  BlitSLTWH(texTitle, 1, nRX1, 480+nRH, nWidthN, nHeightN);
  -- Reset lobby texture colour
  texTitle:SetCRGBA(1, 1, 1, 1);
end
-- Render score ------------------------------------------------------------ --
local function ProcRenderScore()
  -- Draw background
  texTitle:SetCRGBA(1, 1, 1, 1);
  BlitLT(texTitle, -96, 0);
  -- Draw logos
  DrawLogos();
  -- Draw title
  for iI = 1, #aTotals do
    -- Get bar data
    local aData<const> = aTotals[iI];
    -- This is our bar id?
    if iTotalId == iI then
      texSpr:SetCRGB(0, 0.5, 0);
      RenderFade(1, 8, aData[8]-2, 312, aData[8]+10, 1022);
      fontLittle:SetCRGBA(1, 1, 1, 1);
      Print(fontLittle, aData[7]+16, aData[8], aData[6]);
      fontTiny:SetCRGBA(1, 1, 1, 1);
      PrintR(fontTiny, aData[7]+160, aData[8]+1, aData[12]);
      fontTiny:SetCRGBA(1, 1, 1, 1);
      Print(fontTiny, aData[7]+160, aData[8]+1, aData[11]);
      fontLittle:SetCRGBA(1, 1, 1, 1);
      PrintR(fontLittle, aData[7]+304, aData[8], aData[9]);
    else
      if iTotalId > iI then texSpr:SetCRGB(0, 0, 0.5);
                       else texSpr:SetCRGB(0.5, 0, 0) end;
      local nVal = CoreTime()+iI/4;
      RenderFade(sin(nVal)*cos(nVal)+0.75,
        aData[7]+8, aData[8]-2, aData[7]+312, aData[8]+10, 1022);
      fontLittle:SetCRGBA(0.75, 0.75, 0.75, 1);
      Print(fontLittle, aData[7]+16, aData[8], aData[6]);
      fontTiny:SetCRGBA(0, 1, 0, 1);
      PrintR(fontTiny, aData[7]+160, aData[8]+1, aData[12]);
      fontTiny:SetCRGBA(1, 0.5, 0, 1);
      Print(fontTiny, aData[7]+160, aData[8]+1, aData[11]);
      fontLittle:SetCRGBA(1, 0, 1, 1);
      PrintR(fontLittle, aData[7]+304, aData[8], aData[9]);
    end
  end
  -- Set text colour
  fontLittle:SetCRGBAI(0xFFFFFFFF);
  texSpr:SetCRGBAI(0x7F0000FF);
  -- Finished tallying?
  if iTotalId > #aTotals then
    -- Starting X position
    local iX = 8;
    -- Draw the left side of the title and status bar
    for iY = 8, 216, 208 do BlitSLT(texSpr, 847, iX, iY) end;
    -- Move along X axis again by one tile
    iX = iX + 16;
    -- Calculate X position where we are ending drawing at
    local iXmax = iX + (16 * 16);
    -- Until we are at the maximum
    while iX <= iXmax do
      -- Draw top and bottom part
      for iY = 8, 216, 208 do BlitSLT(texSpr, 848, iX, iY) end;
      -- Move X along
      iX = iX + 16;
    end
    -- Draw the right side of the title and status bar
    for iY = 8, 216, 208 do BlitSLT(texSpr, 849, iX, iY) end;
    -- Draw title
    PrintC(fontLittle, 160, 12, sTitleText);
    -- Draw pulsating score
    fontLittle:SetSize(3);
    local nVal = CoreTime();
    fontLittle:SetCA(sin(nVal) * cos(nVal) + 0.75);
    PrintR(fontLittle, 304, 213, strScore);
    -- Draw rank
    fontLittle:SetSize(1);
    Print(fontLittle, 16, 220, strScoreC);
  -- Still tallying?
  else
    -- Animate title and status bars
    if iBarY < 24 then iBarY = iBarY + 1 end;
    -- Starting X position
    local iX = 8;
    -- Draw left part of title and status bar including animation
    BlitSLT(texSpr, 847, iX, -16+iBarY);
    BlitSLT(texSpr, 847, iX, 216+(24-iBarY));
    -- Move X along one tile
    iX = iX + 16;
    -- Draw centre part of title and status bar
    local iXmax = iX + (16 * 16);
    while iX <= iXmax do
      -- Draw top and bottom part
      BlitSLT(texSpr, 848, iX, -16+iBarY);
      BlitSLT(texSpr, 848, iX, 216+(24-iBarY));
      -- Move X along one tile
      iX = iX + 16;
    end
    -- Draw right part of title and status bar
    BlitSLT(texSpr, 849, iX, -16+iBarY);
    BlitSLT(texSpr, 849, iX, 216+(24-iBarY));
    -- Draw title text
    PrintC(fontLittle, 160, -12+iBarY, sTitleText);
    -- Draw score text
    fontLittle:SetSize(3);
    PrintR(fontLittle, 304, 213+(24-iBarY), strScore);
    -- Draw rank
    fontLittle:SetSize(1);
    Print(fontLittle, 16, 220+(24-iBarY), strScoreC);
  end
  -- Reset sprites and font colour this for mouse cursor
  texSpr:SetCRGBAI(0xFFFFFFFF);
  fontLittle:SetCRGBAI(0xFFFFFFFF);
  fontTiny:SetCRGBAI(0xFFFFFFFF);
end
-- When faded out? --------------------------------------------------------- --
local function OnFadedOutToTitle()
  -- Remove callback
  RegisterFBUCallback("score");
  -- Done with the texture handle here
  texTitle = nil;
  --- ...and return to title screen. It can reuse the texture!
  InitTitle();
end
-- GoToTitle procedure -------------------------------------------------------- --
local function GoToTitle()
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Fade out...
  Fade(0, 1, 0.01, ProcRenderScore, OnFadedOutToTitle, true);
end
-- Tick procedure ---------------------------------------------------------- --
local function ProcScore()
  -- If animating in?
  if iTotalId == 0 then
    -- Animate bars
    for iI = 1, #aTotals do
      -- Get bar data
      local aData = aTotals[iI];
      -- Call movement callback for bar
      aData[10](aData);
    end
    -- If all bars have been moved? Start counting
    if aTotals[#aTotals][7] == 0 then iTotalId = 1 end;
    -- Done for now
    return;
  end
  -- Get category data and if category needs tallying?
  local aData<const> = aTotals[iTotalId];
  if aData[1] == 1 then
    -- No more categories left to add? Set finished
    if aData[4] == 0 then aData[1] = 2;
    -- Still tallying?
    else
      -- Do tally function
      local function Tallied()
        -- Clamp value
        aData[2] = aData[3];
        -- Set human readable final quantity
        aData[12] = UtilFormatNumber(aData[2], 0);
        -- Set final score for quantity and update human readable score
        iScoreItem = aData[2] * aData[5]
        aData[9] = UtilFormatNumber(iScoreItem, 0);
        -- Update total score and human readable score
        iTotalScore = iTotalScore + iScoreItem;
        strScore = UtilFormatNumber(iTotalScore, 0);
        -- Set category completed to goto next category
        aData[1] = 2;
        -- Clear score incase the next category is zero
        iScoreItem = 0;
      end
      -- Tallying function
      local function Tally()
        -- Add to tally
        aData[2] = aData[2] + aData[4];
        -- Set human readable final quantity
        aData[12] = UtilFormatNumber(aData[2], 0);
        -- Set tallied score for quantity and update human readable score
        iScoreItem = aData[2] * aData[5]
        aData[9] = UtilFormatNumber(iScoreItem, 0);
        -- Update human readable score
        strScore = UtilFormatNumber(iTotalScore + iScoreItem, 0);
      end
      -- Category counting up?
      if aData[3] >= 0 then
        -- Run function depending if tallying or tally finished
        if aData[2] >= aData[3] then Tallied() else Tally() end;
      -- Category counting down? If tallying completed or overflowed?
      elseif aData[2] <= aData[3] then Tallied() else Tally() end;
    end
    -- Update rank
    for iI = 1, #aRanks do
      local aRank<const> = aRanks[iI];
      if iTotalScore >= aRank[1] then strScoreC = aRank[2] break end;
    end
  -- All categories tallied?
  elseif aData[1] == 2 then
    -- Increment total categories proceeded and if we did all of them?
    iTotalId = iTotalId + 1;
    if iTotalId > #aTotals then
      -- Enable keys and hot spot
      SetKeys(true, iKeyBankId);
      SetHotSpot(iHotSpotId);
      -- Wait for input
      SetCallbacks(nil, ProcRenderScore);
    end
  end
end
-- Render function --------------------------------------------------------- --
local function RenderSimple()
  -- Draw backdrop
  BlitLT(texTitle, -96, 0);
  -- Draw logos
  DrawLogos();
end
-- Function to add a new total --------------------------------------------- --
local function AddTotal(sLabel, iValue, iScorePerTick)
  -- Check parameters
  if not UtilIsString(sLabel) then
    error("Label string is invalid! "..tostring(sLabel)) end;
  if #sLabel == 0 then error("Label is empty!") end;
  if not UtilIsInteger(iValue) then
    error("Value integer is invalid! "..tostring(iValue)) end;
  if not UtilIsInteger(iScorePerTick) then
    error("Score/tick integer is invalid! "..tostring(iScorePerTick)) end;
  -- Starting X and movement callback are conditional
  local nStartX, fcbMove;
  -- If next id is odd?
  if #aTotals % 2 == 0 then
    -- Start from left
    nStartX = -480 - (#aTotals * 16);
    -- Move in from left callback
    local function MoveFromLeft(aData)
      -- Ignore if in centre of screen
      if aData[7] >= 0 then return end;
      aData[7] = min(0, aData[7] + 8);
    end
    -- Set call back to move in from left
    fcbMove = MoveFromLeft;
  -- If next id is even?
  else
    -- Start from right
    nStartX = 480+(#aTotals*16)
    -- Move in from right functino
    local function MoveFromRight(aData)
      -- Ignore if in centre of screen
      if aData[7] <= 0 then return end;
      aData[7] = max(0, aData[7] - 8);
    end
    -- Set call back to move in from right
    fcbMove = MoveFromRight;
  end
  -- Prepare the category in the categories list
  aTotals[1 + #aTotals] = {
    1,                             -- [01] Operational function
    0,                             -- [02] Current 'value' animated tally
    iValue,                        -- [03] Total 'value' remaining to tally
    iValue / 60,                   -- [04] 'Value' to take off per tick
    iScorePerTick,                 -- [05] Score to add per tick 'value'.
    sLabel,                        -- [06] Item label
    nStartX,                       -- [07] Starting X position
    32 + (#aTotals * 14),          -- [08] Starting Y position
    0,                             -- [09] Actual final score for item
    fcbMove,                       -- [10] Move animation callback
    "x"..UtilFormatNumber(iScorePerTick, 0), -- [11] Localised 'iScorePerTick'
    "0",                           -- [12] Localised 'value'
  };
end
-- When the main fbo dimensions changed ------------------------------------ --
local function OnStageUpdated(...)
  local _ _, _, iStageL, _, _, _ = ...;
  -- Update logo positions
  nWidth = -iStageL - 4;
  nAspect = 208 / 58;
  nHeight = nWidth * nAspect;
  nWidthN = -nWidth;
  nHeightN = -nHeight
  nLX1 = iStageL + 4;
  nRX1 = 320 + nWidth;
end
-- When score screen has faded in ------------------------------------------ --
local function OnFadedIn()
  -- Set wait hot spot
  SetHotSpot();
  -- Coloured score
  strScoreC, strScore, iColourIndex = "", "0", 1;
  -- Set callbacks
  SetCallbacks(ProcScore, ProcRenderScore);
end
-- When score assets have loaded? ------------------------------------------ --
local function OnAssetsLoaded(aResources)
  -- Register frame buffer update
  RegisterFBUCallback("score", OnStageUpdated);
  -- Play score music
  PlayMusic(aResources[2]);
  -- Setup lobby texture
  texTitle = aResources[1];
  -- Reset values
  iBarY, iTotalId, iTotalScore, aTotals, iScoreItem = 0, 0, 0, { }, 0;
  -- Count levels completed
  local iZonesComplete = 0;
  for _ in pairs(aGlobalData.gLevelsCompleted) do
    iZonesComplete = iZonesComplete + 1 end;
  -- Add score categories
  for iI, aData in ipairs({
    { "Bank balance",      aGlobalData.gBankBalance,        10 },
    { "Zones completed",   iZonesComplete,               10000 },
    { "Terrain dug",       aGlobalData.gTotalDug,            1 },
    { "Exploration",       aGlobalData.gTotalExploration,    1 },
    { "Gems found",        aGlobalData.gTotalGemsFound,    100 },
    { "Gems sold",         aGlobalData.gTotalGemsSold,     100 },
    { "Gems value",        aGlobalData.gTotalIncome,        10 },
    { "Items purchased",   aGlobalData.gTotalPurchases,   1000 },
    { "Capital carried",   aGlobalData.gTotalCapital,      100 },
    { "Fiends eliminated", aGlobalData.gTotalEnemyKills, 10000 },
    { "Homicide duties",  -aGlobalData.gTotalHomicides,   1000 },
    { "Mortality duties", -aGlobalData.gTotalDeaths,      1000 },
    { "Time taken",       -aGlobalData.gTotalTimeTaken,      1 },
  }) do AddTotal(unpack(aData)) end;
  -- Fade in
  Fade(1, 0, 0.025, RenderSimple, OnFadedIn);
end
-- Init score screen function ---------------------------------------------- --
local function InitScore()
  LoadResources("Game Over", aAssets, OnAssetsLoaded);
end
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, aAssetsData, aCursorIdData, aSfxData;
  -- Grab imports
  BlitLT, BlitSLTWH, BlitSLT, Fade, InitTitle, LoadResources, PlayMusic,
    PlayStaticSound, Print, PrintC, PrintR, RegisterFBUCallback,
    RegisterHotSpot, RegisterKeys, RenderFade, SetCallbacks, SetHotSpot,
    SetKeys, aAssetsData, aCursorIdData, aGlobalData, aSfxData, fontLittle,
    fontTiny, texSpr =
      GetAPI("BlitLT", "BlitSLTWH", "BlitSLT", "Fade", "InitTitle",
        "LoadResources", "PlayMusic", "PlayStaticSound", "Print", "PrintC",
        "PrintR", "RegisterFBUCallback", "RegisterHotSpot", "RegisterKeys",
        "RenderFade", "SetCallbacks", "SetHotSpot", "SetKeys", "aAssetsData",
        "aCursorIdData", "aGlobalData", "aSfxData", "fontLittle",
        "fontTiny", "texSpr");
  -- Setup required assets
  aAssets = { aAssetsData.title, aAssetsData.scorem };
  -- Get cursor ids
  local iCExit<const>, iCWait<const> = aCursorIdData.EXIT, aCursorIdData.WAIT;
  -- Register hot spot for when all scores tallied
  iHotSpotId = RegisterHotSpot({
    { 0, 0, 0, 240, 3, iCExit, false, false, GoToTitle },
  });
  -- Register key binds
  iKeyBankId = RegisterKeys("IN-GAME SCORES", { [Input.States.PRESS] = {
    { Input.KeyCodes.ESCAPE, GoToTitle, "igsc", "CLOSE" }
  } });
  -- Get sound effect ids
  iSSelect = aSfxData.SELECT;
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitScore = InitScore }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
