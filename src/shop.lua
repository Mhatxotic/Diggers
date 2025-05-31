-- SHOP.LUA ================================================================ --
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
local random<const>, format<const>, error<const>, tostring<const> =
  math.random, string.format, error, tostring;
-- M-Engine function aliases ----------------------------------------------- --
local CoreTicks<const>, UtilIsInteger<const>, UtilIsTable<const> =
  Core.Ticks, Util.IsInteger, Util.IsTable;
-- Diggers function and data aliases --------------------------------------- --
local BlitSLT, BuyItem, Fade, GameProc, GetActiveObject, InitCon, InitLobby,
  LoadResources, LoopStaticSound, PlayMusic, PlayStaticSound, PrintC,
  RenderAll, RenderShadow, RenderTip, SetCallbacks, SetHotSpot, SetKeys,
  SetTip, StopSound, aObjectActions, aObjectData, aObjectDirections,
  aObjectJobs, aShopData, fontLittle, fontSpeech, fontTiny;
-- Locals ------------------------------------------------------------------ --
local aActiveObject,                   -- Currently selected digger
      aAssets,                         -- Assets required
      aBuyObject,                      -- Currently selected object data
      aDiggerInfo,                     -- Digger properties
      iAnimDoor,                       -- Current door animation id
      iAnimDoorMod,                    -- Door visibility
      iBuyHoloId,                      -- Current holo emitter id
      iBuyId,                          -- Currently selected object id
      iBuyObjTypeId,                   -- Currently selected object type id
      iForkAnim,                       -- Current forklift truck animation id
      iForkAnimMod,                    -- Forklift enabled id
      iHoloAnimTileId,                 -- Current holo emitter animation id
      iHoloAnimTileIdMod,              -- Holo emitter is being shown
      iHotSpotId,                      -- Active hot spot id
      iHotSpotClosedId,                -- Closed hot spot id
      iHotSpotOpenId,                  -- Opened hot spot id
      iKeyBankId,                      -- Active key bank id
      iKeyBankClosedId,                -- Closed key bank id
      iKeyBankOpenId,                  -- Opened key bank id
      iSHolo,                          -- Switch product sound effect id
      iSError, iSFind, iSHoloHum,      -- Sound effect ids
      iSOpen, iSSelect, iSTrade,       -- More sound effect ids
      iSpeechTicks,                    -- Speech ticks left and shop open
      sLongName, sPrice, sDesc,        -- Long name and info of product
      sMsg,                            -- Speech text
      texShop;                         -- shop texture
-- Tile ids (see data.lua/aAssetsData.shop.P) ------------------------------ --
local iTileDoor<const> = 31;           local iTileFork<const> = 46;
local iTileDoorMax     = iTileDoor + 14;   -- Maximum door tile id
local iTileAnimMax     = iTileFork + 11;   -- Maximum forklift tile id
-- Update price and carryable display -------------------------------------- --
local function UpdateCarryable()
  sPrice = format("%03uz (%u)",
    aBuyObject.VALUE,
    (aDiggerInfo.STRENGTH - aActiveObject.IW) // aBuyObject.WEIGHT)
end
-- Set actual new object --------------------------------------------------- --
local function SetProduct(iId)
  -- Check id is valid
  if not UtilIsInteger(iId) then error("No id specified to set!") end;
  -- Get object type from shelf and make sure it's valid
  local iObjType<const> = aShopData[iId];
  if not UtilIsInteger(iObjType) then
    error("No shop data for item '"..iId.."'!") end;
  -- Set object information and make sure the object data is valid
  iBuyId, iBuyObjTypeId, aBuyObject, iBuyHoloId =
    iId, iObjType, aObjectData[iObjType], iId - 1;
  if not UtilIsTable(aBuyObject) then
    error("No object data for object type '"..iObjType.."'!") end;
  sLongName = aBuyObject.LONGNAME;
  sDesc = aBuyObject.DESC;
  -- Animate the holographic emitter
  iHoloAnimTileId, iHoloAnimTileIdMod = 13, 1;
  -- Update Digger carrying weight
  UpdateCarryable();
end
-- Scroll through objects -------------------------------------------------- --
local function AdjustProduct(iAmount)
  -- Play switching sound
  PlayStaticSound(iSHolo);
  -- Adjust item and wrap around out of bounds values
  SetProduct((iBuyId + iAmount - 1) % #aShopData + 1);
end
-- Shop logic function ----------------------------------------------------- --
local function ProcLogic()
  -- Perform game functions in the background
  GameProc();
  -- Time elapsed to animate the holographic emitter?
  if CoreTicks() % 4 == 0 then
    -- Animate the holographic emitter
    iHoloAnimTileId = iHoloAnimTileId + iHoloAnimTileIdMod;
    if iHoloAnimTileId == 19 then iHoloAnimTileIdMod = -1;
    elseif iHoloAnimTileId == 15 then iHoloAnimTileIdMod = 1 end;
  end
  -- Time elapsed to animate the door and forklift?
  if CoreTicks() % 8 == 0 then
    -- Animate the door
    iAnimDoor = iAnimDoor + iAnimDoorMod;
    if iAnimDoor == iTileDoorMax then iAnimDoorMod = -1;
    elseif iAnimDoor == iTileDoor then iAnimDoorMod = 0 end;
    -- Animate the forklift
    iForkAnim = iForkAnim + iForkAnimMod;
    if iForkAnim == iTileAnimMax then
      iForkAnim, iForkAnimMod = iTileFork, 0 end;
  end
  -- Speech ticks set?
  if iSpeechTicks > 0 then
    -- Reduce ticks count and if the ticks have run out?
    iSpeechTicks = iSpeechTicks - 1;
    if iSpeechTicks == 0 then
      -- Restore keybank and hotspot id
      SetHotSpot(iHotSpotId);
      SetKeys(true, iKeyBankId);
    end
  end
end
-- Render main background scene--------------------------------------------- --
local function RenderBackground()
  -- Render original interface backdrop and shadow
  RenderAll();
  BlitSLT(texShop, 20, 8, 8);
  RenderShadow(8, 8, 312, 208);
  -- Draw animations
  if iAnimDoor ~= 0 then BlitSLT(texShop, iAnimDoor, 272, 79) end;
  if random() < 0.001 and iAnimDoorMod == 0 then iAnimDoorMod = 1 end;
  BlitSLT(texShop, CoreTicks() // 10 % 3 + 28, 9, 174); -- Floor lights
  if iForkAnim ~= 0 then BlitSLT(texShop, iForkAnim, 112, 95) end;
  if random() < 0.001 and iForkAnimMod == 0 then iForkAnimMod = 1 end;
end
-- Render speech bubble scene ---------------------------------------------- --
local function RenderSpeech()
  -- Speech ticks set?
  if iSpeechTicks > 0 then
    -- Render shopkeeper talking and speech bubble
    BlitSLT(texShop, CoreTicks() // 10 % 4 + 22, 112, 127);
    BlitSLT(texShop, 21, 0, 160);
    PrintC(fontSpeech, 56, 167, sMsg);
  end
  -- Render tip
  RenderTip();
end
-- Render open function ---------------------------------------------------- --
local function RenderOpen()
  -- Render background part
  RenderBackground();
  -- Render open parts
  BlitSLT(texShop, iBuyHoloId, 197, 88);
  BlitSLT(texShop, iHoloAnimTileId, 197, 88);
  BlitSLT(texShop, 27, 200, 168); -- Holo emitter light
  BlitSLT(texShop, 26, 16, 16); -- Product info background
  fontLittle:SetCRGB(0.5, 1, 0.5);
  PrintC(fontLittle, 80, 31, sLongName);
  fontLittle:SetCRGB(1, 1, 0);
  PrintC(fontLittle, 80, 63, sPrice);
  fontTiny:SetCRGB(0.5, 0.75, 0);
  PrintC(fontTiny, 80, 43, sDesc);
  -- Render speech and tip
  RenderSpeech();
end
-- Render closed function -------------------------------------------------- --
local function RenderClosed()
  -- Render background part, speech and tip
  RenderBackground();
  RenderSpeech();
end
-- Make the guy talk ------------------------------------------------------- --
local function SetSpeech(sMessage)
  -- Set message and wait time
  sMsg, iSpeechTicks = sMessage, 120;
  -- Disable keys and set wait hot spot
  SetKeys(true);
  SetHotSpot();
  -- Set waiting tip
  SetTip("WAIT...");
end
-- Make the guy talk with a sound effect ----------------------------------- --
local function SetSpeechSound(sMessage, iSfxId)
  -- Play sound and show speech text
  PlayStaticSound(iSfxId);
  SetSpeech(sMessage);
end
-- Open up the shop -------------------------------------------------------- --
local function GoOpen()
  -- Play sound effects
  PlayStaticSound(iSSelect);
  PlayStaticSound(iSOpen);
  LoopStaticSound(iSHoloHum);
  -- Set open shop keys and active ids
  iKeyBankId = iKeyBankOpenId;
  SetKeys(true, iKeyBankOpenId);
  iHotSpotId = iHotSpotOpenId;
  SetHotSpot(iHotSpotOpenId);
  -- Set open shop logic
  SetCallbacks(ProcLogic, RenderOpen);
end
-- Shop exit requested ----------------------------------------------------- --
local function GoExit()
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Stop humming sound
  StopSound(iSHoloHum);
  -- Dereference assets for garbage collector
  texShop = nil;
  -- Set no keys and hot spots
  SetKeys(true);
  SetHotSpot();
  -- Start the loading waiting procedure
  SetCallbacks(GameProc, RenderAll);
  -- Return to lobby
  InitLobby();
end
-- Adjust product ---------------------------------------------------------- --
local function GoLast() AdjustProduct(-1) end;
local function GoNext() AdjustProduct(1) end;
local function GoBuy()
  -- Check weight and if can't carry this?
  if aActiveObject.IW + aBuyObject.WEIGHT > aDiggerInfo.STRENGTH then
    SetSpeechSound("TOO HEAVY FOR YOU", iSError);
  -- Try to buy it and if failed?
  elseif BuyItem(aActiveObject, iBuyObjTypeId) then
    SetSpeechSound("SOLD TO YOU NOW!", iSTrade);
    PlayStaticSound(iSTrade);
    UpdateCarryable();
  -- Can't afford it
  else SetSpeechSound("YOU CAN'T AFFORD IT!", iSError) end;
end
-- Scroll wheel function --------------------------------------------------- --
local function Scroll(nX, nY)
  if nY > 0 then GoLast() elseif nY < 0 then GoNext() end;
end
-- When shop assets have loaded? ------------------------------------------- --
local function OnAssetsLoaded(aResources)
  -- Play shop music
  PlayMusic(aResources[2], nil, nil, nil, 854034);
  -- Set texture handle
  texShop = aResources[1];
  -- Reset animations
  iAnimDoor, iAnimDoorMod = iTileDoor, 0;
  iForkAnim, iForkAnimMod = iTileFork, 0;
  -- Set colour of speech text
  fontSpeech:SetCRGB(0, 0, 0.25);
  -- Set initial speech bubble
  SetSpeech("SELECT ME TO OPEN SHOP");
  -- Select first object
  SetProduct(1);
  -- Set closed shop keys and hotspots
  iHotSpotId, iKeyBankId = iHotSpotClosedId, iKeyBankClosedId;
  -- Set waiting for initial speech bubble
  SetHotSpot();
  -- Set shop callbacks
  SetCallbacks(ProcLogic, RenderClosed);
end
-- Initialise the shop screen ---------------------------------------------- --
local function InitShop()
  -- Get selected digger
  aActiveObject = GetActiveObject();
  if not UtilIsTable(aActiveObject) then
    error("Invalid customer object specified! "..tostring(aActiveObject)) end;
  -- Get object data
  aDiggerInfo = aActiveObject.OD;
  -- Load shop resources
  LoadResources("Shop", aAssets, OnAssetsLoaded);
end
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, aAssetsData, aCursorIdData, aSfxData;
  -- Grab imports
  BlitSLT, BuyItem, Fade, GameProc, GetActiveObject, InitCon, InitLobby,
    LoadResources, LoopStaticSound, PlayMusic, PlayStaticSound, PrintC,
    RegisterHotSpot, RegisterKeys, RenderAll, RenderShadow, RenderTip,
    SetCallbacks, SetHotSpot, SetKeys, SetTip, StopSound, aAssetsData,
    aCursorIdData, aObjectActions, aObjectData, aObjectDirections, aObjectJobs,
    aSfxData, aShopData, fontLittle, fontSpeech, fontTiny =
      GetAPI("BlitSLT", "BuyItem", "Fade", "GameProc", "GetActiveObject",
        "InitCon", "InitLobby", "LoadResources", "LoopStaticSound",
        "PlayMusic", "PlayStaticSound", "PrintC", "RegisterHotSpot",
        "RegisterKeys", "RenderAll", "RenderShadow", "RenderTip",
        "SetCallbacks", "SetHotSpot", "SetKeys", "SetTip", "StopSound",
        "aAssetsData", "aCursorIdData", "aObjectActions", "aObjectData",
        "aObjectDirections", "aObjectJobs", "aSfxData", "aShopData",
        "fontLittle", "fontSpeech", "fontTiny");
  -- Setup assets required
  aAssets = { aAssetsData.shop, aAssetsData.shopm };
  -- Register hotspots
  local iCSelect<const>, iCExit<const> =
    aCursorIdData.SELECT, aCursorIdData.EXIT;
  iHotSpotClosedId = RegisterHotSpot({
    {  94, 130,  59,  76, 0, iCSelect, "OPEN SHOP",   false, GoOpen },
    {   8,   8, 304, 200, 0, 0,        "SHOP IDLE",   false, false  },
    {   0,   0,   0, 240, 3, iCExit,   "GO TO LOBBY", false, GoExit }
  });
  iHotSpotOpenId = RegisterHotSpot({
    {  31,  59,  16,  15, 0, iCSelect, "LAST ITEM",   Scroll, GoLast },
    { 110,  59,  16,  15, 0, iCSelect, "NEXT ITEM",   Scroll, GoNext },
    { 197,  88,  64,  64, 0, iCSelect, "PURCHASE",    Scroll, GoBuy  },
    {   8,   8, 304, 200, 0, 0,        "SHOP",        Scroll, false  },
    {   0,   0,   0, 240, 3, iCExit,   "GO TO LOBBY", Scroll, GoExit }
  });
  -- Register keybinds
  local aKeys<const> = Input.KeyCodes;
  local iPress<const> = Input.States.PRESS;
  local aEscape<const> = { aKeys.ESCAPE, GoExit, "zmtcsl", "LEAVE" };
  local sName<const> = "ZMTC SHOP";
  iKeyBankClosedId = RegisterKeys(sName, { [iPress] = { aEscape,
    { aKeys.ENTER, GoOpen, "zmtcso", "OPEN" },
  } });
  iKeyBankOpenId = RegisterKeys(sName, { [iPress] = { aEscape,
    { aKeys.LEFT,  GoLast, "zmtcspp", "PREVIOUS PRODUCT" },
    { aKeys.RIGHT, GoNext, "zmtcsnp", "NEXT PRODUCT"     },
    { aKeys.SPACE, GoBuy,  "zmtcsbp", "PURCHASE PRODUCT" },
  } });
  -- Set sound effect ids
  iSError, iSFind, iSHolo, iSHoloHum, iSOpen, iSSelect, iSTrade =
    aSfxData.ERROR, aSfxData.FIND, aSfxData.SSELECT, aSfxData.HOLOHUM,
    aSfxData.SOPEN, aSfxData.SELECT, aSfxData.TRADE;
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitShop = InitShop }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
