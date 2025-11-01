-- INTRO.LUA =============================================================== --
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
local error<const>, max<const>, maxinteger<const> =
  error, math.max, math.maxinteger;
-- Engine function aliases ------------------------------------------------- --
local UtilBlank<const>, CoreTime<const>, UtilIsInteger<const> =
  Util.Blank, Core.Time, Util.IsInteger;
-- Diggers function and data aliases --------------------------------------- --
local BlitSLT, BlitSLTRB, BlitLT, Fade, GetCallbacks, InitSetup, InitTitle,
  LoadResources, PrintC, RegisterFBUCallback, RenderFade, RenderShadow,
  SetCallbacks, SetCursorPos, SetHotSpot, SetVLTRB, VideoPlay, VideoStop,
  aIntroSubTitles, fontLittle, texSpr, SetKeys;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Assets data to load
      aSubTitle,                       -- Active subtitle to wait for
      fcbOnFadeIn,                     -- Callback to run on fade in
      fcbRender,                       -- Rendering function
      iHotSpotId,                      -- Hotspot id
      iKeyBankId,                      -- Keybank id
      iSubTitle, iFrameEnd,            -- Subtitle and frame end
      iSubTitle1, iSubTitle2,          -- First and second line subtitle id
      nFWidth, nFHeight, nPadding,     -- Font sizes and padding
      nFadeX, nFadeY1, nFadeY2,        -- Fade values
      nStageST,                        -- Subtitle position
      nStageT, nStageR, nStageB,       -- Stage top, right and bottom
      nStageW, nStageH, nStageL,       -- Stage width, height and left
      sSubTitle1, sSubTitle2,          -- First and second line of subtitles
      texTitle,                        -- Texture handle
      vidVideo;                        -- Video handle
-- Playing procedure() ----------------------------------------------------- --
local function ProcRenderPlaying()
  -- If we're not in widescreen?
  if nStageL == 0.0 then
    -- Draw video normally
    vidVideo:SetTCLTRB(0.0, 0.0, 1.0, 1.0);
    SetVLTRB(vidVideo, 0.0, 0.0, 320.0, 240.0);
    vidVideo:Blit();
  -- In widescreen?
  else
    -- Draw video effect for widescreen (left side)
    vidVideo:SetCRGBA(0.5, 0.5, 0.5, 1.0);
    vidVideo:SetTCLTRB(0.0, 0.0, 0.0, 1.0);
    SetVLTRB(vidVideo, 0.0, 0.0, nStageL, nStageH);
    vidVideo:Blit();
    -- Draw video effect for widescreen (right side)
    vidVideo:SetTCLTRB(1.0, 0.0, 1.0, 1.0);
    SetVLTRB(vidVideo, nStageR, 0.0, nStageW, nStageH);
    vidVideo:Blit();
    -- Draw the actual video in the centre (4:3)
    vidVideo:SetCRGBA(1.0, 1.0, 1.0, 1.0);
    vidVideo:SetTCLTRB(0.0, 0.0, 1.0, 1.0);
    SetVLTRB(vidVideo, 0.0, 0.0, nStageW, nStageH);
    vidVideo:Blit();
    -- Draw transparent tiles over the top of the widescreen border
    texTitle:SetCA(0.5);
    for nY = 0.0, nStageH, 16.0 do
      for nX = -16.0, nStageL - 16.0, -16.0 do
        BlitSLT(texTitle, 5, nX, nY) end;
      for nX = nStageW, nStageR, 16.0 do
        BlitSLT(texTitle, 5, nX, nY) end;
    end
    texTitle:SetCA(1.0);
    -- Draw shadow
    texSpr:SetCA(0.75);
    BlitSLTRB(texSpr, 1023,   0.0, 0.0,  -1.0, 240.0);
    BlitSLTRB(texSpr, 1023, 320.0, 0.0, 321.0, 240.0);
    texSpr:SetCA(0.5);
    BlitSLTRB(texSpr, 1023,  -1.0, 0.0,  -2.0, 240.0);
    BlitSLTRB(texSpr, 1023, 321.0, 0.0, 322.0, 240.0);
    texSpr:SetCA(0.25);
    BlitSLTRB(texSpr, 1023,  -2.0, 0.0,  -3.0, 240.0);
    BlitSLTRB(texSpr, 1023, 322.0, 0.0, 323.0, 240.0);
    texSpr:SetCA(1.0);
  end
  -- Get frame number
  local iFrame<const> = vidVideo:GetFrame();
  -- Have subtitle?
  if sSubTitle1 then
    -- Calculate nX position of rectangle
    local nFadeX1<const> = nStageST - nFadeX;
    local nFadeX2<const> = nStageST + nFadeX;
    -- Draw subtitle background and shadow
    RenderFade(0.75, nFadeX1, nFadeY1, nFadeX2, nFadeY2);
    RenderShadow(nFadeX1, nFadeY1, nFadeX2, nFadeY2);
    -- Draw subtitle
    PrintC(fontLittle, nStageST, iSubTitle1, sSubTitle1);
    -- If we have subtitle two
    if sSubTitle2 then
      PrintC(fontLittle, nStageST, iSubTitle2, sSubTitle2) end;
    -- Hide subtitle if timed out
    if iFrame >= iFrameEnd then sSubTitle1, sSubTitle2 = nil, nil end;
  end
  -- Get next subtitle data
  if iFrame >= aSubTitle[1] then
    -- Grab new fade bounds
    nFadeX, nFadeY1, nFadeY2 = aSubTitle[6], aSubTitle[7], aSubTitle[8];
    -- Set subtitle position
    iSubTitle1, iSubTitle2 = aSubTitle[4], aSubTitle[5];
    -- Set new subtile, ending time and next id
    sSubTitle1, sSubTitle2, iFrameEnd =
      aSubTitle[3][1], aSubTitle[3][2], aSubTitle[2];
    -- Set next sub-title to monitor
    iSubTitle = iSubTitle + 1;
    aSubTitle = aIntroSubTitles[iSubTitle] or { maxinteger };
  end
end
-- Not playing procedure --------------------------------------------------- --
local function ProcRenderSetup()
  -- Draw background
  texTitle:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  BlitLT(texTitle, -96.0, 0.0);
  -- Don't draw anything if in 4:3 mode
  if nStageL >= 0 then return end;
  -- Draw sidebar scrolling logo's
  local nWidth<const> = -nStageL - 4.0;
  local nAspect<const> = 208.0 / 58.0;
  local nHeight<const> = nWidth * nAspect;
  local nLX = (CoreTime() * 100.0) % 240.0;
  local nLY = -nLX;
  local nX<const> = nStageL + 4.0;
  local nXpWidth<const> = nX + nWidth;
  local nHeightPiLX = nHeight + nLX;
  local nHeightPiLY = nHeight + nLY;
  local nXRight<const> = 320.0 + nWidth;
  texTitle:SetCA(0.25);
  BlitSLTRB(texTitle, 1, nX, -240.0 + nLX, nXpWidth, -240.0 + nHeightPiLX);
  BlitSLTRB(texTitle, 1, nX,          nLX, nXpWidth,          nHeightPiLX);
  BlitSLTRB(texTitle, 1, nX,  240.0 + nLX, nXpWidth,  240.0 + nHeightPiLX);
  BlitSLTRB(texTitle, 1, nXRight,         nHeightPiLY, 320.0,         nLY);
  BlitSLTRB(texTitle, 1, nXRight, 240.0 + nHeightPiLY, 320.0, 240.0 + nLY);
  BlitSLTRB(texTitle, 1, nXRight, 480.0 + nHeightPiLY, 320.0, 480.0 + nLY);
  nLX = -nLX;
  nLY = -nLY - 240.0;
  nHeightPiLX = nHeight + nLX;
  nHeightPiLY = nHeight + nLY;
  BlitSLTRB(texTitle, 1, nX, -240.0 + nLX, nXpWidth, -240.0 + nHeightPiLX);
  BlitSLTRB(texTitle, 1, nX,          nLX, nXpWidth,          nHeightPiLX);
  BlitSLTRB(texTitle, 1, nX,  240.0 + nLX, nXpWidth,  240.0 + nHeightPiLX);
  BlitSLTRB(texTitle, 1, nXRight,         nHeightPiLY, 320.0,         nLY);
  BlitSLTRB(texTitle, 1, nXRight, 240.0 + nHeightPiLY, 320.0, 240.0 + nLY);
  BlitSLTRB(texTitle, 1, nXRight, 480.0 + nHeightPiLY, 320.0, 480.0 + nLY);
end
-- Call render function ---------------------------------------------------- --
local function ProcRender() fcbRender() end;
-- When video has faded out? ----------------------------------------------- --
local function OnFadedOutToTitle()
  -- Remove frame buffer update callback
  RegisterFBUCallback("intro");
  -- Destroy video and texture handles
  VideoStop();
  -- Dereference loaded assets for garbage collector
  texTitle, vidVideo = nil, nil;
  -- Load title screen
  InitTitle();
end
-- GoTitle function --------------------------------------------------------- --
local function GoTitle()
  -- Remove event function
  vidVideo:OnEvent(UtilBlank);
  -- Start fading out
  Fade(0.0, 1.0, 0.032, ProcRender, OnFadedOutToTitle, true);
end
-- A video event occurred? ------------------------------------------------- --
local function OnVideoEvent()
  -- Get video events list and id's
  local oEvents<const> = Video.Events;
  local iStop<const>, iPause<const>, iPlay<const>, iFinish<const> =
    oEvents.STOP, oEvents.PAUSE, oEvents.PLAY, oEvents.FINISH;
  -- Actual function
  local function OnVideoEvent(iEvent)
    -- Playing?
    if iEvent == iPlay then
      -- If we were in our render loop? Transition to title screen
      if fcbRender == ProcRenderSetup then
         fcbRender = ProcRenderPlaying end;
    -- Paused?
    elseif iEvent == iPause then
      -- Set pause screen if not already done so
      if CBRender == ProcRenderSetup then fcbRender = ProcRenderSetup end;
    -- Stopped or finished?
    elseif iEvent == iStop or iEvent == iFinish then
      -- We someone took our render callback (i.e. setup) then we need to
      -- to switch render proc
      local _, CBRender = GetCallbacks();
      if CBRender == ProcRender then return GoTitle() end;
      -- If we were not in our render loop (i.e. setup?)
      fcbRender = ProcRenderSetup;
    end
  end
  -- Return actual function
  return OnVideoEvent;
end
OnVideoEvent = OnVideoEvent();
-- Play video and setup event ---------------------------------------------- --
local function SetupVideo()
  -- Set video event callback
  vidVideo:OnEvent(OnVideoEvent);
  -- Play the video
  VideoPlay(vidVideo);
end
-- Register frame buffer update -------------------------------------------- --
local function OnStageUpdated(_, _, iStageL, iStageT, iStageR, iStageB,
  iStageW, iStageH)
  -- Calculate number version of integers
  nStageL, nStageT, nStageR, nStageB, nStageW, nStageH =
   iStageL + 0.0, iStageT + 0.0, iStageR + 0.0,
   iStageB + 0.0, iStageW + 0.0, iStageH + 0.0;
  -- Half width of stage width
  nStageST = nStageW / 2.0;
end
-- When video has faded in? ------------------------------------------------ --
local function OnFadeIn()
  -- Enable keybank and set hotspot to detect clink
  SetKeys(true, iKeyBankId);
  SetHotSpot(iHotSpotId);
  -- Set intro callbacks
  SetCallbacks(nil, ProcRender);
  -- Load setup now
  if fcbOnFadeIn then fcbOnFadeIn() end;
end
-- On faded in go setup ---------------------------------------------------- --
local function OnFadeInGoSetup()
  -- Play the intro
  SetupVideo()
  -- Show the setup screen
  InitSetup(1);
  -- Force the mouse to a position so they can read the intro text
  SetCursorPos(10, 220);
end
-- When intro resources have loaded? --------------------------------------- --
local function OnAssetsLoaded(aResources, bAndSetup)
  -- Subtitle position
  nStageST = 0;
  -- Register a callback so we know when the viewport has changed
  RegisterFBUCallback("intro", OnStageUpdated);
  -- Get the texture handle that was loaded
  texTitle = aResources[1];
  -- Set handle and filter for intro video
  vidVideo = aResources[2];
  vidVideo:SetFilter(false);
  -- Subtitles list
  iSubTitle, iFrameEnd = 1, maxinteger;
  -- For each credit
  for iI = 1, #aIntroSubTitles do
    -- Get subtitle item and we must have at least 3 leans
    local aSubTitle<const> = aIntroSubTitles[iI];
    -- Check parameter count
    if #aSubTitle < 3 then error("Not enough items on "..iI.."!") end;
    if #aSubTitle > 4 then error("Too many items on "..iI.."!") end;
    -- Verify frame start
    local iFrStart<const> = aSubTitle[1];
    if not UtilIsInteger(iFrStart) or iFrStart < 0 then
      error("Invalid start '"..tostring(iFrStart).."' on "..iI.."!") end;
    -- Verify frame end
    local iFrEnd<const> = aSubTitle[1];
    if not UtilIsInteger(iFrEnd) or iFrEnd < 0 then
      error("Invalid end '"..tostring(iFrEnd).."' on "..iI.."!") end;
    -- Get subtitles
    local aSubTitleTexts<const> = aSubTitle[3];
    local sSubTitle1<const> = aSubTitleTexts[1];
    local sSubTitle2<const> = aSubTitleTexts[2];
    -- Calculate length of first subtitle and if we have 2nd subtitle?
    local nWidth = #sSubTitle1 * nFWidth;
    if sSubTitle2 then
      -- Which subtitle is longest?
      nWidth = max(nWidth, #sSubTitle2 * nFWidth);
      -- Insert first and second subtitle Y position
      aSubTitle[1 + #aSubTitle] = 200.0; -- [4]
      aSubTitle[1 + #aSubTitle] = 210.0; -- [5]
    else
      -- Insert first and second (n/a) subtitle Y position
      aSubTitle[1 + #aSubTitle] = 206.0; -- [4]
      aSubTitle[1 + #aSubTitle] = 206.0; -- [5]
    end
    -- Insert half width of subtitle box plus padding
    aSubTitle[1 + #aSubTitle] = (nWidth / 2.0) + nPadding; -- [6]
    -- Insert top position of subtitle box minus padding
    aSubTitle[1 + #aSubTitle] = aSubTitle[4] - nPadding; -- [7]
    -- Insert bottom position of subtitle box plus font height plus padding
    aSubTitle[1 + #aSubTitle] = aSubTitle[5] + nFHeight + nPadding; -- [8]
  end
  -- Set first active subtitle to wait for
  aSubTitle = aIntroSubTitles[iSubTitle];
  -- ProcRender proc
  fcbRender = ProcRenderSetup;
  -- If not setup requested, we're done
  if bAndSetup then
    -- Show setup on faded in
    fcbOnFadeIn = OnFadeInGoSetup;
    -- Do the fade in
    Fade(1.0, 0.0, 0.025, ProcRender, OnFadeIn);
  -- Setup not requested?
  else
    -- Just play video on fade in
    fcbOnFadeIn = SetupVideo;
    -- Prevent the graphic being shown for a couple of frames
    fcbRender = ProcRenderPlaying;
    -- No transition because the intro already has a transition
    OnFadeIn();
  end
end
-- Intro initialisation function ------------------------------------------- --
local function InitIntro(bAndSetup)
  -- Load resources asynchronously. Note: use 'ffmpeg2theora' and not 'ffmpeg'
  -- to encode proper quality videos.
  LoadResources("Intro", aAssets, OnAssetsLoaded, bAndSetup);
end
-- When script has loaded -------------------------------------------------- --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, oAssetsData, iTexScale;
  -- Get imports
  BlitSLT, BlitSLTRB, BlitLT, Fade, GetCallbacks, InitSetup, InitTitle,
    LoadResources, PrintC, RegisterFBUCallback, RegisterHotSpot, RegisterKeys,
    RenderFade, RenderShadow, SetCallbacks, SetCursorPos, SetHotSpot, SetKeys,
    SetVLTRB, VideoPlay, VideoStop, oAssetsData, aIntroSubTitles, fontLittle,
    texSpr, iTexScale =
      GetAPI("BlitSLT", "BlitSLTRB", "BlitLT", "Fade", "GetCallbacks",
        "InitSetup", "InitTitle", "LoadResources", "PrintC",
        "RegisterFBUCallback", "RegisterHotSpot", "RegisterKeys", "RenderFade",
        "RenderShadow", "SetCallbacks", "SetCursorPos", "SetHotSpot",
        "SetKeys", "SetVLTRB", "VideoPlay", "VideoStop", "oAssetsData",
        "aIntroSubTitles", "fontLittle", "texSpr", "iTexScale");
  -- Build assets to load
  aAssets = { oAssetsData.title, oAssetsData.intro };
  -- Get font size and padding
  nFWidth, nFHeight, nPadding =
    fontLittle:GetWidth() / iTexScale,
    fontLittle:GetHeight() / iTexScale, 5.0;
  -- Register keybinds
  iKeyBankId = RegisterKeys("TITLE INTRO", {
    [Input.States.PRESS] =
      { { Input.KeyCodes.ESCAPE, GoTitle, "tic", "CANCEL" } }
  });
  -- Register full-screen hotspot
  iHotSpotId = RegisterHotSpot({
    { 0, 0, 0, 240, 3, 0, false, false, GoTitle }
  });
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitIntro = InitIntro }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
