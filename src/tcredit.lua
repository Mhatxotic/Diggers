-- TCREDIT.LUA ============================================================= --
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
-- Diggers function and data aliases --------------------------------------- --
local BlitLT, Fade, InitTitle, LoadResources, PlayMusic, PrintC, PrintWS,
  SetCallbacks, SetHotSpot, SetKeys, aCreditsData, fontLarge, fontLittle;
-- Locals ------------------------------------------------------------------ --
local aAssetsMusic,                    -- Assets when music is required
      aAssetsNoMusic,                  -- Assets when no music is required
      iCreditId,                       -- Current credit id (aCreditsData)
      iCreditsCounter, iCreditsNext,   -- Credits timer and next trigger
      iHotSpotId,                      -- Hot spot id
      iKeyBankId,                      -- Key bank for title credits keys
      strCredits1, nCredits1Y,         -- Large font title text and position
      strCredits2, nCredits2Y,         -- Small font subtitle text and position
      texTitle;                        -- Title screen texture
-- Set new credit ---------------------------------------------------------- --
local function SetCreditId(iId)
  -- Set credit
  iCreditId = iId;
  -- Get credit data and return if failed
  local aData<const> = aCreditsData[iId];
  if not aData then return end;
  -- Set strings
  iCreditsNext = iCreditsNext + 120;
  strCredits1, strCredits2 = aData[1], aData[2];
  -- Now we need to measure the height of all three strings so we
  -- can place the credits in the exact vertical centre of the screen
  local nCredits1H<const> = PrintWS(fontLittle, 320.0, strCredits1);
  local nCredits2H<const> = PrintWS(fontLarge, 320.0, strCredits2) / 2.0;
  nCredits1Y = 120.0 - nCredits2H - 4.0 - nCredits1H;
  nCredits2Y = 120.0 - nCredits2H;
  -- Success
  return true;
end
-- Render credits proc ----------------------------------------------------- --
local function ProcRender()
  -- Set text colour
  fontLittle:SetCRGB(1.0, 0.7, 1.0);
  fontLarge:SetCRGB(1.0, 1.0, 1.0);
  -- Draw background
  BlitLT(texTitle, -96.0, 0.0);
  -- Display text compared to amount of time passed
  PrintC(fontLittle, 160.0, nCredits1Y, strCredits1);
  PrintC(fontLarge, 160.0, nCredits2Y, strCredits2);
end
-- On fade out init title screen without setting music --------------------- --
local function OnFadedOutToTitle()
  -- Initialise the title and give back the texture handle
  InitTitle(true);
  -- Done with the texture handle here
  texTitle = nil;
end
-- Fade out to title screen ------------------------------------------------ --
local function GoExit()
  -- Start fading out
  Fade(0.0, 1.0, 0.04, ProcRender, OnFadedOutToTitle);
end
-- Credits main logic ------------------------------------------------------ --
local function ProcLogic()
  -- Increment counter and if ignore if counter not exceeded
  iCreditsCounter = iCreditsCounter + 1;
  if iCreditsCounter < iCreditsNext then return end;
  -- Set next credit and return if succeeded
  if SetCreditId(iCreditId + 1) then return end;
  -- Fade out to credits and load demo level
  GoExit();
end
-- When credits have faded in? --------------------------------------------- --
local function OnFadedIn()
  -- Set keys and hotspot for this screen
  SetKeys(true, iKeyBankId);
  SetHotSpot(iHotSpotId);
  -- Set credits callback
  SetCallbacks(ProcLogic, ProcRender);
end
-- When title resources have loaded? --------------------------------------- --
local function OnAssetsLoaded(aResources, bNoMusic)
  -- Load texture and credit tiles
  texTitle = aResources[1];
  -- Play music
  if not bNoMusic then PlayMusic(aResources[2]) end;
  -- Initialise zarg texture and tile
  texTitle:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  -- Credits counter and texts
  iCreditsCounter, iCreditsNext = 0, 0;
  -- Set new credit function
  SetCreditId(1);
  -- Fade in
  Fade(1.0, 0.0, 0.04, ProcRender, OnFadedIn);
end
-- Initialise the credits screen function ---------------------------------- --
local function InitTitleCredits(bNoMusic)
  -- Set assets to use based on music requested and load them
  local aAssets;
  if bNoMusic then aAssets = aAssetsNoMusic else aAssets = aAssetsMusic end;
  LoadResources("Tcre", aAssets, OnAssetsLoaded, bNoMusic);
end
-- Script ready function --------------------------------------------------- --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterKeys, RegisterHotSpot, oAssetsData;
  -- Get imports
  BlitLT, Fade, InitTitle, LoadResources, PlayMusic, PrintC, PrintWS,
    RegisterKeys, RegisterHotSpot, SetCallbacks, SetHotSpot, SetKeys,
    oAssetsData, aCreditsData, fontLarge, fontLittle =
      GetAPI("BlitLT", "Fade", "InitTitle", "LoadResources", "PlayMusic",
        "PrintC", "PrintWS", "RegisterKeys", "RegisterHotSpot", "SetCallbacks",
        "SetHotSpot", "SetKeys", "oAssetsData", "aCreditsData", "fontLarge",
        "fontLittle");
  -- Get assets data
  local oTexture<const> = oAssetsData.title;
  aAssetsNoMusic = { oTexture };
  aAssetsMusic = { oTexture, oAssetsData.titlem };
  -- Register hotspots
  iHotSpotId = RegisterHotSpot({{ 0, 0, 0, 240, 3, 0, false, false, GoExit }});
  -- Register keybinds
  iKeyBankId = RegisterKeys("TITLE CREDITS", {
    [Input.States.PRESS] =
      {{ Input.KeyCodes.ESCAPE, GoExit, "tcc", "CANCEL" }}
  });
end
-- Return imports and exports ---------------------------------------------- --
return { A = { InitTitleCredits = InitTitleCredits }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
