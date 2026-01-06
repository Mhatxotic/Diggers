-- SETUP.LUA =============================================================== --
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
local cos<const>, floor<const>, format<const>, ipairs<const>, len<const>,
  maxinteger<const>, max<const>, min<const>, pairs<const>, remove<const>,
  rep<const>, sin<const>, sort<const>, tonumber<const>, tostring<const>,
  create<const> =
    math.cos, math.floor, string.format, ipairs, utf8.len, math.maxinteger,
    math.max, math.min, pairs, table.remove, string.rep, math.sin, table.sort,
    tonumber, tostring, table.create;
-- Engine function aliases ------------------------------------------------- --
local AudioGetNumPBDs<const>, AudioGetPBDName<const>, AudioReset<const>,
  CoreCPUUsage<const>, CoreEngine<const>, CoreLibrary<const>,
  CoreLicense<const>, CoreRAM<const>, CoreTime<const>, DisplayFSType<const>,
  DisplayGetSize<const>, DisplayGPUFPS<const>, DisplayMonitor<const>,
  DisplayMonitorData<const>, DisplayMonitors<const>, DisplayReset<const>,
  DisplayVidModeData<const>, DisplayVidModes<const>, DisplayVReset<const>,
  InputGetKeyName<const>, InputOnKey<const>, UtilClamp<const>,
  UtilClampInt<const>, UtilExplode<const>, UtilGetRatio<const>,
  UtilWordWrap<const>, VariableRegister<const>, oCVars<const>,
  oMods<const>, iCredits<const>, iNativeMode<const> =
    Audio.GetNumPBDevices, Audio.GetPBDeviceName, Audio.Reset, Core.CPUUsage,
    Core.Engine, Core.Library, Core.License, Core.RAM, Core.Time,
    Display.FSType, Display.GetSize, Display.GPUFPS, Display.Monitor,
    Display.MonitorData, Display.Monitors, Display.Reset, Display.VidModeData,
    Display.VidModes, Display.VReset, Input.GetKeyName, Input.OnKey,
    Util.Clamp, Util.ClampInt, Util.Explode, Util.GetRatio, Util.WordWrap,
    Variable.Register, Variable.Internal, Input.KeyMods, Core.Libraries.MAX,
    Display.FSTypes.NATIVE;
-- Read and prepare engine version information ----------------------------- --
local sAppTitle, sAppVendor, iAppMajor<const>, iAppMinor<const>,
  iAppBuild<const>, iAppRevision<const>, _, _, sAppExeType = CoreEngine();
sAppTitle, sAppVendor, sAppExeType =
  sAppTitle:upper(), sAppVendor:upper(), sAppExeType:upper();
-- Read game version information ------------------------------------------- --
local sGameVersion<const>, sGameName<const>, sGameCopyr<const>,
      sGameDescription<const>, sGameWebsite<const>
      = -- ----------------------------------------------------------------- --
      oCVars.app_version:Get():upper(),
      oCVars.app_longname:Get():upper(),
      oCVars.app_copyright:Get():upper(),
      oCVars.app_description:Get():upper(),
      oCVars.app_website:Get():upper();
-- Other CVars used -------------------------------------------------------- --
local vVidvsync<const>, vAppdelay<const>, vTexfilter<const>, vAudvol<const>,
      vAudstrvol<const>, vAudsamvol<const>, vAudfmvvol<const>,
      vVidmonitor<const>, vWinposx<const>, vWinposy<const>, vWinwidth<const>,
      vWinheight<const>, vVidfs<const>, vVidfsmode<const>, vAudinterface<const>
      = -- ----------------------------------------------------------------- --
      oCVars.vid_vsync, oCVars.app_delay, oCVars.vid_texfilter, oCVars.aud_vol,
      oCVars.aud_strvol, oCVars.aud_samvol, oCVars.aud_fmvvol,
      oCVars.vid_monitor, oCVars.win_posx, oCVars.win_posy, oCVars.win_width,
      oCVars.win_height, oCVars.vid_fs, oCVars.vid_fsmode,
      oCVars.aud_interface;
-- Diggers function and data aliases --------------------------------------- --
local BlitSLTWHA, DisableKeyHandlers, GetCallbacks, GetHotSpot, GetKeyBank,
  GetMusic, InitSetup, IsMouseYLessThan, LoadResources, PlayMusic, PrintC,
  PrintM, PrintR, PrintS, Print, RegisterFBUCallback, RenderFade, RenderShadow,
  RestoreKeyHandlers, SetCallbacks, SetHotSpot, SetKeys, StopMusic, VideoPause,
  VideoResume, tKeyBankCats, oKeyToLiteral, aSetupButtonData, aSetupOptionData,
  fontLarge, fontLittle, fontTiny, texSpr;
-- Frame-limiter types ----------------------------------------------------- --
local aFrameLimiterLabels<const> = {
  "Adaptive VSync",                    -- VSync = -1; Delay = 0
  "None",                              -- VSync =  0; Delay = 0
  "VSync Only",                        -- VSync =  1; Delay = 0
  "Double VSync",                      -- VSync =  2; Delay = 0
  "Adaptive VSync & Suspend",          -- VSync = -1; Delay = 1
  "Suspend Only",                      -- VSync =  0; Delay = 1
  "VSync & Suspend",                   -- VSync =  1; Delay = 1
  "Double VSync & Suspend",            -- VSync =  2; Delay = 1
};
-- Window types ------------------------------------------------------------ --
local aWindowLabels<const> = {
  "Windowed Mode", "Borderless Full-screen Mode", "Exclusive Full-screen Mode",
  "Native Full-screen Mode"
};
-- Custom window size labels ----------------------------------------------- --
local aCustomLabels<const> = { "<Custom>", "<Auto>" };
-- Window sizes ------------------------------------------------------------ --
local aWindowSizes<const> = {          -- Keep to arbitrary aspect ratios
  {   0,   0}, --[[ Default (auto)  --]] { 320, 240}, --[[ ( 4:3 ) QVGA    --]]
  { 480, 360}, --[[ ( 4:3 ) Trivial --]] { 512, 384}, --[[ ( 4:3 ) 0.20M3  --]]
  { 640, 360}, --[[ (16:9 ) 0.23M9  --]] { 640, 400}, --[[ (16:10) 0.26M3  --]]
  { 640, 480}, --[[ ( 4:3 ) 0.29M4  --]] { 720, 540}, --[[ ( 4:3 ) Trivial --]]
  { 768, 480}, --[[ (16:10) WVGA    --]] { 800, 600}, --[[ ( 4:3 ) SVGA    --]]
  { 960, 540}, --[[ (16:9 ) qHD     --]] { 960, 720}, --[[ ( 4:3 ) 0.69M3  --]]
  {1024, 576}, --[[ (16:9 ) 0.59M9  --]] {1280, 720}, --[[ (16:9 ) WXGA    --]]
  {1280, 800}, --[[ (16:10) WXGA    --]] {1280, 960}, --[[ ( 4:3 ) SXGA-   --]]
  {1400, 900}, --[[ (16:9 ) WSXGA   --]] {1600,1200}, --[[ (16:9 ) HD+     --]]
  {1680,1050}, --[[ (16:10) WSXGA+  --]] {1920,1080}, --[[ (16:9 ) FHD     --]]
  {1920,1200}, --[[ (16:10) WUXGA   --]] {2048,1280}, --[[ (16:10) 2.62MA  --]]
  {2304,1440}, --[[ (16:10) 3.32MA  --]] {2560,1440}, --[[ (16:9 ) WQHD    --]]
  {2560,1600}  --[[ (16:10) WQXGA   --]]
};
-- Other ----------------------------------------------------------------------
local iOColour, aColours<const> = 1, { -- Colour transition animations
  0xFFF0F0F0,0xFFE0E0E0,0xFFD0D0D0,0xFFC0C0C0,0xFFB0B0B0,0xFFA0A0A0,0xFF909090,
  0xFF808080,0xFF707070,0xFF606060,0xFF505050,0xFF404040,0xFF303030,0xFF202020,
  0xFF101010,0xFF202020,0xFF303030,0xFF404040,0xFF505050,0xFF606060,0xFF707070,
  0xFF808080,0xFF909090,0xFFA0A0A0,0xFFB0B0B0,0xFFC0C0C0,0xFFD0D0D0,0xFFE0E0E0
};
-- Main locals ------------------------------------------------------------- --
local aAssets,                         -- Required assets
      fcbRender, fcbLogic,             -- Current input/render/logic funcs
      iLastHotSpot,                    -- Hotspot before entering setup
      iLastKeyBank,                    -- Keybank before entering setup
      musLast,                         -- Music handle before entering setup
      nButtonIntensity,                -- Current button intensity
      nButtonIntensityIncrement,       -- Current button intensity increment
      nCPUUsageProcess,                -- Current process CPU usage
      nCPUUsageSystem,                 -- Current system CPU usage
      nGPUFramesPerSecond,             -- Current graphical frames per second
      nRAMUsePercentage,               -- Current ram usage percentage
      nStageB, nStageH, nStageL,       -- Bottom, height, left stage bounds
      nStageR, nStageT, nStageW,       -- Right, top and width stage bounds
      nStatusLinePos,                  -- Marquee text tip position
      nStatusLineSize,                 -- Marquee text tip width
      nTime,                           -- Current execution time
      iTipId,                          -- Current tip id
      sStatusLine1, sStatusLine2,      -- Current status title and subtitle
      sStatusLineSave,                 -- Saved status title
      sTitle;                          -- Current main title
-- Readme configuration ---------------------------------------------------- --
local iReadmeRows<const> = 28;         -- Maximum readme on-screen rows
local iReadmeCols<const> = 77;         -- Maximum readme on-screen columns
local nReadmeSpacing<const> = 6.0;     -- Spacing between each line
local nReadmePaddingX<const> = 8.0;    -- Starting X co-ordinate
local nReadmePaddingY<const> = 27.0;   -- Starting Y co-ordinate
local iReadmeColsM1<const> = iReadmeCols - 1; -- Readme columns minus one
-- Readme locals ----------------------------------------------------------- --
local aCreditLines = create(1616);     -- Actual readme data
local aRmClrData<const> = create(iReadmeRows); -- Readme colour data
local iHotSpotReadme,                  -- Readme hotspot id
      iKeyBankReadme,                  -- Readme keybank id
      aReadmeData,                     -- Readme data
      aReadmeVisibleLines;             -- Readme/binds lines data
local iReadmeIndexBegin = 1;           -- Current start line
local iReadmeIndexEnd = 1;             -- Ending line
-- Configuration locals ---------------------------------------------------- --
local iAudioDeviceId,                  -- Current audio device id
      iAudioDeviceIdOriginal,          -- Original audio device id
      iFullScreenMode,                 -- Current full-screen mode number
      iFullScreenModeOriginal,         -- Original full-screen mode number
      iFullScreenState,                -- Current full-screen state
      iFullScreenStateOriginal,        -- Original full-screen state
      iHotSpotSetup,                   -- Setup hotspots
      iKeyBankSetup,                   -- Key bank id for configuration screen
      iMonitorId,                      -- Current monitor id
      iMonitorIdOriginal,              -- Original monitor id
      iSelectedButton,                 -- Currently selected button
      iSelectedOption,                 -- Currently selected option
      iWindowId,                       -- Current window size id
      iWindowIdOriginal;               -- Original window size id
-- Binding locals ---------------------------------------------------------- --
local aBindsList<const> = create(136); -- All of the formatted keybind data
local iBindsIndexBegin = 1;            -- Current starting keybinds position
local iBindsIndexEnd = 1;              -- Current ending keybinds position
local iHotSpotBind;                    -- Bind hotspots
local iKeyBankBind;                    -- Key bank id for key binds screen
-- ------------------------------------------------------------------------- --
local function GetMonitorIdOrPrimary()
  -- If the monitor id is set to the primary monitor then we need to return
  -- the actual id of the primary monitor instead
  if iMonitorId == -1 then return DisplayMonitor() end;
  -- Return selected monitor id
  return iMonitorId;
end
-- ------------------------------------------------------------------------- --
local function ColouriseText(sText)
  -- Set next colour to start on
  local iColour, sOutText = iOColour, "";
  -- For each letter in the title
  for iIndex = 1, #sText do
    -- Apply colour to the letter
    sOutText = sOutText..format("\rc%08x",
      aColours[1 + (iColour % #aColours)])..
      sText:sub(iIndex, iIndex);
    -- Next colour
    iColour = iColour - 1;
  end
  -- Set colour for next time
  iOColour = (iOColour + 1) % #aColours;
  -- Return result
  return sOutText;
end
-- ------------------------------------------------------------------------- --
local function FlickerColour1()
  fontLarge:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  fontTiny:SetCRGBA(0.75, 0.75, 0.5, 1.0);
end
-- ------------------------------------------------------------------------- --
local function FlickerColour2()
  fontLarge:SetCRGBA(0.75, 0.75, 0.75, 1.0);
  fontTiny:SetCRGBA(1.0, 1.0, 0.75, 1.0);
end
-- ------------------------------------------------------------------------- --
local function FlickerColours(cbCol1, cbCol2)
  if nTime % 0.43 < 0.215 then cbCol1() else cbCol2() end;
end
-- ------------------------------------------------------------------------- --
local function RenderBackgroundStart(nId)
  -- Render game background
  fcbRender();
  -- Draw background animation
  local nStageLP6<const> = nStageL + 6.0;
  local nTimeM2<const> = nTime * 2.0;
  texSpr:SetCRGB(0.0, 0.0, 0.0);
  for nY = nStageT + 6.0, nStageB, 16.0 do
    local nTimeM2SX<const> = nTimeM2 - nY;
    for nX = nStageLP6, nStageR, 16.0 do
      local nAngle = nTimeM2SX - nX;
      nAngle = 0.5 + ((cos(nAngle) * sin(nAngle)));
      texSpr:SetCA(nAngle * 0.75);
      local nDim<const> = nAngle * 16;
      BlitSLTWHA(texSpr, 444, nX, nY, nDim, nDim, nAngle);
    end
  end
  -- Draw background for text
  texSpr:SetCRGB(0.2, 0.1, 0.1);
  RenderFade(0.75, 4.0, 28.0, 316.0, 212.0, 1022);
  -- Draw title and status fades
  texSpr:SetCRGB(0.4, 0.2, 0.2);
  RenderFade(0.75, 4.0, 212.0, 316.0, 236.0, 1022);
  RenderFade(0.75, 4.0, 4.0, 316.0, 28.0, 1022);
  -- Draw shadow around window
  RenderShadow(4.0, 4.0, 316.0, 236.0);
  -- Print title
  texSpr:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  -- Set alternating colour for title
  FlickerColours(FlickerColour1, FlickerColour2);
  PrintC(fontLarge, 160.0, 8.0, ColouriseText(sTitle));
  -- Print tip
  if nStatusLineSize and nStatusLineSize > 0 then
    PrintM(fontTiny, 8.0 - nStatusLinePos, 226.0,
      nStatusLinePos, 304.0 + nStatusLinePos, sStatusLine2);
    nStatusLinePos = nStatusLinePos + 1;
    if nStatusLinePos >= nStatusLineSize then nStatusLinePos = 0.0 end;
  else PrintC(fontTiny, 160.0, 226.0, sStatusLine2) end;
  -- Print system information
  FlickerColours(FlickerColour2, FlickerColour1);
  PrintC(fontTiny, 160.0, 217.0, sStatusLine1);
  Print(fontTiny, 8.0, 9.0, format("RAM %.1f%%", nRAMUsePercentage));
  PrintR(fontTiny, 312.0, 18.0, format("%.1f%% ENG", nCPUUsageProcess));
  FlickerColours(FlickerColour1, FlickerColour2);
  PrintR(fontTiny, 312.0, 9.0, format("%.1f%% SYS", nCPUUsageSystem));
  Print(fontTiny, 8.0, 18.0, format("%.1f FPS", nGPUFramesPerSecond));
end
-- ------------------------------------------------------------------------- --
local function Refresh()
  -- Refresh monitor settings
  local function RefreshMonitorSettings()
    -- Initialise monitor video modes and use primary monitor if invalid
    iMonitorId = tonumber(vVidmonitor:Get());
    if iMonitorId < -1 or iMonitorId >= DisplayMonitors() then
      iMonitorId = -1 end;
    iMonitorIdOriginal = iMonitorId;
    -- Initialise video resolution and use desktop resolution if invalid
    iFullScreenState = tonumber(vVidfs:Get());
    if iFullScreenState < 0 or iFullScreenState > 1 then
      iFullScreenState = 0 end;
    iFullScreenMode = tonumber(vVidfsmode:Get());
    -- If full-screen mode is enabled?
    if iFullScreenState == 1 then
      -- If full-screen mode is -1 (Exclusive full-screen)?
      if iFullScreenMode >= -1 then iFullScreenState = 2;
      -- If full-screen mode is -2 (Borderless window mode)?
      elseif iFullScreenMode == -2 then iFullScreenState = 1 end;
    -- Windowed mode
    else iFullScreenMode = -2 end;
    -- If the full-screen mode CVar is invalid then reset to 'automatic' mode
    -- where the engine will set the full-screen mode to the desktop mode.
    if iFullScreenMode < -2 or
      iFullScreenMode >= DisplayVidModes(GetMonitorIdOrPrimary()) then
        iFullScreenMode = -1 end;
    -- Record the the initialised variables so we can check if they were
    -- modified when the user clicks the apply button.
    iFullScreenModeOriginal = iFullScreenMode;
    iFullScreenStateOriginal = iFullScreenState;
  end;
  -- Refresh window settings
  local function RefreshWindowSettings()
    -- Get window size
    local iWindowWidth = tonumber(vWinwidth:Get());
    local iWindowHeight = tonumber(vWinheight:Get());
    -- Set to defaults if invalid
    if iWindowWidth < -1 then iWindowWidth = -1 end;
    if iWindowHeight < -1 then iWindowHeight = -1 end;
    -- Set 'automatic' window id
    iWindowId = 0;
    -- Find window size in list and override the above index if found
    for iIndex = 1, #aWindowSizes do
      local aData = aWindowSizes[iIndex];
      if aData[1] == iWindowWidth and aData[2] == iWindowHeight then
        iWindowId = iIndex;
      end
    end
    -- Record original id
    iWindowIdOriginal = iWindowId;
  end
  -- Refresh audio settings
  local function RefreshAudioSettings()
    iAudioDeviceId = tonumber(vAudinterface:Get());
    iAudioDeviceIdOriginal = iAudioDeviceId;
  end
  -- Perform refreshes
  RefreshMonitorSettings();
  RefreshWindowSettings();
  RefreshAudioSettings();
  -- This will update the text on all the labels based on updated values
  for iIndex = 1, #aSetupOptionData do
    local aData<const> = aSetupOptionData[iIndex];
    aData[7] = aData[2]();
  end
end
-- On frame buffer refresh callback ---------------------------------------- --
local function OnStageUpdated(iStageW, iStageH, iStageL, iStageT, iStageR,
  iStageB)
  -- Update stage bounds as numbers
  nStageW, nStageH, nStageL, nStageT, nStageR, nStageB =
    iStageW + 0.0, iStageH + 0.0, iStageL + 0.0,
    iStageT + 0.0, iStageR + 0.0, iStageB + 0.0;
  -- Refresh settings
  Refresh();
end
-- ------------------------------------------------------------------------- --
local function ApplySettings()
  -- Do window reset?
  local bWindowReset = false;
  -- Set window size
  if iWindowId >= 1 and iWindowId <= #aWindowSizes then
    local aData<const> = aWindowSizes[iWindowId];
    if aData[1] == 0 and aData[2] == 0 then bWindowReset = true end;
    vWinwidth:Integer(aData[1]);
    vWinheight:Integer(aData[2]);
  end
  -- Set window variables if needed
  if iFullScreenState == 2 then vVidfs:Integer(1);
                           else vVidfs:Integer(iFullScreenState) end;
  -- If full-screen mode is resetting?
  if iFullScreenMode == -3 then
    -- Now set to default mode
    iFullScreenMode = -2;
    vVidfsmode:Reset();
  else vVidfsmode:Integer(iFullScreenMode) end;
  vVidmonitor:Integer(iMonitorId);
  vAudinterface:Integer(iAudioDeviceId);
  -- Reset audio subsystem if interface changed
  if iAudioDeviceIdOriginal ~= iAudioDeviceId then AudioReset() end;
  -- If GPU related parameters changed from original then reset video
  if iFullScreenMode ~= iFullScreenModeOriginal or
     iFullScreenStateOriginal ~= iFullScreenState or
     iMonitorIdOriginal ~= iMonitorId then DisplayVReset();
  -- If window parameters changed then just reset window
  elseif bWindowReset or iFullScreenState == 0 and
         iWindowId ~= iWindowIdOriginal then DisplayReset() end;
  -- Refresh/update settings
  Refresh();
end
-- ------------------------------------------------------------------------- --
local function ProcSysInfo()
  -- Get time
  nTime = CoreTime();
  -- Get cpu info, ram info and fps
  nCPUUsageProcess, nCPUUsageSystem = CoreCPUUsage();
  nRAMUsePercentage = CoreRAM();
  nGPUFramesPerSecond = DisplayGPUFPS();
end
-- ------------------------------------------------------------------------- --
local function ProcRenderReadme()
  -- Render default background
  RenderBackgroundStart(757);
  -- Draw readme
  for iIndex = 1, #aReadmeVisibleLines do
    -- Get data
    local aData<const> = aReadmeVisibleLines[iIndex];
    -- Calculate gradient colour
    local iCol<const> = aRmClrData[iIndex];
    -- Calculate intensity
    local nIntensity<const> =
      0.75 + (((iIndex / #aReadmeVisibleLines) + nTime) % 0.25);
    -- Set colour
    fontTiny:SetCRGB(nIntensity, nIntensity, nIntensity);
    -- Print line
    Print(fontTiny, aData[1], aData[2], aData[3]);
  end
  -- Set alternating title colour based on current time
  if nTime % 0.43 < 0.215 then fontTiny:SetCRGBA(0.5, 0.5, 0.5, 1.0);
                          else fontTiny:SetCRGBA(0.75, 0.75, 0.75, 1.0) end;
end
-- ------------------------------------------------------------------------- --
local function SetTip(nNewTipId, sTip)
  -- Ignore if tip set
  if nNewTipId == iTipId then return end;
  -- Set new tip
  iTipId = nNewTipId;
  -- No tip? Reset
  if not sTip then
    -- Save status line
    sStatusLine2 = sStatusLineSave;
    -- Re-calculate size and reset position
    nStatusLineSize, nStatusLinePos = -1, -1;
    -- Done
    return;
  end
  -- Get size of tip
  local sTipPlusSep<const> = sTip.." -+- "
  local nTipSizePixels<const> = PrintS(fontTiny, sTipPlusSep);
  local nMaxLine<const> = 304.0 + nTipSizePixels;
  -- Fill the line until it is big enough to scroll seamlessly
  sStatusLine2, nStatusLineSize = "", nTipSizePixels;
  while nStatusLineSize < nMaxLine do
    -- Set the tip and append a separator for seamless repeating
    sStatusLine2 = sStatusLine2..sTipPlusSep;
    -- Calculate size
    nStatusLineSize = PrintS(fontTiny, sStatusLine2);
  end
  -- Reset size to tip length
  nStatusLineSize = nTipSizePixels;
  -- Add more text so we can have a seamless repeating
  sStatusLine2 = sStatusLine2..sTip;
  -- Reset position
  nStatusLinePos = -304.0;
end
-- ------------------------------------------------------------------------- --
local function UpdateReadmeLines()
  -- Clear displayed lines
  local iMaximum<const> = min(iReadmeIndexBegin + iReadmeRows, #aReadmeData);
  aReadmeVisibleLines = create(iMaximum);
  -- For each line in readme file...
  for iIndex = iReadmeIndexBegin, iMaximum do
    -- Get line and truncate it if it is too long
    local sLine = aReadmeData[iIndex];
    if #sLine > iReadmeColsM1 then sLine = sLine:sub(1, iReadmeColsM1) end;
    -- Insert visible line
    aReadmeVisibleLines[1 + #aReadmeVisibleLines] =
      { nReadmePaddingX, nReadmePaddingY + ((#aReadmeVisibleLines + 1) *
        nReadmeSpacing), sLine };
  end
  -- Update statuses
  sStatusLine1 = "DISPLAYING LINE "..iReadmeIndexBegin.." TO "..
    iReadmeIndexEnd.." OF "..#aReadmeData.." OF THESE ACKNOWLEDGEMENTS";
  -- Make sure marquee is showing
  SetTip(0, "MOVE THE CURSOR TO THE BOTTOM OR TOP OF THE SCREEN AND PRESS \z
    RMB, JB1 OR PRESS "..
    tKeyBankCats.srmpu[9]..", "..tKeyBankCats.srmpd[9]..", "..
    tKeyBankCats.srmh[9]..", "..tKeyBankCats.srme[9]..", "..
    tKeyBankCats.srmu[9].." OR "..tKeyBankCats.srmd[9].." TO SCROLL THE \z
    README. "..tKeyBankCats.gksc[9]..", RMB OR JB2 TO RETURN TO SETUP. "..
    tKeyBankCats.sf[9].." TO LEAVE SETUP.");
end
-- ------------------------------------------------------------------------- --
local function InitReadme()
  -- Set title
  sTitle = "ABOUT";
  -- Set readme lines
  aReadmeData = aCreditLines;
  -- This make sure the status tip is updated
  iTipId = -1;
  -- Initialise readme lines
  UpdateReadmeLines();
  -- Restore original keys
  SetKeys(true, iKeyBankReadme);
  SetHotSpot(iHotSpotReadme);
  -- Set readme procedures
  SetCallbacks(ProcSysInfo, ProcRenderReadme);
end
-- ------------------------------------------------------------------------- --
local function ProcRenderSetup()
  -- Render default background
  RenderBackgroundStart(771);
  -- For each category
  for iIndex, aData in pairs(aSetupOptionData) do
    -- Get hot spot data
    local aHotSpot<const> = aData[1];
    -- Intensity value for pulsating colours
    local nIntensity;
    -- Option is selected?
    if iSelectedOption ~= iIndex then
      -- Set pulsating colour for category text
      nIntensity = 0.5 + (((iIndex/#aSetupOptionData) + nTime) % 0.5);
      fontLittle:SetCRGB(0.0, 0.0, nIntensity);
    -- Option is not selected?
    else
      -- Draw a pulsating background to show it is selected
      texSpr:SetCRGB(0.0, 0.0, 0.0);
      RenderFade(nButtonIntensity,
        aHotSpot[1], aHotSpot[2], aHotSpot[3], aHotSpot[4], 1022);
      texSpr:SetCRGB(1.0, 1.0, 1.0);
      fontLittle:SetCRGB(1.0, 1.0, 1.0);
    end
    Print(fontLittle, aData[4], aData[3], aData[5]);
    if iSelectedOption == iIndex then fontLittle:SetCRGB(1.0, 1.0, 1.0);
    else
      nIntensity = 0.5 + (((iIndex / #aSetupOptionData) + -nTime) % 0.5);
      fontLittle:SetCRGB(0.0, nIntensity, 0.0);
    end
    PrintR(fontLittle, aData[6], aData[3], aData[7]);
  end
  -- For each button
  texSpr:SetCRGB(0.0, 0.0, 0.0);
  for iIndex, aData in pairs(aSetupButtonData) do
    -- Get bounds information
    local aHSData<const> = aData[1];
    -- Button is not selected?
    if iSelectedButton ~= iIndex then
     -- Just draw black background
      RenderFade(0.5, aHSData[1], aHSData[2], aHSData[3], aHSData[4], 1023);
    -- Button is selected?
    else
      -- Set glowing colour
      texSpr:SetCRGB(nButtonIntensity, nButtonIntensity, nButtonIntensity);
      -- Draw background
      RenderFade(1.0 - nButtonIntensity,
        aHSData[1], aHSData[2], aHSData[3], aHSData[4], 1022);
    end
    -- Set button text colour and print the text
    fontLittle:SetCRGB(1.0, 1.0, 1.0);
    PrintC(fontLittle, aData[3], aData[4], aData[5]);
  end
  -- Print generic info
  if nTime % 0.43 < 0.215 then fontTiny:SetCRGBA(0.5, 0.5, 0.5, 1.0);
                          else fontTiny:SetCRGBA(0.75, 0.75, 0.75, 1.0) end;
  -- Reset sprites colour because we changed it
  texSpr:SetCRGBA(1.0, 1.0, 1.0, 1.0);
end
-- ------------------------------------------------------------------------- --
local function ProcLogicSetup()
  -- Set system info
  ProcSysInfo();
  -- Set button intensity
  nButtonIntensity =
    UtilClamp(nButtonIntensity + nButtonIntensityIncrement, 0.25, 0.75);
  if nButtonIntensity == 0.25 or nButtonIntensity == 0.75 then
    nButtonIntensityIncrement = -nButtonIntensityIncrement end;
end
-- ------------------------------------------------------------------------- --
local function InitConfig()
  -- No option selected
  iSelectedOption = 0;
  -- Set title
  sTitle = "SETUP";
  -- Initialise status bars
  sStatusLine1 = sGameName.." ("..sAppExeType..") "..sGameVersion.."."..
    iAppMajor.."."..iAppMinor.."."..iAppBuild.."."..iAppRevision.." - "..
    sGameWebsite;
  sStatusLine2 = sAppVendor.." PROUDLY PRESENTS "..sGameName.."! A REMAKE \z
    FOR MODERN OPERATING SYSTEMS AND HARDWARE FROM THE CLASSIC CD32 AND DOS \z
    DAYS. THIS IS THE CONFIGURATION SCREEN. PRESS "..tKeyBankCats.sf[9].." \z
    OR CLICK THE EDGE OF THE SCREEN TO RETURN TO THE GAME OR MOVE YOUR MOUSE \z
    OVER AN OPTION TO HAVE MORE EXPLAINED ABOUT IT HERE. USE YOUR MOUSE OR \z
    JOYSTICK TO MOVE THE CURSOR AND THE BUTTONS TO CHANGE OPTIONS. PRESS "..
    tKeyBankCats.gksc[9].." AT ANY TIME TO SEE THIS SCREEN, "..
    tKeyBankCats.gksb[9].." TO CHANGE KEYBINDINGS OR "..
    tKeyBankCats.gksa[9].." TO SEE THE ACKNOWLEDGEMENTS. \z
    PRESS ALT+ENTER AT ANY TIME TO TOGGLE FULL-SCREEN AND WINDOW. PRESS "..
    tKeyBankCats.gkcc[9].." TO FIX THE MOUSE CURSOR, PRESS "..
    tKeyBankCats.gkwr[9].." TO RESTORE THE WINDOW POSITION OR PRESS "..
    tKeyBankCats.gkss[9].." TO TAKE A SCREENSHOT.";
  sStatusLineSave = sStatusLine2;
  SetTip(0, sStatusLineSave);
  -- Refresh all settings
  Refresh();
  -- Restore original keys and hot spots
  SetKeys(true, iKeyBankSetup);
  SetHotSpot(iHotSpotSetup);
  -- Set configuration procedures
  SetCallbacks(ProcLogicSetup, ProcRenderSetup);
end
-- ------------------------------------------------------------------------- --
local function UpdateBindsLines()
  -- Clear displayed lines
  local iMaximum<const> = min(iBindsIndexBegin + iReadmeRows, #aBindsList);
  aReadmeVisibleLines = create(iMaximum);
  -- For each line in readme file...
  for iIndex = iBindsIndexBegin, iMaximum do
    -- Get line and truncate it if it is too long
    local aBind<const> = aBindsList[iIndex];
    local sLine = aBind[6];
    local sBind<const> = aBind[8];
    sLine = sLine.." "..rep(".", 74 - #sLine - #sBind).." "..sBind;
    if #sLine > iReadmeColsM1 then sLine = sLine:sub(1, iReadmeColsM1) end;
    -- Insert visible line
    local nY<const> =
      nReadmePaddingY + ((#aReadmeVisibleLines + 1.0) * nReadmeSpacing)
    aReadmeVisibleLines[1 + #aReadmeVisibleLines] =
      { nReadmePaddingX, nY, sLine, nReadmePaddingX + 304.0, nY + 6.0, aBind };
  end
  -- Update statuses
  sStatusLine1 = "DISPLAYING INPUT BINDING "..iBindsIndexBegin.." TO "..
    iBindsIndexEnd.." OF "..#aBindsList.." OF TOTAL INPUT BINDINGS";
  -- Make sure marquee is showing
  SetTip(0, "MOVE THE CURSOR TO A BIND YOU WANT TO CHANGE AND PRESS LMB OR \z
    JB1 ON IT TO CHANGE THE KEY BINDING FOR IT. PRESS "..
    tKeyBankCats.sbpu[9]..", "..tKeyBankCats.sbpd[9]..", "..
    tKeyBankCats.sbh[9]..", "..tKeyBankCats.sbe[9]..", "..
    tKeyBankCats.sbu[9].." OR "..tKeyBankCats.sbd[9].." TO SCROLL THE \z
    BINDS. "..tKeyBankCats.gksc[9]..", RMB OR JB2 TO RETURN TO SETUP. "..
    tKeyBankCats.sf[9].." TO LEAVE SETUP.");
end
-- ------------------------------------------------------------------------- --
local function RenderBinds()
  -- Render default background
  RenderBackgroundStart(757);
  -- Draw readme
  for iIndex = 1, #aReadmeVisibleLines do
    -- Get data
    local aData<const> = aReadmeVisibleLines[iIndex];
    -- Calculate gradient colour
    local iCol<const> = aRmClrData[iIndex];
    -- Return if no option is selected
    local nIntensity;
    if iSelectedOption == iIndex then
      -- Get currently selected line data and render a selection rectangle
      texSpr:SetCRGB(0.0, 1.0, 0.0);
      RenderFade(0.75, aData[1], aData[2], aData[4], aData[5], 1022);
      texSpr:SetCRGB(1.0, 1.0, 1.0);
      nIntensity = 1;
    else
      -- Calculate intensity
      nIntensity = 0.75 + (((iIndex / #aReadmeVisibleLines) + nTime) % 0.25);
    end
    -- Set text colour and print the bind line
    fontTiny:SetCRGB(nIntensity, nIntensity, nIntensity);
    Print(fontTiny, aData[1], aData[2], aData[3]);
  end
  -- Set alternating title colour based on current time
  if nTime % 0.43 < 0.215 then fontTiny:SetCRGBA(0.5, 0.5, 0.5, 1.0);
                          else fontTiny:SetCRGBA(0.75, 0.75, 0.75, 1.0) end;
end
-- ------------------------------------------------------------------------- --
local function InitBinds()
  -- No option selected
  iSelectedOption = 0;
  -- Set title
  sTitle = "BINDINGS";
  -- Clear status line
  sStatusLineSave = nil;
  -- This make sure the status tip is updated
  iTipId = -1;
  -- Update binds lines
  UpdateBindsLines();
  -- Set binding keys and hot spots
  SetKeys(true, iKeyBankBind);
  SetHotSpot(iHotSpotBind);
  -- Set configuration procedures
  SetCallbacks(ProcSysInfo, RenderBinds)
end
-- ------------------------------------------------------------------------- --
local function DoInitSetup(iMode)
  -- Get current callbacks
  local CBProc, CBRender = GetCallbacks();
  -- Available modes
  local aModes<const> = {
    { InitConfig, ProcRenderSetup  },
    { InitBinds,  RenderBinds },
    { InitReadme, ProcRenderReadme },
  };
  -- Set and check requested mode/
  local aMode<const> = aModes[iMode];
  if not aMode then error("Invalid mode: "..iMode) end;
  -- Return if function already set
  if CBRender == aMode[2] then return end;
  -- Save current keybank and hotspot so we can restore it on exit
  if not iLastKeyBank then iLastKeyBank = GetKeyBank() end;
  if not iLastHotSpot then iLastHotSpot = GetHotSpot() end;
  -- Remove the mode and go through available modes
  remove(aModes, iMode);
  for iIndex = 1, #aModes do
    -- Get mode data and just call init function if we're still in setup
    local aAltMode<const> = aModes[iIndex];
    if CBRender == aAltMode[2] then return aMode[1]() end;
  end
  -- Required setup assets finished loading
  local function OnLoaded(aResource)
    -- Save current music
    musLast = GetMusic();
    -- Play setup music
    PlayMusic(aResource[1], nil, 1);
    -- Initialise button intensity
    nButtonIntensity, nButtonIntensityIncrement = 1.0, 0.01;
    -- Backup old callbacks (Return to them later)
    fcbLogic, fcbRender = CBProc, CBRender;
    -- Get time
    nTime = CoreTime();
    -- Call the mode init function
    aMode[1]();
  end
  -- Pause any video playing
  VideoPause();
  -- Register frame buffer update
  RegisterFBUCallback("setup", OnStageUpdated);
  -- Load bank texture
  LoadResources("Setup", aAssets, OnLoaded);
end
InitSetup = DoInitSetup;
-- Script has been initialised --------------------------------------------- --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local PlayStaticSound, RegisterHotSpot, RegisterKeys, oAssetsData,
    oCursorIdData, oSfxData;
  -- Grab import functions and data
  BlitSLTWHA, DisableKeyHandlers, GetCallbacks, GetHotSpot, GetKeyBank,
    GetMusic, IsMouseYLessThan, LoadResources, PlayMusic, PlayStaticSound,
    PrintC, PrintM, PrintR, PrintS, Print, RegisterFBUCallback,
    RegisterHotSpot, RegisterKeys, RenderFade, RenderShadow,
    RestoreKeyHandlers, SetCallbacks, SetHotSpot, SetKeys, StopMusic,
    VideoPause, VideoResume, oAssetsData, oCursorIdData, tKeyBankCats,
    oKeyToLiteral, aSetupButtonData, aSetupOptionData, oSfxData, fontLarge,
    fontLittle, fontTiny, texSpr =
      GetAPI("BlitSLTWHA", "DisableKeyHandlers", "GetCallbacks", "GetHotSpot",
        "GetKeyBank", "GetMusic", "IsMouseYLessThan", "LoadResources",
        "PlayMusic", "PlayStaticSound", "PrintC", "PrintM", "PrintR", "PrintS",
        "Print", "RegisterFBUCallback", "RegisterHotSpot", "RegisterKeys",
        "RenderFade", "RenderShadow", "RestoreKeyHandlers", "SetCallbacks",
        "SetHotSpot", "SetKeys", "StopMusic", "VideoPause", "VideoResume",
        "oAssetsData", "oCursorIdData", "tKeyBankCats", "oKeyToLiteral",
        "aSetupButtonData", "aSetupOptionData", "oSfxData", "fontLarge",
        "fontLittle", "fontTiny", "texSpr");
  -- Set assetsData
  aAssets = { oAssetsData.setupm };
  -- Callback to set all settings to default
  local function SetDefaults()
    -- Push defaults
    iFullScreenState = 0;
    iFullScreenMode = -3;
    iMonitorId = -1;
    iAudioDeviceId = -1;
    iWindowId = 1;
    -- Other options
    vWinposx:Reset();
    vWinposy:Reset();
    vAppdelay:Reset();
    vVidvsync:Reset();
    vTexfilter:Reset();
    -- Reset volumes
    vAudvol:Reset();
    vAudstrvol:Reset();
    vAudsamvol:Reset();
    vAudfmvvol:Reset();
    -- Set new settings
    ApplySettings();
  end
  -- Set original procedures function
  local function GoFinish()
    -- Unload data
    aReadmeData, aReadmeVisibleLines = nil, nil;
    -- Return to sub-proc
    SetCallbacks(fcbLogic, fcbRender);
    -- Music to resume? Play the music and dereference the handle
    if musLast then musLast = PlayMusic(musLast, nil, 2);
    -- No music to set? Just stop the setup music
    else StopMusic() end;
    -- Resume any video that might be playing
    VideoResume();
    -- Restore redraw callback
    RegisterFBUCallback("setup");
    -- Restore original hotspot and keyback
    SetKeys(true, iLastKeyBank);
    SetHotSpot(iLastHotSpot);
    -- Done with saved keybank id
    iLastKeyBank, iLastHotSpot = nil, nil;
  end
  -- Apply button data
  local aButtons<const> =
    { GoFinish, ApplySettings, SetDefaults, InitBinds, InitReadme };
  -- Get frequently used sound effect ids
  local iSClick<const>, iSSelect<const> = oSfxData.CLICK, oSfxData.SELECT;
  -- Start drawing buttons from the left and the size of each button. We set
  -- the shader to round off any sub-pixelling so fractions are handled safely.
  local nX, nSize<const>, nYButton<const> = 4.0, 312.0 / #aButtons, 193.0;
  local nYButtonText<const> = nYButton + 5.0;
  -- Text position
  local nSizeD2<const> = nSize / 2.0;
  -- Hot spots list
  local aHotSpots<const> = create(#aButtons);
  -- For each button
  for iButtonIndex = 1, #aButtons do
    -- Get button and hot spot data
    local aButton<const> = aSetupButtonData[iButtonIndex];
    local aHotSpot<const> = aButton[1];
    -- Assign to hot spots list
    aHotSpots[iButtonIndex] = aHotSpot;
    -- Set button bounds
    aHotSpot[1], aHotSpot[2], aHotSpot[3], aHotSpot[4] =
      nX, nYButton, nSize, 19;
    -- Text position
    aButton[3], aButton[4] = nX + nSizeD2, nYButtonText;
    -- Get the callback
    local iTip<const>, sTip<const> = aButton[2], aButton[6];
    local function OnHover()
      iSelectedButton, iSelectedOption = iButtonIndex, 0;
      SetTip(iTip, sTip);
    end
    aHotSpot[7] = OnHover;
    -- Function to play sound and call the callback
    local fcbOnClick<const> = aButtons[iButtonIndex];
    local function OnClick() PlayStaticSound(iSSelect) fcbOnClick() end;
    aHotSpot[9] = OnClick;
    -- Next button position
    nX = nX + nSize;
  end
  -- Option picker callbacks : Monitor choice callbacks
  local function MonitorUpdate()
    if iMonitorId == -1 then return "Primary Monitor" end;
    local sMsg<const> = DisplayMonitorData(iMonitorId);
    if #sMsg > 34 then return sMsg:sub(0,30).."..." end;
    return sMsg;
  end
  local function MonitorDown()
    if iMonitorId == -1 then return end;
    iMonitorId = iMonitorId - 1;
  end
  local function MonitorUp()
    if iMonitorId == DisplayMonitors()-1 then return end;
    iMonitorId = iMonitorId + 1;
  end
  -- Full-screen state callbacks
  local function FSStateUpdate()
    if DisplayFSType() == iNativeMode then return aWindowLabels[4] end;
    return aWindowLabels[iFullScreenState + 1];
  end
  local function FSStateDown()
    if iFullScreenState <= 0 or
       DisplayFSType() == iNativeMode then return end;
    iFullScreenState = iFullScreenState - 1;
    if iFullScreenState < 2 then iFullScreenMode = -2 end;
  end
  local function FSStateUp()
    if iFullScreenState >= #aWindowLabels-2 or
       DisplayFSType() == iNativeMode then return end;
    iFullScreenState = iFullScreenState + 1;
    if iFullScreenState == 2 then iFullScreenMode = -1 end;
  end
  -- Resolution callbacks
  local function FSResUpdate()
    if iFullScreenMode == -2 or
       DisplayFSType() == iNativeMode then return "Disabled" end;
    if iFullScreenMode == -1 then return "Automatic" end;
    -- Which one
    local iWidth<const>, iHeight<const>, iBits<const>, nRefresh<const> =
      DisplayVidModeData(GetMonitorIdOrPrimary(), iFullScreenMode);
    -- Return data
    return iWidth.."x"..iHeight.."x"..iBits.." "..nRefresh.."hz ("..
      UtilGetRatio(iWidth, iHeight)..")";
  end
  local function FSResDown()
    if iFullScreenMode <= -1 or
       DisplayFSType() == iNativeMode then
      return end;
    iFullScreenMode = iFullScreenMode - 1;
  end
  local function FSResUp()
    if iFullScreenMode <= -2 or
       DisplayFSType() == iNativeMode or
       iFullScreenMode >= DisplayVidModes(GetMonitorIdOrPrimary())-1 then
      return end;
    iFullScreenMode = iFullScreenMode + 1;
  end
  -- Window size callbacks
  local function WSizeUpdate()
    -- Ignore if in full-screen
    if iFullScreenState ~= 0 or
       DisplayFSType() == iNativeMode then
      return "Disabled" end;
    -- Custom resolution? Return custom resolution label with size
    if iWindowId <= 1 then
      local iWinX<const>, iWinY<const> = DisplayGetSize();
      return aCustomLabels[iWindowId + 1].." "..
        iWinX.."x"..iWinY.." ("..UtilGetRatio(iWinX, iWinY)..")";
    end
    -- Which one
    local aData<const> = aWindowSizes[iWindowId];
    if not aData then return "Unknown ("..iWindowId..")" end;
    -- Return data
    return aData[1].."x"..aData[2]..
      " ("..UtilGetRatio(aData[1], aData[2])..")";
  end
  local function WSizeDown()
    if iFullScreenState ~= 0 or
       DisplayFSType() == iNativeMode then return end;
    iWindowId = iWindowId - 1;
    if iWindowId < 1 then iWindowId = 1 end;
  end
  local function WSizeUp()
    if iFullScreenState ~= 0 or
       DisplayFSType() == iNativeMode then return end;
    iWindowId = iWindowId + 1;
    if iWindowId > #aWindowSizes then iWindowId = #aWindowSizes end;
  end
  -- Frame limiter choice callbacks
  local function GetVarVidVsync() return tonumber(vVidvsync:Get()) end;
  local function GetVarAppDelay() return tonumber(vAppdelay:Get()) end;
  local function LimiterGet()
    -- Get VSync value, thread delay and kernel tick rate
    local iFrameLimiter = 1 + GetVarVidVsync();
    -- Check for delay and if set? Set software category too
    if GetVarAppDelay() > 0 then iFrameLimiter = iFrameLimiter + 4 end;
    -- Return value
    return iFrameLimiter;
  end
  local function LimiterUpdate()
    -- Get VSync value, thread delay and kernel tick rate
    local iFrameLimiter = 1 + GetVarVidVsync();
    -- Check for delay and if set? Set software category too
    if GetVarAppDelay() > 0 then iFrameLimiter = iFrameLimiter + 4 end;
    -- Set original value
    return aFrameLimiterLabels[LimiterGet()+1];
  end
  local function LimiterSet(iFrameLimiter)
    -- Set frame limiter options
    local iVSync, iDelay;
    if iFrameLimiter >= 4 then iVSync, iDelay = -1 + (iFrameLimiter % 4), 1;
    else iVSync, iDelay = -1 + iFrameLimiter, 0 end;
    vVidvsync:Integer(iVSync);
    vAppdelay:Integer(iDelay);
  end
  local function LimiterDown()
    LimiterSet(UtilClampInt(LimiterGet()-1, 0, #aFrameLimiterLabels-1));
  end
  local function LimiterUp()
    LimiterSet(UtilClampInt(LimiterGet()+1, 0, #aFrameLimiterLabels-1));
  end
  -- Filter choice callbacks
  local function GetVarTexFilter() return tonumber(vTexfilter:Get()) end;
  local function SetVarTexFilter(iV) return vTexfilter:Integer(iV) end;
  local function FilterUpdate()
    -- Point filtering if disabled
    if GetVarTexFilter() == 0 then return "Point" end;
    -- Anything else is bilinear
    return "Bilinear";
  end
  local function FilterSwap()
    -- Set enabled (GL_LINEAR) if was disabled
    if GetVarTexFilter() == 0 then return SetVarTexFilter(3) end;
    -- Set disabled (GL_NEAREST) if was enabled
    SetVarTexFilter(0);
  end
  -- Audio device set callbacks
  local function AudioUpdate()
    if iAudioDeviceId == -1 then return "Default Playback Device";
    elseif iAudioDeviceId >= AudioGetNumPBDs() then
      return "Invalid Playback Device" end;
    local sName = AudioGetPBDName(iAudioDeviceId);
    local sPrefix<const> = "OpenAL Soft on ";
    if sName:sub(1, #sPrefix) == sPrefix then sName = sName:sub(#sPrefix) end;
    if #sName > 34 then return sName:sub(0,30).."..." end;
    return sName;
  end
  local function AudioDown()
    if iAudioDeviceId == -1 then return end;
    iAudioDeviceId = iAudioDeviceId - 1;
  end
  local function AudioUp()
    if iAudioDeviceId == AudioGetNumPBDs()-1 then return end;
    iAudioDeviceId = iAudioDeviceId + 1;
  end
  -- Volume set utilities
  local function VPrepare(vCV) return floor(vCV:Get() * 100).."%" end;
  local function VSet(vCV, iAdj)
    vCV:Number(UtilClamp(tonumber(vCV:Get()) + (iAdj * 0.01), 0, 1));
  end
  -- Master volume callbacks
  local function VMasterUpdate() return VPrepare(vAudvol) end;
  local function VMasterSet(iAdj) VSet(vAudvol, iAdj) end;
  local function VMasterDown() VMasterSet(-1) end;
  local function VMasterUp() VMasterSet(1) end;
  -- Stream volume callbacks
  local function VStreamUpdate() return VPrepare(vAudstrvol) end;
  local function VStreamSet(iAdj) VSet(vAudstrvol, iAdj) end;
  local function VStreamDown() VStreamSet(-1) end;
  local function VStreamUp() VStreamSet(1) end;
  -- Sample volume callbacks
  local function VSampleSet(iAdj) VSet(vAudsamvol, iAdj) end;
  local function VSampleUpdate() return VPrepare(vAudsamvol) end;
  local function VSampleDown() VSampleSet(-1) end;
  local function VSampleUp() VSampleSet(1) end;
  -- FMV volume callbacks
  local function VFMVUpdate() return VPrepare(vAudfmvvol) end;
  local function VFMVSet(iAdj) VSet(vAudfmvvol, iAdj) end;
  local function VFMVDown() VFMVSet(-1) end;
  local function VFMVUp() VFMVSet(1) end;
  -- Apply functions to static option table
  for iIndex, aF in ipairs({
    { MonitorUpdate, MonitorDown, MonitorUp  }, -- [01]
    { FSStateUpdate, FSStateDown, FSStateUp  }, -- [02]
    { FSResUpdate,   FSResDown,   FSResUp    }, -- [03]
    { WSizeUpdate,   WSizeDown,   WSizeUp    }, -- [04]
    { LimiterUpdate, LimiterDown, LimiterUp  }, -- [05]
    { FilterUpdate,  FilterSwap,  FilterSwap }, -- [06]
    { AudioUpdate,   AudioDown,   AudioUp    }, -- [07]
    { VMasterUpdate, VMasterDown, VMasterUp  }, -- [08]
    { VStreamUpdate, VStreamDown, VStreamUp  }, -- [09]
    { VSampleUpdate, VSampleDown, VSampleUp  }, -- [10]
    { VFMVUpdate,    VFMVDown,    VFMVUp     }, -- [11]
  }) do
    local aOptionItem<const> = aSetupOptionData[iIndex];
    local fcbUpdateFunc<const> = aF[1];
    aOptionItem[2] = fcbUpdateFunc;
    local aHotSpot<const> = aOptionItem[1];
    -- Setup dimensions
    aHotSpot[1], aHotSpot[2] = 4, 28 + (iIndex - 1) * 15;
    aHotSpot[3], aHotSpot[4] = 312, 15;
    -- Setup text position
    aOptionItem[3] = aHotSpot[2] + 4; -- Y
    aOptionItem[4] = aHotSpot[1] + 4; -- Left justified X
    aOptionItem[6] = aHotSpot[3];     -- Right justified X
    -- Setup custom hover function
    local sTip<const> = aOptionItem[8];
    local function OnHover()
      -- Select the option, deselect the button and set the tip
      iSelectedOption, iSelectedButton = iIndex, 0;
      SetTip(iIndex, sTip);
    end
    aHotSpot[7] = OnHover;
    -- Setup custom scroll option
    local fcbDown<const>, fcbUp<const> = aF[2], aF[3];
    local function OnScroll(nX, nY)
      -- Mouse scrolling down?
      if nY < 0 then
        -- Play sound, select last option and update the setting
        PlayStaticSound(iSClick);
        fcbDown();
        aOptionItem[7] = fcbUpdateFunc();
      -- Mouse scrolling up?
      elseif nY > 0 then
        -- Play sound, select next option and update the setting
        PlayStaticSound(iSClick);
        fcbUp();
        aOptionItem[7] = fcbUpdateFunc();
      end
    end
    aHotSpot[8] = OnScroll;
    -- Setup custom click function
    local function OnClick(iButton)
      -- LMB or JB1?
      if iButton == 0 then
        -- Play sound, select next option and update the setting
        PlayStaticSound(iSClick);
        fcbUp();
        aOptionItem[7] = fcbUpdateFunc();
      -- RMB or JB1?
      elseif iButton == 1 then
        -- Play sound, select last option and update the setting
        PlayStaticSound(iSClick);
        fcbDown();
        aOptionItem[7] = fcbUpdateFunc();
      end
    end
    aHotSpot[9] = OnClick;
    -- Add the hot spot to the hot spots list
    aHotSpots[1 + #aHotSpots] = aHotSpot;
  end
  -- Register the hot spots
  local function OnSetupHover()
    iSelectedOption, iSelectedButton = 0, 0;
    SetTip(100, sStatusLineSave);
  end;
  -- Get frequently used cursor ids
  local iCBottom<const>, iCExit<const>, iCSelect<const>, iCTop<const> =
    oCursorIdData.BOTTOM, oCursorIdData.EXIT, oCursorIdData.SELECT,
    oCursorIdData.TOP;
  -- Default hot spot
  aHotSpots[1 + #aHotSpots] =
    { 4, 4, 312, 232, 0, 0,      OnSetupHover, false, false    };
  aHotSpots[1 + #aHotSpots] =
    { 0, 0,   0, 240, 3, iCExit, OnSetupHover, false, GoFinish };
  iHotSpotSetup = RegisterHotSpot(aHotSpots);
  -- Get frequently used keyboard keys
  local oKeys<const>, oStates<const> = Input.KeyCodes, Input.States;
  local iPress<const>, iRepeat<const>, iControl<const>, iBackspace<const>,
    iLetterC<const>, iEscape<const>, iLetterD<const> = oStates.PRESS,
      oStates.REPEAT, oMods.CONTROL, oKeys.BACKSPACE, oKeys.C, oKeys.ESCAPE,
      oKeys.D;
  -- Setup key bank
  local aGenericEscape<const> = { iEscape, GoFinish, "sf", "CLOSE" };
  local aOnlyEscape<const> = { [iPress] = { aGenericEscape } };
  -- Setup configuration keys
  iKeyBankSetup = RegisterKeys("SETUP", aOnlyEscape);
  -- Frequently used key ids
  local iPageUp<const>, iPageDown<const>, iHome<const>, iEnd<const>,
    iUp<const>, iDown<const> = oKeys.PAGE_UP, oKeys.PAGE_DOWN, oKeys.HOME,
      oKeys.END, oKeys.UP, oKeys.DOWN;
  -- Set readme position to specified line
  local function SetReadme(iLine)
    -- Get maximum lines
    local iMax<const> =
      UtilClampInt(#aReadmeData - #aRmClrData, 1, maxinteger);
    -- Set to end line?
    if iLine == maxinteger then iReadmeIndexBegin = iMax;
    -- Set line?
    else iReadmeIndexBegin = UtilClampInt(iLine, 1, iMax) end;
    -- Set ending line
    iReadmeIndexEnd =
      UtilClampInt(iReadmeIndexBegin + #aRmClrData, 1, #aReadmeData);
    -- Update displayed readme lines
    UpdateReadmeLines();
  end
  -- Readme function events
  local function ScrollReadme(iAdj) SetReadme(iReadmeIndexBegin + iAdj) end;
  local function ScrollReadmePageUp() ScrollReadme(-29) end;
  local function ScrollReadmePageDown() ScrollReadme(29) end;
  local function ScrollReadmeUp() ScrollReadme(-1) end;
  local function ScrollReadmeDown() ScrollReadme(1) end;
  local function ScrollReadmeHome() SetReadme(1) end;
  local function ScrollReadmeEnd() SetReadme(#aReadmeData) end;
  -- Setup readme keys
  local aReadmePageUp<const>, aReadmePageDown<const>,
        aReadmeHome<const>,   aReadmeEnd<const>,
        aReadmeUp<const>,     aReadmeDown<const> =
    { iPageUp,   ScrollReadmePageUp,   "srmpu", "SCROLL UP A PAGE"    },
    { iPageDown, ScrollReadmePageDown, "srmpd", "SCROLL DOWN A PAGE"  },
    { iHome,     ScrollReadmeHome,     "srmh",  "SCROLL TO THE START" },
    { iEnd,      ScrollReadmeEnd,      "srme",  "SCROLL TO THE END"   },
    { iUp,       ScrollReadmeUp,       "srmu",  "SCROLL UP A LINE"    },
    { iDown,     ScrollReadmeDown,     "srmd",  "SCROLL DOWN A LINE"  };
  iKeyBankReadme = RegisterKeys("SETUP ACKNOWLEDGEMENTS", {
    [iPress] = { aGenericEscape, aReadmePageUp, aReadmePageDown,
      aReadmeHome, aReadmeEnd, aReadmeUp, aReadmeDown },
    [iRepeat] = { aReadmePageUp, aReadmePageDown, aReadmeHome,
      aReadmeEnd, aReadmeUp, aReadmeDown },
  });
  -- Setup readme hot spots
  local function OnScrollReadme(nX, nY)
    -- Vertical scrolling?
    if     nY < 0 then ScrollReadmeDown();
    elseif nY > 0 then ScrollReadmeUp();
    -- Horizontal scrolling?
    elseif nX < 0 then ScrollReadmePageDown();
    elseif nX > 0 then ScrollReadmePageUp() end;
  end
  iHotSpotReadme = RegisterHotSpot({
    { 4,   4, 312,  24, 0, iCTop,
      false, OnScrollReadme, ScrollReadmePageUp },
    { 4, 212, 312,  24, 0, iCBottom,
      false, OnScrollReadme, ScrollReadmePageDown },
    { 4,   4, 312, 232, 0, 0,
      false, OnScrollReadme, false },
    { 0,   0,   0, 240, 3, iCExit,
      false, OnScrollReadme, GoFinish             },
  });
  -- Set binds list starting line
  local function SetBinds(iLine)
    -- Get maximum lines
    local iMax<const> =
      UtilClampInt(#aBindsList - #aRmClrData, 1, maxinteger);
    -- Set to end line?
    if iLine == maxinteger then iBindsIndexBegin = iMax;
    -- Set line?
    else iBindsIndexBegin = UtilClampInt(iLine, 1, iMax) end;
    -- Set ending line
    iBindsIndexEnd =
      UtilClampInt(iBindsIndexBegin + #aRmClrData, 1, #aBindsList);
    -- Update displayed readme lines
    UpdateBindsLines();
  end
  -- Bind scroll callbacks
  local function ScrollBinds(iAdj) SetBinds(iBindsIndexBegin + iAdj) end;
  local function ScrollBindsPageUp() ScrollBinds(-29) end;
  local function ScrollBindsPageDown() ScrollBinds(29) end;
  local function ScrollBindsUp() ScrollBinds(-1) end;
  local function ScrollBindsDown() ScrollBinds(1) end;
  local function ScrollBindsHome() SetBinds(1) end;
  local function ScrollBindsEnd() SetBinds(#aBindsList) end;
  -- Setup bind keys
  local aBindsPageUp<const>, aBindsPageDown<const>,
        aBindsHome<const>,   aBindsEnd<const>,
        aBindsUp<const>,     aBindsDown<const> =
    { iPageUp,   ScrollBindsPageUp,   "sbpu", "SCROLL UP A PAGE"    },
    { iPageDown, ScrollBindsPageDown, "sbpd", "SCROLL DOWN A PAGE"  },
    { iHome,     ScrollBindsHome,     "sbh",  "SCROLL TO THE START" },
    { iEnd,      ScrollBindsEnd,      "sbe",  "SCROLL TO THE END"   },
    { iUp,       ScrollBindsUp,       "sbu",  "SCROLL UP A LINE"    },
    { iDown,     ScrollBindsDown,     "sbd",  "SCROLL DOWN A LINE"  };
  iKeyBankBind = RegisterKeys("SETUP BINDINGS", {
    [iPress] = { aGenericEscape, aBindsPageUp, aBindsPageDown,
      aBindsHome, aBindsEnd, aBindsUp, aBindsDown },
    [iRepeat] = { aBindsPageUp, aBindsPageDown, aBindsHome,
      aBindsEnd, aBindsUp, aBindsDown },
  });
  -- Init third party credits
  local function Header(sString)
    -- Add ellipsis
    sString = sString.."...";
    -- Add titlebar for credit
    aCreditLines[1 + #aCreditLines] = sString;
    aCreditLines[1 + #aCreditLines] = rep('=', len(sString));
    aCreditLines[1 + #aCreditLines] = "";
  end
  -- Add game name header
  Header(sGameName.." "..sGameVersion);
  -- Write  game information
  aCreditLines[1 + #aCreditLines] = sGameDescription..".";
  aCreditLines[1 + #aCreditLines] =
    "COPYRIGHT (C) "..sGameCopyr:sub(14):upper()..".";
  aCreditLines[1 + #aCreditLines] = "RUNNING ON "..sAppTitle.." "..iAppMajor..
    "."..iAppMinor.."."..iAppBuild.."."..iAppRevision.." FOR "..sAppExeType..
    ".";
  aCreditLines[1 + #aCreditLines] = "SEE HTTPS://"..sGameWebsite..
    " FOR MORE INFORMATION AND UPDATES.";
  aCreditLines[1 + #aCreditLines] = "";
  -- Add third party credits header
  Header("ACKNOWLEDGEMENT OF "..iCredits.." THIRD-PARTY CREDITS");
  -- Enumerate credits so we can build a quick credits list
  local iIndex = 0;
  repeat
    -- Get first credit information and if we can show a second?
    local sName<const>, sVersion<const> = CoreLibrary(iIndex);
    -- 1-index credit id.
    iIndex = iIndex + 1;
    if iIndex < iCredits then
      -- Get second credit information
      local sName2<const>, sVersion2<const> = CoreLibrary(iIndex);
      -- Go forward another entry
      iIndex = iIndex + 1;
      -- Insert both credits
      aCreditLines[1 + #aCreditLines] =
        format("%2d: %-16s %16s  %2d: %-16s %16s",
        iIndex-1, sName:upper(), "(v"..sVersion:upper()..")",
        iIndex, sName2:upper(), "(v"..sVersion2:upper()..")");
    -- Only one left so write last
    else aCreditLines[1 + #aCreditLines] = format("%2d: %-17s %15s", iIndex,
      sName:upper(), "(v"..sVersion:upper()..")") end;
  -- Until there are no more items left
  until iIndex >= iCredits;
  -- Add space
  aCreditLines[1 + #aCreditLines] = "";
  -- Add licenses header
  Header("LICENSES");
  -- Now for all the other credits in detail
  for iIndex = 0, iCredits - 1 do
    -- Get credit information
    local sName<const>, sVersion<const>, bCopyright, sAuthor<const> =
      CoreLibrary(iIndex);
    -- Set copyright
    if bCopyright then bCopyright = "(C)";
                  else bCopyright = "BY" end;
    -- Line to write
    Header((iIndex+1)..". USES "..sName:upper().." "..bCopyright.." "..
      sAuthor:upper());
    -- Add credit license
    local aLines<const> = UtilExplode(CoreLicense(iIndex), "\n");
    for iIndex = 1, #aLines do
      local sLine<const> = aLines[iIndex];
      if #sLine > 78 then
        local aWrappedLines<const> = UtilWordWrap(sLine, iReadmeCols, 0);
        for iWI = 1, #aWrappedLines do
          aCreditLines[1 + #aCreditLines] = aWrappedLines[iWI]:upper();
        end
      else aCreditLines[1 + #aCreditLines] = sLine:upper() end;
    end
  end
  -- Add third party credits header
  aCreditLines[1 + #aCreditLines] = "*** END-OF-FILE ***";
  -- Init text colours
  for iIndex = 1, iReadmeRows do
    aRmClrData[1 + #aRmClrData] = (iIndex / iReadmeRows) * 0.25 end;
  -- Truncate bottom empty lines
  while #aCreditLines > 0 and #aCreditLines[#aCreditLines] == 0 do
    remove(aCreditLines) end;
  -- Get flag for a unsigned integer saveable cvar type
  local iSS<const> = Variable.Flags.UINTEGERSAVE;
  -- Build bindings list
  for iBind = 1, #tKeyBankCats do
    -- Get bind data
    local aBind<const> = tKeyBankCats[iBind];
    -- Create a cvar for key
    local function CVarModified(sV)
      -- Convert to number and check it
      sV = floor(tonumber(sV));
      if sV < 0 and sV >= 1000 then return false end;
      -- Update actual keybind and literal value
      aBind[1] = sV;
      local sValue<const> = oKeyToLiteral[sV] or oKeyToLiteral.UNKNOWN;
      aBind[8] = sValue.." ["..format("%03d", sV).."]";
      aBind[9] = sValue;
      -- Accepted
      return true;
    end
    -- Register a variable for it
    aBind[7] = VariableRegister("gam_key_"..aBind[3], aBind[1], iSS,
      CVarModified);
    -- Put in bindings list
    aBindsList[1 + #aBindsList] = aBind;
  end
  -- Sort the bindings list
  local function BindSortFunction(aA, aB) return aA[6] < aB[6] end;
  sort(aBindsList, BindSortFunction);
  -- Get OK result for Variable:Integer()
  local iVROK<const> = Variable.Result.OK;
  -- Binds area clicked
  local function OnBindsClick()
    -- Get key bind data
    local aBindData<const> = aReadmeVisibleLines[iSelectedOption][6];
    -- Set text to receive key
    local sTextSave<const> = aBindData[8];
    aBindData[8] = "???";
    -- Update readme lines
    UpdateBindsLines();
    -- Remove marquee settings
    sStatusLineSave, nStatusLineSize, nStatusLinePos, iTipId =
      nil, nil, nil, nil;
    -- Update tip at the bottom
    sStatusLine1 = "PRESS ANY KEY TO USE AS NEW KEY BINDING";
    sStatusLine2 = "CTRL+C:CANCEL  \z
                    CTRL+D:DEFAULT  \z
                    CTRL+BACKSPACE:CLEAR";
    -- Unset hots pots to show wait cursor
    SetHotSpot();
    -- Disable all input events
    DisableKeyHandlers();
    -- On key scan functino
    local function OnScanKey(iKey, iState, iMods, iScan)
      -- Ignore if not pressed
      if iState ~= iPress then return end;
      -- Mods were pressed?
      if iMods > 0 then
        -- Control was pressed?
        if iMods & iControl == iControl then
          -- Backspace was pressed? Set unbound
          if iKey == iBackspace then iKey = 0;
          -- C was pressed? Keep existing key
          elseif iKey == iLetterC then iKey = aBindData[1];
          -- D key was pressed? Use default
          elseif iKey == iLetterD then iKey = aBindData[5];
          -- Not recognised? Ignore press
          else return end;
        -- Do not process key with mods
        else return end;
      end
      -- Apply bind to cvar the cvar callback will change the text to the
      -- new value but won't if the value could not be changed in which we
      -- restore the original text value here.
      if aBindData[7]:Integer(iKey) ~= iVROK then aBindData[8] = sTextSave end;
      -- Restore input handlers
      RestoreKeyHandlers();
      -- Restore hot spots
      SetHotSpot(iHotSpotBind);
      -- Update readme lines
      UpdateBindsLines();
    end
    -- Set new callbacks
    InputOnKey(OnScanKey);
  end
  -- Cursor over binds area. Find which option the mouse is in
  local function HoverBinds()
    for iIndex = 1, #aReadmeVisibleLines do
      if IsMouseYLessThan(aReadmeVisibleLines[iIndex][5]) then
        iSelectedOption = iIndex;
        return;
      end
    end
  end
  -- Clear option when not hovering over anything interesting in binds screen
  local function HoverNone() iSelectedOption = 0 end;
  -- Scroll wheel moved in setup binds screen
  local function OnScrollBinds(nX, nY)
    -- Vertical scrolling?
    if     nY < 0 then ScrollBindsDown();
    elseif nY > 0 then ScrollBindsUp();
    -- Horizontal scrolling?
    elseif nX < 0 then ScrollBindsPageDown();
    elseif nX > 0 then ScrollBindsPageUp() end;
  end
  -- Register key binds screen hot spots
  iHotSpotBind = RegisterHotSpot({
    { 8,  33, 304, 174, 0, iCSelect, HoverBinds,
      OnScrollBinds, OnBindsClick        },
    { 4,   4, 312,  24, 0, iCTop,    HoverNone,
      OnScrollBinds, ScrollBindsPageUp   },
    { 4, 212, 312,  24, 0, iCBottom, HoverNone,
      OnScrollBinds, ScrollBindsPageDown },
    { 4,   4, 312, 232, 0, 0,        HoverNone,
      OnScrollBinds, false               },
    { 0,   0,   0, 240, 3, iCExit,   HoverNone,
      OnScrollBinds, GoFinish            }
  });
end
-- Return imports and exports ---------------------------------------------- --
return { A = { InitSetup = InitSetup }, F = OnScriptLoaded };
-- == End-of-File ========================================================== --

