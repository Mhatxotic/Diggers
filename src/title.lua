-- TITLE.LUA =============================================================== --
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
local pairs<const>, random<const> = pairs, math.random;
-- Engine function aliases ------------------------------------------------- --
local CoreRAM<const>, DisplayVRAM<const>, UtilBytes<const> =
  Core.RAM, Display.VRAM, Util.Bytes;
-- Consts ------------------------------------------------------------------ --
local strVersion<const> = Variable.Internal.app_version:Get().." ";
-- Diggers function and data aliases --------------------------------------- --
local BlitSLT, DeInitLevel, Fade, GameProc, GetActivePlayer, GetGameTicks,
  GetOpponentPlayer, InitLobby, InitNewGame, InitTitleCredits, LoadLevel,
  LoadResources, LoadSaveData, PlayStaticSound, PrintC, RegisterFBUCallback,
  RenderObjects, RenderTerrain, SelectObject, SetHotSpot, tKeyBankCats,
  aLevelsData, oObjectTypes, aObjs, fontTiny;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Assets to load
      fcbEnterAnimProc,                -- Enter animation procedure
      fcbLeaveAnimProc,                -- Leave animation procedure
      fcbRC,                           -- System information update function
      iHotSpotId,                      -- Button hotspot id
      iKeyBankId,                      -- Title key bank id
      iNextUpdate,                     -- Next system information update
      iSSelect,                        -- Select sound effect id
      nPostSGX,                        -- Quit game post position
      nStageB, nStageL, nStageR,       -- Stage bounds
      strCredits,                      -- Credits
      strSubTitle,                     -- Version and system information text
      texTitle;                        -- Texture tile
-- Get engine information -------------------------------------------------- --
local sAppTitle, sAppVendor, iAppMajor<const>, iAppMinor<const>,
  iAppBuild<const>, iAppRevision<const>, _, _, sAppExeType = Core.Engine();
sAppTitle, sAppVendor, sAppExeType =
  sAppTitle:upper(), sAppVendor:upper(), sAppExeType:upper();
-- Static element positions ------------------------------------------------ --
local nCentreX, nCreditsY, nLogoX, nLogoY, nPostY, nSubY =
  160.0, 206.0, 79.0, 12.0, 72.0, 58.0;
-- Render in procedure ----------------------------------------------------- --
local function RenderProcEnterAnim()
  -- Scroll in amount
  local n1, n2 = 160.0, 168.0;
  -- Initial animation procedure
  local function RenderProcInitialAnim()
    -- Render terrain and game objects
    RenderTerrain();
    RenderObjects();
    -- Render title objects
    BlitSLT(texTitle, 2, nLogoX, 12.0 - n1);
    BlitSLT(texTitle, 3, nStageL - n1, nPostY);
    BlitSLT(texTitle, 4, nStageR - (168.0 - n2), nPostY);
    -- Render status text
    fontTiny:SetCRGB(1.0, 0.9, 0.0);
    PrintC(fontTiny, nCentreX, 58.0 - n1, strSubTitle);
    PrintC(fontTiny, nCentreX, 206.0 + n1, strCredits);
    -- Move components in
    n1 = n1 - (n1 * 0.1);
    n2 = n2 - (n2 * 0.1);
    if n1 > 1.0 and n2 > 1.0 then return end;
    -- Animation completed
    local function RenderProcFinishedAnim()
      -- Render terrain and game objects
      RenderTerrain();
      RenderObjects();
      -- Render title objects
      BlitSLT(texTitle, 2, nLogoX, nLogoY);
      BlitSLT(texTitle, 3, nStageL, nPostY);
      BlitSLT(texTitle, 4, nPostSGX, nPostY);
      -- Render status text
      fontTiny:SetCRGB(1.0, 0.9, 0.0);
      PrintC(fontTiny, nCentreX, nSubY, strSubTitle);
      PrintC(fontTiny, nCentreX, nCreditsY, strCredits);
    end
    -- Set finished callback and execute it
    fcbEnterAnimProc = RenderProcFinishedAnim;
    fcbEnterAnimProc();
  end
  -- Set initial animation procedure end execute it
  fcbEnterAnimProc = RenderProcInitialAnim;
  fcbEnterAnimProc();
end
-- Render fade out procedure ----------------------------------------------- --
local function RenderProcLeaveAnim()
  -- Scroll in amount
  local n1, n2 = 160.0, 168.0;
  -- Initial animation procedure
  local function RenderProcInitialAnim()
    -- Render terrain and game objects
    RenderTerrain();
    RenderObjects();
    -- Render title objects
    BlitSLT(texTitle, 2, nLogoX, -148.0 + n1);
    BlitSLT(texTitle, 3, nStageL - 168.0 + n1, nPostY);
    BlitSLT(texTitle, 4, nStageR - n2, nPostY);
    -- Render status text
    fontTiny:SetCRGB(1.0, 0.9, 0.0);
    PrintC(fontTiny, nCentreX, 58.0 - n1, strSubTitle);
    PrintC(fontTiny, nCentreX, 370.0 - n1, strCredits);
    -- Move components in
    n1 = n1 - (n1 * 0.05);
    n2 = n2 - (n2 * 0.05);
    if n1 >= 1.0 and n2 >= 1.0 then return end;
    -- Animation completed
    local function RenderProcFinishedAnim()
      -- Render terrain and game objects
      RenderTerrain();
      RenderObjects();
    end
    -- Set finished callback and execute it
    fcbLeaveAnimProc = RenderProcFinishedAnim;
    fcbLeaveAnimProc();
  end
  -- Set initial animation procedure end execute it
  fcbLeaveAnimProc = RenderProcInitialAnim;
  fcbLeaveAnimProc();
end
-- Render fade out procedure ----------------------------------------------- --
local function RenderProcLeave() fcbLeaveAnimProc() end;
-- Enter fade out to credits procedure ------------------------------------- --
local function FadeOutToCredits()
  -- When demo level faded out?
  local function OnFadeToCredits()
    -- Remove frame buffer update callback
    RegisterFBUCallback("title");
    -- De-init level
    DeInitLevel();
    -- Done with the texture here
    texTitle = nil;
    -- Init title screen credits without music
    InitTitleCredits(true);
  end
  -- Fade out to credits
  Fade(0.0, 1.0, 0.04, RenderProcLeave, OnFadeToCredits);
end
-- When demo level as loaded? ---------------------------------------------- --
local function ProcLogic()
  -- Process game functions
  GameProc();
  -- Refresh system information every second
  if GetGameTicks() % 60 == 59 then fcbRC() end;
  -- Select a random digger on the first tick
  if GetGameTicks() % 600 == 599 then
    -- Set next RAM update time
    iNextUpdate = GetGameTicks() + 60;
    -- Find a digger from the opposing player
    local oPlayer;
    if random() >= 0.5 then oPlayer = GetOpponentPlayer();
                       else oPlayer = GetActivePlayer() end;
    local oObj = oPlayer.D[random(#oPlayer.D)];
    -- Still not found? Find a random object
    if not oObj then oObj = aObjs[random(#aObjs)] end;
    -- Select the object if we got something!
    if oObj then SelectObject(oObj) end;
  end
  -- Return if it is not time to show the credits
  if GetGameTicks() % 1500 < 1499 then return end;
  -- Fade to credits
  FadeOutToCredits();
end
-- Render function --------------------------------------------------------- --
local function ProcRender() fcbEnterAnimProc() end;
-- Detect VRAM and update subtitle ----------------------------------------- --
local function DetectVideoMemory()
  -- Setup VRAM update function and no VRAM available?
  local _, _, nVFree<const> = DisplayVRAM();
  if nVFree == -1 then
    -- No VRAM callback
    local function NoVRAM()
      -- Get and display only RAM
      local _, _, nFree<const> = CoreRAM();
      strSubTitle = strVersion..UtilBytes(nFree, 1).." RAM FREE";
    end
    -- Set NO VRAM available callback
    fcbRC = NoVRAM;
  -- VRAM is available?
  else
    -- VRAM available callback
    local function VRAM()
      -- Get VRAM available and if is shared memory?
      local _, _, nVFree<const>, _, bIsShared<const> = DisplayVRAM();
      if bIsShared then
        strSubTitle = strVersion..UtilBytes(nVFree, 1).. "(S+V) FREE";
      -- Is dedicated memory?
      else
        -- Get free main memory
        local _, _, nFree<const> = CoreRAM();
        -- If both the same the memory is shared
        strSubTitle = strVersion..UtilBytes(nFree, 1).."(S)/"..
                                  UtilBytes(nVFree, 1).. "(V) FREE";
      end
    end
    -- Set VRAM available callback
    fcbRC = VRAM;
  end
  -- Update subtitle
  fcbRC();
end
-- Framebuffer changed callback -------------------------------------------- --
local function OnStageUpdated(_, _, iStageL, _, iStageR, iStageB)
  -- Update stage bounds converting to numbers
  nStageL, nStageR, nStageB =
    iStageL + 0.0, iStageR + 0.0, iStageB + 0.0;
  -- Recalculate post start game position
  nPostSGX = nStageR - 168.0;
  -- Re-detect video RAM
  DetectVideoMemory();
end
-- Main demo level loader -------------------------------------------------- --
local function GoLoadLevel(strTitle)
  -- Setup frame buffer updated callback
  RegisterFBUCallback("title", OnStageUpdated);
  -- Set initial enter function
  fcbEnterAnimProc, fcbLeaveAnimProc =
    RenderProcEnterAnim, RenderProcLeaveAnim;
  -- Next update time
  iNextUpdate = GetGameTicks();
  -- Build array of all the completed levels from every save slot
  local aZones, aZonesKV<const> = { }, { };
  for iSlotId, aSlotData in pairs(LoadSaveData()) do
    for iZoneId in pairs(aSlotData[16]) do
      if not aZonesKV[iZoneId] then
        aZonesKV[iZoneId] = true;
        aZones[1 + #aZones] = iZoneId;
      end
    end
  end
  -- If zero or one zone completed then allow showing the first two zones
  if #aZones <= 1 then aZones[1], aZones[2] = 1, 2 end;
  -- Load AI vs AI and use random zone
  LoadLevel(aZones[random(#aZones)], strTitle, iKeyBankId,
    oObjectTypes.DIGRANDOM, true, oObjectTypes.DIGRANDOM, true,
    ProcLogic, ProcRender, FadeOutToCredits, iHotSpotId, nil, nil, true);
end
-- When faded out to quit -------------------------------------------------- --
local function OnFadeOutToQuit() Core.Quit(0) end;
-- Fade out to quit -------------------------------------------------------- --
local function GoQuit()
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Fade to black then quit
  return Fade(0.0, 1.0, 0.04, RenderProcLeave, OnFadeOutToQuit, true);
end
-- When faded out to start game -------------------------------------------- --
local function OnFadeOutToLobby()
  -- Remove frame buffer update callback
  RegisterFBUCallback("title");
  -- De-init level
  DeInitLevel();
  -- Dereference loaded assets for garbage collector
  texTitle = nil;
  -- Reset game parameters
  InitNewGame();
  -- Load closed lobby
  InitLobby();
end
-- Fade out to start game -------------------------------------------------- --
local function GoLobby()
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Start fading out
  Fade(0.0, 1.0, 0.04, RenderProcLeave, OnFadeOutToLobby, true);
end
-- Resources are ready? ---------------------------------------------------- --
local function OnAssetsLoaded(aResources, bNoMusic)
  -- Initialise title texture
  texTitle = aResources[1];
  texTitle:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  -- Initialise credits
  strCredits = "ORIGINAL VERSIONS BY TOBY SIMPSON AND MIKE FROGGATT\n\z
    (C) 1994 MILLENNIUM INTERACTIVE LTD. ALL RIGHTS RESERVED\n\rcffffff4f\z
    POWERED BY "..sAppTitle.." (C) 2026 "..sAppVendor..". \z
      ALL RIGHTS RESERVED\n\z
    PRESS "..tKeyBankCats.gksc[9].." TO SETUP, "..
      tKeyBankCats.gksb[9].." TO SET KEYS OR "..
      tKeyBankCats.gksa[9].." TO SEE ACKNOWLEDGEMENTS AT ANY TIME";
  -- Load demonstration level without or with title music
  if bNoMusic then GoLoadLevel() else GoLoadLevel("title") end;
end
-- Initialise the title screen function ------------------------------------ --
local function InitTitle(bNoMusic)
  LoadResources("Title", aAssets, OnAssetsLoaded, bNoMusic);
end
-- Script ready function --------------------------------------------------- --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, oAssetsData, oCursorIdData, oSfxData;
  -- Get imports
  BlitSLT, DeInitLevel, Fade, GameProc, GetActivePlayer, GetGameTicks,
    GetOpponentPlayer, InitLobby, InitNewGame, InitTitleCredits, LoadLevel,
    LoadResources, LoadSaveData, PlayStaticSound, PrintC, RegisterFBUCallback,
    RegisterHotSpot, RegisterKeys, RenderObjects, RenderTerrain, SelectObject,
    SetHotSpot, oAssetsData, oCursorIdData, tKeyBankCats, aLevelsData,
    oObjectTypes, aObjs, oSfxData, fontTiny =
      GetAPI("BlitSLT", "DeInitLevel", "Fade", "GameProc", "GetActivePlayer",
        "GetGameTicks", "GetOpponentPlayer", "InitLobby", "InitNewGame",
        "InitTitleCredits", "LoadLevel", "LoadResources", "LoadSaveData",
        "PlayStaticSound", "PrintC", "RegisterFBUCallback", "RegisterHotSpot",
        "RegisterKeys", "RenderObjects", "RenderTerrain", "SelectObject",
        "SetHotSpot", "oAssetsData", "oCursorIdData", "tKeyBankCats",
        "aLevelsData", "oObjectTypes", "aObjs", "oSfxData", "fontTiny");
  -- Build assets data
  aAssets = { oAssetsData.title };
  -- Get sound id
  iSSelect = oSfxData.SELECT;
  -- Register keybinds
  local oKeys<const> = Input.KeyCodes;
  iKeyBankId = RegisterKeys("TITLE SCREEN", { [Input.States.PRESS] = {
    { oKeys.ENTER,  GoLobby, "tsst", "START GAME" },
    { oKeys.ESCAPE, GoQuit,  "tsqg", "QUIT GAME" }
  } });
  -- Register hot spots
  iHotSpotId = RegisterHotSpot({
    {  54, 152,  69,  29, 1, oCursorIdData.EXIT, false, false, GoQuit  },
    {  38, 137,  86,  46, 2, oCursorIdData.OK,   false, false, GoLobby }
  });
end
-- Return imports and exports ---------------------------------------------- --
return { A = { InitTitle = InitTitle }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
