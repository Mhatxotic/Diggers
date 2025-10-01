-- BLIT.LUA ================================================================ --
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
local collectgarbage<const> = collectgarbage;
-- Engine function aliases ------------------------------------------------- --
local CoreCatchup<const>, CoreTime<const>, FontPrint<const>, FontPrintC<const>,
  FontPrintCT<const>, FontPrintM<const>, FontPrintR<const>, FontPrintS<const>,
  FontPrintU<const>, FontPrintUR<const>, FontPrintW<const>, FontPrintWS<const>,
  TextureBlitLTRB<const>, TextureBlitSLTA<const>, TextureBlitSLTWHA<const>,
  TextureBlitSLTWH<const>, TextureBlitLT<const>, TextureBlitSLT<const>,
  TextureBlitSLTRB<const>, TextureTileA<const>, UtilClamp<const>,
  UtilIsFunction<const>, UtilIsNumber<const>, VideoSetVLTRB<const> =
    Core.Catchup, Core.Time, Font.Print, Font.PrintC, Font.PrintCT,
    Font.PrintM, Font.PrintR, Font.PrintS, Font.PrintU, Font.PrintUR,
    Font.PrintW, Font.PrintWS, Texture.BlitLTRB, Texture.BlitSLTA,
    Texture.BlitSLTWHA, Texture.BlitSLTWH, Texture.BlitLT, Texture.BlitSLT,
    Texture.BlitSLTRB, Texture.TileA, Util.Clamp, Util.IsFunction,
    Util.IsNumber, Video.SetVLTRB;
-- Library functions loaded later ------------------------------------------ --
local ClearStates, IsMouseInBounds, MusicVolume, SetCallbacks, SetHotSpot,
  SetKeys;
-- Locals ------------------------------------------------------------------ --
local fcbFading = false;               -- Fading callback
local fontLittle,                      -- Little font
      nLoadX, nLoadY,                  -- Loader position
      nStageB, nStageL,                -- Stage bottom and left co-ord
      nStageR, nStageT,                -- Stage right and top co-ord
      nTexScale,                       -- Texture scale
      sTip,                            -- Current tip and bounds
      texSpr;                          -- Sprites texture
-- Print text left with scale ---------------------------------------------- --
local function Print(fontHandle, nX, nY, sText)
  FontPrint(fontHandle, nX * nTexScale, nY * nTexScale, sText);
end
-- Print text centre with scale -------------------------------------------- --
local function PrintC(fontHandle, nX, nY, sText)
  FontPrintC(fontHandle, nX * nTexScale, nY * nTexScale, sText);
end
-- Print text centre with texture glyphs and scale ------------------------- --
local function PrintCT(fontHandle, nX, nY, sText, texHandle)
  FontPrintCT(fontHandle, nX * nTexScale, nY * nTexScale, sText, texHandle);
end
-- Print text right with scale --------------------------------------------- --
local function PrintR(fontHandle, nX, nY, sText)
  FontPrintR(fontHandle, nX * nTexScale, nY * nTexScale, sText);
end
-- Simulate a print with maximum width ------------------------------------- --
local function PrintWS(fontHandle, nWidth, strText)
  return FontPrintWS(fontHandle, nWidth * nTexScale, 0, strText) / nTexScale;
end
-- Print with maximum width ------------------------------------------------ --
local function PrintW(fontHandle, nX, nY, nWrapX, strText)
  FontPrintW(fontHandle, nX * nTexScale, nY * nTexScale,
    nWrapX * nTexScale, 0, strText);
end
-- Simulate a print -------------------------------------------------------- --
local function PrintS(fontHandle, strText)
  return FontPrintS(fontHandle, strText) / nTexScale;
end
-- Print a scrolling string ------------------------------------------------ --
local function PrintM(fontHandle, nX, nY, nScroll, nWidth, sText)
  FontPrintM(fontHandle, nX * nTexScale, nY * nTexScale,
    nScroll * nTexScale, nWidth * nTexScale, sText);
end
-- Print text upwards (left align) ----------------------------------------- --
local function PrintU(fontHandle, nX, nY, sText)
  FontPrintU(fontHandle, nX * nTexScale, nY * nTexScale, sText);
end
-- Print text upwards (right align) ---------------------------------------- --
local function PrintUR(fontHandle, nX, nY, sText)
  FontPrintUR(fontHandle, nX * nTexScale, nY * nTexScale, sText);
end
-- Blit bounds with scale -------------------------------------------------- --
local function BlitLTRB(texHandle, nX1, nY1, nX2, nY2)
  TextureBlitLTRB(texHandle, nX1 * nTexScale, nY1 * nTexScale,
                             nX2 * nTexScale, nY2 * nTexScale);
end
-- Blit tile/coords/size/angle with scale ---------------------------------- --
local function BlitSLTWHA(texHandle, iTileId, nX, nY, nW, nH, nA)
  TextureBlitSLTWHA(texHandle, iTileId, nX * nTexScale, nY * nTexScale,
                                        nW * nTexScale, nH * nTexScale, nA);
end
-- Blit tile/coords/size with scale ---------------------------------------- --
local function BlitSLTWH(texHandle, iTileId, nX, nY, nW, nH)
  TextureBlitSLTWH(texHandle, iTileId, nX * nTexScale, nY * nTexScale,
                                       nW * nTexScale, nH * nTexScale);
end
-- Blit tile/bounds with scale --------------------------------------------- --
local function BlitSLTRB(texHandle, iTileId, nX1, nY1, nX2, nY2)
  TextureBlitSLTRB(texHandle, iTileId, nX1 * nTexScale, nY1 * nTexScale,
                                       nX2 * nTexScale, nY2 * nTexScale);
end
-- Blit tile/x/y with scale ------------------------------------------------ --
local function BlitSLT(texHandle, iTileId, nX, nY)
  TextureBlitSLT(texHandle, iTileId, nX * nTexScale, nY * nTexScale);
end
-- Blit tile/x/y with scale and angle -------------------------------------- --
local function BlitSLTA(texHandle, iTileId, nX, nY, nAngle)
  TextureBlitSLTA(texHandle, iTileId, nX * nTexScale, nY * nTexScale, nAngle);
end
-- Blit x/y with scale ----------------------------------------------------- --
local function BlitLT(texHandle, nX, nY)
  TextureBlitLT(texHandle, nX * nTexScale, nY * nTexScale);
end
-- Set vertex for video handle --------------------------------------------- --
local function SetVLTRB(vidHandle, nX1, nY1, nX2, nY2)
  VideoSetVLTRB(vidHandle, nX1 * nTexScale, nY1 * nTexScale,
                           nX2 * nTexScale, nY2 * nTexScale);
end
-- Add a tile to a texture ------------------------------------------------- --
local function TileA(texHandle, nX1, nY1, nX2, nY2)
  return TextureTileA(texHandle, nX1 * nTexScale, nY1 * nTexScale,
                                 nX2 * nTexScale, nY2 * nTexScale);
end
-- Do render the tip ------------------------------------------------------- --
local function DoRenderTip(nX)
  -- Draw the background of the tip rect
  BlitSLT(texSpr, 847, nX,        216.0);
  BlitSLT(texSpr, 848, nX + 16.0, 216.0);
  BlitSLT(texSpr, 848, nX + 32.0, 216.0);
  BlitSLT(texSpr, 848, nX + 48.0, 216.0);
  BlitSLT(texSpr, 849, nX + 64.0, 216.0);
  -- Set tip colour and render the text
  fontLittle:SetCRGB(1.0, 1.0, 1.0);
  PrintC(fontLittle, nX + 40.0, 220.0, sTip);
end
-- Render the tip in the bottom right -------------------------------------- --
local function RenderTip()
  -- Return if no tip
  if not sTip then return end;
  -- Draw tip in different positions if mouse cursor is over the tip
  if IsMouseInBounds(232, 216, 312, 232) then DoRenderTip(144.0);
                                         else DoRenderTip(232.0) end;
end
-- Render shadow ----------------------------------------------------------- --
local function RenderShadow(nLeft, nTop, nRight, nBottom)
  -- Draw a shadow using the solid sprite
  texSpr:SetCA(0.2);
  -- Horizontal row 1
  BlitSLTRB(texSpr, 1023, nLeft + 3.0, nBottom, nRight, nBottom + 1.0);
  -- Vertical column 1
  BlitSLTRB(texSpr, 1023, nRight, nTop + 3.0, nRight + 1.0, nBottom);
  texSpr:SetCA(0.1);
  -- Horizontal row 2
  BlitSLTRB(texSpr, 1023, nLeft + 4.0, nBottom, nRight, nBottom + 2.0);
  -- Vertical column 2
  BlitSLTRB(texSpr, 1023, nRight, nTop + 4.0, nRight + 2.0, nBottom);
  -- Horizontal corner 1
  BlitSLTRB(texSpr, 1023, nRight, nBottom, nRight + 2.0, nBottom + 1.0);
  -- Vertical corner 2
  BlitSLTRB(texSpr, 1023, nRight, nBottom, nRight + 1.0, nBottom + 2.0);
  texSpr:SetCA(0.05);
  -- Horizontal row 3
  BlitSLTRB(texSpr, 1023, nLeft + 5.0, nBottom, nRight, nBottom + 3.0);
  -- Vertical column 3
  BlitSLTRB(texSpr, 1023, nRight, nTop + 5.0, nRight + 3.0, nBottom);
  texSpr:SetCA(1.0);
end
-- Render the tip and shadow ----------------------------------------------- --
local function RenderTipShadow()
  -- Return if no tip
  if not sTip then return end;
  -- Render the tip
  DoRenderTip(232.0)
  -- Render the shadow
  RenderShadow(232.0, 216.0, 312.0, 232.0);
end;
-- Set bottom right tip ---------------------------------------------------- --
local function SetTip(strTip) sTip = strTip end;
-- Loading indicator ------------------------------------------------------- --
local function ProcLoader()
  texSpr:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  BlitSLTA(texSpr, 801, nLoadX, nLoadY, CoreTime() * 2.0);
end
-- Render fade ------------------------------------------------------------- --
local function RenderFade(nAmount, nLeft, nTop, nRight, nBottom, iS)
  texSpr:SetCA(nAmount);
  BlitSLTRB(texSpr, iS or 1023,
    nLeft or nStageL, nTop or nStageT,
    nRight or nStageR, nBottom or nStageB);
  texSpr:SetCA(1.0);
end
-- Fade -------------------------------------------------------------------- --
local function Fade(nStart, nEnd, nStep, fcbDuring, fcbAfter, bAndMusic)
  -- Check parameters
  if not UtilIsNumber(nStart) then
    error("Invalid starting value number! "..tostring(nStart)) end;
  if not UtilIsNumber(nEnd) then
    error("Invalid ending value number! "..tostring(nEnd)) end;
  if not UtilIsNumber(nStep) then
    error("Invalid fade inc/decremember value! "..tostring(nStep)) end
  if not UtilIsFunction(fcbAfter) then
    error("Invalid after function! "..tostring(fcbAfter)) end;
  -- If already fading, run the after function
  if UtilIsFunction(fcbFading) then fcbFading() end;
  -- Disable all keybanks and globals
  SetKeys(false);
  -- Disable hotspots
  SetHotSpot();
  -- During function
  local function During(nVal)
    -- Clear states
    ClearStates();
    -- Call users during function
    fcbDuring();
    -- Clamp new fade value
    nStart = UtilClamp(nVal, 0.0, 1.0);
    -- Render blackout
    RenderFade(nStart, nStageL, StageTop, nStageR, nStageB);
    -- Fade music too
    if bAndMusic then MusicVolume(1.0 - nStart) end;
  end
  -- Finished function
  local function Finish()
    -- Reset fade vars
    nStart, fcbFading = nEnd, nil;
    -- Enable global keys
    SetKeys(true);
    -- Just draw tip while the after function decides what to do
    SetCallbacks(nil, ProcLoader);
    -- Call the after function
    fcbAfter();
  end
  -- Cleanup function
  local function Clean()
    -- Garbage collect
    collectgarbage();
    -- Reset hi-res timer
    CoreCatchup();
  end
  -- Fade out?
  if nStart < nEnd then
    -- Save old fade function
    fcbFading = fcbAfter;
    -- Function during
    local function ProcFadeOut()
      -- Fade out
      During(nStart + nStep);
      -- Finished if we reached the ending point
      if nStart < nEnd then return end;
      -- Cleanup
      Clean();
      -- Call finish function
      Finish()
    end
    -- Set fade out procedure
    SetCallbacks(nil, ProcFadeOut);
  -- Fade in?
  elseif nStart > nEnd then
    -- Cleanup
    Clean();
    -- Save old fade function
    fcbFading = fcbAfter;
    -- Function during
    local function OnFadeInFrame()
      -- Fade in
      During(nStart - nStep);
      -- Finished if we reached the ending point
      if nStart <= nEnd then Finish() end;
    end
    -- Set fade in procedure
    SetCallbacks(nil, OnFadeInFrame);
  -- Ending already reached?
  else
    -- Cleanup
    Clean();
    -- Call finish function
    Finish();
  end
end
-- Set frame buffer update callback (always active) ------------------------ --
local function OnStageUpdated(_, _, iStageL, iStageT, iStageR, iStageB)
  nStageL, nStageT, nStageR, nStageB =
    iStageL + 0.0, iStageT + 0.0, iStageR + 0.0, iStageB + 0.0;
  nLoadX, nLoadY = nStageR - 24.0, nStageB - 24.0;
end
-- Script ready function --------------------------------------------------- --
local function OnScriptLoaded(GetAPI)
  -- Functions only for this scope
  local RegisterFBUCallback;
  -- Get and store texture scale
  ClearStates, IsMouseInBounds, MusicVolume, RegisterFBUCallback, SetCallbacks,
    SetHotSpot, SetKeys, fontLittle, nTexScale, texSpr =
      GetAPI("ClearStates", "IsMouseInBounds", "MusicVolume",
        "RegisterFBUCallback", "SetCallbacks", "SetHotSpot", "SetKeys",
        "fontLittle", "iTexScale", "texSpr");
  -- Convert texture scale to number
  nTexScale = nTexScale + 0.0;
  -- Set frame buffer update callback (always active)
  RegisterFBUCallback("blit", OnStageUpdated);
  -- Return if texture scale is set to 1
  if nTexScale <= 1 then return end;
  -- Enumerate cursor id datas
  for iId, aCData in pairs(GetAPI("aCursorData")) do
    -- Save original cursor id position adjustments
    local nX<const>, nY<const> = aCData[3], aCData[4];
    -- Backup values
    aCData[5], aCData[6] = nX, nY;
    -- Scale current values
    aCData[3] = nX * nTexScale;
    aCData[4] = nY * nTexScale;
  end
end
-- Return imports and exports ---------------------------------------------- --
return { F = OnScriptLoaded, A = { Fade = Fade, Print = Print, PrintC = PrintC,
  PrintCT = PrintCT, PrintM = PrintM, PrintR = PrintR, PrintS = PrintS,
  PrintU = PrintU, PrintUR = PrintUR, PrintW = PrintW, PrintWS = PrintWS,
  BlitLTRB = BlitLTRB, BlitLT = BlitLT, BlitSLT = BlitSLT,
  BlitSLTRB = BlitSLTRB, BlitSLTWH = BlitSLTWH, BlitSLTWHA = BlitSLTWHA,
  RenderFade = RenderFade, RenderShadow = RenderShadow, RenderTip = RenderTip,
  RenderTipShadow = RenderTipShadow, SetTip = SetTip, SetVLTRB = SetVLTRB,
  TileA = TileA } };
-- End-of-File ============================================================= --
