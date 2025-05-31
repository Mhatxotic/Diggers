-- BOOK.LUA ================================================================ --
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
-- M-Engine function aliases ----------------------------------------------- --
local CoreLog<const>, UtilBlank<const>, UtilClampInt<const> =
  Core.Log, Util.Blank, Util.ClampInt;
-- Diggers function and data aliases --------------------------------------- --
local BlitLT, BlitSLT, Fade, GameProc, InitCon, InitContinueGame,
  LoadResources, PlayMusic, PlayStaticSound, PrintW, RenderAll, RenderShadow,
  RenderTip, RenderTipShadow, SetTip, SetCallbacks, SetHotSpot, SetKeys,
  fontSpeech;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Assets required
      aBookData,                       -- Book data
      aIllustration;                   -- Illustration data
local aPageHotSpots<const> = { };      -- Page specific hotspots
local aZmtcTexture,                    -- Lobby closed texture asset
      fcbFinish,                       -- Callback to call to exit
      fcbOnPageAssetsPost,             -- When page assets have loaded
      fcbProcLogic,                    -- Main page logic callback
      fcbProcRenderBack,               -- Rendering background callback
      fcbProcRender,                   -- Render callback for in-game or lobby
      iHotSpotCoverId, iHotSpotPageId, -- Hot spot id for cover and pages part
      iHotSpotStartId,                 -- Hot spot to set when cover page load
      iKeyBankCoverId, iKeyBankPageId, -- Key bank id for cover and pages part
      iKeyBankStartId,                 -- Key bank to set when cover page load
      iPage,                           -- Book current page
      iSClick, iSSelect,               -- Sound effects used
      strExitTip, strPage, strText,    -- Tip strings and actual page text
      strPageNext, strPageLast,        -- Next and last page tips
      texCover, texPage, texZmtc;      -- Book, page and bg texture handles
-- Book render callback ---------------------------------------------------- --
local function ProcRenderPage()
  -- Render book background
  fcbProcRenderBack();
  -- Render page
  BlitLT(texPage, 8, 8);
  -- Render text
  fontSpeech:SetCRGB(0.45, 0.3, 0.22);
  PrintW(fontSpeech, 77, 32, 298, strText);
  -- Render illustration if set
  if aIllustration then
    BlitSLT(texPage, aIllustration[1], aIllustration[2], aIllustration[3]);
  end
end
-- Page loader function ---------------------------------------------------- --
local function LoadPage(fcbOnComplete)
  -- Get page data
  local aPage<const> = aBookData[iPage];
  -- Set text, illustration data
  strText, aIllustration = aPage.T, aPage.I;
  -- Set text line spacing if specified
  fontSpeech:SetLSpacing(aPage.L or 0);
  -- Update page and set it as tip
  strPage = "PAGE "..iPage.."/"..#aBookData;
  SetTip(strPage)
  -- Set last and next page tip
  strPageNext = iPage + 1;
  if strPageNext < #aBookData then strPageNext = "TO PAGE "..strPageNext.." >";
  else strPageNext = "AT END" end;
  strPageLast = iPage - 1;
  if strPageLast > 0 then strPageLast = "< TO PAGE "..strPageLast;
  else strPageLast = "AT START" end;
  -- Set hotspots based on page
  SetHotSpot(aPageHotSpots[iPage] or iHotSpotPageId);
end
-- Switch page with sound -------------------------------------------------- --
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
-- Book button action callbacks -------------------------------------------- --
local function GoExit() fcbFinish() end
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
-- Hover functions (dynamic) ----------------------------------------------- --
local function HoverExit() SetTip(strExitTip) end;
local function HoverIdle() SetTip(strPage) end;
local function HoverNext() SetTip(strPageNext) end;
local function HoverLast() SetTip(strPageLast) end;
-- Scroll wheel callback --------------------------------------------------- --
local function OnScroll(nX, nY)
  if nY > 0 then GoLast() elseif nY < 0 then GoNext() end;
end
-- On render callback ------------------------------------------------------ --
local function ProcRenderCover()
  -- Render background
  fcbProcRenderBack();
  -- Draw backdrop
  BlitLT(texCover, 8, 8);
end
-- Change cover to inside the book ----------------------------------------- --
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
  SetCallbacks(fcbProcLogic, ProcRenderPage);
end
-- Set render background function ------------------------------------------ --
local function ProcRenderBackInGame()
  -- Render game interface
  RenderAll();
  -- Draw tip
  RenderTip();
  -- Render shadow
  RenderShadow(8, 8, 312, 208);
end
-- Set render background function ------------------------------------------ --
local function ProcRenderBackLobby()
  -- Render static background
  BlitLT(texZmtc, -54, 0);
  -- Draw tip and return
  RenderTipShadow();
end
-- Cover loaded in-game supplimental callback ------------------------------ --
local function OnPageAssetsPostInGame()
  -- Set intro page keys and hot spots
  SetKeys(true, iKeyBankStartId);
  SetHotSpot(iHotSpotStartId);
  -- No transition from in-game
  SetCallbacks(GameProc, fcbProcRender);
end
-- Cover data loaded? ------------------------------------------------------ --
local function OnPageAssetsPostLobbyFadedIn()
  -- Set intro page and hot spots keys
  SetKeys(true, iKeyBankStartId);
  SetHotSpot(iHotSpotStartId);
  -- Return control to main loop
  SetCallbacks(nil, fcbProcRender);
end
-- Cover loaded in-lobby supplimental callback ----------------------------- --
local function OnPageAssetsPostLobby()
  -- From controller screen? Fade in
  Fade(1, 0, 0.04, fcbProcRender, OnPageAssetsPostLobbyFadedIn);
end
-- Finish in-game supplimental callback ------------------------------------ --
local function ExitInGame()
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Dereference assets for garbage collector
  texPage, texCover = nil, nil;
  -- Start the loading waiting procedure
  SetCallbacks(GameProc, RenderAll);
  -- Continue game
  InitContinueGame();
end
-- On faded event ---------------------------------------------------------- --
local function OnExitLobbyFadedOut()
  -- Dereference assets for garbage collector
  texPage, texCover, texZmtc = nil, nil, nil;
  -- Init controller screen
  InitCon();
end
-- Finish in-lobby supplimental callback ----------------------------------- --
local function ExitLobby()
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Fade out to controller
  Fade(0, 1, 0.04, fcbProcRender, OnExitLobbyFadedOut);
end
-- Lobby cover resources laoded -------------------------------------------- --
local function OnAssetsLoadedLobby(texHandle)
  -- Get lobby texture and setup background tile. This will be nil if loading
  -- from in-game so it doesn't matter. Already handled.
  texZmtc = texHandle;
end
-- When the resources have loaded ------------------------------------------ --
local function OnAssetsLoaded(aResources, fcbProcCustomHandle)
  -- Set texture and setup tiles
  texCover, texPage = aResources[1], aResources[2];
  -- Call supplimental load routine depending if we're in-game or not
  fcbProcCustomHandle(aResources[3]);
  -- If we've shown the cover page?
  if strText then
    -- Set page keybank and callbacks
    iKeyBankStartId, iHotSpotStartId, fcbProcRender =
      iKeyBankPageId, aPageHotSpots[iPage] or iHotSpotPageId, ProcRenderPage;
  -- Not shown the cover page yet? Set render callback
  else
    -- Set cover page keybank and callbanks
    iKeyBankStartId, iHotSpotStartId, fcbProcRender =
      iKeyBankCoverId, iHotSpotCoverId, ProcRenderCover;
  end
  -- Cover has loaded
  fcbOnPageAssetsPost();
end
-- Init book screen function ----------------------------------------------- --
local function InitBook(bFromInGame)
  -- Post asset loaded function
  local fcbProcCustomHandle;
  -- Loading from in-game
  if bFromInGame then
    -- Set text for exit tip
    strExitTip = "BACK TO GAME";
    -- Nothing to load in slot two
    aAssets[3] = nil;
    -- Set specific behaviour from in-game
    fcbProcCustomHandle = UtilBlank;
    fcbOnPageAssetsPost = OnPageAssetsPostInGame;
    fcbProcRenderBack = ProcRenderBackInGame;
    fcbProcLogic = GameProc;
    fcbFinish = ExitInGame;
  -- Loading from lobby?
  else
    -- Set text for exit tip
    strExitTip = "CONTROLLER";
    -- Load backdrop from closed lobby
    aAssets[3] = aZmtcTexture;
    -- Set specific behaviour from the lobby
    fcbProcCustomHandle = OnAssetsLoadedLobby;
    fcbOnPageAssetsPost = OnPageAssetsPostLobby;
    fcbProcRenderBack = ProcRenderBackLobby;
    fcbProcLogic = UtilBlank;
    fcbFinish = ExitLobby;
  end
  -- Load the resources
  LoadResources("Book", aAssets, OnAssetsLoaded, fcbProcCustomHandle);
end
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, aAssetsData, aCursorIdData, aSfxData;
  -- Grab imports
  BlitLT, BlitSLT, Fade, GameProc, InitCon, InitContinueGame, LoadResources,
    PlayMusic, PlayStaticSound, PrintW, RegisterHotSpot, RegisterKeys,
    RenderAll, RenderShadow, RenderTip, RenderTipShadow, SetCallbacks,
    SetHotSpot, SetKeys, SetTip, aAssetsData, aBookData, aCursorIdData,
    aSfxData, fontSpeech =
      GetAPI("BlitLT", "BlitSLT", "Fade", "GameProc", "InitCon",
        "InitContinueGame", "LoadResources", "PlayMusic", "PlayStaticSound",
        "PrintW", "RegisterHotSpot", "RegisterKeys", "RenderAll",
        "RenderShadow", "RenderTip", "RenderTipShadow", "SetCallbacks",
        "SetHotSpot", "SetKeys", "SetTip", "aAssetsData", "aBookData",
        "aCursorIdData", "aSfxData", "fontSpeech");
  -- Set book data language
  local sLocale<const> = Core.Locale();
  CoreLog("Locale '"..sLocale.."' detected.");
  -- Grab language part and if not found?
  local sLang<const> = sLocale:sub(1, 2);
  if not sLang or #sLang ~= 2 then
    -- English is default language and log the error
    aBookData = aBookData.en;
    CoreLog("Locale '"..sLocale.."' not recognised! Defaulting to English.");
  else
    -- Get book language data
    local aData<const> = aBookData[sLang];
    if aData then
      -- Accepted
      aBookData = aData;
      CoreLog("Language '"..sLang.."' selected.");
    else
      -- English is default language and log the error
      aBookData = aBookData.en;
      CoreLog("Language '"..sLang.."' not supported! Defaulting to English.");
    end
  end
  -- Prepare assets
  aZmtcTexture = aAssetsData.zmtc;
  aAssets = { aAssetsData.bookcover, aAssetsData.bookpage, false };
  -- Register key binds
  local aKeys<const>, aStates<const> = Input.KeyCodes, Input.States;
  local iPress<const>, iRepeat<const> = aStates.PRESS, aStates.REPEAT;
  local aClose<const>, aPrev<const>, aNext<const> =
    { aKeys.ESCAPE, GoExit, "zmtctbcl", "CLOSE" },
    { aKeys.LEFT, GoLast, "zmtctbpp", "PREVIOUS PAGE" },
    { aKeys.RIGHT, GoNext, "zmtctbnp", "NEXT PAGE" };
  local sName<const> = "ZMTC BOOK";
  iKeyBankPageId = RegisterKeys(sName, { [iPress] = { aClose, aPrev, aNext,
    { aKeys.N1, GoChapter1, "zmtctbgcon", "ABOUT THIS BOOK" },
    { aKeys.N2, GoChapter2, "zmtctbgctw", "HOW TO START DIGGERS" },
    { aKeys.N3, GoChapter3, "zmtctbgcth", "THE PLANET ZARG" },
    { aKeys.N4, GoChapter4, "zmtctbgcfo", "RACE DESCRIPTIONS" },
    { aKeys.N5, GoChapter5, "zmtctbgcfi", "ZONE DESCRIPTIONS" },
    { aKeys.N6, GoChapter6, "zmtctbgcsi", "FLORA AND FAUNA" },
    { aKeys.N7, GoChapter7, "zmtctbgcse", "THE MINING STORE" },
    { aKeys.N8, GoChapter8, "zmtctbgcei", "MINING APPARATUS" },
    { aKeys.N9, GoChapter9, "zmtctbgcni", "ZARGON BANK" },
    { aKeys.N0, GoChapter10, "zmtctbgcte", "ZARGON STOCK MARKET" },
    { aKeys.MINUS, GoChapter11, "zmtctbgcel", "ZARGON MINING HISTORY" },
    { aKeys.BACKSPACE, GoIndex, "zmtctbc", "CONTENTS" },
  }, [iRepeat]={ aPrev, aNext } });
  iKeyBankCoverId = RegisterKeys(sName, { [iPress] = { aClose,
    { aKeys.ENTER, GoOpen, "zmtcbob", "OPEN BOOK" } } });
  -- Set cursor ids
  local iCOK<const>, iCSelect<const>, iCExit<const> =
    aCursorIdData.OK, aCursorIdData.SELECT, aCursorIdData.EXIT;
  -- Hotspots for all screens
  local aHSIndex<const>, aHSNext<const>, aHSLast<const>, aHSIdle<const>,
    aHSExit<const> =
      {  19,  68,  20,  22, 0, iCSelect, "INDEX PAGE", OnScroll, GoIndex   },
      {  19,  96,  20,  22, 0, iCSelect, HoverNext,    OnScroll, GoNext    },
      {  19, 122,  20,  22, 0, iCSelect, HoverLast,    OnScroll, GoLast    },
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
      aHSToAdd[#aHSToAdd + 1] = aHSIdle;
      aHSToAdd[#aHSToAdd + 1] = aHSExit;
      -- Register and bind hotspot
      aPageHotSpots[iPage] = RegisterHotSpot(aHSToAdd);
    end
  end
  -- Set points of interest data for cover
  iHotSpotCoverId = RegisterHotSpot({
    {   8,   8, 304, 200, 0, iCOK,   "OPEN BOOK", false, GoOpen },
    {   0,   0,   0, 240, 3, iCExit, HoverExit,   false, GoExit }
  });
  -- Set default points of interest data
  iHotSpotPageId = RegisterHotSpot({ aHSIndex, aHSNext, aHSLast, aHSIdle,
    aHSExit });
  -- Set sound effect ids
  iSClick, iSSelect = aSfxData.CLICK, aSfxData.SELECT;
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitBook = InitBook }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
