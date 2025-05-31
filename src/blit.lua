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
-- Lua aliases (optimisation) ---------------------------------------------- --
local collectgarbage<const> = collectgarbage;
-- M-Engine function aliases ----------------------------------------------- --
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
      iLoadX, iLoadY,                  -- Loader position
      iStageBottom, iStageLeft,        -- Stage bottom and left co-ord
      iStageRight, iStageTop,          -- Stage right and top co-ord
      iTexScale,                       -- Texture scale
      sTip,                            -- Current tip and bounds
      texSpr;                          -- Sprites texture
-- Print text left with scale ---------------------------------------------- --
local function Print(fontHandle, iX, iY, sText)
  FontPrint(fontHandle, iX * iTexScale, iY * iTexScale, sText);
end
-- Print text centre with scale -------------------------------------------- --
local function PrintC(fontHandle, iX, iY, sText)
  FontPrintC(fontHandle, iX * iTexScale, iY * iTexScale, sText);
end
-- Print text centre with texture glyphs and scale ------------------------- --
local function PrintCT(fontHandle, iX, iY, sText, texHandle)
  FontPrintCT(fontHandle, iX * iTexScale, iY * iTexScale, sText, texHandle);
end
-- Print text right with scale --------------------------------------------- --
local function PrintR(fontHandle, iX, iY, sText)
  FontPrintR(fontHandle, iX * iTexScale, iY * iTexScale, sText);
end
-- Simulate a print with maximum width ------------------------------------- --
local function PrintWS(fontHandle, iWidth, strText)
  return FontPrintWS(fontHandle, iWidth * iTexScale, 0, strText) / iTexScale;
end
-- Print with maximum width ------------------------------------------------ --
local function PrintW(fontHandle, iX, iY, iWrapX, strText)
  FontPrintW(fontHandle, iX * iTexScale, iY * iTexScale,
    iWrapX * iTexScale, 0, strText);
end
-- Simulate a print -------------------------------------------------------- --
local function PrintS(fontHandle, strText)
  return FontPrintS(fontHandle, strText) / iTexScale;
end
-- Print a scrolling string ------------------------------------------------ --
local function PrintM(fontHandle, iX, iY, iScroll, iWidth, sText)
  FontPrintM(fontHandle, iX * iTexScale, iY * iTexScale,
    iScroll * iTexScale, iWidth * iTexScale, sText);
end
-- Print text upwards (left align) ----------------------------------------- --
local function PrintU(fontHandle, iX, iY, sText)
  FontPrintU(fontHandle, iX * iTexScale, iY * iTexScale, sText);
end
-- Print text upwards (right align) ---------------------------------------- --
local function PrintUR(fontHandle, iX, iY, sText)
  FontPrintUR(fontHandle, iX * iTexScale, iY * iTexScale, sText);
end
-- Blit bounds with scale -------------------------------------------------- --
local function BlitLTRB(texHandle, iX1, iY1, iX2, iY2)
  TextureBlitLTRB(texHandle, iX1 * iTexScale, iY1 * iTexScale,
                             iX2 * iTexScale, iY2 * iTexScale);
end
-- Blit tile/coords/size/angle with scale ---------------------------------- --
local function BlitSLTWHA(texHandle, iTileId, iX, iY, iW, iH, nA)
  TextureBlitSLTWHA(texHandle, iTileId, iX * iTexScale, iY * iTexScale,
                                        iW * iTexScale, iH * iTexScale, nA);
end
-- Blit tile/coords/size with scale ---------------------------------------- --
local function BlitSLTWH(texHandle, iTileId, iX, iY, iW, iH)
  TextureBlitSLTWH(texHandle, iTileId, iX * iTexScale, iY * iTexScale,
                                       iW * iTexScale, iH * iTexScale);
end
-- Blit tile/bounds with scale --------------------------------------------- --
local function BlitSLTRB(texHandle, iTileId, iX1, iY1, iX2, iY2)
  TextureBlitSLTRB(texHandle, iTileId, iX1 * iTexScale, iY1 * iTexScale,
                                       iX2 * iTexScale, iY2 * iTexScale);
end
-- Blit tile/x/y with scale ------------------------------------------------ --
local function BlitSLT(texHandle, iTileId, iX, iY)
  TextureBlitSLT(texHandle, iTileId, iX * iTexScale, iY * iTexScale);
end
-- Blit tile/x/y with scale and angle -------------------------------------- --
local function BlitSLTA(texHandle, iTileId, iX, iY, nAngle)
  TextureBlitSLTA(texHandle, iTileId, iX * iTexScale, iY * iTexScale, nAngle);
end
-- Blit x/y with scale ----------------------------------------------------- --
local function BlitLT(texHandle, iX, iY)
  TextureBlitLT(texHandle, iX * iTexScale, iY * iTexScale);
end
-- Set vertex for video handle --------------------------------------------- --
local function SetVLTRB(vidHandle, iX1, iY1, iX2, iY2)
  VideoSetVLTRB(vidHandle, iX1 * iTexScale, iY1 * iTexScale,
                           iX2 * iTexScale, iY2 * iTexScale);
end
-- Add a tile to a texture ------------------------------------------------- --
local function TileA(texHandle, iX1, iY1, iX2, iY2)
  return TextureTileA(texHandle, iX1 * iTexScale, iY1 * iTexScale,
                                 iX2 * iTexScale, iY2 * iTexScale);
end
-- Do render the tip ------------------------------------------------------- --
local function DoRenderTip(iX)
  -- Draw the background of the tip rect
  BlitSLT(texSpr, 847, iX,      216);
  BlitSLT(texSpr, 848, iX + 16, 216);
  BlitSLT(texSpr, 848, iX + 32, 216);
  BlitSLT(texSpr, 848, iX + 48, 216);
  BlitSLT(texSpr, 849, iX + 64, 216);
  -- Set tip colour and render the text
  fontLittle:SetCRGB(1, 1, 1);
  PrintC(fontLittle, iX + 40, 220, sTip);
end
-- Render the tip in the bottom right -------------------------------------- --
local function RenderTip()
  -- Return if no tip
  if not sTip then return end;
  -- Draw tip in different positions if mouse cursor is over the tip
  if IsMouseInBounds(232, 216, 312, 232) then DoRenderTip(144);
                                         else DoRenderTip(232) end;
end
-- Render shadow ----------------------------------------------------------- --
local function RenderShadow(iL, iT, iR, iB)
  -- Draw a shadow using the solid sprite
  texSpr:SetCA(0.2);
  BlitSLTRB(texSpr, 1023, iL+3, iB, iR, iB+1); -- Horizontal row 1
  BlitSLTRB(texSpr, 1023, iR, iT+3, iR+1, iB); -- Vertical column 1
  texSpr:SetCA(0.1);
  BlitSLTRB(texSpr, 1023, iL+4, iB, iR, iB+2); -- Horizontal row 2
  BlitSLTRB(texSpr, 1023, iR, iT+4, iR+2, iB); -- Vertical column 2
  BlitSLTRB(texSpr, 1023, iR, iB, iR+2, iB+1); -- Horizontal corner 1
  BlitSLTRB(texSpr, 1023, iR, iB, iR+1, iB+2); -- Vertical corner 2
  texSpr:SetCA(0.05);
  BlitSLTRB(texSpr, 1023, iL+5, iB, iR, iB+3); -- Horizontal row 3
  BlitSLTRB(texSpr, 1023, iR, iT+5, iR+3, iB); -- Vertical column 3
  texSpr:SetCA(1);
end
-- Render the tip and shadow ----------------------------------------------- --
local function RenderTipShadow()
  -- Return if no tip
  if not sTip then return end;
  -- Render the tip
  DoRenderTip(232)
  -- Render the shadow
  RenderShadow(232, 216, 312, 232);
end;
-- Set bottom right tip ---------------------------------------------------- --
local function SetTip(strTip) sTip = strTip end;
-- Loading indicator ------------------------------------------------------- --
local function ProcLoader()
  texSpr:SetCRGBA(1, 1, 1, 1);
  BlitSLTA(texSpr, 801, iLoadX, iLoadY, CoreTime() * 2);
end
-- Render fade ------------------------------------------------------------- --
local function RenderFade(nAmount, iL, iT, iR, iB, iS)
  texSpr:SetCA(nAmount);
  BlitSLTRB(texSpr, iS or 1023, iL or iStageLeft,  iT or iStageTop,
                                iR or iStageRight, iB or iStageBottom);
  texSpr:SetCA(1);
end
-- Fade -------------------------------------------------------------------- --
local function Fade(S, E, C, D, A, M, L, T, R, B, Z)
  -- Check parameters
  if not UtilIsNumber(S) then
    error("Invalid starting value number! "..tostring(S)) end;
  if not UtilIsNumber(E) then
    error("Invalid ending value number! "..tostring(E)) end;
  if not UtilIsNumber(C) then
    error("Invalid fade inc/decremember value! "..tostring(C)) end
  if not UtilIsFunction(A) then
    error("Invalid after function! "..tostring(A)) end;
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
    D();
    -- Clamp new fade value
    S = UtilClamp(nVal, 0, 1);
    -- Render blackout
    RenderFade(S, L, T, R, B, Z);
    -- Fade music too
    if M then MusicVolume(1 - S) end;
  end
  -- Finished function
  local function Finish()
    -- Reset fade vars
    S, fcbFading = E, nil;
    -- Enable global keys
    SetKeys(true);
    -- Just draw tip while the after function decides what to do
    SetCallbacks(nil, ProcLoader);
    -- Call the after function
    A();
  end
  -- Cleanup function
  local function Clean()
    -- Garbage collect
    collectgarbage();
    -- Reset hi-res timer
    CoreCatchup();
  end
  -- Fade out?
  if S < E then
    -- Save old fade function
    fcbFading = A;
    -- Function during
    local function ProcFadeOut()
      -- Fade out
      During(S + C);
      -- Finished if we reached the ending point
      if S < E then return end;
      -- Cleanup
      Clean();
      -- Call finish function
      Finish()
    end
    -- Set fade out procedure
    SetCallbacks(nil, ProcFadeOut);
  -- Fade in?
  elseif S > E then
    -- Cleanup
    Clean();
    -- Save old fade function
    fcbFading = A;
    -- Function during
    local function OnFadeInFrame()
      -- Fade in
      During(S - C);
      -- Finished if we reached the ending point
      if S <= E then Finish() end;
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
-- Script ready function --------------------------------------------------- --
local function OnScriptLoaded(GetAPI)
  -- Functions only for this scope
  local RegisterFBUCallback;
  -- Get and store texture scale
  ClearStates, IsMouseInBounds, MusicVolume, RegisterFBUCallback, SetCallbacks,
    SetHotSpot, SetKeys, fontLittle, iTexScale, texSpr =
      GetAPI("ClearStates", "IsMouseInBounds", "MusicVolume",
        "RegisterFBUCallback", "SetCallbacks", "SetHotSpot", "SetKeys",
        "fontLittle", "iTexScale", "texSpr");
  -- Set frame buffer update callback (always active)
  local function OnStageUpdated(...)
    local _; _, _, iStageLeft, iStageTop, iStageRight, iStageBottom = ...;
    iLoadX, iLoadY = iStageRight - 24, iStageBottom - 24;
  end
  RegisterFBUCallback("blit", OnStageUpdated);
  -- Return if texture scale is set to 1
  if iTexScale <= 1 then return end;
  -- Enumerate cursor id datas
  for iId, aCData in pairs(GetAPI("aCursorData")) do
    -- Save original cursor id position adjustments
    local iX<const>, iY<const> = aCData[3], aCData[4];
    -- Backup values
    aCData[5], aCData[6] = iX, iY;
    -- Scale current values
    aCData[3] = iX * iTexScale;
    aCData[4] = iY * iTexScale;
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
