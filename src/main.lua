-- MAIN.LUA ================================================================ --
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
local collectgarbage<const>, cos<const>, error<const>, floor<const>,
  format<const>, pairs<const>, random<const>, remove<const>, rep<const>,
  sin<const>, tonumber<const>, tostring<const>, type<const>, unpack<const>,
  create<const> =
    collectgarbage, math.cos, error, math.floor, string.format,
    pairs, math.random, table.remove, string.rep, math.sin, tonumber,
    tostring, type, table.unpack, table.create;
-- Engine function aliases ------------------------------------------------- --
local AssetParseBlock<const>, ClipSet<const>, CoreCatchup<const>,
  CoreEnd<const>, CoreLog<const>, CoreLogEx<const>, CoreOnTick<const>,
  CoreQuit<const>, CoreReset<const>, CoreStack<const>, CoreWrite<const>,
  FboDraw<const>, FboMatrix<const>, InputOnKey<const>, InputSetCursor<const>,
  CoreTime<const>, TextureCreate<const>, UtilBlank<const>, UtilDuration<const>,
  UtilExplode<const>, UtilFlushArray<const>, UtilImplode<const>,
  UtilIsFunction<const>, UtilIsInteger<const>, UtilIsString<const>,
  UtilIsTable<const>, VariableRegister<const> =
    Asset.ParseBlock, Clip.Set, Core.Catchup, Core.End, Core.Log, Core.LogEx,
    Core.OnTick, Core.Quit, Core.Reset, Core.Stack, Core.Write, Fbo.Draw,
    Fbo.Matrix, Input.OnKey, Input.SetCursor, Core.Time, Texture.Create,
    Util.Blank, Util.Duration, Util.Explode, Util.FlushArray, Util.Implode,
    Util.IsFunction, Util.IsInteger, Util.IsString, Util.IsTable,
    Variable.Register;
-- Locals ------------------------------------------------------------------ --
local CBProc, CBRender;                -- Generic tick callbacks
local aMods<const>   = create(34);     -- Modules data
local bTestMode      = false;          -- Test mode enabled
local fFont<const>   = Font.Console(); -- Main console class
local fboMain<const> = Fbo.Main();     -- Main frame buffer object class
local iAPI           = 0;              -- Variables in API
local iTexScale;                       -- Texture scale
local oAPI<const>    = create(0, 183); -- API to send to other functions
local oCache         = create(0, 4);   -- File cache
local oFbuCbs<const> = create(0, 16);  -- Frame buffer updated function
-- Stage dimensions -------------------------------------------------------- --
local iStageWidth  = 320;              -- Width of stage (Monitor)
local iStageHeight = 240;              -- Height of stage (Monitor)
local iOrthoWidth  = iStageWidth;      -- Width of stage (4:3)
local iOrthoHeight = iStageHeight;     -- Height of stage (4:3)
local iStageLeft   = 0;                -- Left of stage
local iStageTop    = 0;                -- Top of stage
local iStageRight  = iStageWidth;      -- Right of stage
local iStageBottom = iStageHeight;     -- Bottom of stage
local iStageLeftO  = iStageLeft;       -- Left of stage (unscaled)
local iStageTopO   = iStageTop;        -- Top of stage (unscaled)
local iStageRightO = iStageRight;      -- Right of stage (unscaled)
-- These could be called even though they aren't initialised yet ----------- --
local CursorRender, DisableKeyHandlers, JoystickProc, MainProcFunc,
  RestoreKeyHandlers, SetKeys, SetHotSpot, SetTip = UtilBlank, UtilBlank,
    UtilBlank, UtilBlank, UtilBlank, UtilBlank, UtilBlank, UtilBlank;
-- Constants for loader ---------------------------------------------------- --
local oBFlags<const> = Image.FlagsPre;     -- Get bitmap loading flags
local iPNG<const> = oBFlags.TOGPU|oBFlags.FCE_PNG;-- Get forced PNG format flag
local oPFlags<const> = Pcm.Flags;          -- Get waveform loading flags
local iOGG<const> = oPFlags.FCE_OGG;       -- Get forced wave format
local oPrFlags<const> = Asset.Progress;    -- Asset progress flags
local iFStart<const> = oPrFlags.FILESTART; -- File opened with information
-- Table debug function (global on purpose) -------------------------------- --
function Debug(oData)
  -- Printing function
  local function Print(iIndent, sWhat) CoreWrite(rep(" ", iIndent)..sWhat) end
  -- Debug a variable
  local function DoDump(sName, oData, iLv)
    -- Print variable name
    Print(iLv, sName.." ("..tostring(oData)..") = {");
    -- Index
    local iI = 0;
    -- Increase indent
    iLv = iLv + 2;
    -- Enumerate keys and values
    for sK, vV in pairs(oData) do
      -- Recurse if a table
      if UtilIsTable(vV) then DoDump(sK, vV, iLv);
      -- Print key and value
      else Print(iLv, tostring(sK).." : "..type(vV).." = "..tostring(vV)) end;
      -- Increment counter
      iI = iI + 1;
    end
    -- Decrease indent
    iLv = iLv - 2;
    -- Print total
    Print(iLv, "} = "..iI.." ["..#oData.."]");
  end
  -- Must be a table
  if UtilIsTable(oData) then return DoDump("ROOT", oData, 0) end;
  -- Just a variable
  Print(0, type(oData).." = "..tostring(oData));
end
-- Check and put functions in API ------------------------------------------ --
local function PutAPI(sName, oModAPI)
  -- Check parameters
  if not UtilIsTable(oModAPI) then error(sName..": bad api!") end;
  -- How many functions registered?
  local iFunctions = 0;
  -- Add functions to the api
  for sKey, vVar in pairs(oModAPI) do
    -- Check variable name
    if not UtilIsString(sKey) then
      error(sName.."["..tostring(sKey).."] bad key!") end;
    -- Check not already registered
    if oAPI[sKey] ~= nil then
      error(sName.."["..sKey.."] already registered!") end;
    -- Check that value is valid
    if nil == vVar then error(sName.."["..sKey.."] bad variable!") end;
    -- Assign variable in internal API
    oAPI[sKey] = vVar;
    -- API function added
    iFunctions = iFunctions + 1;
  end
  -- Add to total functions
  iAPI = iAPI + iFunctions;
  -- Log result
  CoreLog("Module '"..sName.."' added "..iFunctions.." members (now "..
    iAPI..") to the API.");
end
-- Parse the return value of a script -------------------------------------- --
local function ParseScriptResult(sName, oModData)
  -- Check parameters
  if not UtilIsString(sName) then error("Bad name: "..tostring(sName)) end;
  if not UtilIsTable(oModData) then error(sName..": bad return!") end;
  local fcbModCb<const> = oModData.F;
  if not UtilIsFunction(fcbModCb) then error(sName..": bad callback!") end;
  local oModAPI<const> = oModData.A;
  -- Set name of module
  oModData.N = sName;
  -- Put functions in API
  PutAPI(sName, oModAPI);
  -- Put returned data in API for later when everything is loaded and we'll
  -- call the modules callback function with the fully loaded API.
  aMods[1 + #aMods] = oModData;
end
-- Function to parse a script ---------------------------------------------- --
local function ParseScript(asScript)
  -- Get name of module
  local sName<const> = asScript:Name();
  -- Compile the script and parse the return value
  ParseScriptResult(sName, AssetParseBlock(sName, 1, asScript));
  -- Return success
  return true;
end
-- Get callbacks ----------------------------------------------------------- --
local function GetCallbacks() return CBProc, CBRender end;
-- Set callbacks ----------------------------------------------------------- --
local function SetCallbacks(fcbTick, fcbRender)
  CBProc, CBRender = fcbTick or UtilBlank, fcbRender or UtilBlank end;
-- Error handler ----------------------------------------------------------- --
local function SetErrorMessage(sReason)
  -- Activate main frame buffer object just incase it isn't
  fboMain:Activate();
  -- Show cursor
  InputSetCursor(true);
  -- Convert to string if it isn't
  if not UtilIsString(sReason) then sReason = tostring(sReason) end;
  -- Make sure text doesn't go off the screen
  local sFullReason<const> = sReason;
  -- Parse lines in stack string
  local aLines<const> = UtilExplode(sReason, "\n");
  -- Prune locals (keeping them in the full reason)
  for iIndex = #aLines, 1, -1 do
    if aLines[iIndex]:sub(1, 2) == "--" then remove(aLines, iIndex) end;
  end
  -- Prune too many lines
  if #aLines > 15 then
    while #aLines > 15 do remove(aLines) end;
    aLines[1 + #aLines] = "...more";
  end
  -- Build short reason
  sReason = UtilImplode(aLines, "\n");
  -- Log the message
  CoreLogEx(sFullReason, 1);
  -- Add generic info to the message
  local sMessage<const> =
    "ERROR!\n\n\z
     \rcffffff00The program has halted due to an unexpected problem.\rr\n\n\z
     Reason:-\n\n\z
     \rcffffff00"..sReason.."\rr\n\n\z
     C:Continue  R:Restart  A:Abort  P:Clipboard  F:Fail";
  -- Get key states
  local iRelease<const> = Input.States.RELEASE;
  -- Keys used in tick function
  local oKeys<const> = Input.KeyCodes;
  local iKeyC<const>, iKeyR<const>, iKeyA<const>, iKeyP<const>, iKeyF<const> =
    oKeys.C, oKeys.R, oKeys.A, oKeys.P, oKeys.F;
  -- Disable key handlers
  DisableKeyHandlers();
  -- Input event callback
  local function OnKey(iKey, iState)
    -- Ignore if not releasing a key
    if iState ~= iRelease then return end;
    -- Continue key pressed?
    if iKey == iKeyC then
      -- Hide cursor
      InputSetCursor(false);
      -- Restore key handlers if available
      RestoreKeyHandlers();
      -- Restore tick function
      CoreOnTick(MainProcFunc);
    -- Restart key pressed?
    elseif iKey == iKeyR then CoreReset();
    -- Abort key pressed?
    elseif iKey == iKeyA then CoreQuit();
    -- Clipboard key pressed?
    elseif iKey == iKeyP then ClipSet("C", sFullReason, UtilBlank);
    -- Fail key pressed?
    elseif iKey == iKeyF then CoreEnd() end;
  end
  -- Override current input funciton
  InputOnKey(OnKey);
  -- Second change bool
  local nNext = 0;
  -- Text position and width
  local iTextLeft<const> = iStageLeftO + 8;
  local iTextTop<const> = iStageTopO + 8;
  local iTextRight<const> = iStageRightO - 8;
  -- Callback function
  local function OnTick()
    -- Set clear colour depending on time
    local nTime<const>, nRed = CoreTime();
    nRed = cos(nTime) * sin(nTime) + 0.5;
    -- Show error message
    fboMain:SetClearColour(nRed, 0.0, 0.0, 1.0);
    fFont:SetCRGBA(1.0, 1.0, 1.0, 1.0);
    fFont:SetSize(1.0);
    fFont:PrintW(iTextLeft, iTextTop, iTextRight, 0, sMessage);
    -- Draw frame if we changed the background colour
    if nTime >= nNext then FboDraw() nNext = nTime + 0.032 end;
  end
  -- Set loop function
  CoreOnTick(OnTick);
end
-- ------------------------------------------------------------------------- --
local function TimeIt(sName, fcbCallback, ...)
  -- Check parameters
  if not UtilIsString(sName) then
    error("Name string is invalid! "..tostring(sName)) end;
  if not UtilIsFunction(fcbCallback) then
    error("Function is invalid! "..tostring(fcbCallback)) end;
  -- Save time
  local nTime<const> = CoreTime();
  -- Execute function
  fcbCallback(...);
  -- Put result in console
  CoreLog("Procedure '"..sName.."' completed in "..
    UtilDuration(CoreTime() - nTime, 3).." sec!");
end
-- Generic function to return a handle ------------------------------------- --
local function NoSecondStage(hH) return hH end;
-- Asset types supported --------------------------------------------------- --
local aTypes<const> = {
  -- Async function   Params  Prefix  Suffix  Data loader function  Info?   Id
  { Image.FileAsync,  {iPNG}, "tex/", ".png", Texture.CreateTS, false,   --  1
    { 1, 2, 3, 4 } },
  { Image.FileAsync,  {iPNG}, "tex/", ".png", TextureCreate,    false }, --  2
  { Image.FileAsync,  {iPNG}, "tex/", ".png", Font.Image,       false,   --  3
    { 1, 2, 3, 4, 9 } },
  { Pcm.FileAsync,    {iOGG}, "sfx/", ".ogg", Sample.Create,    false }, --  4
  { Asset.FileAsync,  {0},    "",     "",     NoSecondStage,    false }, --  5
  { Image.FileAsync,  {0},    "tex/", ".png", Mask.Create,      false }, --  6
  { Stream.FileAsync, {},     "mus/", ".ogg", NoSecondStage,    false }, --  7
  { Video.FileAsync,  {},     "fmv/", ".ogv", NoSecondStage,    false }, --  8
  { Asset.FileAsync,  {0},    "src/", ".lua", ParseScript,      true  }, --  9
  { Image.FileAsync,  {iPNG}, "tex/", ".png", Texture.ImageUT,  false,   -- 10
    { 2 } },
  { Json.FileAsync,   {},     "",    ".json", Json.ToTable,     false }, -- 11
  -- Async function   Params  Prefix Suffix  Data loader function  Info?    Id
};
-- Loader ------------------------------------------------------------------ --
local function LoadResources(sProcedure, aResources, fComplete, ...)
  -- Check parameters
  if not UtilIsString(sProcedure) then
    error("Procedure name string is invalid! "..tostring(sProcedure)) end;
  if not UtilIsTable(aResources) then
    error("Resources table is invalid! "..tostring(aResources)) end;
  if #aResources == 0 then error("No resources specified to load!") end;
  if not UtilIsFunction(fComplete) then
    error("Finished callback is invalid! "..tostring(fComplete)) end;
  -- Initialise queue
  local sDst, aInfo, oNCache, iTotal, iLoaded =
    "", { }, create(0, #aResources), nil, nil;
  -- Progress update on asynchronous loading
  local function ProgressUpdate(iCmd, ...)
    if iCmd == iFStart then aInfo = { ... } end;
  end
  -- Output handles
  local aOutputHandles<const> = create(#aResources);
  -- Grab extra parameters to send to callback
  local aParams<const> = { ... };
  -- Load item
  local function LoadItem(iI)
    -- Get resource data
    local oResource<const> = aResources[iI];
    if not UtilIsTable(oResource) then
      error("Supplied table at index "..iI.." is invalid!") end;
    -- Get type of resource and throw error if the type is invalid
    local iType<const> = oResource.T;
    local aTypeData<const> = aTypes[iType];
    if not UtilIsTable(aTypeData) then
      error("Supplied load type of '"..tostring(iType)..
        "' is invalid at index "..iI.."!") end;
    -- Get destination file to load and check it
    sDst = aTypeData[3]..oResource.F..aTypeData[4];
    if #sDst == 0 then error("Filename at index "..iI.." is empty!") end;
    -- Build parameters table to send to function
    local aSrcParams<const> = aTypeData[2];
    local aDstParams<const> = { sDst,                 -- [1]
                                unpack(aSrcParams) }; -- [2]
    aDstParams[1 + #aDstParams] = SetErrorMessage;    -- [3]
    aDstParams[1 + #aDstParams] = ProgressUpdate;     -- [4]
    -- Say in log that we are loading
    CoreLog("Loading resource "..iI.."/"..iTotal.." of type "..iType..": '"..
      sDst.."'...");
    -- Get no-cache setting
    local bNoCache<const> = oResource.NC;
    -- When final handle has been acquired
    local function OnHandle(vHandle, bCached)
      -- Set handle for final callback
      aOutputHandles[iI] = vHandle;
      -- Cache the handle unless requested not to
      if not bNoCache then oNCache[sDst] = vHandle end;
      -- Set stage 2 duration and total duration
      oResource.ST2 = CoreTime() - oResource.ST2;
      oResource.ST3 = oResource.ST1 + oResource.ST2;
      -- Loaded counter increment
      iLoaded = iLoaded + 1;
      -- No need to show intermediate load times if cached
      if bCached then bCached = ".";
      -- Wasn't cached?
      else
        -- Calculate times for log
        bCached = " ("..UtilDuration(oResource.ST1, 3).."+"..
                        UtilDuration(oResource.ST2, 3);
        -- Add no cache flag and finish string
        if bNoCache then bCached = bCached.."/NC).";
                    else bCached = bCached..")." end;
      end
      -- Say in log that we loaded
      CoreLog("Loaded resource "..iLoaded.."/"..iTotal..": '"..
        sDst.."' in "..UtilDuration(oResource.ST3, 3).." sec"..bCached);
      -- Load the next item if not completed yet
      if iLoaded < iTotal then return LoadItem(iI + 1) end;
      -- Set new cache
      oCache = oNCache;
      -- Enable global keys
      SetKeys(true);
      -- Clear tip
      SetTip();
      -- Garbage collect to remove unloaded assets
      collectgarbage();
      -- Execute finished handler function with our resource list
      TimeIt(sProcedure, fComplete, aOutputHandles, unpack(aParams));
    end
    -- Setup handle
    local function SetupSecondStage()
      -- Get current time
      local nTime<const> = CoreTime();
      -- Set stage 1 duration and stage 2 start time
      oResource.ST1 = nTime - oResource.ST1;
      oResource.ST2 = nTime;
      -- File information required?
      local vInfoRequired<const> = aTypeData[6];
      -- Get final call parameters and if not specified?
      local aParams = oResource.P;
      if aParams == nil then
        -- Create preallocated parameters table if required
        local iParamsSize;
        if vInfoRequired then iParamsSize = #aInfo else iParamsSize = 0 end;
        aParams = create(iParamsSize);
        oResource.P = aParams;
      -- Check that user specified parameters are valid
      elseif not UtilIsTable(aParams) then
        error("Invalid params "..tostring(aParams).." at index "..iI.."!") end;
      -- File information required? Add all the parameters
      if vInfoRequired then
        for iI = 1, #aInfo do aParams[1 + #aParams] = aInfo[iI] end;
      end
    end
    -- When first handle has been loaded
    local function OnLoaded(vData)
      -- Setup second stage
      SetupSecondStage();
      -- Load the file and set the handle
      OnHandle(aTypeData[5](vData, unpack(oResource.P)));
    end
    aDstParams[1 + #aDstParams] = OnLoaded;
    -- Set stage 1 time
    oResource.ST1 = CoreTime();
    -- Reset parameters for progress update
    UtilFlushArray(aInfo);
    -- Send cached handle if it exists
    local vCached<const> = oCache[sDst];
    if vCached then
      -- Setup second stage
      SetupSecondStage();
      -- Send straight to handle
      OnHandle(vCached, true);
    -- Dispatch the call
    else aTypeData[1](unpack(aDstParams)) end;
  end
  -- Disable global keys until everything has loaded
  SetKeys(false);
  -- Disable hotspots
  SetHotSpot();
  -- Initialise counters
  iTotal, iLoaded = #aResources, 0;
  -- Clear callbacks but keep the last render callback
  SetCallbacks(nil, CBRender);
  -- Set tip to loading incase players computer is slow. May show, may not.
  SetTip("LOADING...");
  -- Load first item
  LoadItem(1);
  -- Progress function
  local function GetProgress() return iLoaded/iTotal, sDst end
  -- Return progress function
  return GetProgress;
end
-- Refresh viewport info --------------------------------------------------- --
local function RefreshViewportInfo()
  -- Refresh matrix parameters
  iStageWidth, iStageHeight,
    iStageLeftO, iStageTopO, iStageRightO, iStageBottom = fboMain:GetMatrix();
  iOrthoWidth, iOrthoHeight = FboMatrix();
  -- Floor all the values as the main frame buffer object is always on the
  -- pixel boundary
  iStageWidth, iStageHeight, iStageLeft, iStageTop, iStageRight, iStageBottom,
    iOrthoWidth, iOrthoHeight =
      floor(iStageWidth) // iTexScale, floor(iStageHeight) // iTexScale,
      floor(iStageLeftO) // iTexScale, floor(iStageTopO) // iTexScale,
      floor(iStageRightO) // iTexScale, floor(iStageBottom) // iTexScale,
      floor(iOrthoWidth) // iTexScale, floor(iOrthoHeight) // iTexScale;
  -- Call frame buffer callbacks
  for _, fcbC in pairs(oFbuCbs) do
    -- Protected call so we can handle errors
    local bResult<const>, sReason<const> = xpcall(fcbC, CoreStack,
      iStageWidth, iStageHeight, iStageLeft, iStageTop, iStageRight,
      iStageBottom, iOrthoWidth, iOrthoHeight);
    if not bResult then SetErrorMessage(sReason) end;
  end
end
-- Register a callback and automatically when window size changes ---------- --
local function RegisterFrameBufferUpdateCallback(sName, fCB)
  -- Check parameters
  if not UtilIsString(sName) then
    error("Invalid callback name string! "..tostring(sName)) end;
  if nil ~= fCB and not UtilIsFunction(fCB) then
    error("Invalid callback function! "..tostring(fCB)) end;
  -- Register callback when frame buffer is updated
  oFbuCbs[sName] = fCB;
  -- If a callback was set then call it
  if nil ~= fCB then
    fCB(iStageWidth, iStageHeight, iStageLeft, iStageTop, iStageRight,
      iStageBottom, iOrthoWidth, iOrthoHeight) end;
end
-- Returns wether test mode is enabled ------------------------------------- --
local function GetTestMode() return bTestMode end;
-- Load the texture scale value -------------------------------------------- --
local function LoadTextureScale(oAssetsData)
  -- Customised texture scale file exists?
  local sScaleFile<const> = "tex/scale.txt";
  if not Asset.FileExists(sScaleFile) then iTexScale = 1 return end;
  -- Load the texture scale number from file and make sure it is valid
  local nTexScale<const> = tonumber(Asset.File(sScaleFile, 0):ToString());
  if not nTexScale then error("Erroneous texture scale '"..
    tostring(nTexScale).."' in '"..sScaleFile.."'!") end;
  if not UtilIsInteger(nTexScale) then error("Texture scale '"..
    nTexScale.."' must be integral in '"..sScaleFile.."'!") end;
  if nTexScale < 1 or nTexScale > 16 then
    error("Scale '"..nTexScale.."' out of range in '"..sScaleFile.."'!") end;
  -- Set new accepted scale
  iTexScale = nTexScale;
  -- Get maximum texture size and make sure guest's GPU supports it. 1024^2
  -- is the maximum size texture we use at 1X scale.
  local iMaxUsedTexSize<const> = 1024;
  local iMaxSize<const> = Texture.MaxSize();
  if iTexScale * iMaxUsedTexSize > iMaxSize then
    local _<const>, _<const>, sDisplay<const> = Display.GPU();
    error("Fatal error! The installed "..iTexScale.."X scale texture pack \z
           is not supported on this rendering device ("..sDisplay..") as \z
           it will only support a maximum scale of "..
           (iMaxSize//iMaxUsedTexSize).."X ("..iMaxSize.."^2).");
  end
  -- Now we have to scale all relavant co-ordinates so for each asset
  for sIdentifier, oAssetData in pairs(oAssetsData) do
    -- Get type and if not valid show an error
    local iType<const> = oAssetData.T;
    if not UtilIsInteger(iType) then
      error("Invalid type '"..tostring(iType).."' in "..
        sIdentifier.."!") end;
    -- Get type data and if not valid then show an error
    local aTypeItem<const> = aTypes[iType];
    if not UtilIsTable(aTypeItem) then
      error("Invalid type data '"..tostring(aTypeItem).."' in "..
        sIdentifier.."!") end;
    -- Check that we have parameters to modify and if we do?
    local aParamsToModify<const> = aTypeItem[7];
    if UtilIsTable(aParamsToModify) then
      -- Get and check function parameters
      local aFuncParams<const> = oAssetData.P;
      if not UtilIsTable(aFuncParams) then
        error("Invalid func params data '"..tostring(aFuncParams)..
          "' in data for type "..iType.." in "..sIdentifier.."!") end;
      -- Walk through the parameters to modify
      for iPMIndex = 1, #aParamsToModify do
        -- Get and check the function param
        local iFPIndex<const> = aParamsToModify[iPMIndex];
        local vParam<const> = aFuncParams[iFPIndex];
        if UtilIsTable(vParam) then
          -- Scale all its values
          for iPAIndex = 1, #vParam do
            -- Get current value and make sure it is valid
            local iValue<const> = vParam[iPAIndex];
            if UtilIsInteger(iValue) then
              vParam[iPAIndex] = iValue * iTexScale;
            -- Invalid value type
            else error("Invalid array param type '"..tostring(iValue)..
              "' at '"..iPAIndex..":"..iFPIndex"' for type "..iType..
              " in "..sIdentifier.."!") end;
          end
        -- Scale just the integer
        elseif UtilIsInteger(vParam) then
          aFuncParams[iFPIndex] = vParam * iTexScale;
        -- Unknown format. This is an error
        else error("Invalid param type '"..tostring(vParam).."' at '"..
          iFPIndex"' for type "..iType.." in "..sIdentifier.."!") end;
      end
    -- Invalid parameters to modify data if not nil
    elseif aParamsToModify ~= nil then
      error("Invalid type param data '"..tostring(aParamsToModify)..
        "' for type "..iType.." in "..sIdentifier.."!") end;
  end
  -- Resize frame buffer if texture scale different
  local oVariables<const> = Variable.Internal;
  Fbo.Resize(oVariables.vid_orwidth:Get() * iTexScale,
             oVariables.vid_orheight:Get() * iTexScale);
end
-- Main procedure callback ------------------------------------------------- --
local function MainCallback()
  -- Poll joysticks (input.lua)
  JoystickProc();
  -- Execute logic tick
  CBProc();
  -- Render the scene
  CBRender();
  -- Render the cursor (input.lua)
  CursorRender();
  -- Draw screen at end of engine tick
  FboDraw();
end
-- The first tick function ------------------------------------------------- --
local function fcbTick()
  -- Load base assets data
  local aScriptTypeData<const> = aTypes[9];
  local oAssetsData, aBaseAssets, iBaseScripts, iBaseFonts, iBaseTextures,
    iBaseMasks, iBaseSounds, aBaseSounds;
  oAssetsData, aBaseAssets, iBaseScripts, iBaseFonts, iBaseTextures,
    iBaseMasks, iBaseSounds, aBaseSounds =
      Asset.Parse(aScriptTypeData[3].."asset"..aScriptTypeData[4], 9);
  -- Load texture scale
  LoadTextureScale(oAssetsData);
  -- Refresh viewport info and automatically when window size changes
  Fbo.OnRedraw(RefreshViewportInfo);
  RefreshViewportInfo();
  -- Empty CVar callback event function
  local function fcbEmpty() return true end;
  -- Initialise base API functions
  ParseScriptResult("main", { F=UtilBlank, A={ GetCallbacks = GetCallbacks,
    GetTestMode = GetTestMode, LoadResources = LoadResources,
    RefreshViewportInfo = RefreshViewportInfo,
    RegisterFBUCallback = RegisterFrameBufferUpdateCallback,
    SetCallbacks = SetCallbacks, SetErrorMessage = SetErrorMessage,
    TimeIt = TimeIt, fcbEmpty = fcbEmpty } });
  -- Store texture scale and assets data
  oAPI.iTexScale = iTexScale;
  oAPI.oAssetsData = oAssetsData;
  -- When base assets have loaded
  local function OnLoaded(aResources)
    -- Set font handles
    oAPI.fontLarge, oAPI.fontLittle, oAPI.fontTiny, oAPI.fontSpeech =
      aResources[iBaseFonts], aResources[iBaseFonts + 1],
      aResources[iBaseFonts + 2], aResources[iBaseFonts + 3];
    -- Set sprites texture
    oAPI.texSpr = aResources[iBaseTextures];
    -- Set and check masks
    oAPI.maskLevel, oAPI.maskSprites =
      aResources[iBaseMasks], aResources[iBaseMasks + 1];
    -- Function to grab an API function. This function will be sent to all
    -- the above loaded modules.
    local function GetAPI(...)
      -- Get functions and if there is only one then return it
      local aFuncs<const> = { ... }
      if #aFuncs == 0 then error("No functions specified to check") end;
      -- Functions already added
      local oAdded<const> = create(0, #aFuncs);
      -- Find each function specified and return all of them
      local aRets<const> = create(#aFuncs);
      for iI = 1, #aFuncs do
        -- Check parameter
        local sMember<const> = aFuncs[iI];
        if not UtilIsString(sMember) then
          error("Function name at "..iI.." is invalid") end;
        -- Check if we already cached this member and if already have it?
        local iCached<const> = oAdded[sMember];
        if iCached ~= nil then
          -- Print an error so we can remove duplicates
          error("Member '"..sMember.."' at parameter "..iI..
            " already requested at parameter "..iCached.."!");
        end
        -- Get the function callback and if it's a function?
        local vMember<const> = oAPI[sMember];
        if vMember == nil then
          error("Invalid member '"..sMember.."'! "..tostring(vMember));
        end
        -- Cache function so we can track duplicated
        oAdded[sMember] = iI;
        -- Add it to returns
        aRets[1 + #aRets] = vMember;
      end
      -- Unpack returns table and return all the functions requested
      return unpack(aRets);
    end
    -- Register file data CVar
    local oCVF<const> = Variable.Flags;
    -- Default CVar flags for boolean storage
    local iCFB<const> = oCVF.BOOLEANSAVE;
    -- ...and a CVar that lets us show setup for the first time
    oAPI.cvSetup = VariableRegister("gam_setup", 1, iCFB, fcbEmpty);
    -- ...and a CVar that lets us skip the intro
    oAPI.cvIntro = VariableRegister("gam_intro", 1, iCFB, fcbEmpty);
    -- ...and a CVar that lets us start straight into a level
    oAPI.cvTest = VariableRegister("gam_test", "", oCVF.STRING, fcbEmpty);
    -- ...and a CVar to force a different language
    oAPI.cvLang = VariableRegister("gam_lang", "", oCVF.STRINGSAVE, fcbEmpty);
    -- Ask modules to grab needed functions from the API (first chance)
    for iI = 1, #aMods do
      local oModData<const> = aMods[iI];
      local fcbFunc<const> = oModData.I;
      if fcbFunc then PutAPI(oModData.N, fcbFunc(GetAPI)) end;
    end
    -- Assign loaded sound effects (audio.lua)
    GetAPI("RegisterSounds")(aResources, iBaseSounds, #aBaseSounds);
    -- Ask modules to grab needed functions from the API (last chance)
    for iI = 1, #aMods do
      local oModData<const> = aMods[iI];
      local fcbFunc<const> = oModData.F;
      if fcbFunc then fcbFunc(GetAPI, oModData, oAPI) end;
    end
    -- Some library functions and variables only for this scope
    local InitBook, InitCon, InitCredits, InitTitleCredits, InitDebugPlay,
      InitEditor, InitEnding, InitFail, InitFile, InitIntro, InitMap,
      InitNewGame, InitPixels, InitRace, InitScene, InitScore, InitTitle,
      LoadLevel, aLevelsData, oObjectTypes, aRacesData;
    -- Load dependecies we need on this module
    CursorRender, DisableKeyHandlers, InitBook, InitCon, InitCredits,
      InitDebugPlay, InitEditor, InitEnding, InitFail, InitFile, InitIntro,
      InitMap, InitNewGame, InitPixels, InitRace, InitScene, InitScore,
      InitTitle, InitTitleCredits, JoystickProc, LoadLevel, RestoreKeyHandlers,
      SetHotSpot, SetKeys, SetTip, aLevelsData, oObjectTypes, aRacesData =
        GetAPI("CursorRender", "DisableKeyHandlers", "InitBook", "InitCon",
          "InitCredits", "InitDebugPlay", "InitEditor", "InitEnding",
          "InitFail", "InitFile", "InitIntro", "InitMap", "InitNewGame",
          "InitPixels", "InitRace", "InitScene", "InitScore", "InitTitle",
          "InitTitleCredits", "JoystickProc", "LoadLevel",
          "RestoreKeyHandlers", "SetHotSpot", "SetKeys", "SetTip",
          "aLevelsData", "oObjectTypes", "aRacesData");
    -- Set main callback
    fcbTick = MainCallback;
    -- Init game counters so testing stuff quickly works properly
    InitNewGame();
    -- Hide the cursor
    InputSetCursor(false);
    -- Test mode requested?
    local sTestValue<const> = oAPI.cvTest:Get();
    if #sTestValue > 0 then
      -- Test mode enabled
      bTestMode = true;
      -- Get start level
      local iStartLevel<const> = tonumber(sTestValue) or 0;
      -- Test random level? (game.lua)
      if iStartLevel == 0 then LoadLevel(random(#aLevelsData), "game", -1);
      -- Test a specific level (game.lua)
      elseif iStartLevel >= 1 and iStartLevel <= #aLevelsData then
        LoadLevel(iStartLevel, "game", -1);
      -- Test a specific level with starting scene (scene.lua)
      elseif iStartLevel > #aLevelsData and iStartLevel <= #aLevelsData*2 then
        InitScene(iStartLevel - #aLevelsData, "game");
      -- Testing infinite play mode? (debug.lua)
      elseif iStartLevel == -1 then InitDebugPlay();
      -- Testing the level editor (editor.lua)
      elseif iStartLevel == -2 then InitEditor();
      -- Testing the fail screen (fail.lua)
      elseif iStartLevel == -3 then InitFail();
      -- Testing the game over (score.lua)
      elseif iStartLevel == -4 then InitScore();
      -- Testing the final credits (ending.lua)
      elseif iStartLevel == -5 then InitCredits(false);
      -- Testing the final rolling credits (ending.lua)
      elseif iStartLevel == -6 then InitCredits(true);
      -- Testing the title screen rolling credits (tcredits.lua)
      elseif iStartLevel == -7 then InitTitleCredits();
      -- Testing the controller screen (cntrl.lua)
      elseif iStartLevel == -8 then InitCon();
      -- Testing the book screen (book.lua)
      elseif iStartLevel == -9 then InitBook();
      -- Testing the race screen (race.lua)
      elseif iStartLevel == -10 then InitRace();
      -- Testing the map screen (map.lua)
      elseif iStartLevel == -11 then InitMap();
      -- Testing the file select screen (file.lua)
      elseif iStartLevel == -12 then InitFile();
      -- Testing pixels
      elseif iStartLevel == -13 then InitPixels(oAPI.texSpr);
      -- Testing a races ending (ending.lua)
      elseif iStartLevel > -18 and iStartLevel <= -14 then
        InitEnding(#aRacesData + (-18 - iStartLevel));
      -- Reserved for testing win and map post mortem (game/post.lua)
      elseif iStartLevel <= -18 and iStartLevel > -18 - #aLevelsData then
        LoadLevel(-iStartLevel-17, "game", -1, nil, nil, nil, nil, nil, nil,
          nil, nil, 17550);
      -- Invalid test code so skip the below return
      else goto invalid end;
      -- Valid test code
      do return end;
      -- Invalid test mode label
      ::invalid::
    end
    -- If being run for first time
    if 0 == tonumber(oAPI.cvSetup:Get()) then
      -- Skip intro? Initialise title screen
      if 0 == tonumber(oAPI.cvIntro:Get()) then return InitTitle() end;
      -- Initialise intro with setup dialog
      return InitIntro(false);
    end
    -- Initialise setup screen by default
    InitIntro(true);
    -- No longer show setup screen
    oAPI.cvSetup:Boolean(false);
  end
  -- Start loading assets
  local fcbProgress<const> = LoadResources("Core", aBaseAssets, OnLoaded);
  -- Get console font and do positional calculations
  local fSolid<const> = TextureCreate(Image.Colour(0xFFFFFFFF), 0);
  local nWidth<const>, nHeight<const>, nBorder<const> =
    (300.0 * iTexScale), (2.0 * iTexScale), (1.0 * iTexScale);
  local nX<const> = (160.0 * iTexScale) - (nWidth / 2.0) - nBorder;
  local nY<const> = (120.0 * iTexScale) - (nHeight / 2.0) - nBorder;
  local nBorderX2<const> = nBorder * 2.0;
  local nXPlus1<const>, nYPlus1<const> = nX + nBorder, nY + nBorder;
  local nXBack<const> = nX + nWidth + nBorderX2
  local nYBack<const> = nY + nHeight + nBorderX2;
  local nXBack2<const> = nX + nWidth + nBorder;
  local nYBack2<const> = nY + nHeight + (nBorderX2 - nBorder);
  local nXText<const> = nX + nWidth + nBorderX2;
  local nYText<const> = nY - (3.0 * iTexScale);
  -- Last percentage
  local nLastPercentage = -1.0;
  -- Loader display function
  local function LoaderProc()
    -- Get current progress and return if progress hasn't changed
    local nPercent<const>, sFile<const> = fcbProgress();
    if nPercent == nLastPercentage then return end;
    nLastPercentage = nPercent;
    -- Draw progress bar
    fSolid:SetCRGBA(1.0, 0.0, 0.0, 1.0); -- Border
    fSolid:BlitLTRB(nX, nY, nXBack, nYBack);
    fSolid:SetCRGBA(0.25, 0.0, 0.0, 1.0); -- Backdrop
    fSolid:BlitLTRB(nXPlus1, nYPlus1, nXBack2, nYBack2);
    fSolid:SetCRGBA(1.0, 1.0, 1.0, 1.0); -- Progress
    fSolid:BlitLTRB(nXPlus1, nYPlus1, nXPlus1+(nPercent*nWidth), nYBack2);
    fFont:SetSize(iTexScale);
    fFont:SetCRGBA(1.0, 1.0, 1.0, 1.0); -- Filename & percentage
    fFont:PrintU(nX, nYText, sFile);
    fFont:PrintUR(nXText, nYText, format("%.f%% Completed", nPercent * 100));
    -- Catchup accumulator (we don't care about it);
    CoreCatchup();
    -- Draw screen at end of LUA tick
    FboDraw();
  end
  -- Set new tick function
  fcbTick = LoaderProc;
end
-- Main callback with smart error handling --------------------------------- --
local function MainProc()
  -- Protected call so we can handle errors
  local bResult<const>, sReason<const> = xpcall(fcbTick, CoreStack);
  if not bResult then SetErrorMessage(sReason) end;
end
-- Backup function for error handler --------------------------------------- --
MainProcFunc = MainProc;
-- This will be the main entry procedure ----------------------------------- --
CoreOnTick(MainProc);
-- End-of-File ============================================================= --
