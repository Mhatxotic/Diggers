-- DEBUG.LUA =============================================================== --
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
local max<const>, min<const>, random<const>, format<const>, ceil<const>,
  sin<const>, cos<const> =
    math.max, math.min, math.random, string.format, math.ceil, math.sin,
    math.cos;
-- Engine function aliases ------------------------------------------------- --
local UtilHex<const>, CoreCPUUsage<const>, CoreRAM<const>, CoreUptime<const>,
  CoreLUATime<const>, CoreLUAUsage<const>, UtilDuration<const>,
  DisplayGPUFPS<const> =
    Util.Hex, Core.CPUUsage, Core.RAM, Core.Uptime, Core.LUATime,
    Core.LUAUsage, Util.Duration, Display.GPUFPS;
-- Diggers function and data aliases --------------------------------------- --
local BlitSLT, BlitSLTRB, BlitSLTWH, DrawHealthBar, Fade, GetGameTicks,
  GetMouseX, GetMouseY, GetTileUnderMouse, aPlayers, aObjs, RenderTerrain,
  RenderObjects, RenderShroud, texSpr, fontLarge, fontLittle, fontTiny,
  SelectObject, GameProc, GetActiveObject, GetActivePlayer, SetCallbacks,
  LoadLevel, PrintC, PrintCT, PrintT, PrintR, Print, UpdateShroud,
  SetPlaySounds, GetOpponentPlayer, RegisterFBUCallback, aLevelsData,
  GetViewportData, RenderAll, RenderInterface, JOB, ACT;
-- Locals ------------------------------------------------------------------ --
local bHud = true;                     -- Show hud?
local iPixPosX, iPixPosY, iPixPosTargetX, iPixPosTargetY, iPixCenPosX,
  iPixCenPosY, iPosX, iPosY, iAbsCenPosX, iAbsCenPosY, iViewportW, iViewportH,
  iVPX, iVPY, oPlrActive, oObjActive, oPlrOpponent;
-- Load infinite play ------------------------------------------------------ --
local function InitDebugPlay(iId)
  -- Set random level if not set
  if not iId then iId = random(#aLevelsData) end;
  -- Frame buffer updated function
  local iStageL, iStageT, iStageR, iStageB;
  local function OnStageUpdatedd(...)
    local _ _, _, iStageL, iStageT, iStageR, iStageB = ...;
  end
  -- We want to know when the frame buffer is updated
  RegisterFBUCallback("debug", OnStageUpdatedd);
  -- Player and digger ids for selection
  local iSelectedPlayerId, iSelectedDiggerId = 1, 1;
  -- Select next digger
  local function SelectNextDigger()
    iSelectedDiggerId = iSelectedDiggerId + 1;
    if iSelectedDiggerId > 5 then
      iSelectedDiggerId = 1;
      iSelectedPlayerId = iSelectedPlayerId + 1;
      if iSelectedPlayerId > 2 then iSelectedPlayerId = 1 end;
    end
  end
  -- Level information
  local iLevelId, sLevelName, sLevelType, iWinLimit;
  -- Render function
  local function OnRender()
    -- Hud not enabled?
    if not bHud then return RenderAll() end;
    -- Render terrain
    RenderTerrain();
    -- Get system information
    local nCpu<const>, nSys<const> = CoreCPUUsage();
    local nPerc<const>, _, _, _, nProc<const>, nPeak<const> = CoreRAM();
    -- For each object
    for iObjId = 1, #aObjs do
      -- Get object data
      local oObj<const> = aObjs[iObjId];
      local iX<const>, iY<const> = oObj.X, oObj.Y;
      -- If in bounds of the viewport?
      local iXX<const>, iYY<const> =
        iX - iVPX + oObj.OFX, iY - iVPY + oObj.OFY;
      if min(iXX + 16, iStageR) > max(iXX, iStageL) and
         min(iYY + 16, iStageB) > max(iYY, iStageT) then
        -- Draw the texture
        BlitSLT(texSpr, oObj.S, iXX, iYY);
        -- Got an attachment? Draw that too!
        if oObj.STA then
          BlitSLT(texSpr, oObj.SA, iXX + oObj.OFXA, iYY + oObj.OFYA);
        end
        -- Centre location of digger information
        local iXXC<const> = iXX + 8;
        -- Active object is a digger?
        local iDiggerId<const> = oObj.DI;
        if iDiggerId then
          -- Is player one?
          if oObj.P == oPlrActive then
            -- Active object? Set brighter
            if oObj == oObjActive then fontTiny:SetCRGBA(1.0, 0.7, 0.8, 1.0);
            -- Inactive object? Set dim
            else fontTiny:SetCRGBA(1.0, 0.6, 0.7, 0.75) end;
          -- Is player two? Active object? Set brighter
          elseif oObj == oObjActive then
            fontTiny:SetCRGBA(0.34, 0.9, 0.5, 1.0);
          -- Inactive object? Set dim
          else fontTiny:SetCRGBA(0.24, 0.8, 0.4, 0.75) end;
          -- Draw name and id of digger
          PrintC(fontTiny, iXXC, iYY - 9, oObj.OD.NAME.." "..iDiggerId);
          -- Get object inventory and if have any
          local aObjInv<const> = oObj.I;
          if #aObjInv > 0 then
            -- Draw them above head
            local iX = iXX - ((#aObjInv - 1) * 8 // 2) + 4;
            local iY<const> = iYY - 18;
            local iY2<const> = iY + 8;
            for iIIndex = 1, #aObjInv do
              BlitSLTRB(texSpr, aObjInv[iIIndex].S, iX, iY, iX+8, iY2);
              iX = iX + 8;
            end
          end
        -- Not a digger?
        else
          -- Active object? Set brighter
          if oObj == oObjActive then fontTiny:SetCRGBA(1.0, 1.0, 1.0, 1.0);
          -- Inactive object? Set dim
          else fontTiny:SetCRGBA(0.9, 0.9, 0.9, 0.75) end;
          -- Draw name of object
          PrintC(fontTiny, iXXC, iYY - 9, oObj.OD.NAME.." "..oObj.U);
        end
        -- Set string for object target
        local aTarget = oObj.T;
        if aTarget then aTarget = format("\rt%08x%u", aTarget.S, aTarget.DI)
        -- No target?
        else
          -- Start of pursuer list
          aTarget = "\n";
          -- Add pursuers
          for iUId, aPursuer in pairs(oObj.TL) do
            aTarget = aTarget..format("\rt%08x%u", aPursuer.S, aPursuer.U) end;
          -- Remove text if no pursuers
          if #aTarget <= 1 then aTarget = "" end;
        end
        -- Draw object status under object
        PrintCT(fontTiny, iXXC, iYY + 17, iX.."x"..iY.."\n"..
          oObj.A..":"..oObj.J..":"..oObj.D.." "..oObj.AT.."\n"..
          UtilHex(oObj.F)..aTarget, texSpr);
        -- Draw health bar
        local iYHealth<const> = iYY - 2;
        texSpr:SetCRGB(0.0, 0.0, 0.0)
        BlitSLTWH(texSpr, 1022, iXX, iYHealth, 16, 1);
        DrawHealthBar(oObj.H, 6.25, iXX, iYHealth, 1);
      end
    end
    -- Render shroud and interface
    RenderShroud();
    -- Draw engine info
    fontTiny:SetCRGBA(1.0, 1.0, 1.0, 0.75);
    -- Draw game information
    Print(fontTiny, iStageL + 5.0, 5.0, format("\z
      %s [%02u]\n\z     %s\n\z          %u TO WIN\n\z
      %u OBJECTS\n\n\z  %d@%d%9s\n\z    ZOGS%6u/%u\n\z
      DUG%7u/%u\n\z     KO%8s/%u\n\z    TRDE%6u/%u\n\n\z
      %d@%d%9s\n\z      ZOGS%6u/%u\n\z  DUG%7u/%u\n\z
      KO%8s/%u\n\z      TRDE%6u/%u",
        sLevelName, iLevelId, sLevelType, iWinLimit, #aObjs,
        oPlrActive.I, oPlrActive.RI, oPlrActive.RD.LONGNAME, oPlrActive.M,
        oPlrActive.GI, oPlrActive.DUG, oPlrActive.GEM,
        format("%u/%u", oPlrActive.LK, oPlrActive.EK), oPlrActive.DC,
        oPlrActive.GS, oPlrActive.PUR, oPlrOpponent.I, oPlrOpponent.RI,
        oPlrOpponent.RD.LONGNAME, oPlrOpponent.M, oPlrOpponent.GI,
        oPlrOpponent.DUG, oPlrOpponent.GEM,
        format("%u/%u", oPlrOpponent.LK, oPlrOpponent.EK), oPlrOpponent.DC,
        oPlrOpponent.GS, oPlrOpponent.PUR));
    -- Draw system information
    PrintR(fontTiny, iStageR - 5.0, 5.0, format("\z
      %u/%u S FRAM\n\z    %.3f %% CPUP\n\z  %.3f M RAMP\n\z
      %.3f M PEAK\n\z     %.3f M LUAU\n\z   %.3f %% CPUS\n\z
      %.3f %% RAMS\n\n\z  %s GAMT\n\z       %s LUAT\n\z
      %s ENGT\n\n\z       %d/%4d VPXC\n\z   %d/%4d VPXT\n\z
      %d/%4d VCPX\n\z     %d/%4d APOS\n\z   %d/%4d ACPS\n\z
      %d/%4d AMAX\n\z     %d/%4d MPOS\n\z   %d/%4d MPLP",
        GetGameTicks(), DisplayGPUFPS(), nCpu, nProc / 1048576,
        nPeak / 1048576, CoreLUAUsage() / 1048576, nSys, nPerc,
        UtilDuration(GetGameTicks() / 60, 0), UtilDuration(CoreLUATime(), 0),
        UtilDuration(CoreUptime(), 0), iPixPosX, iPixPosY, iPixPosTargetX,
        iPixPosTargetY, iPixCenPosX, iPixCenPosY, iPosX, iPosY, iAbsCenPosX,
        iAbsCenPosY, iViewportW, iViewportH, GetMouseX(), GetMouseY(),
        GetTileUnderMouse()));
    -- Restore font alpha as a lot of modules expect it to be 1.
    fontTiny:SetCA(1.0);
    -- Render interface
    RenderInterface();
  end
  -- Finished playing this zone
  local function OnFinish()
    -- When level has faded out?
    local function OnFadeOut()
      -- Unregister frame buffer update event
      RegisterFBUCallback("debug");
      -- Load a new level
      InitDebugPlay();
    end
    -- Fade out to load a new level
    Fade(0.0, 1.0, 0.04, OnRender, OnFadeOut);
  end
  -- Store mouse position
  local iX, iY, iPPX, iPPY, iNextObjectPoll, iRate,
    iRateM1, aPlayerAtHumanStart = GetMouseX(), GetMouseY(), 0, 0, 0;
  -- Debug mode initialisation function
  local function OnInit(...)
    -- Get viewport information
    iPixPosX, iPixPosY, iPixPosTargetX, iPixPosTargetY, iPixCenPosX,
      iPixCenPosY, iPosX, iPosY, iAbsCenPosX, iAbsCenPosY, iViewportW,
      iViewportH, iVPX, iVPY = GetViewportData();
    -- Store level information
    iLevelId, sLevelName, sLevelType, iWinLimit = ...;
    -- Get active player object and opponent player
    oPlrActive = GetActivePlayer();
    oObjActive = GetActiveObject();
    oPlrOpponent = GetOpponentPlayer();
    -- Set remove shroud mode
    oPlrOpponent.US = true;
    -- Get and enumerate player diggers
    local aDiggers<const> = oPlrOpponent.D;
    for iDiggerId = 1, #aDiggers do
      -- Get digger
      local oDigger<const> = aDiggers[iDiggerId];
      -- Set remove shroud mode
      oDigger.US = true;
      UpdateShroud(oDigger.AX, oDigger.AY);
    end
    -- Set money tick rate
    iRate = 216000 // iWinLimit;
    iRateM1 = iRate - 1;
    -- Identify the player at the 'human player' start location as we'll give
    -- a handicap to the AI starting at the human start position since most
    -- human player start locations are not helpful the AI.
    for iI = 1, #aPlayers do
      local aPlayer<const> = aPlayers[iI];
      if aPlayer.RI == 1 then aPlayerAtHumanStart = aPlayer break end;
    end
  end
  -- Set real function
  local function OnTick()
    -- Get viewport information
    iPixPosX, iPixPosY, iPixPosTargetX, iPixPosTargetY, iPixCenPosX,
      iPixCenPosY, iPosX, iPosY, iAbsCenPosX, iAbsCenPosY, iViewportW,
      iViewportH, iVPX, iVPY = GetViewportData();
    -- Add 1 Zog to what would be main player every so often. This eventually
    -- gives the player a lead. They might eventually purchase something, and
    -- the game will end eventually.
    if GetGameTicks() % iRate == iRateM1 then
      aPlayerAtHumanStart.M = aPlayerAtHumanStart.M + 1;
      if aPlayerAtHumanStart.M >= iWinLimit then OnFinish() end;
    end
    -- If we're blocked from polling objects then don't
    if GetGameTicks() < iNextObjectPoll then GameProc() return end
    -- Mouse position or viewport changed?
    iNewX, iNewY = GetMouseX(), GetMouseY();
    if iNewX ~= iX or iNewY ~= iY or iPixPosX ~= iPPX or iPixPosY ~= iPPY then
      -- Update new position and block time for 10 seconds
      iX, iY, iNextObjectPoll, iPPX, iPPY = iNewX, iNewY, GetGameTicks() + 600,
        iPixPosX, iPixPosY;
      -- Don't cycle objects
      GameProc();
      -- Done
      return
    end
    -- New object selected
    local oObj;
    -- For each player
    for iPlayer = 1, #aPlayers do
      -- Get player diggers and enumerate them
      local aDiggers<const> = aPlayers[iPlayer].D;
      for iDigger = 1, #aDiggers do
        -- Get digger object and if it is in danger?
        local oDigger<const> = aDiggers[iDigger];
        if oDigger and
           oDigger.J == JOB.INDANGER and
           oDigger.A ~= ACT.DEATH and
          (oDigger.A ~= ACT.FIGHT or
           oDigger.P == oPlrActive) then
          -- It is selected
          iSelectedPlayerId, iSelectedDiggerId = iPlayer, iDigger;
          oObj = oDigger;
          -- Do not check any more diggers
          break;
        end
      end
      -- Break if we got a digger
      if oObj then break end;
    end
    -- Switch object every 10 seconds
    if not oObj and GetGameTicks() % 600 == 0 then
      -- Try again point
      ::tryagain::
      -- Select a player
      local oPlayer<const> = aPlayers[iSelectedPlayerId];
      -- Get player diggers
      local aDiggers<const> = oPlayer.D;
      -- Find a digger from the specified player.
      oObj = aDiggers[iSelectedDiggerId];
      -- Loop if we don't find a digger
      if not oObj then SelectNextDigger() goto tryagain end;
    end
    -- New object selected?
    if oObj then
      -- Select the object and player if we got something!
      SelectObject(oObj);
      -- Next object
      SelectNextDigger();
    end
    -- Execute a game tick
    GameProc();
  end
  -- Load infinite play (AI vs AI)
  LoadLevel(iId, "game", -1, nil, true, nil, true, OnTick, OnRender, OnFinish,
    nil, nil, nil, true, OnInit);
  -- Play sound effects
  SetPlaySounds(true);
end
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI, oAPI)
  -- Grab imports
  BlitSLT, BlitSLTRB, BlitSLTWH, DrawHealthBar, Fade, GameProc,
    GetActiveObject, GetActivePlayer, GetGameTicks, GetMouseX,
    GetMouseY, GetOpponentPlayer, GetTileUnderMouse, GetViewportData,
    LoadLevel, PrintC, PrintCT, PrintR, Print, RegisterFBUCallback,
    RenderObjects, RenderShroud, RenderTerrain, SelectObject, SetCallbacks,
    SetPlaySounds, UpdateShroud, aLevelsData, aObjs, aPlayers, fontLarge,
    fontLittle, fontTiny, texSpr, RenderAll, RenderInterface, JOB, ACT =
      GetAPI("BlitSLT", "BlitSLTRB", "BlitSLTWH", "DrawHealthBar", "Fade",
        "GameProc", "GetActiveObject", "GetActivePlayer", "GetGameTicks",
        "GetMouseX", "GetMouseY", "GetOpponentPlayer", "GetTileUnderMouse",
        "GetViewportData", "LoadLevel", "PrintC", "PrintCT", "PrintR", "Print",
        "RegisterFBUCallback", "RenderObjects", "RenderShroud",
        "RenderTerrain", "SelectObject", "SetCallbacks", "SetPlaySounds",
        "UpdateShroud", "aLevelsData", "aObjs", "aPlayers", "fontLarge",
        "fontLittle", "fontTiny", "texSpr", "RenderAll", "RenderInterface",
        "oObjectJobs", "oObjectActions");
  -- Toggle hud
  local function ToggleHud(sValue)
    -- No parameter
    if not sValue then bHud = not bHud return end;
    -- Parameter specified
    bHud = tonumber(sValue) ~= 0;
  end
  -- Debug commands
  local aCommands<const> = {
    ["hud"] = ToggleHud
  };
  -- Register a console command to dump level mask and keep it safe in API.
  local CommandRegister<const> = Command.Register;
  local function ConCmdSetLevel(_, sValue, ...)
    -- If is a command?
    local fcbFunc<const> = aCommands[sValue]
    if fcbFunc then return fcbFunc(...) end;
    -- On faded out
    local function OnFadeOut() InitDebugPlay(tonumber(sValue)) end;
    -- Fade out to load a new level
    Fade(0.0, 1.0, 0.04, RenderAll, OnFadeOut);
  end
  oAPI.cmdDebug = CommandRegister("debug", 1, 3, ConCmdSetLevel);
end
-- Exports and imports ----------------------------------------------------- --
return { F = OnScriptLoaded, A = { InitDebugPlay = InitDebugPlay } };
-- End-of-File ============================================================= --
