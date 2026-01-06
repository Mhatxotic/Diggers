-- PAUSE.LUA =============================================================== --
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
local cos<const>, sin<const> = math.cos, math.sin;
-- Engine function aliases ------------------------------------------------- --
local CoreTime<const>, UtilFormatNTime<const> = Core.Time, Util.FormatNTime;
-- Diggers function and data aliases --------------------------------------- --
local BlitSLTWHA, GetCallbacks, GetHotSpot, GetKeyBank, GetMusic, PlayMusic,
  PlayStaticSound, PrintC, RegisterFBUCallback, RenderAll, RenderFade,
  RenderTip, SetCallbacks, SetHotSpot, SetKeys, SetTip, StopMusic, TriggerEnd,
  tKeyBankCats, fontLarge, fontTiny;
-- Statics ------------------------------------------------------------------ --
local nPauseX<const> = 160.0;                    -- Pause text X position
local nPauseY<const> = 72.0;                     -- Pause text Y position
local nInstructionY<const> = nPauseY + 24.0;     -- Instruction text Y position
local nSmallTipsY<const> = nInstructionY + 44.0; -- Small tips Y position
-- Locals ------------------------------------------------------------------ --
local fCBProc, fCBRender;              -- Last callbacks
local iHotSpotId;                      -- Pause screen hot spot id
local iKeyBankId;                      -- Pause screen key bank id
local iLastHotSpotId;                  -- Saved hot spot id
local iLastKeyBankId;                  -- Saved key bank id
local iSClick, iSSelect;               -- Sound ids
local muMusic;                         -- Current music played
local nStageL, nStageR;                -- Stage horizontal bounds
local nStageT, nStageB;                -- Stage vertical bounds
local nTime;                           -- Current time
local nTimeNext;                       -- Next clock update
local sInstruction;                    -- Instruction text
local sSmallTips;                      -- Small instructions text
local texSpr;                          -- Sprite texture
-- End game callback ------------------------------------------------------- --
local function EndGame()
  -- Dereference music
  muMusic = nil;
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Abort the game with the opponent raising all the money
  TriggerEnd(3);
end
-- Continue game callback -------------------------------------------------- --
local function ContinueGame()
  -- Play sound
  PlayStaticSound(iSClick);
  -- Resume music if we have it
  if muMusic then muMusic = PlayMusic(muMusic, nil, 2) end;
  -- Remove stage bounds callback
  RegisterFBUCallback("pause");
  -- Restore game keys and hotspot
  SetKeys(true, iLastKeyBankId);
  SetHotSpot(iLastHotSpotId);
  -- Unpause
  SetCallbacks(fCBProc, fCBRender);
end
-- Pause logic callback ---------------------------------------------------- --
local function ProcPause()
  -- Get current time
  nTime = CoreTime();
  -- Ignore if next update not elapsed
  if nTime < nTimeNext then return end;
  -- Set new pause string
  SetTip(UtilFormatNTime("%a/%H:%M:%S"));
  -- Set next update time
  nTimeNext = nTime + 0.25;
end
-- Pause render callback --------------------------------------------------- --
local function RenderPause()
  -- Render terrain, game objects, and a subtle fade
  RenderAll();
  RenderFade(0.75);
  -- Draw background animations
  local nStageLP6<const> = nStageL + 6.0;
  local nTimeM2<const> = nTime * 2.0;
  for nY = nStageT + 7.0, nStageB, 16.0 do
    local nTimeM2SX<const> = nTimeM2;
    for nX = nStageLP6, nStageR, 16.0 do
      local nPos<const> = (nY * nStageR) + nX;
      local nAngle = nTimeM2SX + (nPos / 0.46);
      nAngle = 0.5 + ((cos(nAngle) * sin(nAngle)));
      texSpr:SetCRGBA(0.0, 0.0, 0.0, nAngle * 0.5);
      local nDim<const> = nAngle * 16.0;
      BlitSLTWHA(texSpr, 444, nX, nY, nDim, nDim, nAngle);
    end
  end
  texSpr:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  -- Write text informations
  local nTime<const> = CoreTime();
  fontLarge:SetCRGBA(1.0, 1.0, 1.0,
    0.1 + (0.5 + (sin(nTime) * cos(nTime) * 0.9)));
  PrintC(fontLarge, nPauseX, nInstructionY, sInstruction);
  fontTiny:SetCRGBA(0.5, 0.5, 0.5, 1.0);
  PrintC(fontTiny, nPauseX, nSmallTipsY, sSmallTips);
  fontLarge:SetCRGBA(1.0, 1.0, 1.0, 1.0);
  -- Get and print local time
  RenderTip();
end
-- When main framebuffer size has changed ---------------------------------- --
local function OnStageUpdated(_, _, iStageL, iStageT, iStageR, iStageB)
  -- Update stage bounds as numbers
  nStageL, nStageT, nStageR, nStageB =
    iStageL + 0.0, iStageT + 0.0, iStageR + 0.0, iStageB + 0.0;
end
-- Init pause screen ------------------------------------------------------- --
local function InitPause()
  -- Consts
  sInstruction = "PAUSED!"
  sSmallTips =
    "PRESS \rcffffff00"..tKeyBankCats.igpatg[9]..
      "\rr OR SELECT AT EDGE TO ABORT GAME\n"..
    "PRESS \rcffffff00"..tKeyBankCats.igpcg[9]..
      "\rr OR SELECT IN MIDDLE TO RESUME GAME\n"..
    "PRESS \rcffffff00"..tKeyBankCats.gksc[9]..
      "\rr TO CHANGE ENGINE OPTIONS\n"..
    "PRESS \rcffffff00"..tKeyBankCats.gksb[9]..
      "\rr TO CHANGE KEY BINDINGS\n"..
    "PRESS \rcffffff00"..tKeyBankCats.gksa[9]..
      "\rr FOR THE GAME AND ENGINE CREDITS\n"..
    "PRESS \rcffffff00"..tKeyBankCats.gkcc[9]..
      "\rr TO RESET CURSOR POSITION\n"..
    "PRESS \rcffffff00"..tKeyBankCats.gkwr[9]..
      "\rr TO RESET WINDOW SIZE AND POSITION\n"..
    "PRESS \rcffffff00"..tKeyBankCats.gkss[9]..
      "\rr TO TAKE A SCREENSHOT";
  -- Save current music
  muMusic = GetMusic();
  -- Save callbacks
  fCBProc, fCBRender = GetCallbacks();
  -- Stop music
  StopMusic(1);
  -- Get stage bounds
  RegisterFBUCallback("pause", OnStageUpdated);
  -- Pause string
  nTimeNext = 0.0;
  -- Save game keybank id to restore it on exit
  iLastKeyBankId = GetKeyBank();
  iLastHotSpotId = GetHotSpot();
  -- Set pause screen keys and no hot spots
  SetKeys(true, iKeyBankId);
  SetHotSpot(iHotSpotId);
  -- Set pause procedure
  SetCallbacks(ProcPause, RenderPause);
end
-- When scripts have loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, oCursorIdData, oSfxData;
  -- Get imports
  BlitSLTWHA, GetCallbacks, GetHotSpot, GetKeyBank, GetMusic, PlayMusic,
    PlayStaticSound, PrintC, RegisterFBUCallback, RegisterHotSpot,
    RegisterKeys, RenderAll, RenderFade, RenderTip, SetCallbacks, SetHotSpot,
    SetKeys, SetTip, StopMusic, TriggerEnd, oCursorIdData, tKeyBankCats,
    oSfxData, fontLarge, fontTiny, texSpr =
      GetAPI("BlitSLTWHA", "GetCallbacks", "GetHotSpot", "GetKeyBank",
        "GetMusic", "PlayMusic", "PlayStaticSound", "PrintC",
        "RegisterFBUCallback", "RegisterHotSpot", "RegisterKeys",
        "RenderAll", "RenderFade", "RenderTip", "SetCallbacks",
        "SetHotSpot", "SetKeys", "SetTip", "StopMusic", "TriggerEnd",
        "oCursorIdData", "tKeyBankCats", "oSfxData", "fontLarge", "fontTiny",
        "texSpr");
  -- Setup hot spot
  iHotSpotId = RegisterHotSpot({
    { 8, 8, 8, 224, 3, oCursorIdData.OK,   false, false, ContinueGame },
    { 0, 0, 0, 240, 3, oCursorIdData.EXIT, false, false, EndGame      }
  });
  -- Setup keybank
  local oKeys<const>, oStates<const> = Input.KeyCodes, Input.States;
  iKeyBankId = RegisterKeys("IN-GAME PAUSE", {
    [oStates.PRESS] = {
      { oKeys.Q,      EndGame,      "igpatg", "ABORT THE GAME" },
      { oKeys.ESCAPE, ContinueGame, "igpcg",  "CONTINUE GAME" }
    }
  });
  -- Get sound effects
  iSClick, iSSelect = oSfxData.CLICK, oSfxData.SELECT;
end
-- Exports and imports ----------------------------------------------------- --
return { F = OnScriptLoaded, A = { InitPause = InitPause } };
-- End-of-File ============================================================= --
