-- FILE.LUA ================================================================ --
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
local cos<const>, floor<const>, format<const>, pairs<const>, sin<const>,
  tonumber<const> =
    math.cos, math.floor, string.format, pairs, math.sin, tonumber;
-- M-Engine function aliases ----------------------------------------------- --
local UtilFormatNumber<const>, UtilFormatTime<const>, CoreOSTime<const>,
  CoreTime<const>, VariableSave<const> = Util.FormatNumber, Util.FormatTime,
    Core.OSTime, Core.Time, Variable.Save;
-- Diggers function and data aliases --------------------------------------- --
local BlitLT, Fade, InitCon, LoadResources, PlayStaticSound, PrintC,
  RenderFade, RenderShadow, RenderTipShadow, SetCallbacks, SetHotSpot, SetKeys,
  SetTip, aLevelsData, aObjectData, aObjectTypes, fontSpeech, texSpr;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Required assets
      aFileData, aNameData;            -- File and file names data
local aSaveSlot<const> = { };          -- Contains save cvars
local iHotSpotIdLoadOnly,              -- Hot spot id (Load only)
      iHotSpotIdLoadSave,              -- Hot spot id (Load AND save)
      iHotSpotIdNoLoadSave,            -- Hot spot id (No load/save)
      iHotSpotIdSaveOnly,              -- Hot spot id (Save only)
      iKeyBankIdLoadOnly,              -- Key bank id (Load only)
      iKeyBankIdLoadSave,              -- Key bank id (Load AND save)
      iKeyBankIdNoLoadSave,            -- Key bank id (No load/save)
      iKeyBankIdSaveOnly,              -- Key bank id (Save only)
      iSClick, iSSelect,               -- Sound effect ids
      iSelected;                       -- File selected
local sEmptyString<const> = "";        -- An empty string
local sMsg,                            -- Title text
      texFile, texZmtc;                -- File screen and zmtc texture
-- Match text -------------------------------------------------------------- --
local sFileMatchText<const> =
  "^(%d+),(%d+),(%d+),(%d+),(%d+),(%d+),(%d+),(%d+),(%d+),(%d+),(%d+),(%d+),\z
    (%d+),(%d+),(%d+),(%d+),([%d%s]*)$"
-- Global data ------------------------------------------------------------- --
local aGlobalData<const> = { };
-- Initialise a new game --------------------------------------------------- --
local function InitNewGame()
  aGlobalData.gBankBalance,      aGlobalData.gCapitalCarried,
  aGlobalData.gGameSaved,        aGlobalData.gLevelsCompleted,
  aGlobalData.gNewGame,          aGlobalData.gPercentCompleted,
  aGlobalData.gSelectedLevel,    aGlobalData.gSelectedRace,
  aGlobalData.gTotalCapital,     aGlobalData.gTotalExploration,
  aGlobalData.gTotalDeaths,      aGlobalData.gTotalDug,
  aGlobalData.gTotalGemsFound,   aGlobalData.gTotalGemsSold,
  aGlobalData.gTotalIncome,      aGlobalData.gTotalEnemyKills,
  aGlobalData.gTotalPurchases,   aGlobalData.gTotalHomicides,
  aGlobalData.gTotalTimeTaken,   aGlobalData.gZogsToWinGame =
    0,                             0,
    true,                          { },
    true,                          0,
    nil,                           nil,
    0,                             0,
    0,                             0,
    0,                             0,
    0,                             0,
    0,                             0,
    0,                             17500;
end
-- Read, verify and return save data --------------------------------------- --
local function LoadSaveData()
  -- Data to return
  local aFileData<const>, aNameData<const> = { }, { };
  -- Get game data CVars
  for iIndex = 1, #aSaveSlot do
    -- Get CVar and if not empty
    local sData<const> = aSaveSlot[iIndex]:Get();
    if #sData > 0 then
      -- Get data for num
      -- We need 5 comma separated values (Last value optional)
      local T, TTT, R, B, C, TSP, TC, TDE, TD, TGS, TGF, TI,
        TDG, TPE, TP, LC, L = sData:match(sFileMatchText);
      -- Convert everything to integers
      T, TTT, R, B, C, TSP, TC, TDE, TD, TGS, TGF, TI, TDG, TPE, TP, LC =
        tonumber(T), tonumber(TTT), tonumber(R), tonumber(B), tonumber(C),
        tonumber(TSP), tonumber(TC), tonumber(TDE), tonumber(TD),
        tonumber(TGS), tonumber(TGF), tonumber(TI), tonumber(TDG),
        tonumber(TPE), tonumber(TP), tonumber(LC);
      -- Check variables and if they are all good?
      if TTT and T and R and B and C and TSP and TC and TDE and TD and
         TGS and TGF and TI and TDG and TPE and TP and LC and L and
         T >= 1 and TTT >= 0 and R >= 0 and R <= 3 and
         B <= aGlobalData.gZogsToWinGame and C >= 0 and C <= 9999 and
         TSP >= 0 and TC >= 0 and TDE >= 0 and TD >= 0 and TGS >= 0 and
         TGF >= 0 and TI >= 0 and TDG >= 0 and TPE >= 0 and TP >= 0 and
         LC >= 0 and LC <= #aLevelsData then
        -- Parse levels completed
        local CL<const>, LA = { }, 0;
        for LI in L:gmatch("(%d+)") do
          -- Convert to number and if valid number?
          LI = tonumber(LI);
          if LI and LI >= 1 and LI <= #aLevelsData then
            -- Push valid level
            CL[LI], LA = true, LA + 1;
          end
        end
        -- Levels added and valid number of levels?
        if LA > 0 and LA <= #aLevelsData and LA == LC then
          -- Level data OK! file and name data
          aFileData[iIndex], aNameData[iIndex] =
            { T, TTT, R, B, C, TSP, TC, TDE, TD, TGS,
              TGF, TI, TDG, TPE, TP, CL },
            format("%s (%s) %u%% (%s$)",
              UtilFormatTime(T, "%a %b %d %H:%M:%S %Y"):upper(),
              aObjectData[aObjectTypes.FTARG + R].NAME,
              floor(B / aGlobalData.gZogsToWinGame * 100),
              UtilFormatNumber(B, 0));
        else aNameData[iIndex] = "CORRUPTED SLOT "..iIndex.." (E#2)" end;
      else aNameData[iIndex] = "CORRUPTED SLOT "..iIndex.." (E#1)" end;
    else aNameData[iIndex] = "EMPTY SLOT "..iIndex end;
  end
  -- Return data
  return aFileData, aNameData;
end
-- Render callback --------------------------------------------------------- --
local function RenderFile()
  -- Draw trace-centre backdrop, file screen and shadow
  BlitLT(texZmtc, -96, 0);
  BlitLT(texFile, 8, 8);
  RenderShadow(8, 8, 312, 208);
  -- Draw message
  fontSpeech:SetCRGB(0, 0, 0.25);
  PrintC(fontSpeech, 160, 31, sMsg);
  -- Render file names
  for iFileId = 1, #aSaveSlot do
    -- File selected? Draw selection box!
    if iSelected == iFileId then
      local nTime<const> = CoreTime();
      RenderFade(0.5 + (sin(nTime) * cos(nTime) * 0.25),
        35, 47 + (iFileId * 13), 285, 60 + (iFileId * 13));
    end
    -- Print name of file
    fontSpeech:SetCRGB(1, 1, 1);
    PrintC(fontSpeech, 160, 49 + (iFileId * 13), aNameData[iFileId]);
  end
  -- Draw tip
  RenderTipShadow();
end
-- Fade to controller ------------------------------------------------------ --
local function GoCntrl()
  -- Play select sound
  PlayStaticSound(iSSelect);
  -- When faded out?
  local function OnFadeOut()
    -- Dereference assets for garbage collector
    texFile = nil;
    -- Load controller screen
    InitCon();
  end
  -- Fade out
  Fade(0, 1, 0.04, RenderFile, OnFadeOut);
end
-- Item selected ----------------------------------------------------------- --
local function Select(iId)
  -- Return if already selected
  if iId == iSelected then return end;
  -- Play select sound
  PlayStaticSound(iSClick);
  -- Set selected file
  iSelected = iId;
  -- Set message to selected file
  sMsg = aNameData[iSelected];
  -- Key bank and hot spot selected
  local iKeyBankIdSelected, iHotSpotIdSelected;
  -- If not empty slot?
  if aFileData[iSelected] then
    -- If new game?
    if not aGlobalData.gSelectedRace or aGlobalData.gNewGame then
      iKeyBankIdSelected, iHotSpotIdSelected =
        iKeyBankIdLoadOnly, iHotSpotIdLoadOnly;
    -- Continuation game?
    else iKeyBankIdSelected, iHotSpotIdSelected =
      iKeyBankIdLoadSave, iHotSpotIdLoadSave end;
  -- Empty slot so if new game?
  elseif not aGlobalData.gSelectedRace or aGlobalData.gNewGame then
    iKeyBankIdSelected, iHotSpotIdSelected =
      iKeyBankIdNoLoadSave, iHotSpotIdNoLoadSave;
  -- Continuation game?
  else iKeyBankIdSelected, iHotSpotIdSelected =
    iKeyBankIdSaveOnly, iHotSpotIdSaveOnly end;
  -- Set specified key bank and hot spot
  SetKeys(true, iKeyBankIdSelected);
  SetHotSpot(iHotSpotIdSelected);
end
-- Delete file ------------------------------------------------------------- --
local function GoDelete()
  -- No id? Ignore
  if not iSelected or not aFileData[iSelected] then return end;
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Write data
  aSaveSlot[iSelected]:Clear();
  -- Set message
  sMsg = "FILE "..iSelected.." DELETED SUCCESSFULLY!";
  -- Commit CVars on the game engine to persistent storage
  VariableSave();
  -- Refresh data
  aFileData, aNameData = LoadSaveData();
  -- Key bank and hot spot selected
  local iKeyBankIdSelected, iHotSpotIdSelected;
  -- If new game?
  if not aGlobalData.gSelectedRace or aGlobalData.gNewGame then
    iKeyBankIdSelected, iHotSpotIdSelected =
      iKeyBankIdNoLoadSave, iHotSpotIdNoLoadSave;
  -- Continuation game?
  else iKeyBankIdSelected, iHotSpotIdSelected =
    iKeyBankIdSaveOnly, iHotSpotIdSaveOnly end;
  -- Set specified key bank and hot spot
  SetKeys(true, iKeyBankIdSelected);
  SetHotSpot(iHotSpotIdSelected);
end
-- Load file --------------------------------------------------------------- --
local function GoLoad()
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Get data and if no data then ignore
  local Data<const> = aFileData[iSelected];
  -- Set variables
  aGlobalData.gTotalTimeTaken, aGlobalData.gSelectedRace,
  aGlobalData.gSelectedLevel,  aGlobalData.gZogsToWinGame,
  aGlobalData.gBankBalance,    aGlobalData.gPercentCompleted,
  aGlobalData.gCapitalCarried, aGlobalData.gNewGame,
  aGlobalData.gGameSaved,      aGlobalData.gTotalHomicides,
  aGlobalData.gTotalCapital,   aGlobalData.gTotalExploration,
  aGlobalData.gTotalDeaths,    aGlobalData.gTotalGemsSold,
  aGlobalData.gTotalGemsFound, aGlobalData.gTotalIncome,
  aGlobalData.gTotalDug,       aGlobalData.gTotalEnemyKills,
  aGlobalData.gTotalPurchases, aGlobalData.gLevelsCompleted =
    Data[2],                     Data[3],
    nil,                         17500,
    Data[4],                     floor(aGlobalData.gBankBalance/
                                       aGlobalData.gZogsToWinGame*100),
    Data[5],                     false,
    true,                        Data[6],
    Data[7],                     Data[8],
    Data[9],                     Data[10],
    Data[11],                    Data[12],
    Data[13],                    Data[14],
    Data[15],                    Data[16];
  -- Set success message
  sMsg = "FILE LOADED SUCCESSFULLY!";
  -- Can save now
  SetKeys(true, iKeyBankIdLoadSave);
  SetHotSpot(iHotSpotIdLoadSave);
end
-- Save file --------------------------------------------------------------- --
local function GoSave()
  -- Number of levels and levels completed
  local iZonesCompleted, sLevelsCompleted = 0, sEmptyString;
  -- For each level completed
  for iZoneId in pairs(aGlobalData.gLevelsCompleted) do
    if iZonesCompleted == 0 then sLevelsCompleted = sLevelsCompleted..iZoneId;
    else sLevelsCompleted = sLevelsCompleted.." "..iZoneId end;
    iZonesCompleted = iZonesCompleted + 1;
  end
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Write data
  aSaveSlot[iSelected]:String(
    format("%u,%u,%u,%d,%d,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%s",
      CoreOSTime(), aGlobalData.gTotalTimeTaken,
      aGlobalData.gSelectedRace, aGlobalData.gBankBalance,
      aGlobalData.gCapitalCarried, aGlobalData.gTotalHomicides,
      aGlobalData.gTotalCapital, aGlobalData.gTotalExploration,
      aGlobalData.gTotalDeaths, aGlobalData.gTotalGemsSold,
      aGlobalData.gTotalGemsFound, aGlobalData.gTotalIncome,
      aGlobalData.gTotalDug, aGlobalData.gTotalEnemyKills,
      aGlobalData.gTotalPurchases, iZonesCompleted, sLevelsCompleted));
  -- Set message
  sMsg = "FILE "..iSelected.." SAVED SUCCESSFULLY!";
  -- Can exit to title
  aGlobalData.gGameSaved = true;
  -- Commit CVars on the game engine to persistent storage
  VariableSave();
  -- Refresh data
  aFileData, aNameData = LoadSaveData();
  -- Set key bank and hot spot to load and save
  SetKeys(true, iKeyBankIdLoadSave);
  SetHotSpot(iHotSpotIdLoadSave);
end
-- Action functions -------------------------------------------------------- --
local function GoFile1() Select(1) end;
local function GoFile2() Select(2) end;
local function GoFile3() Select(3) end;
local function GoFile4() Select(4) end;
-- Selection adjust function ----------------------------------------------- --
local function GoAdjustFile(iAmount)
  Select(1 + ((((iSelected or 0) + iAmount) - 1) % 4));
end
-- Mouse scroll event ------------------------------------------------------ --
local function OnScroll(nX, nY)
  if nY < 0 then GoAdjustFile(1) elseif nY > 0 then GoAdjustFile(-1) end
end
-- When file screen has faded in? ------------------------------------------ --
local function OnFadeIn()
  -- Set key bank and hotspot id
  SetKeys(true, iKeyBankIdNoLoadSave);
  SetHotSpot(iHotSpotIdNoLoadSave);
  -- Set controller callbacks
  SetCallbacks(nil, RenderFile);
end
-- When file assets have loaded? ------------------------------------------- --
local function OnAssetsLoaded(aResources)
  -- Set loaded texture resource and create tile for file screen
  texFile = aResources[1];
  -- Setup zmtc texture
  texZmtc = aResources[2];
  -- Display data
  aFileData, aNameData = LoadSaveData();
  -- Make sure nothing selected so load/save buttons are disabled
  iSelected, sMsg = nil, "SELECT FILE";
  -- Change render procedures
  Fade(1, 0, 0.04, RenderFile, OnFadeIn);
end
-- Init load/save screen function ------------------------------------------ --
local function InitFile() LoadResources("File", aAssets, OnAssetsLoaded) end;
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, aAssetsData, aCursorIdData, aSfxData,
    fcbEmpty;
  -- Grab imports
  BlitLT, Fade, InitCon, LoadResources, PlayStaticSound, PrintC,
    RegisterHotSpot, RegisterKeys, RenderFade, RenderShadow, RenderTipShadow,
    SetCallbacks, SetHotSpot, SetKeys, SetTip, aAssetsData, aCursorIdData,
    aLevelsData, aObjectData, aObjectTypes, aSfxData, fcbEmpty, fontSpeech,
    texSpr =
      GetAPI("BlitLT", "Fade", "InitCon", "LoadResources", "PlayStaticSound",
        "PrintC", "RegisterHotSpot", "RegisterKeys", "RenderFade",
        "RenderShadow", "RenderTipShadow", "SetCallbacks", "SetHotSpot",
        "SetKeys", "SetTip", "aAssetsData", "aCursorIdData", "aLevelsData",
        "aObjectData", "aObjectTypes", "aSfxData", "fcbEmpty", "fontSpeech",
        "texSpr");
  -- Set assets data
  aAssets = { aAssetsData.file, aAssetsData.zmtc };
  -- Set sound effect ids
  iSClick, iSSelect = aSfxData.CLICK, aSfxData.SELECT;
  -- Setup key banks
  local aKeys<const> = Input.KeyCodes;
  local iPress<const> = Input.States.PRESS;
  local aKBDelete<const>, aKBLoad<const>, aKBSave<const>, aKBFile1<const>,
    aKBFile2<const>, aKBFile3<const>, aKBFile4<const>, aKBEscape<const> =
      { aKeys.BACKSPACE, GoDelete, "zmtcfdsf", "DELETE SELECTED FILE" },
      { aKeys.L,         GoLoad,   "zmtcflsf", "LOAD SELECTED FILE"   },
      { aKeys.S,         GoSave,   "zmtcfssf", "SAVE SELECTED FILE"   },
      { aKeys.N1,        GoFile1,  "zmtcfsfa", "SELECT 1ST FILE"      },
      { aKeys.N2,        GoFile2,  "zmtcfsfb", "SELECT 2ND FILE"      },
      { aKeys.N3,        GoFile3,  "zmtcfsfc", "SELECT 3RD FILE"      },
      { aKeys.N4,        GoFile4,  "zmtcfsfd", "SELECT 4TH FILE"      },
      { aKeys.ESCAPE,    GoCntrl,  "zmtcfc",   "CANCEL"               };
  local sName<const> = "ZMTC FILE";
  iKeyBankIdLoadSave = RegisterKeys(sName, { [iPress] = { aKBDelete,
    aKBLoad, aKBSave, aKBFile1, aKBFile2, aKBFile3, aKBFile4, aKBEscape } });
  iKeyBankIdLoadOnly = RegisterKeys(sName, { [iPress] = { aKBDelete,
    aKBLoad, aKBFile1, aKBFile2, aKBFile3, aKBFile4, aKBEscape } });
  iKeyBankIdSaveOnly = RegisterKeys(sName, { [iPress] = { aKBDelete,
    aKBSave, aKBFile1, aKBFile2, aKBFile3, aKBFile4, aKBEscape } });
  iKeyBankIdNoLoadSave = RegisterKeys(sName, { [iPress] = { aKBDelete,
    aKBFile1, aKBFile2, aKBFile3, aKBFile4, aKBEscape } });
  -- Get cursor ids
  local iCOK<const>, iCSelect<const>, iCExit<const> =
    aCursorIdData.OK, aCursorIdData.SELECT, aCursorIdData.EXIT;
  -- Setup hot spots
  local aHSLoad<const>, aHSSave<const>, aHS1<const>, aHS2<const>, aHS3<const>,
    aHS4<const>, aHSFile<const>, aHSCntrl<const> =
      {  57, 126,  60,  60, 0, iCOK,     "LOAD FILE",  OnScroll, GoLoad  },
      { 201, 126,  60,  60, 0, iCOK,     "SAVE FILE",  OnScroll, GoSave  },
      {  35,  60, 250,  13, 0, iCSelect, "FILE 1",     OnScroll, GoFile1 },
      {  35,  73, 250,  13, 0, iCSelect, "FILE 2",     OnScroll, GoFile2 },
      {  35,  86, 250,  13, 0, iCSelect, "FILE 3",     OnScroll, GoFile3 },
      {  35,  99, 250,  13, 0, iCSelect, "FILE 4",     OnScroll, GoFile4 },
      {   8,   8, 304, 200, 0, 0,        "LOAD/SAVE",  OnScroll, false   },
      {   0,   0,   0, 240, 3, iCExit,   "CONTROLLER", OnScroll, GoCntrl };
  iHotSpotIdLoadSave = RegisterHotSpot({
    aHSLoad, aHSSave, aHS1, aHS2, aHS3, aHS4, aHSFile, aHSCntrl });
  iHotSpotIdLoadOnly = RegisterHotSpot({
    aHSLoad, aHS1, aHS2, aHS3, aHS4, aHSFile, aHSCntrl });
  iHotSpotIdSaveOnly = RegisterHotSpot({
    aHSSave, aHS1, aHS2, aHS3, aHS4, aHSFile, aHSCntrl });
  iHotSpotIdNoLoadSave = RegisterHotSpot({
    aHS1, aHS2, aHS3, aHS4, aHSFile, aHSCntrl });
  -- Register file data CVar
  local aCVF<const> = Variable.Flags;
  -- Default CVar flags for string storage
  local iCFR<const> = aCVF.STRINGSAVE|aCVF.TRIM|aCVF.PROTECTED|aCVF.DEFLATE;
  -- Variable register function
  local VariableRegister<const> = Variable.Register;
  -- Four save slots so four save variables required
  for iSlotId = 1, 4 do
    aSaveSlot[iSlotId] =
      VariableRegister("gam_data"..iSlotId, sEmptyString, iCFR, fcbEmpty);
  end
end
-- Exports and imports ----------------------------------------------------- --
return { F = OnScriptLoaded, A = { InitFile = InitFile,
  InitNewGame = InitNewGame, LoadSaveData = LoadSaveData,
  aGlobalData = aGlobalData } };
-- End-of-File ============================================================= --
