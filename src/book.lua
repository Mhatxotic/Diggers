-- BOOK.LUA ================================================================ --
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
local CoreLocale<const>, CoreLog<const>, CoreLogEx<const>, UtilBlank<const>,
  UtilClampInt<const> = Core.Locale, Core.Log, Core.LogEx, Util.Blank,
    Util.ClampInt;
-- Diggers function and data aliases --------------------------------------- --
local BlitLT, BlitSLT, Fade, InitCon, LoadResources, PlayStaticSound, PrintW,
  RenderShadow, RenderTipShadow, SetTip, SetCallbacks, SetHotSpot, SetKeys,
  fontSpeech;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Assets required
      aBookData,                       -- Book data
      aIllustration;                   -- Illustration data
local fcbProcRender,                   -- Render callback for in-game or lobby
      iHotSpotCoverId, iHotSpotPageId, -- Hot spot id for cover and pages part
      iHotSpotStartId,                 -- Hot spot to set when cover page load
      iKeyBankCoverId, iKeyBankPageId, -- Key bank id for cover and pages part
      iKeyBankStartId,                 -- Key bank to set when cover page load
      iPage;                           -- Book current page
local oPageHotSpots<const> = { };      -- Page specific hotspots
local oAPI,                            -- API to access language tables
      strExitTip, strPage, strText,    -- Tip strings and actual page text
      strPageNext, strPageLast,        -- Next and last page tips
      texFlag,                         -- Flags textures (4, en, fr, de, it)
      texCover, texPage, texZmtc;      -- Book, page and bg texture handles
-- Set render background function ------------------------------------------ --
local function ProcRenderBackLobby()
  -- Render static background
  BlitLT(texZmtc, -54.0, 0.0);
  -- Render shadow
  RenderShadow(8.0, 8.0, 312.0, 208.0);
  -- Draw tip and return
  RenderTipShadow();
end
-- Book render callback ---------------------------------------------------- --
local function ProcRenderPage()
  -- Render book background
  ProcRenderBackLobby();
  -- Render page
  BlitLT(texPage, 8.0, 8.0);
  -- Render text
  fontSpeech:SetCRGB(0.45, 0.3, 0.22);
  PrintW(fontSpeech, 77, 28.0, 298.0, strText);
  -- Render illustration if set
  if aIllustration then
    BlitSLT(texPage, aIllustration[1], aIllustration[2], aIllustration[3]);
  end
  -- Draw language buttons and shadows
  for iI = 0, 3 do
    local nX<const> = 8 + (iI * 24);
    BlitSLT(texPage, 31 + iI, nX, 216.0);
    RenderShadow(nX, 216.0, nX + 16.0, 232.0);
  end
end
-- On render callback ------------------------------------------------------ --
local function ProcRenderCover()
  -- Render background
  ProcRenderBackLobby();
  -- Draw backdrop
  BlitLT(texCover, 8.0, 8.0);
end
-- Init book screen function ----------------------------------------------- --
local function InitBook()
  -- Set text for exit tip
  strExitTip = "CONTROLLER";
  -- Callback when the resources have loaded
  local function OnAssetsLoaded(aResources)
    -- Set texture and setup tiles
    texCover, texPage, texZmtc = aResources[1], aResources[2], aResources[3];
    -- If we've shown the cover page?
    if strText then
      -- Set page keybank and callbacks
      iKeyBankStartId, iHotSpotStartId, fcbProcRender =
        iKeyBankPageId, oPageHotSpots[iPage] or iHotSpotPageId, ProcRenderPage;
    -- Not shown the cover page yet? Set render callback
    else
      -- Set cover page keybank and callbanks
      iKeyBankStartId, iHotSpotStartId, fcbProcRender =
        iKeyBankCoverId, iHotSpotCoverId, ProcRenderCover;
    end
    -- Cover data loaded callback
    local function OnPageAssetsPostLobbyFadedIn()
      -- Set intro page and hot spots keys
      SetKeys(true, iKeyBankStartId);
      SetHotSpot(iHotSpotStartId);
      -- Return control to main loop
      SetCallbacks(nil, fcbProcRender);
    end
    -- Cover has loaded
    Fade(1.0, 0.0, 0.04, fcbProcRender, OnPageAssetsPostLobbyFadedIn);
  end
  -- Load the resources
  LoadResources("Book", aAssets, OnAssetsLoaded);
end
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI, aModData, oNAPI)
  -- Set API so we can easily access language tables
  oAPI = oNAPI;
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, oAssetsData, oCursorIdData, oSfxData,
    cvLang;
  -- Grab imports
  BlitLT, BlitSLT, Fade, InitCon, LoadResources, PlayStaticSound, PrintW,
    RegisterHotSpot, RegisterKeys, RenderShadow, RenderTipShadow, SetCallbacks,
    SetHotSpot, SetKeys, SetTip, oAssetsData, oCursorIdData, oSfxData, cvLang,
    fontSpeech =
      GetAPI("BlitLT", "BlitSLT", "Fade", "InitCon", "LoadResources",
        "PlayStaticSound", "PrintW", "RegisterHotSpot", "RegisterKeys",
        "RenderShadow", "RenderTipShadow", "SetCallbacks", "SetHotSpot",
        "SetKeys", "SetTip", "oAssetsData", "oCursorIdData", "oSfxData",
        "cvLang", "fontSpeech");
  -- Get sound effects used
  local iSClick<const>, iSSelect<const> = oSfxData.CLICK, oSfxData.SELECT;
  -- Language selector function
  local function SelectLanguage(sSelectedLang, bRetry)
    -- Auto-detect language?
    if #sSelectedLang == 0 then sSelectedLang = CoreLocale():sub(1, 2);
    -- Not valid?
    elseif #sSelectedLang ~= 2 then
      -- Select English instead
      CoreLog("Language invalid! Defaulting to English.");
      SelectLanguage("", true);
    end
    -- Get book language data and if it is there?
    local aData<const> = oAPI["aBookData_"..sSelectedLang];
    if aData then
      -- Accepted
      aBookData = aData;
      CoreLog("Language '"..sSelectedLang.."' selected.");
    -- Just incase to prevent recursive
    elseif bRetry then
      error("Internal error: Language '"..sSelectedLang.."' not available!");
    -- Not found?
    else
      -- English is default language and log the error
      CoreLogEx("Language '"..sSelectedLang..
        "' not supported! Defaulting to English.", Core.LogLevels.WARNING);
      SelectLanguage("en", true);
    end
  end
  -- Select requested language override
  SelectLanguage(cvLang:Get());
  -- Page loader function
  local function LoadPage(fcbOnComplete)
    -- Get page data
    local aPage<const> = aBookData[iPage];
    -- Set text, illustration data
    strText, aIllustration = aPage.T, aPage.I;
    -- Set text line spacing if specified
    fontSpeech:SetLSpacing(aPage.L or 0.0);
    -- Update page and set it as tip
    strPage = "PAGE "..iPage.."/"..#aBookData;
    SetTip(strPage)
    -- Set last and next page tip
    strPageNext = iPage + 1;
    if strPageNext <= #aBookData then
      strPageNext = "TO PAGE "..strPageNext.." >";
    else strPageNext = "AT END" end;
    strPageLast = iPage - 1;
    if strPageLast > 0 then strPageLast = "< TO PAGE "..strPageLast;
    else strPageLast = "AT START" end;
    -- Set hotspots based on page
    SetHotSpot(oPageHotSpots[iPage] or iHotSpotPageId);
  end
  -- Switch page with sound
  local function GoAdjustPage(iNewPage)
    -- Return if same page else set new page
    iNewPage = UtilClampInt(iNewPage, 1, #aBookData);
    if iNewPage == iPage then return end;
    iPage = iNewPage;
    -- Play the sound
    PlayStaticSound(iSClick);
    -- Load the specified new page
    LoadPage();
  end
  -- Book button action callbacks
  local function GoIndex() GoAdjustPage(2) end;
  local function GoChapter1() GoAdjustPage(3) end;
  local function GoChapter2() GoAdjustPage(8) end;
  local function GoChapter3() GoAdjustPage(20) end;
  local function GoChapter4() GoAdjustPage(23) end;
  local function GoChapter5() GoAdjustPage(32) end;
  local function GoChapter6() GoAdjustPage(37) end;
  local function GoChapter7() GoAdjustPage(55) end;
  local function GoChapter8() GoAdjustPage(57) end;
  local function GoChapter9() GoAdjustPage(74) end;
  local function GoChapter10() GoAdjustPage(78) end;
  local function GoChapter11() GoAdjustPage(80) end;
  local function GoLast() GoAdjustPage(iPage - 1) end;
  local function GoNext() GoAdjustPage(iPage + 1) end;
  local function GoRefresh()
    -- Overrides loading same page
    local iCPage<const> = iPage;
    iPage = -1;
    -- Reload the page
    GoAdjustPage(iCPage);
  end
  -- Change cover to inside the book
  local function GoOpen()
    -- Set renderer to book page
    fcbProcRender = ProcRenderPage;
    -- Set active page texture and clear cover texture
    texCover = nil;
    -- Load first page
    iPage = 1;
    LoadPage();
    -- Play click sound
    PlayStaticSound(iSSelect);
    -- Set page keys and hot spots
    SetKeys(true, iKeyBankPageId);
    -- Set main page game proc
    SetCallbacks(nil, ProcRenderPage);
  end
  -- Finish in-lobby supplimental callback
  local function GoExit()
    -- Play sound
    PlayStaticSound(iSSelect);
    -- On faded event
    local function OnExitLobbyFadedOut()
      -- Dereference assets for garbage collector
      texPage, texCover, texZmtc = nil, nil, nil;
      -- Init controller screen
      InitCon();
    end
    -- Fade out to controller
    Fade(0.0, 1.0, 0.04, fcbProcRender, OnExitLobbyFadedOut);
  end
  -- Prepare assets
  aAssets = { oAssetsData.bookcover, oAssetsData.bookpage, oAssetsData.zmtc };
  -- Register key binds
  local oKeys<const>, oStates<const> = Input.KeyCodes, Input.States;
  local iPress<const>, iRepeat<const> = oStates.PRESS, oStates.REPEAT;
  local aClose<const>, aClose2<const>, aPrev<const>, aNext<const> =
    { oKeys.ESCAPE, GoExit, "zmtctbcl", "CLOSE BOOK" },
    { oKeys.F8, GoExit, "zmtctbclb", "CLOSE BOOK (IN-GAME TOGGLE)" },
    { oKeys.LEFT, GoLast, "zmtctbpp", "PREVIOUS PAGE" },
    { oKeys.RIGHT, GoNext, "zmtctbnp", "NEXT PAGE" };
  local sName<const> = "ZMTC BOOK";
  iKeyBankPageId = RegisterKeys(sName, { [iPress] = {
    aClose, aClose2, aPrev, aNext,
    { oKeys.N1, GoChapter1, "zmtctbgcon", "ABOUT THIS BOOK" },
    { oKeys.N2, GoChapter2, "zmtctbgctw", "HOW TO START DIGGERS" },
    { oKeys.N3, GoChapter3, "zmtctbgcth", "THE PLANET ZARG" },
    { oKeys.N4, GoChapter4, "zmtctbgcfo", "RACE DESCRIPTIONS" },
    { oKeys.N5, GoChapter5, "zmtctbgcfi", "ZONE DESCRIPTIONS" },
    { oKeys.N6, GoChapter6, "zmtctbgcsi", "FLORA AND FAUNA" },
    { oKeys.N7, GoChapter7, "zmtctbgcse", "THE MINING STORE" },
    { oKeys.N8, GoChapter8, "zmtctbgcei", "MINING APPARATUS" },
    { oKeys.N9, GoChapter9, "zmtctbgcni", "ZARGON BANK" },
    { oKeys.N0, GoChapter10, "zmtctbgcte", "ZARGON STOCK MARKET" },
    { oKeys.MINUS, GoChapter11, "zmtctbgcel", "ZARGON MINING HISTORY" },
    { oKeys.BACKSPACE, GoIndex, "zmtctbc", "CONTENTS" },
  }, [iRepeat]={ aPrev, aNext } });
  iKeyBankCoverId = RegisterKeys(sName, { [iPress] = {
    aClose, aClose2,
    { oKeys.ENTER, GoOpen, "zmtcbob", "OPEN BOOK" } } });
  -- Set cursor ids
  local iCOK<const>, iCSelect<const>, iCExit<const> =
    oCursorIdData.OK, oCursorIdData.SELECT, oCursorIdData.EXIT;
  -- Scroll wheel callback
  local function OnScroll(nX, nY)
    if nY > 0.0 then GoNext() elseif nY < 0.0 then GoLast() end;
  end
  -- Language selection callbacks
  local function GoLang(sLang) SelectLanguage(sLang) GoRefresh() end
  local function GoEnglish() GoLang("en") end;
  local function GoFrench() GoLang("fr") end;
  local function GoGerman() GoLang("de") end;
  local function GoItalian() GoLang("it") end;
  -- Hover functions (dynamic)
  local function HoverExit() SetTip(strExitTip) end;
  local function HoverIdle() SetTip(strPage) end;
  local function HoverNext() SetTip(strPageNext) end;
  local function HoverLast() SetTip(strPageLast) end;
  -- Hotspots for all screens
  local aHSIndex<const>, aHSNext<const>, aHSLast<const>, aEnFlag<const>,
    aFrFlag<const>, aDeFlag<const>, aItFlag<const>, aHSIdle<const>,
    aHSExit<const> =
      {  19,  68,  20,  22, 0, iCSelect, "INDEX PAGE", OnScroll, GoIndex   },
      {  19,  96,  20,  22, 0, iCSelect, HoverNext,    OnScroll, GoNext    },
      {  19, 122,  20,  22, 0, iCSelect, HoverLast,    OnScroll, GoLast    },
      {   8, 216,  16,  16, 0, iCSelect, "ENGLISH",    OnScroll, GoEnglish },
      {  32, 216,  16,  16, 0, iCSelect, "FRANCAIS",   OnScroll, GoFrench  },
      {  56, 216,  16,  16, 0, iCSelect, "DEUTSCHE",   OnScroll, GoGerman  },
      {  80, 216,  16,  16, 0, iCSelect, "ITALIANO",   OnScroll, GoItalian },
      {   8,   8, 304, 200, 0, 0,        HoverIdle,    OnScroll, false     },
      {   0,   0,   0, 240, 3, iCExit,   HoverExit,    OnScroll, GoExit    };
  -- Start building page specific hotspots
  for iPage = 1, #aBookData do
    -- Get page data and if it has hotspots
    local aHotSpots<const> = aBookData[iPage].H;
    if aHotSpots then
      -- Hotspot data to add
      local aHSToAdd<const> = { aHSIndex, aHSNext, aHSLast };
      -- Walk through hotspots
      for iHotSpot = 1, #aHotSpots do
        -- Get hotspot data
        local aHotSpot<const> = aHotSpots[iHotSpot];
        -- Create function for callback
        local iPageId<const> = aHotSpot[5];
        aHotSpot[5] = 0;
        aHotSpot[6] = iCSelect;
        local function OnHover() SetTip("GO PAGE "..iPageId) end;
        aHotSpot[7] = OnHover;
        aHotSpot[8] = OnScroll;
        local function OnClick() GoAdjustPage(iPageId) end;
        aHotSpot[9] = OnClick;
        -- Add it to hotspot list
        aHSToAdd[#aHSToAdd + 1] = aHotSpot;
      end
      -- Add rest of default hotspots
      aHSToAdd[#aHSToAdd + 1] = aEnFlag;
      aHSToAdd[#aHSToAdd + 1] = aFrFlag;
      aHSToAdd[#aHSToAdd + 1] = aDeFlag;
      aHSToAdd[#aHSToAdd + 1] = aItFlag;
      aHSToAdd[#aHSToAdd + 1] = aHSIdle;
      aHSToAdd[#aHSToAdd + 1] = aHSExit;
      -- Register and bind hotspot
      oPageHotSpots[iPage] = RegisterHotSpot(aHSToAdd);
    end
  end
  -- Set points of interest data for cover
  iHotSpotCoverId = RegisterHotSpot({
    {   8,   8, 304, 200, 0, iCOK,   "OPEN BOOK", false, GoOpen },
    {   0,   0,   0, 240, 3, iCExit, HoverExit,   false, GoExit }
  });
  -- Set default points of interest data
  iHotSpotPageId = RegisterHotSpot({ aHSIndex, aHSNext, aHSLast, aEnFlag,
    aFrFlag, aDeFlag, aItFlag, aHSIdle, aHSExit });
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitBook = InitBook }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
