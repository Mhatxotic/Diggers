-- ENDING.LUA ============================================================== --
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
local error<const>, max<const> = error, math.max;
-- Engine function aliases ------------------------------------------------- --
local UtilFormatNumber<const>, UtilIsInteger<const>, UtilIsTable<const> =
  Util.FormatNumber, Util.IsInteger, Util.IsTable;
-- Diggers function and data aliases --------------------------------------- --
local BlitLT, BlitSLTRB, BlitSLT, Fade, GetCallbacks, InitCredits,
  LoadResources, PlayMusic, PrintC, RegisterFBUCallback, SetCallbacks,
  SetVLTRB, VideoPlay, VideoStop, oEndingData, oGlobalData, fontLittle;
-- Locals ------------------------------------------------------------------ --
local aAssets1, aAssets2, aAssets3;    -- Assets required
local aEndingItem;                     -- Race ending data
local iActionTimer;                    -- Action timer for delays
local iMarqueePos1, iMarqueePos2;      -- Marquee position
local nStageL, nStageR;                -- Stage horizontal bounds
local nStageW, nStageH;                -- Stage dimensions
local sText1A, sText1B, sText1Bd;      -- Operations complete dialogue
local sText2A, sText2B;                -- Race specific ending dialogue
local sText3A, sText3B, sText3Ad;      -- Stranger movie dialogue
local sText3Bd;                        -- Actual animating ending texts
local texEnding;                       -- Race specific ending texture handle
local texZmtc;                         -- Zmtc texture handle
local texSpr;                          -- Sprite textures
local texTitle;                        -- Title textures
local vidEnding;                       -- Ending video
-- When ending screen 3 has faded out -------------------------------------- --
local function OnEnding3FadedOut()
  -- Remove FBO callback
  RegisterFBUCallback("ending");
  -- Destroy video and texture handles
  VideoStop();
  -- Clear variables
  aEndingItem, iActionTimer, iMarqueePos1, iMarqueePos2, nStageH, nStageL,
    nStageR, nStageW, sText1Bd, sText3Ad, sText3Bd, texZmtc, texSpr, texTitle,
    vidEnding =
      nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
      nil;
  -- Initialise final credits
  InitCredits();
end
-- Credits render callback ------------------------------------------------- --
local function ProcRenderEnding3()
  -- If we're not in widescreen?
  if nStageL == 0.0 then
    -- Draw video normally
    vidEnding:SetTCLTRB(0.0, 0.0, 1.0, 1.0);
    SetVLTRB(vidEnding, 0.0, 0.0, 320.0, 240.0);
    vidEnding:Blit();
  -- In widescreen?
  else
    -- Draw video effect for widescreen (left side)
    vidEnding:SetCRGBA(0.5, 0.5, 0.5, 1.0);
    vidEnding:SetTCLTRB(0.0, 0.0, 0.0, 1.0);
    SetVLTRB(vidEnding, 0.0, 0.0, nStageL, nStageH);
    vidEnding:Blit();
    -- Draw video effect for widescreen (right side)
    vidEnding:SetTCLTRB(1.0, 0.0, 1.0, 1.0);
    SetVLTRB(vidEnding, nStageR, 0.0, nStageW, nStageH);
    vidEnding:Blit();
    -- Draw the actual video in the centre (4:3)
    vidEnding:SetCRGBA(1.0, 1.0, 1.0, 1.0);
    vidEnding:SetTCLTRB(0.0, 0.0, 1.0, 1.0);
    SetVLTRB(vidEnding, 0.0, 0.0, nStageW, nStageH);
    vidEnding:Blit();
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
  -- Scroll text
  fontLittle:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  PrintC(fontLittle, 160.0, 200.0, sText3Ad);
  PrintC(fontLittle, 160.0, 220.0, sText3Bd);
end
-- Credits logic callback --------------------------------------------------- --
local function ProcLogicEnding3()
  -- For each 6th of a second
  if iActionTimer % 10 == 0 then
    -- Increment marquee
    if iMarqueePos1 >= #sText3A then
      if iMarqueePos2 < #sText3B then
        iMarqueePos2 = iMarqueePos2 + 1;
        sText3Bd = sText3B:sub(1, iMarqueePos2);
      end
    else
      iMarqueePos1 = iMarqueePos1 + 1;
      sText3Ad = sText3A:sub(1, iMarqueePos1);
    end
  end
  -- Increment action timer
  iActionTimer = iActionTimer + 1;
end
-- A video event occurred? ------------------------------------------------- --
local function OnVideoEvent()
  -- Get video events list and id's
  local aEvents<const> = Video.Events;
  local iStop<const>, iPause<const>, iPlay<const>, iFinish<const> =
    aEvents.STOP, aEvents.PAUSE, aEvents.PLAY, aEvents.FINISH;
  -- Actual function
  local function OnVideoEvent(iEvent)
    -- Paused, stopped or finished?
    if iEvent == iStop or iEvent == iFinish then
      -- We someone took our render callback (i.e. setup) then we need to
      -- to switch render proc
      local _, CBRender = GetCallbacks();
      if CBRender == ProcRenderEnding3 then
        return Fade(0.0, 1.0, 0.005, ProcRenderEnding3,
          OnEnding3FadedOut, true) end;
    end
  end
  -- Return actual function
  return OnVideoEvent;
end
OnVideoEvent = OnVideoEvent();
-- When ending 3 resources have loaded ------------------------------------- --
local function OnEnding3AssetsLoaded(aResources)
  -- Load stranger texture and tiles
  vidEnding, texTitle = aResources[1], aResources[2];
  -- Set video event callback
  vidEnding:OnEvent(OnVideoEvent);
  -- Play the video
  VideoPlay(vidEnding);
  -- Wait on ending screen 3
  SetCallbacks(ProcLogicEnding3, ProcRenderEnding3);
end
-- Register frame buffer update -------------------------------------------- --
local function OnStageUpdated(_, _, iStageL, _, iStageR, _, iStageW, iStageH)
  nStageL, nStageR, nStageW, nStageH =
    iStageL + 0.0, iStageR + 0.0, iStageW + 0.0, iStageH + 0.0;
end
-- When ending screen 2 has faded out -------------------------------------- --
local function OnEnding2FadedOut()
  -- Dereference ending asset to garbage collector
  texEnding = nil;
  -- Reset action timer
  iActionTimer = 0;
  -- Reset final text positions
  iMarqueePos1, iMarqueePos2 = 0, 0;
  sText3Ad, sText3Bd = "", "";
  -- Register a callback so we know when the viewport has changed
  RegisterFBUCallback("ending", OnStageUpdated);
  -- Load ending 3 resources
  LoadResources("Ending3", aAssets3, OnEnding3AssetsLoaded);
end
-- Render ending part 2 ---------------------------------------------------- --
local function ProcRenderEnding2()
  -- Draw background
  BlitLT(texEnding, -54.0, 0.0);
  -- Draw text
  fontLittle:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  PrintC(fontLittle, 160.0, 200.0, sText2A);
  PrintC(fontLittle, 160.0, 220.0, sText2B);
end
-- Ending two procedure ---------------------------------------------------- --
local function ProcLogicEnding2()
  -- Increment action timer and done if action timer not reached yet
  iActionTimer = iActionTimer + 1;
  if iActionTimer < 600 then return end
  -- Fade out on ending screen 2
  Fade(0.0, 1.0, 0.01, ProcRenderEnding2, OnEnding2FadedOut);
end
-- When render part 2 has faded in ----------------------------------------- --
local function OnEnding2FadedIn()
  -- Wait on ending screen 2
  SetCallbacks(ProcLogicEnding2, ProcRenderEnding2);
end
-- Ending screen 2 resources loaded? --------------------------------------- --
local function OnEnding2AssetsLoaded(aResources)
  -- Load texture and tiles
  texEnding = aResources[1];
  -- Set custom race specific texts
  sText2A, sText2B = aEndingItem[2], aEndingItem[3];
  -- Fade in ending screen 2
  Fade(1.0, 0.0, 0.01, ProcRenderEnding2, OnEnding2FadedIn);
end
-- When ending 1 has faded out --------------------------------------------- --
local function OnEnding1FadedOut()
  -- Dereference lobby asset to garbage collector
  texZmtc = nil;
  -- Reset action timer
  iActionTimer = 0;
  -- Set race scene filename
  aAssets2[1].F = "endrace"..aEndingItem[1];
  -- Load ending screen 2 resource
  LoadResources("Ending2", aAssets2, OnEnding2AssetsLoaded);
end
-- Render callback --------------------------------------------------------- --
local function ProcRenderEnding1()
  -- Draw background
  BlitLT(texZmtc, -96.0, 0.0);
  -- Draw text
  fontLittle:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  PrintC(fontLittle, 160.0, 200.0, sText1A);
  PrintC(fontLittle, 160.0, 220.0, sText1Bd);
end
-- First ending scene waiting ---------------------------------------------- --
local function ProcLogicEnding1()
  -- Increment action timer and done if action timer not reached yet
  iActionTimer = iActionTimer + 1;
  if iActionTimer < 600 then return end;
  -- Fade out ending screen 1
  Fade(0.0, 1.0, 0.01, ProcRenderEnding1, OnEnding1FadedOut);
end
-- First ending screen procedure ------------------------------------------- --
local function OnEnding1FadedIn()
  -- Reset action timer
  iActionTimer = 0;
  -- Wait on ending screen 1
  SetCallbacks(ProcLogicEnding1, ProcRenderEnding1);
end
-- When assets have loaded? ------------------------------------------------ --
local function OnEnding1AssetsLoaded(aResources)
  -- Play win music
  PlayMusic(aResources[2]);
  -- Load lobby texture
  texZmtc = aResources[1];
  -- Set dynamic completed text
  sText1Bd = UtilFormatNumber(oGlobalData.gBankBalance, 0).." OF THE "..
             UtilFormatNumber(oGlobalData.gZogsToWinGame, 0).." "..sText1B;
  -- Fade in to ending screen 1 (Mining operations complete!)
  Fade(1.0, 0.0, 0.01, ProcRenderEnding1, OnEnding1FadedIn);
end
-- Init ending screen functions -------------------------------------------- --
local function InitEnding(iRaceId)
  -- Check race id and check ending data
  if not UtilIsInteger(iRaceId) then error("No race id specified!") end;
  aEndingItem = oEndingData[iRaceId];
  if not UtilIsTable(oEndingData) then error("Invalid race id!") end;
  -- Load bank texture
  LoadResources("Ending1", aAssets1, OnEnding1AssetsLoaded);
end
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Grab imports
  BlitLT, BlitSLT, BlitSLTRB, Fade, GetCallbacks, InitCredits, LoadResources,
    PlayMusic, PrintC, RegisterFBUCallback, SetCallbacks, SetVLTRB, VideoPlay,
    VideoStop, oEndingData, oGlobalData, fontLittle, texSpr =
      GetAPI("BlitLT", "BlitSLT", "BlitSLTRB", "Fade", "GetCallbacks",
        "InitCredits", "LoadResources", "PlayMusic", "PrintC",
        "RegisterFBUCallback", "SetCallbacks", "SetVLTRB", "VideoPlay",
        "VideoStop", "oEndingData", "oGlobalData", "fontLittle", "texSpr");
  -- Setup required assets
  local oAssetsData<const> = GetAPI("oAssetsData");
  aAssets1 = { oAssetsData.zmtc, oAssetsData.postm };
  aAssets2 = { oAssetsData.ending2 };
  aAssets3 = { oAssetsData.ending3, oAssetsData.title };
  -- Set ending texts
  local aEnding1Data<const> = oEndingData[-1];
  sText1A, sText1B = aEnding1Data[1], aEnding1Data[2];
  local aEnding3Data<const> = oEndingData[-2];
  sText3A, sText3B = aEnding3Data[1], aEnding3Data[2];
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitEnding = InitEnding }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
