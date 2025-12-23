-- CNTRL.LUA =============================================================== --
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
local unpack<const> = table.unpack;
-- Diggers function and data aliases --------------------------------------- --
local BlitSLT, BlitLT, Fade, InitBook, InitFile, InitLobby, InitMap, InitRace,
  LoadResources, PlayStaticSound, PrintC, RenderShadow, RenderTipShadow,
  SetCallbacks, SetHotSpot, SetKeys, oGlobalData, fontSpeech;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Assets required
      aFlashData,                      -- Active hot point
      aSpeechList,                     -- Controller speeches list
      iAnimTimer,                      -- Action timer
      iHotSpotId, iKeyBankId,          -- Selected hotspot and keybank ids
      iHotSpotIdNew, iHotSpotIdCont,   -- Hot spot id (new game / continue)
      iKeyBankIdNew, iKeyBankIdCont,   -- Key bank id (new game / continue)
      iSpeechIndex,                    -- Current speech index
      iSpeechListCount,                -- Controller speech chatter frame
      iSpeechListLoop,                 -- Controller speech chatter loop point
      iSpeechTimer,                    -- Time to show controller speech.
      iSSelect,                        -- Select sound effect id
      sMsg,                            -- Controller speech message
      texCon,                          -- Controller texture
      texZmtc;                         -- Zmtc background texture
-- Tile ids (see data.lua/oAssetsData.cntrl.P) ----------------------------- --
local tileSpeech<const>  = 1;          local tileConAnim<const> = 1;
local tileFish<const>    = 4;          local tileMap<const>     = 8;
local tileRace<const>    = 9;          local tileBook<const>    = 10;
local tileFile<const>    = 11;
-- Data for flashing textures to help the player know what to do ----------- --
local aFlashCache<const> = {
  [tileMap]  = { tileMap,    9.0,   9.0 },
  [tileRace] = { tileRace, 242.0, 160.0 },
  [tileBook] = { tileBook,   9.0, 176.0 },
  [tileFile] = { tileFile,  76.0, 181.0 },
};
-- Render callback --------------------------------------------------------- --
local function ProcRender()
  -- Draw backdrop, controller screen and shadow around it
  BlitLT(texZmtc, -96.0, 0.0);
  BlitLT(texCon, 8.0, 8.0);
  RenderShadow(8.0, 8.0, 312.0, 208.0);
  -- Draw animated fish. The first tile is already drawn.
  local iFishAnimId<const> = iAnimTimer % 5;
  if iFishAnimId > 0 then
    BlitSLT(texCon, tileFish + iFishAnimId, 19.0, 135.0) end;
  -- Controller talking?
  if iSpeechTimer > 0 then
    -- Draw controller speaking. The first tile is already drawn.
    local iAnimId<const> = iAnimTimer % 4;
    if iAnimId > 0 then
      BlitSLT(texCon, iAnimId + tileConAnim, 100.0, 36.0) end;
    -- Have flash data?
    if aFlashData then
      -- Draw flashing hotspot. The first tile is already drawn.
      local iFlashAnimId<const> = iAnimTimer % 2;
      if iFlashAnimId > 0 then
        BlitSLT(texCon, iFlashAnimId + aFlashData[1],
          aFlashData[2], aFlashData[3]) end;
    end
    -- Draw speech bubble and caption
    BlitSLT(texCon, tileSpeech, 147.0, 139.0);
    PrintC(fontSpeech, 225.0, 146.0, sMsg);
  end
  -- Draw tip
  RenderTipShadow();
end
-- Controller logic -------------------------------------------------------- --
local function ProcLogic()
  -- Grab a speech item relating to the current index and if found?
  local aSpeechItem<const> = aSpeechList[iSpeechIndex];
  if aSpeechItem then
    -- Set new speech data
    iSpeechTimer, sMsg, aFlashData = 300, aSpeechItem[1], aSpeechItem[2];
  -- Else if we're at the end? Reset the index
  elseif iSpeechIndex == iSpeechListLoop then iSpeechIndex = 0 end;
  -- Increment index
  iSpeechIndex = iSpeechIndex + 1;
  -- Calculate animation timer
  iAnimTimer = iSpeechIndex // 10;
  -- Decrease speech timer if controller speaking
  if iSpeechTimer > 0 then iSpeechTimer = iSpeechTimer - 1 end;
end
-- Transition to another scene --------------------------------------------- --
local function GoTransition(fcbOnFadeOut, ...);
  -- Play select sound
  PlayStaticSound(iSSelect);
  -- Save parameters
  local aParams<const> = { ... };
  -- GoTransition helper
  local function OnFadeOut()
    -- Dereference assets for garbage collection
    aSpeechList, iAnimTimer, iHotSpotId, iKeyBankId, iSpeechIndex,
      iSpeechListCount, iSpeechListLoop, iSpeechTimer, sMsg, texCon, texZmtc =
        nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil;
    -- Do next procedure
    fcbOnFadeOut(unpack(aParams));
  end
  -- Fade out to requested loading procedure
  return Fade(0.0, 1.0, 0.04, ProcRender, OnFadeOut);
end
-- Hotspot function events ------------------------------------------------- --
local function GoBook() GoTransition(InitBook, false) end;
local function GoFile() GoTransition(InitFile) end;
local function GoLobby() GoTransition(InitLobby, true) end;
local function GoMap() GoTransition(InitMap) end;
local function GoRace() GoTransition(InitRace) end;
-- When controller screen has faded in? ------------------------------------ --
local function OnFadedIn()
  -- Set keybank and hotspots
  SetKeys(true, iKeyBankId);
  SetHotSpot(iHotSpotId);
  -- Set controller callbacks
  SetCallbacks(ProcLogic, ProcRender);
end
-- When controller resources have loaded? ---------------------------------- --
local function OnAssetsLoaded(aResources)
  -- Set zmtc and controller texture handles
  texZmtc, texCon = aResources[1], aResources[2];
  -- Initialise animation and speech variables
  iSpeechTimer, aSpeechList, iSpeechListCount, iSpeechListLoop, iSpeechIndex,
    iAnimTimer = 0, { }, 60, 0, 0, 0;
  -- Add a speech item
  local function AddSpeechItem(sString, iId)
    aSpeechList[iSpeechListCount] = { sString, aFlashCache[iId] };
    iSpeechListCount = iSpeechListCount + 900;
    iSpeechListLoop = iSpeechListCount - 120;
  end
  -- If we're not in a new game?
  if not oGlobalData.gNewGame then
    -- Set continue hotspot and keybank
    iHotSpotId, iKeyBankId = iHotSpotIdCont, iKeyBankIdCont;
    -- If no zone is selected?
    if not oGlobalData.gSelectedLevel then
      -- Player returned from completing a zone
      AddSpeechItem("WELCOME BACK, MASTER MINER");
      AddSpeechItem("PLEASE PICK YOUR NEXT ZONE", tileMap);
    -- Zone already selected? Tell player to bugger off
    else AddSpeechItem("NOW YOU'RE DONE, BE GONE") end;
    -- Add some other things
    AddSpeechItem("RECORDED YOUR PROGRESS?", tileFile);
    AddSpeechItem("WHAT!? YOU'RE STILL HERE?");
  -- New game?
  else
    -- Set new hotspot and keybank
    iHotSpotId, iKeyBankId = iHotSpotIdNew, iKeyBankIdNew;
    -- Race not selected?
    if not oGlobalData.gSelectedRace then
      -- Zone not selected?
      if not oGlobalData.gSelectedLevel then
        -- Tell player to pick diggers race and zone
        AddSpeechItem("WELCOME, MASTER MINER", tileFile);
        AddSpeechItem("YOU'LL NEED TO PICK DIGGERS", tileRace);
        AddSpeechItem("YOU'LL WANT TO PICK A ZONE", tileMap);
      -- Level selected? Tell player to pick diggers
      else AddSpeechItem("NOW YOU MUST PICK DIGGERS", tileRace) end;
      -- Player can also load previous progress
      AddSpeechItem("PAST RECORDS ARE HERE", tileFile);
    -- Race selected but zone not selected? Tell player to pick a zone
    elseif not oGlobalData.gSelectedLevel then
      AddSpeechItem("YOU MUST ALSO PICK A ZONE", tileMap);
    -- Player has picked zone and race?
    else
      -- Tell player to bugger off and play the game
      AddSpeechItem("NOW YOU'RE DONE, BE GONE");
      AddSpeechItem("WHAT!? YOU'RE STILL HERE?");
    end
  end
  -- Add some generic chatter
  AddSpeechItem("THE BOOK MAY BE OF HELP", tileBook);
  AddSpeechItem("AND DON'T TAKE ALL DAY");
  -- Set colour of speech text
  fontSpeech:SetCRGB(0.0, 0.0, 0.25);
  -- Change render procedures
  Fade(1.0, 0.0, 0.04, ProcRender, OnFadedIn);
end
-- Init controller screen function ----------------------------------------- --
local function InitCon()
  LoadResources("Controller", aAssets, OnAssetsLoaded);
end;
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, oAssetsData, oCursorIdData, oSfxData;
  -- Grab imports
  BlitSLT, BlitLT, Fade, InitBook, InitFile, InitLobby, InitMap, InitRace,
    LoadResources, PlayStaticSound, PrintC, RegisterHotSpot, RegisterKeys,
    RenderShadow, RenderTipShadow, SetCallbacks, SetHotSpot, SetKeys,
    oAssetsData, oCursorIdData, oGlobalData, oSfxData, fontSpeech =
      GetAPI("BlitSLT", "BlitLT", "Fade", "InitBook", "InitFile", "InitLobby",
        "InitMap", "InitRace", "LoadResources", "PlayStaticSound", "PrintC",
        "RegisterHotSpot", "RegisterKeys", "RenderShadow", "RenderTipShadow",
        "SetCallbacks", "SetHotSpot", "SetKeys", "oAssetsData",
        "oCursorIdData", "oGlobalData", "oSfxData", "fontSpeech");
  -- Set assets data
  aAssets = { oAssetsData.zmtc, oAssetsData.cntrl };
  -- Set sound effect ids
  iSSelect = oSfxData.SELECT;
  -- Required cursor id
  local iCSelect<const>, iCExit<const> =
    oCursorIdData.SELECT, oCursorIdData.EXIT;
  -- Set up hotspots data
  local aHSMap<const>, aHSBook<const>, aHSFile<const>,
        aHSCntrl<const>, aHSExit<const> =
    {   9,   9,  48,  52, 0, iCSelect, "SELECT ZONE", false, GoMap   },
    {   9, 176,  67,  31, 0, iCSelect, "THE BOOK",    false, GoBook  },
    {  76, 182,  87,  25, 0, iCSelect, "LOAD/SAVE",   false, GoFile  },
    {   8,   8, 304, 200, 0, 0,        "CONTROLLER",  false, false   },
    {   0,   0,   0, 240, 3, iCExit,   "GO TO LOBBY", false, GoLobby }
  -- Register hotspots for new game
  iHotSpotIdNew = RegisterHotSpot({ aHSMap, aHSBook, aHSFile,
    { 243, 160,  18,  44, 0, iCSelect, "SELECT RACE", false, GoRace  },
    aHSCntrl, aHSExit });
  -- Register hotspots for continue game
  iHotSpotIdCont =
    RegisterHotSpot({ aHSMap, aHSBook, aHSFile, aHSCntrl, aHSExit });
  -- Register keybinds
  local oKeys<const> = Input.KeyCodes;
  local iPress<const> = Input.States.PRESS;
  local sName<const> = "ZMTC CONTROLLER";
  local aKBLobby<const>, aKBBook<const>, aKBFile<const>, aKBZone<const> =
    { oKeys.ESCAPE, GoLobby, "zmtccgtl", "GO TO LOBBY"   },
    { oKeys.B,      GoBook,  "zmtcrtb",  "READ THE BOOK" },
    { oKeys.F,      GoFile,  "zmtcfs",   "FILE STORAGE"  },
    { oKeys.Z,      GoMap,   "zmtccsz",  "SELECT ZONE"   };
  -- Register keybank for continue game
  iKeyBankIdCont = RegisterKeys(sName,
    { [iPress] = { aKBLobby, aKBBook, aKBFile, aKBZone } });
  -- Register keybank for new game
  iKeyBankIdNew = RegisterKeys(sName, { [iPress] = { aKBLobby, aKBBook,
    aKBFile, { oKeys.R, GoRace, "zmtccsrc", "SELECT RACE" }, aKBZone } });
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitCon = InitCon }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
