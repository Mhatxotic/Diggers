-- PAUSE.LUA =============================================================== --
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
local cos<const>, sin<const> = math.cos, math.sin;
-- M-Engine function aliases ----------------------------------------------- --
local CoreTime<const>, UtilFormatNTime<const> = Core.Time, Util.FormatNTime;
-- Diggers function and data aliases --------------------------------------- --
local BlitSLTWHA, GetCallbacks, GetHotSpot, GetKeyBank, GetMusic,
  InitLose, PlayMusic, PlayStaticSound, PrintC, RegisterFBUCallback,
  RenderAll, RenderFade, RenderTip, SetCallbacks, SetHotSpot, SetKeys,
  SetTip, StopMusic, TriggerEnd, aKeyBankCats, fontLittle, fontTiny;
-- Statics ------------------------------------------------------------------ --
local iPauseX<const> = 160;            -- Pause text X position
local iPauseY<const> = 72;             -- Pause text Y position
local iInstructionY<const> = iPauseY + 24; -- Instruction text Y position
local iSmallTipsY<const> = iInstructionY + 44; -- Small tips Y position
-- Locals ------------------------------------------------------------------ --
local iHotSpotId;                      -- Pause screen hot spot id
local iKeyBankId;                      -- Pause screen key bank id
local iLastKeyBankId;                  -- Saved key bank id
local iLastHotSpotId;                  -- Saved hot spot id
local iStageT, iStageB;                -- Stage vertical bounds
local iStageL, iStageR;                -- Stage horizontal bounds
local iSSelect;                        -- Sound error and select ids
local sInstruction;                    -- Instruction text
local sSmallTips;                      -- Small instructions text
local muMusic;                         -- Current music played
local nTime;                           -- Current time
local fCBProc, fCBRender;              -- Last callbacks
local nTimeNext;                       -- Next clock update
local aSquares<const> = { };           -- Pause effect
local texSpr;                          -- Sprite texture
-- End game callback ------------------------------------------------------- --
local function EndGame()
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Abort the game
  TriggerEnd(InitLose);
end
-- Continue game callback -------------------------------------------------- --
local function ContinueGame()
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Resume music if we have it
  if muMusic then PlayMusic(muMusic, nil, 2) end;
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
  local iStageLP6<const> = iStageL + 6;
  local nTimeM2<const> = nTime * 2;
  for iY = iStageT + 7, iStageB, 16 do
    local nTimeM2SX<const> = nTimeM2;
    for iX = iStageLP6, iStageR, 16 do
      local iPos = (iY * iStageR) + iX;
      local nAngle = nTimeM2SX + (iPos / 0.46);
      nAngle = 0.5 + ((cos(nAngle) * sin(nAngle)));
      texSpr:SetCRGBA(0, 0, 0, nAngle * 0.5);
      local nDim<const> = nAngle * 16;
      BlitSLTWHA(texSpr, 444, iX, iY, nDim, nDim, nAngle);
    end
  end
  texSpr:SetCRGBA(1, 1, 1, 1);
  -- Write text informations
  local nTime = CoreTime();
  fontLittle:SetCRGBA(1, 1, 1, 0.1 + (0.5 + (sin(nTime) * cos(nTime) * 0.9)));
  PrintC(fontLittle, iPauseX, iInstructionY, sInstruction);
  fontTiny:SetCRGBA(0.5, 0.5, 0.5, 1);
  PrintC(fontTiny, iPauseX, iSmallTipsY, sSmallTips);
  fontLittle:SetCRGBA(1, 1, 1, 1);
  -- Get and print local time
  RenderTip();
end
local function OnStageUpdated(...)
  -- Update stage bounds
  local _ _, _, iStageL, iStageT, iStageR, iStageB = ...;
end
-- Init pause screen ------------------------------------------------------- --
local function InitPause()
  -- Consts
  sInstruction = "PAUSED!"
  sSmallTips =
    "PRESS \rcffffff00"..aKeyBankCats.igpatg[9]..
      "\rr OR SELECT AT EDGE TO ABORT GAME\n"..
    "PRESS \rcffffff00"..aKeyBankCats.igpcg[9]..
      "\rr OR SELECT IN MIDDLE TO RESUME GAME\n"..
    "PRESS \rcffffff00"..aKeyBankCats.gksc[9]..
      "\rr TO CHANGE ENGINE OPTIONS\n"..
    "PRESS \rcffffff00"..aKeyBankCats.gksb[9]..
      "\rr TO CHANGE KEY BINDINGS\n"..
    "PRESS \rcffffff00"..aKeyBankCats.gksa[9]..
      "\rr FOR THE GAME AND ENGINE CREDITS\n"..
    "PRESS \rcffffff00"..aKeyBankCats.gkcc[9]..
      "\rr TO RESET CURSOR POSITION\n"..
    "PRESS \rcffffff00"..aKeyBankCats.gkwr[9]..
      "\rr TO RESET WINDOW SIZE AND POSITION\n"..
    "PRESS \rcffffff00"..aKeyBankCats.gkss[9]..
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
  nTimeNext = 0;
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
  local RegisterHotSpot, RegisterKeys, aCursorIdData, aSfxData;
  -- Get imports
  BlitSLTWHA, GetCallbacks, GetHotSpot, GetKeyBank, GetMusic, InitLose,
    PlayMusic, PlayStaticSound, PrintC, RegisterFBUCallback, RegisterHotSpot,
    RegisterKeys, RenderAll, RenderFade, RenderTip, SetCallbacks,
    SetHotSpot, SetKeys, SetTip, StopMusic, TriggerEnd, aCursorIdData,
    aKeyBankCats, aSfxData, fontLittle, fontTiny, texSpr =
      GetAPI("BlitSLTWHA", "GetCallbacks", "GetHotSpot", "GetKeyBank",
        "GetMusic", "InitLose", "PlayMusic", "PlayStaticSound", "PrintC",
        "RegisterFBUCallback", "RegisterHotSpot", "RegisterKeys",
        "RenderAll", "RenderFade", "RenderTip", "SetCallbacks",
        "SetHotSpot", "SetKeys", "SetTip", "StopMusic", "TriggerEnd",
        "aCursorIdData", "aKeyBankCats", "aSfxData", "fontLarge", "fontTiny",
        "texSpr");
  -- Setup hot spot
  iHotSpotId = RegisterHotSpot({
    { 8, 8, 8, 224, 3, aCursorIdData.OK,   false, false, ContinueGame },
    { 0, 0, 0, 240, 3, aCursorIdData.EXIT, false, false, EndGame      }
  });
  -- Setup keybank
  local aKeys<const>, aStates<const> = Input.KeyCodes, Input.States;
  iKeyBankId = RegisterKeys("IN-GAME PAUSE", {
    [aStates.PRESS] = {
      { aKeys.Q,      EndGame,      "igpatg", "ABORT THE GAME" },
      { aKeys.ESCAPE, ContinueGame, "igpcg",  "CONTINUE GAME" }
    }
  });
  -- Get sound effects
  iSSelect = aSfxData.SELECT;
end
-- Exports and imports ----------------------------------------------------- --
return { F = OnScriptLoaded, A = { InitPause = InitPause } };
-- End-of-File ============================================================= --
