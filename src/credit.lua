-- CREDIT.LUA ============================================================== --
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
local random<const>, remove<const>, create<const> =
  math.random, table.remove, table.create;
-- Diggers function and data aliases --------------------------------------- --
local BlitLTRB, DeInitLevel, Fade, GameProc, GetMusic, InitScore, LoadDemoLevel,
  LoadLevel, LoadResources, LockViewport, PlayMusic, PrintC, PrintR, Print,
  PrintWS, RegisterFBUCallback, RenderObjects, RenderTerrain, SelectObject,
  SetCallbacks, aCreditsData, aCreditsXData, aEndLoadData, aLevelTypesData,
  aLevelsData, oObjectTypes, aObjs, aPlayers, fontLarge, fontLittle;
-- Other locals ------------------------------------------------------------ --
local aAssets,                         -- Assets required
      aLevels,                         -- Levels available to show
      aXCredits,                       -- Rolling credits data
      bLast,                           -- Is the last level to show?
      fcbCreditsRender,                -- Credits render callback function
      iActionTimer,                    -- Action timer between levels
      iCreditId,                       -- Current credit id
      nCredits1Y, nCredits2Y,          -- Credits position
      nRollingCreditY,                 -- Rolling credits position
      nStageM,                         -- Centre of stage position
      nStageT, nStageR, nStageB,       -- Stage top, right and bottom bounds
      nStageW, nStageH, nStageL,       -- Stage width, height and left bounds
      strCredits1, strCredits2,        -- Credits first and second line
      texVig;                          -- Vignette texture
-- A simple blank function ------------------------------------------------- --
local function BlankFunction() end;
-- Rolling credits 'fake' level data --------------------------------------- --
local aEndLevelData<const> = { n = "END", f = "end", t = false };
-- When faded out to title? ------------------------------------------------ --
local function OnFadeOutScore()
  -- De-init the level data
  DeInitLevel();
  -- Dereference assets to garbage collector
  texVig = nil;
  -- Remove frame buffer update
  RegisterFBUCallback("credits");
  -- Initialise score screen
  InitScore();
end
-- Render rolling credits function ----------------------------------------- --
local function RenderExtra()
  -- Render terrain and objects
  RenderTerrain();
  RenderObjects();
  -- Render vignette
  BlitLTRB(texVig, nStageL, nStageT, nStageR, nStageB);
  -- Prepare font colours
  fontLarge:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  fontLittle:SetCRGBA(0.0, 1.0, 0.0, 1.0);
  -- Enumerate remaining credits
  local iI = 1;
  while iI <= #aXCredits do
    -- Get credit data
    local aCredit<const> = aXCredits[iI];
    -- Get top of title credit
    local nTop<const> = nRollingCreditY + aCredit[1];
    -- Get bottom of name credit
    local nBottom<const> = nRollingCreditY + aCredit[3];
    -- If bottom of credit is off the top of the screen?
    if nBottom < nStageT then
      -- Remove the credit and if there are no more remaining?
      remove(aXCredits, iI);
      if #aXCredits == 0 then
        -- Fade to title
        return Fade(0.0, 1.0, 0.0025, RenderExtra, OnFadeOutScore, true);
      end
    -- Top of credit is showing from the bottom of the screen?
    elseif nTop < nStageB then
      -- Get top of name credit
      local nMiddle<const> = nRollingCreditY + aCredit[2];
      -- Draw credit title if below the top of the screen
      if nMiddle > nStageT then
        PrintC(fontLittle, nStageM, nTop, aCredit[4]);
      end
      -- Draw credit name if above the bottom of the screen
      if nMiddle < nStageB then
        PrintC(fontLarge, nStageM, nMiddle, aCredit[5]);
      end
      -- Process next credit
      iI = iI + 1;
    -- No need to process more if name credit is off the bottom
    elseif nBottom >= nStageB then break end;
  end
end
-- Credits procedure ------------------------------------------------------- --
local function ExtraProc()
  -- Process game functions
  GameProc();
  -- Scroll up credits
  nRollingCreditY = nRollingCreditY - 0.25;
  -- Keep viewport in top left
  LockViewport();
end
-- Init rolling credits ---------------------------------------------------- --
local function InitRollingCredits(strMusic)
  -- Reset credit data
  aXCredits = create(#aCreditsXData);
  -- Current absolute position on-screen
  local nYEnd = 0;
  -- Enumerate through all extra credits
  for iIndex = 1, #aCreditsXData do
    -- Get credit title and name
    local aCredit<const> = aCreditsXData[iIndex];
    -- Simulate print of title string and return height
    local nHeight1<const> = PrintWS(fontLittle, nStageW, aCredit[1]);
    -- Calculate absolute bottom pixel of title text on screen
    local nYEndPnHeight1<const> = nYEnd + nHeight1;
    -- Simulate print of name string and return height
    local nHeight2<const> = PrintWS(fontLarge, nStageW, aCredit[2]);
    -- calculate absolute bottom pixel of name text on screen
    local nYEndPnHeight1PnHeight2<const> = nYEndPnHeight1 + nHeight2;
    -- Build credit data
    aXCredits[1 + #aXCredits] = {
      nYEnd,                          -- [1] Top of title
      nYEndPnHeight1 + 4.0,           -- [2] Top of name
      nYEndPnHeight1PnHeight2 + 16.0, -- [3] Bottom of name
      aCredit[1],                     -- [4] Credit title
      aCredit[2]                      -- [5] Credit name
    };
    -- Move Y pointer down
    nYEnd = nYEndPnHeight1PnHeight2 + 20.0;
  end
  -- Current absolute Y position of all credits starting at the bottom
  nRollingCreditY = nStageB;
  -- When faded out to title? Load demo level
  LoadLevel(aEndLevelData, strMusic, nil, nil, true, oObjectTypes.DIGRANDOM,
    true, ExtraProc, RenderExtra, BlankFunction, 0, nil, nil, true,
    LockViewport);
end
-- Main render function ---------------------------------------------------- --
local function ProcCreditsRender()
  -- Render terrain and objects
  RenderTerrain();
  RenderObjects();
  -- Render vignette
  BlitLTRB(texVig, nStageL, nStageT, nStageR, nStageB);
  -- Prepare font colours
  fontLarge:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  fontLittle:SetCRGBA(0.0, 1.0, 0.0, 1.0);
end
-- Render function --------------------------------------------------------- --
local function RenderCreditsBottomLeft()
  -- Render terrain, objects and vignette
  ProcCreditsRender();
  -- Render credits
  local nLeft<const> = nStageL + 16.0;
  Print(fontLittle, nLeft, nCredits1Y, strCredits1);
  Print(fontLarge, nLeft, nCredits2Y, strCredits2);
end
-- Render function --------------------------------------------------------- --
local function RenderCreditsTopRight()
  -- Render terrain, objects and vignette
  ProcCreditsRender();
  -- Render credits
  local nRight<const> = nStageR - 16.0;
  PrintR(fontLittle, nRight, 16.0, strCredits1);
  PrintR(fontLarge, nRight, 28.0, strCredits2);
end
-- When faded out to next level? ------------------------------------------- --
local function OnLevelFadedOut() LoadDemoLevel(1 + iCreditId) end;
-- Credits procedure ------------------------------------------------------- --
local function ProcCreditsLogic()
  -- Process game functions
  GameProc();
  -- Should we change level?
  iActionTimer = iActionTimer + 1;
  if iActionTimer < 600 then return end;
  -- Keep rendering text during blackout loading
  SetCallbacks(nil, nil);
  -- If this is the last credit?
  if bLast then
    return Fade(0.0, 1.0, 0.04, fcbCreditsRender, InitRollingCredits);
  end
  -- Fade out to next level
  Fade(0.0, 1.0, 0.04, fcbCreditsRender, OnLevelFadedOut);
end
-- Load demo level --------------------------------------------------------- --
local function DoLoadDemoLevel(iLCreditId, strMusic)
  -- Set credit id
  iCreditId = iLCreditId;
  -- Action timer
  iActionTimer = 0;
  -- Get a random level to load
  local iLevelIdPicked<const> = random(#aLevels);
  local iLevelId<const> = aLevels[iLevelIdPicked];
  remove(aLevels, iLevelIdPicked);
  -- Record if this is the last credit
  bLast = iCreditId >= #aCreditsData or #aLevels == 0;
  -- Get credit and try next credit if invalid
  local aCredit<const> = aCreditsData[iCreditId];
  if not aCredit then return LoadDemoLevel(iLevelId, iCreditId + 1) end;
  -- Get texts
  strCredits1, strCredits2 = aCredit[1], aCredit[2];
  -- Now we need to measure the height of both fonts so we can place the
  -- credits in the exact position of the screen
  local nCredits1H<const> = PrintWS(fontLittle, nStageW, strCredits1);
  local nCredits2H<const> = PrintWS(fontLarge, nStageW, strCredits2);
  nCredits2Y = nStageB - 12 - nCredits2H;
  nCredits1Y = nCredits2Y - 4 - nCredits1H;
  -- Pick which way to render the credits
  if #aLevels % 2 == 0 then fcbCreditsRender = RenderCreditsTopRight;
                       else fcbCreditsRender = RenderCreditsBottomLeft end;
  -- Init function
  local function OnInit()
    -- Select a random object and not a digger! The last objects in-- the list are always the diggers so we can just crop them out.
    -- If we get an object then select and focus on the object!
    if bRandObject then SelectObject(aObjs[random(#aObjs -
      (#aPlayers[1].D * 2))], true) end;
  end
  -- Load demo level
  LoadLevel(iLevelId, strMusic, nil, nil, true, oObjectTypes.DIGRANDOM, true,
    ProcCreditsLogic, fcbCreditsRender, BlankFunction, 0, nil, nil, true,
    OnInit);
end
LoadDemoLevel = DoLoadDemoLevel;
-- When the opengl viewport has changed ------------------------------------ --
local function OnStageUpdated(_, _, iStageL, iStageT, iStageR, iStageB,
  iStageW, iStageH)
  -- Get new stage values as numbers
  nStageL, nStageT, nStageR, nStageB, nStageW, nStageH =
    iStageL + 0.0, iStageT + 0.0, iStageR + 0.0,
    iStageB + 0.0, iStageW + 0.0, iStageH + 0.0;
  -- Set middle of stage
  nStageM = nStageW / 2.0;
end
-- When assets have loaded ------------------------------------------------- --
local function OnAssetsLoaded(aResources, bRolling)
  -- Set vignette texture
  texVig = aResources[1];
  -- Register frame buffer update
  RegisterFBUCallback("credits", OnStageUpdated);
  -- Build levels to pick from
  aLevels = create(#aLevelsData);
  for iI = 1, #aLevelsData do aLevels[1 + #aLevels] = iI end;
  -- Load first level or credits
  if bRolling then InitRollingCredits("credits");
              else LoadDemoLevel(1, "credits") end;
end
-- Init ending screen functions -------------------------------------------- --
local function InitCredits(bRolling)
  LoadResources("Credits", aAssets, OnAssetsLoaded, bRolling);
end
-- Script has been laoded -------------------------------------------------- --
local function OnScriptLoaded(GetAPI)
  -- Imports
  BlitLTRB, DeInitLevel, Fade, GameProc, GetMusic, InitScore, LoadLevel,
    LoadResources, LockViewport, PlayMusic, PrintC, PrintR, Print, PrintWS,
    RegisterFBUCallback, RenderObjects, RenderTerrain, SelectObject,
    SetCallbacks, aCreditsData, aCreditsXData, aLevelTypesData,
    aLevelsData, oObjectTypes, aObjs, aPlayers, fontLarge, fontLittle =
      GetAPI("BlitLTRB", "DeInitLevel", "Fade", "GameProc", "GetMusic",
        "InitScore", "LoadLevel", "LoadResources", "LockViewport", "PlayMusic",
        "PrintC", "PrintR", "Print", "PrintWS", "RegisterFBUCallback",
        "RenderObjects", "RenderTerrain", "SelectObject", "SetCallbacks",
        "aCreditsData", "aCreditsXData", "aLevelTypesData", "aLevelsData",
        "oObjectTypes", "aObjs", "aPlayers", "fontLarge", "fontLittle");
  -- Setup required assets
  local oAssetsData<const> = GetAPI("oAssetsData");
  aAssets = { oAssetsData.credits };
  -- Set ending level load data
  aEndLevelData.t = aLevelTypesData[4];
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitCredits = InitCredits }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
