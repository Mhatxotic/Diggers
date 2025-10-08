-- AUDIO.LUA =============================================================== --
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
local error, tostring = error, tostring;
-- Engine function aliases ------------------------------------------------- --
local UtilIsInteger<const>, UtilIsNumber<const>, UtilIsTable<const> =
  Util.IsInteger, Util.IsNumber, Util.IsTable;
-- Input handling variables ------------------------------------------------ --
local aSounds<const>            = { }; -- Sound effects
local vidVideo;                        -- FMV playback handle
local nPosition;                       -- Saved music position
local musMusic;                        -- Currently playing music handle
local iLoops;                          -- Saved music loops count
-- ------------------------------------------------------------------------- --
local function VideoStop()
  if vidVideo then vidVideo = vidVideo:Destroy() end;
end
-- ------------------------------------------------------------------------- --
local function VideoPause() if vidVideo then vidVideo:Pause() end end;
-- ------------------------------------------------------------------------- --
local function VideoResume() if vidVideo then vidVideo:Play() end end;
-- ------------------------------------------------------------------------- --
local function VideoPlay(Handle)
  VideoStop();
  vidVideo = Handle;
  vidVideo:SetVLTRB(0.0, 0.0, 320.0, 240.0);
  vidVideo:SetTCLTRB(0.0, 0.0, 1.0, 1.0);
  vidVideo:SetFilter(true);
  vidVideo:Play();
  return vidVideo;
end
-- Return music handle ----------------------------------------------------- --
local function GetMusic() return musMusic end;
-- Set music and video volume ---------------------------------------------- --
local function MusicVolume(nVolume)
  if musMusic then musMusic:SetVolume(nVolume) end;
  if vidVideo then vidVideo:SetVolume(nVolume) end;
end
-- Pause if there is a music handle----------------------------------------- --
local function PauseMusic() if musMusic then musMusic:Stop() end end;
-- Resume music if there is a music handle---------------------------------- --
local function ResumeMusic() if musMusic then musMusic:Play() end end
-- Stop music -------------------------------------------------------------- --
local function StopMusic(iPosCmd)
  -- No current track? No problem
  if not musMusic then return end;
  -- Save position?
  if 1 == iPosCmd then
    -- Save position
    nPosition = musMusic:GetPosition();
    -- Save loop count
    iLoops = musMusic:GetLoop();
  end
  -- Stop music
  musMusic = musMusic:Stop();
end
-- ------------------------------------------------------------------------- --
local function PlayMusic(musHandle, nVolume, iPosCmd, iLoop, iStart)
  -- Set default parameters that aren't specified
  if not UtilIsNumber(nVolume) then nVolume = 1 end;
  if not UtilIsInteger(iPosCmd) then iPosCmd = 0 end;
  if not UtilIsInteger(iLoop) then iLoop = -1 end;
  if not UtilIsInteger(iStart) then iStart = 0 end;
  -- Stop music
  StopMusic(iPosCmd);
  -- Handle specified?
  if musHandle then
    -- Set loop
    if iStart then musHandle:SetLoopBegin(iStart) end;
    -- Pause video if there is one
    if vidVideo then vidVideo:Pause() end;
    -- Asked to restore position?
    if 2 == iPosCmd and nPosition and nPosition > 0 then
      -- Restore position
      musHandle:SetPosition(nPosition);
      -- Play music
      musHandle:SetLoop(iLoops);
      -- Delete position and loop variable
      nPosition, iLoops = nil, nil;
    -- No restore position?
    else
      -- Play music from start
      musHandle:SetPosition(0);
      -- iLoop forever
      musHandle:SetLoop(-1);
    end
    -- Set volume
    musHandle:SetVolume(nVolume);
    -- Play music
    musHandle:Play();
    -- Set current track
    musMusic = musHandle;
  end
end
-- Function to play sound at the specified pan ----------------------------- --
local function PlaySound(iSfxId, nPan, nPitch)
  aSounds[iSfxId]:Play(1, nPan, nPitch or 1, false);
end
-- Function to play sound with no panning ---------------------------------- --
local function PlayStaticSound(iSfxId, nGain, nPitch)
  aSounds[iSfxId]:Play(nGain or 1, 0, nPitch or 1, false);
end
-- Function to loop the specified sound at the specified pan --------------- --
local function LoopSound(iSfxId, nPan, nPitch)
  aSounds[iSfxId]:Play(1, nPan, nPitch or 1, true);
end
-- Function to loop the specified sound with no panning -------------------- --
local function LoopStaticSound(iSfxId, nGain, nPitch)
  aSounds[iSfxId]:Play(nGain or 1, 0, nPitch or 1, true);
end
-- Function to stop specified sound ---------------------------------------- --
local function StopSound(iSfxId) aSounds[iSfxId]:Stop() end;
-- Function to register loaded sounds list --------------------------------- --
local function RegisterSounds(aHandles, iStart, iExpect)
  -- Check parameters
  if not UtilIsTable(aHandles) then
    error("Invalid table specified: "..tostring(aHandles)) end;
  if not UtilIsInteger(iStart) then
    error("Invalid start specified: "..tostring(iStart)) end;
  if not UtilIsInteger(iExpect) then
    error("Invalid count specified: "..tostring(iExpect)) end;
  if iStart < 1 then
    error("Invalid start specified: "..iStart) end;
  if iExpect < 0 then
    error("Invalid expect specified: "..iExpect) end;
  local iEnd<const> = iStart + iExpect - 1;
  if iEnd > #aHandles then
    error("Invalid end specified: "..iStart..","..iExpect..","..iEnd) end;
  -- Set all the requested handles
  for iSHIndex = iStart, iEnd do
    aSounds[1 + #aSounds] = aHandles[iSHIndex] end;
  -- Check we got the correct amount
  if iExpect ~= #aSounds then
    error("Only "..#aSounds.." of "..iExpect.." sound effects!") end;
end
-- Return module information ----------------------------------------------- --
return { F = Util.Blank, A = { GetMusic = GetMusic, LoopSound = LoopSound,
  LoopStaticSound = LoopStaticSound, MusicVolume = MusicVolume,
  PauseMusic = PauseMusic, PlayMusic = PlayMusic, PlaySound = PlaySound,
  PlayStaticSound = PlayStaticSound, RegisterSounds = RegisterSounds,
  ResumeMusic = ResumeMusic, StopMusic = StopMusic, StopSound = StopSound,
  VideoPause = VideoPause, VideoPlay = VideoPlay, VideoResume = VideoResume,
  VideoStop = VideoStop, InitTNTMap = InitTNTMap } };
-- End-of-File ============================================================= --
