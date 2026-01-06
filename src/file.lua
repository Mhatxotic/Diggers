-- FILE.LUA ================================================================ --
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
local cos<const>, error<const>, floor<const>, format<const>, pairs<const>,
  sin<const>, tonumber<const>, create<const>, unpack<const> =
    math.cos, error, math.floor, string.format, pairs, math.sin, tonumber,
    table.create, table.unpack;
-- Engine function aliases ------------------------------------------------- --
local CoreLogEx<const>, UtilFormatNumber<const>, UtilFormatTime<const>,
  CoreOSTime<const>, CoreTime<const>, VariableSave<const> =
    Core.LogEx, Util.FormatNumber, Util.FormatTime, Core.OSTime, Core.Time,
    Variable.Save;
-- Diggers function and data aliases --------------------------------------- --
local BlitLT, Fade, InitCon, LoadResources, PlayStaticSound, PrintC,
  RenderFade, RenderShadow, RenderTipShadow, SetCallbacks, SetHotSpot, SetKeys,
  SetTip, aLevelsData, aRacesData, oObjectData, oObjectTypes, fontSpeech,
  texSpr, tKeyBankCats;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Required assets
      aFileData, aNameData;            -- File and file names data
local aSaveSlot<const> = create(4);    -- Contains save cvars
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
local oGlobalData<const> = create(0, 20);
-- Initialise a new game --------------------------------------------------- --
local function InitNewGame()
  oGlobalData.gBankBalance,      oGlobalData.gCapitalCarried,
  oGlobalData.gGameSaved,        oGlobalData.gLevelsCompleted,
  oGlobalData.gNewGame,          oGlobalData.gPercentCompleted,
  oGlobalData.gSelectedLevel,    oGlobalData.gSelectedRace,
  oGlobalData.gTotalCapital,     oGlobalData.gTotalExploration,
  oGlobalData.gTotalDeaths,      oGlobalData.gTotalDug,
  oGlobalData.gTotalGemsFound,   oGlobalData.gTotalGemsSold,
  oGlobalData.gTotalIncome,      oGlobalData.gTotalEnemyKills,
  oGlobalData.gTotalPurchases,   oGlobalData.gTotalHomicides,
  oGlobalData.gTotalTimeTaken,   oGlobalData.gZogsToWinGame =
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
-- Parse level data and return result -------------------------------------- --
local function ParseSaveData(cvSlot)
  -- Get CVar and if not empty
  if cvSlot:Empty() then return false end;
  -- We need 17 comma separated values
  local aTokens<const> = { cvSlot:Get():match(sFileMatchText); }
  if #aTokens ~= 17 then return false, 101 end;
  -- For each string in the tokens list
  for iIndex = 1, #aTokens - 1 do
    -- Convert the string to number
    local iValue<const> = tonumber(aTokens[iIndex])
    -- String to number conversion failed?
    if not iValue then return false, 200 + iIndex end;
    -- No value should be negative
    if iValue < 0 then return false, 300 + iIndex end;
    -- Accepted value
    aTokens[iIndex] = iValue;
  end
  -- Now parse all the integers of each one
  local iTimestamp<const>, iTimeTaken<const>, iSelectedRace<const>,
    iBankBalance<const>, iCaptialCarried<const>, iHomicides<const>,
    iTotalCapital<const>, iExploration<const>, iMortalities<const>,
    iGemsSold<const>, iGemsFound<const>, iIncome<const>, iDug<const>,
    iFiendsKilled<const>, iPurchases<const>, iLevelsCompleted<const>,
    sLevelsCompleted<const> = unpack(aTokens);
  -- Check that race id is valid
  if iSelectedRace >= #aRacesData then return false, 400 end;
  -- Can't keep a balance over the winning total without seeing end game
  if iBankBalance > oGlobalData.gZogsToWinGame then return false, 401 end;
  -- Having this much in devices at the end of the level is impossible
  if iCaptialCarried > 65535 then return false, 402 end;
  -- Number of levels completed can't exceed the actual number of levels
  if iLevelsCompleted > #aLevelsData then return false, 403 end;
  -- This is a overestimate but protects from insane values
  if iIncome > (iLevelsCompleted * 65535) then return false, 404 end;
  -- If it takes at most 4 digs to clear a typical block and there are 16384
  -- blocks in a level, then the value can't possibly be over the levels
  -- completed count.
  if iDug > (iLevelsCompleted * 65535) then return false, 405 end;
  -- There are 16384 blocks in a level so 16384 shroud tiles
  if iExploration > (iLevelsCompleted * 16384) then return false, 406 end;
  -- Since a gem found is a gem that's dug, it can't be over the dug count
  if iGemsFound > iDug then return false, 407 end;
  -- Homicides or deaths can't be over the maximum number of diggers in each
  -- level completed
  if iHomicides > (iLevelsCompleted * 5) then return false, 408 end;
  if iMortalities > (iLevelsCompleted * 5) then return false, 409 end;
  -- Parse levels completed
  local aLevelsCompleted<const>, iLevelId = create(34), 0;
  for iLevelIndex in sLevelsCompleted:gmatch("(%d+)") do
    -- Convert to number and if valid number?
    local iCompleted<const> = tonumber(iLevelIndex);
    if not iCompleted then return false, 500 end;
    if iCompleted < 1 then return false, 501 end;
    if iCompleted > #aLevelsData then return false, 502 end;
    -- Push valid level
    aLevelsCompleted[iCompleted], iLevelId = true, iLevelId + 1;
  end
  -- Levels added and valid number of levels?
  if iLevelId <= 0 then return false, 503 end;
  if iLevelId > #aLevelsData then return false, 504 end;
  if iLevelId ~= iLevelsCompleted then return false, 505 end;
  -- Return both file data data...
  return true, { iTimestamp, iTimeTaken, iSelectedRace, iBankBalance,
    iCaptialCarried, iHomicides, iTotalCapital, iExploration, iMortalities,
    iGemsSold, iGemsFound, iIncome, iDug, iFiendsKilled, iPurchases,
    aLevelsCompleted },
    -- and filename
    format("%s (%s) %u%% ($%s)",
      UtilFormatTime(iTimestamp, "%a %b %d %H:%M:%S %Y"):upper(),
      oObjectData[oObjectTypes.FTARG + iSelectedRace].NAME,
      floor(iBankBalance / oGlobalData.gZogsToWinGame * 100),
      UtilFormatNumber(iBankBalance, 0));
end
-- Read, verify and return save data --------------------------------------- --
local function LoadSaveData()
  -- Data to return
  local aFileData<const>, aNameData<const> = create(4), create(4);
  -- Get game data CVars
  for iIndex = 1, #aSaveSlot do
    -- Parse save data and if failed?
    local bResult<const>, aFData<const>, sData =
      ParseSaveData(aSaveSlot[iIndex])
    if not bResult then
      -- Corrupted slot?
      if aFData then
        -- Data not available
        aFileData[iIndex] = false;
        -- Set corrupted label for player
        sData = format("CORRUPTED SLOT %d (ERROR #%d)", iIndex, aFData);
      -- Just an empty slot
      else sData = format("EMPTY SLOT %d", iIndex) end;
    -- Success so set parsed file data
    else aFileData[iIndex] = aFData end;
    -- Set file name so user can see
    aNameData[iIndex] = sData;
  end
  -- Return data
  return aFileData, aNameData;
end
-- Render callback --------------------------------------------------------- --
local function RenderFile()
  -- Draw trace-centre backdrop, file screen and shadow
  BlitLT(texZmtc, -96.0, 0.0);
  BlitLT(texFile, 8.0, 8.0);
  RenderShadow(8.0, 8.0, 312.0, 208.0);
  -- Draw message
  fontSpeech:SetCRGB(0.0, 0.0, 0.25);
  PrintC(fontSpeech, 160.0, 31.0, sMsg);
  -- Render file names
  for iFileId = 1, #aSaveSlot do
    -- Calculate Y
    local nY<const> = iFileId * 13.0;
    -- File selected? Draw selection box!
    if iSelected == iFileId then
      local nTime<const> = CoreTime();
      RenderFade(0.5 + (sin(nTime) * cos(nTime) * 0.25),
        35.0, 41.0 + nY, 285.0, 54.0 + nY);
    end
    -- Print name of file
    fontSpeech:SetCRGB(1.0, 1.0, 1.0);
    PrintC(fontSpeech, 160.0, 43.0 + nY, aNameData[iFileId]);
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
  Fade(0.0, 1.0, 0.04, RenderFile, OnFadeOut);
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
    if not oGlobalData.gSelectedRace or oGlobalData.gNewGame then
      iKeyBankIdSelected, iHotSpotIdSelected =
        iKeyBankIdLoadOnly, iHotSpotIdLoadOnly;
    -- Continuation game?
    else iKeyBankIdSelected, iHotSpotIdSelected =
      iKeyBankIdLoadSave, iHotSpotIdLoadSave end;
  -- Empty slot so if new game?
  elseif not oGlobalData.gSelectedRace or oGlobalData.gNewGame then
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
  if not iSelected or aFileData[iSelected] == nil then return end;
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Write data
  aSaveSlot[iSelected]:Clear();
  -- Set message
  sMsg = format("FILE %d DELETED SUCCESSFULLY!", iSelected);
  -- Commit CVars on the game engine to persistent storage
  VariableSave();
  -- Refresh data
  aFileData, aNameData = LoadSaveData();
  -- Key bank and hot spot selected
  local iKeyBankIdSelected, iHotSpotIdSelected;
  -- If new game?
  if not oGlobalData.gSelectedRace or oGlobalData.gNewGame then
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
  local aData<const> = aFileData[iSelected];
  -- Set variables
  oGlobalData.gTotalTimeTaken, oGlobalData.gSelectedRace,
  oGlobalData.gSelectedLevel,  oGlobalData.gZogsToWinGame,
  oGlobalData.gBankBalance,    oGlobalData.gPercentCompleted,
  oGlobalData.gCapitalCarried, oGlobalData.gNewGame,
  oGlobalData.gGameSaved,      oGlobalData.gTotalHomicides,
  oGlobalData.gTotalCapital,   oGlobalData.gTotalExploration,
  oGlobalData.gTotalDeaths,    oGlobalData.gTotalGemsSold,
  oGlobalData.gTotalGemsFound, oGlobalData.gTotalIncome,
  oGlobalData.gTotalDug,       oGlobalData.gTotalEnemyKills,
  oGlobalData.gTotalPurchases, oGlobalData.gLevelsCompleted =
    aData[2],                     aData[3],
    nil,                          17500,
    aData[4],                     floor(oGlobalData.gBankBalance /
                                    oGlobalData.gZogsToWinGame * 100),
    aData[5],                     false,
    true,                         aData[6],
    aData[7],                     aData[8],
    aData[9],                     aData[10],
    aData[11],                    aData[12],
    aData[13],                    aData[14],
    aData[15],                    aData[16];
  -- Set success message
  sMsg = format("FILE %d LOADED SUCCESSFULLY!", iSelected);
  -- Can save now
  SetKeys(true, iKeyBankIdLoadSave);
  SetHotSpot(iHotSpotIdLoadSave);
end
-- Save file --------------------------------------------------------------- --
local function GoSave()
  -- Number of levels and levels completed
  local iZonesCompleted, iLevelsCompleted = 0, sEmptyString;
  -- For each level completed
  for iZoneId in pairs(oGlobalData.gLevelsCompleted) do
    if iZonesCompleted == 0 then iLevelsCompleted = iLevelsCompleted..iZoneId;
    else iLevelsCompleted = iLevelsCompleted.." "..iZoneId end;
    iZonesCompleted = iZonesCompleted + 1;
  end
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Write data
  aSaveSlot[iSelected]:String(
    format("%u,%u,%u,%d,%d,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%s",
      CoreOSTime(), oGlobalData.gTotalTimeTaken,
      oGlobalData.gSelectedRace, oGlobalData.gBankBalance,
      oGlobalData.gCapitalCarried, oGlobalData.gTotalHomicides,
      oGlobalData.gTotalCapital, oGlobalData.gTotalExploration,
      oGlobalData.gTotalDeaths, oGlobalData.gTotalGemsSold,
      oGlobalData.gTotalGemsFound, oGlobalData.gTotalIncome,
      oGlobalData.gTotalDug, oGlobalData.gTotalEnemyKills,
      oGlobalData.gTotalPurchases, iZonesCompleted, iLevelsCompleted));
  -- Set message
  sMsg = format("FILE %d SAVED SUCCESSFULLY!", iSelected);
  -- Can exit to title
  oGlobalData.gGameSaved = true;
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
local function GoFile5() Select(5) end;
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
  iSelected, sMsg = nil, "SELECT A FILE BELOW";
  -- Change render procedures
  Fade(1.0, 0.0, 0.04, RenderFile, OnFadeIn);
end
-- Init load/save screen function ------------------------------------------ --
local function InitFile() LoadResources("File", aAssets, OnAssetsLoaded) end;
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, oAssetsData, oCursorIdData, oSfxData,
    fcbEmpty;
  -- Grab imports
  BlitLT, Fade, InitCon, LoadResources, PlayStaticSound, PrintC,
    RegisterHotSpot, RegisterKeys, RenderFade, RenderShadow, RenderTipShadow,
    SetCallbacks, SetHotSpot, SetKeys, SetTip, oAssetsData, oCursorIdData,
    aLevelsData, aRacesData, oObjectData, oObjectTypes, oSfxData, fcbEmpty,
    fontSpeech, texSpr, tKeyBankCats =
      GetAPI("BlitLT", "Fade", "InitCon", "LoadResources", "PlayStaticSound",
        "PrintC", "RegisterHotSpot", "RegisterKeys", "RenderFade",
        "RenderShadow", "RenderTipShadow", "SetCallbacks", "SetHotSpot",
        "SetKeys", "SetTip", "oAssetsData", "oCursorIdData", "aLevelsData",
        "aRacesData", "oObjectData", "oObjectTypes", "oSfxData", "fcbEmpty",
        "fontSpeech", "texSpr", "tKeyBankCats");
  -- Set assets data
  aAssets = { oAssetsData.file, oAssetsData.zmtc };
  -- Set sound effect ids
  iSClick, iSSelect = oSfxData.CLICK, oSfxData.SELECT;
  -- Setup key banks
  local oKeys<const> = Input.KeyCodes;
  local iPress<const> = Input.States.PRESS;
  local aKBDelete<const>, aKBLoad<const>, aKBSave<const>, aKBFile1<const>,
    aKBFile2<const>, aKBFile3<const>, aKBFile4<const>, aKBFile5<const>,
    aKBEscape<const> =
      { oKeys.BACKSPACE, GoDelete, "zmtcfdsf", "DELETE SELECTED FILE" },
      { oKeys.L,         GoLoad,   "zmtcflsf", "LOAD SELECTED FILE"   },
      { oKeys.S,         GoSave,   "zmtcfssf", "SAVE SELECTED FILE"   },
      { oKeys.N1,        GoFile1,  "zmtcfsfa", "SELECT 1ST FILE"      },
      { oKeys.N2,        GoFile2,  "zmtcfsfb", "SELECT 2ND FILE"      },
      { oKeys.N3,        GoFile3,  "zmtcfsfc", "SELECT 3RD FILE"      },
      { oKeys.N4,        GoFile4,  "zmtcfsfd", "SELECT 4TH FILE"      },
      { oKeys.N5,        GoFile5,  "zmtcfsfe", "SELECT 5TH FILE"      },
      { oKeys.ESCAPE,    GoCntrl,  "zmtcfc",   "CANCEL"               };
  local sName<const> = "ZMTC FILE";
  iKeyBankIdLoadSave = RegisterKeys(sName, { [iPress] = { aKBDelete, aKBLoad,
    aKBSave, aKBFile1, aKBFile2, aKBFile3, aKBFile4, aKBFile5, aKBEscape } });
  iKeyBankIdLoadOnly = RegisterKeys(sName, { [iPress] = { aKBDelete, aKBLoad,
    aKBFile1, aKBFile2, aKBFile3, aKBFile4, aKBFile5, aKBEscape } });
  iKeyBankIdSaveOnly = RegisterKeys(sName, { [iPress] = { aKBDelete, aKBSave,
    aKBFile1, aKBFile2, aKBFile3, aKBFile4, aKBFile5, aKBEscape } });
  iKeyBankIdNoLoadSave = RegisterKeys(sName, { [iPress] = { aKBDelete,
    aKBFile1, aKBFile2, aKBFile3, aKBFile4, aKBFile5, aKBEscape } });
  -- Get cursor ids
  local iCOK<const>, iCSelect<const>, iCExit<const> =
    oCursorIdData.OK, oCursorIdData.SELECT, oCursorIdData.EXIT;
  -- Setup hot spots
  local aHSLoad<const>, aHSSave<const>, aHS1<const>, aHS2<const>, aHS3<const>,
    aHS4<const>, aHS5, aHSFile<const>, aHSCntrl<const> =
      {  57, 126,  60,  60, 0, iCOK,     "LOAD FILE",  OnScroll, GoLoad  },
      { 201, 126,  60,  60, 0, iCOK,     "SAVE FILE",  OnScroll, GoSave  },
      {  35,  54, 250,  13, 0, iCSelect, "FILE 1",     OnScroll, GoFile1 },
      {  35,  67, 250,  13, 0, iCSelect, "FILE 2",     OnScroll, GoFile2 },
      {  35,  80, 250,  13, 0, iCSelect, "FILE 3",     OnScroll, GoFile3 },
      {  35,  93, 250,  13, 0, iCSelect, "FILE 4",     OnScroll, GoFile4 },
      {  35, 106, 250,  13, 0, iCSelect, "FILE 5",     OnScroll, GoFile5 },
      {   8,   8, 304, 200, 0, 0,        "LOAD/SAVE",  OnScroll, false   },
      {   0,   0,   0, 240, 3, iCExit,   "CONTROLLER", OnScroll, GoCntrl };
  iHotSpotIdLoadSave = RegisterHotSpot({
    aHSLoad, aHSSave, aHS1, aHS2, aHS3, aHS4, aHS5, aHSFile, aHSCntrl });
  iHotSpotIdLoadOnly = RegisterHotSpot({
    aHSLoad, aHS1, aHS2, aHS3, aHS4, aHS5, aHSFile, aHSCntrl });
  iHotSpotIdSaveOnly = RegisterHotSpot({
    aHSSave, aHS1, aHS2, aHS3, aHS4, aHS5, aHSFile, aHSCntrl });
  iHotSpotIdNoLoadSave = RegisterHotSpot({
    aHS1, aHS2, aHS3, aHS4, aHS5, aHSFile, aHSCntrl });
  -- Register file data CVar
  local aCVF<const> = Variable.Flags;
  -- Default CVar flags for string storage
  local iCFR<const> = aCVF.STRINGSAVE|aCVF.TRIM|aCVF.PROTECTED|aCVF.DEFLATE;
  -- Variable register function
  local VariableRegister<const> = Variable.Register;
  -- Callback to check if game version changed
  local iVersion<const> =
    tonumber(Variable.Internal.app_version:Get():match("%d+"));
  if not iVersion then error("Internal error: App version not valid!") end;
  -- Note that this cvar will unregister when we're done with it as it is
  -- stored a local variable. There isn't any need for the user to modify
  -- this so the behaviour is as intended.
  local cvVersion<const> = VariableRegister("gam_lastversion", "0",
    aCVF.UINTEGERSAVE, fcbEmpty);
  -- If version is different?
  local iOldVersion<const> = tonumber(cvVersion:Get());
  if iVersion ~= iOldVersion then
    -- Log that the version changed
    CoreLogEx("Version change from "..
      iOldVersion.." to "..iVersion.."!", Core.LogLevels.WARNING);
    -- Update saved version to new version
    cvVersion:Integer(iVersion);
    -- Here we can eventually make changes to the game saves if we ever need to
    -- change the format of them
  end
  -- Five save slots so five save variables required
  for iSlotId = 1, 5 do
    aSaveSlot[iSlotId] =
      VariableRegister("gam_data"..iSlotId, sEmptyString, iCFR, fcbEmpty);
  end
end
-- Exports and imports ----------------------------------------------------- --
return { F = OnScriptLoaded, A = { InitFile = InitFile,
  InitNewGame = InitNewGame, LoadSaveData = LoadSaveData,
  oGlobalData = oGlobalData } };
-- End-of-File ============================================================= --
