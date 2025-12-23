-- BANK.LUA ================================================================ --
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
local format<const>, unpack<const>, error<const> =
  string.format, table.unpack, error;
-- Engine function aliases ------------------------------------------------- --
local UtilBlank<const>, UtilIsTable<const> = Util.Blank, Util.IsTable;
-- Diggers function and data aliases --------------------------------------- --
local BlitLT, BlitSLT, Fade, GameProc, GetActiveObject, GetGameTicks,
  HaveZogsToWin, InitLobby, LoadResources, PlayMusic, PlayStaticSound, PrintC,
  RenderAll, RenderShadow, RenderTip, SellSpecifiedItems, SetCallbacks,
  SetHotSpot, SetKeys, SetTip, aGemsAvailable, oObjectActions, oObjectData,
  oObjectDirections, oObjectJobs, oObjectTypes, fontSpeech, texSpr;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Required assets
      aBankerData,                     -- Banker data
      bGameWon,                        -- Game is won?
      fcbSpeechCallback,               -- Speech callback
      iAnimTimer,                      -- Animation timer
      iBankerId,                       -- Banker id selected
      iBankerTexId,                    -- Banker texture id selected
      iHotSpotId,                      -- Bank hotspot id
      iKeyBankId,                      -- Bank key bank id
      iSError, iSFind, iSSelect,       -- Sound effect ids
      iSTrade,                         -- Trade sound effect id
      nBankerX, nBankerY,              -- Banker position
      nSpeechBubbleX, nSpeechBubbleY,  -- Speech bubble position
      nSpeechTextX, nSpeechTextY,      -- Speech text position
      iSpeechTimer,                    -- Speech timer
      iTreasureValueModifier,          -- Modified treasure value
      oObjActive,                      -- Currently selected digger
      oPlayer,                         -- Owner of digger
      strBankerSpeech,                 -- Speech bubble text
      texBank;                         -- Bank texture
-- Tile data (See data.hpp/oAssetsData.bank.P) ----------------------------- --
local tileSpeech<const> = 1;           -- Speech tile
-- Banker id to mouse function look up table ------------------------------- --
local aBankerStaticData<const> = {
  -- GemXY --- TexId --- BankerXY ---- BubbleXY ---- MessageXY ----
  {  50.0, 21.0, { 1,   25.0, 96.0,    0.0, 62.0,   56.0, 69.0 } }, -- [1]
  { 153.0, 21.0, { 4,  129.0, 96.0,  104.0, 62.0,  160.0, 69.0 } }, -- [2]
  { 257.0, 21.0, { 7,  233.0, 96.0,  208.0, 62.0,  264.0, 69.0 } }  -- [3]
  -- GemXY --- TexId --- BankerXY ---- BubbleXY ---- MessageXY ----
};
-- Function to refresh banker data ----------------------------------------- --
local function RefreshData()
  -- Return if not enough data or data the same
  if #aBankerData == #aBankerStaticData and
    aGemsAvailable[1] == aBankerData[1][1] then return end;
    -- For each gem available
  for iGemId = 1, #aBankerStaticData do
    -- Get gem type and function data
    local iGemTypeId<const> = aGemsAvailable[iGemId];
    local aFuncData<const> = aBankerStaticData[iGemId];
    local aGemObjData<const> = oObjectData[iGemTypeId];
    -- Insert data into lookup table
    aBankerData[iGemId] = {
      iGemId,                                 -- [01] Gem (banker) id
      iGemTypeId,                             -- [02] Gem type id
      aGemObjData.VALUE // 2 +                -- [03] Gem value
        iTreasureValueModifier,
      aGemObjData[oObjectActions.STOP]        -- [04] Gem sprite
                 [oObjectDirections.NONE][1],
      aGemObjData.LONGNAME,                   -- [05] Gem name
      aFuncData[1],                           -- [06] Gem position X
      aFuncData[2],                           -- [07] Gem position Y
      aFuncData[3]                            -- [08] Speech data for banker
    };
  end
end
-- Set speech -------------------------------------------------------------- --
local function SetSpeech(iId, iHoldTime, iSfxId, strMsg, fcbOnComplete)
  -- Set speech message and banker id
  strBankerSpeech = strMsg;
  iBankerId = iId;
  -- Set render details from lookup table
  iBankerTexId, nBankerX, nBankerY, nSpeechBubbleX, nSpeechBubbleY,
    nSpeechTextX, nSpeechTextY = unpack(aBankerData[iId][8]);
  -- Finish callback
  local function OnComplete()
    -- Call completion function if set
    if fcbOnComplete then fcbOnComplete();
    -- No completion function
    else
      -- Enable hotspots and keys again
      SetHotSpot(iHotSpotId);
      SetKeys(true, iKeyBankId);
    end
  end
  -- Set event when speech completed
  fcbSpeechCallback = OnComplete;
  -- Play sound
  PlayStaticSound(iSfxId);
  -- Set speech timer
  iSpeechTimer = iHoldTime;
  -- Disable keys and set waiting hot spot
  SetKeys(true);
  SetHotSpot();
  -- Set waiting tip
  SetTip("WAIT...");
end
-- Check commands ---------------------------------------------------------- --
local function CheckPrice(iBankerId)
  -- Get data for slot
  local aData<const> = aBankerData[iBankerId];
  -- Set the price
  SetSpeech(iBankerId, 60, iSSelect,
    format("%s FETCHES $%03u", aData[5], aData[3]))
end
-- Check price callbaks ---------------------------------------------------- --
local function GoPriceFTarg() CheckPrice(1) end;
local function GoPriceHabbish() CheckPrice(2) end;
local function GoPriceGrablin() CheckPrice(3) end;
-- Function to check if player has won game -------------------------------- --
local function HasBeatenGame()
  -- Ignore if win message already used or player hasn't beaten game
  if bGameWon or not HaveZogsToWin(oPlayer) then return end;
  -- Set speech bubble for win
  SetSpeech(iBankerId, 120, iSFind, "YOU'VE WON THIS ZONE!");
  -- Set that we've won the game so we don't have to say it again
  bGameWon = true;
end
-- Sell commands ----------------------------------------------------------- --
local function Sell(iBankerId)
  -- Get gem id
  local iGemId<const> = aBankerData[iBankerId][2];
  -- Record money
  local iMoney<const>, strName = oPlayer.M, nil;
  -- Sell all Jennite first before trying to sell anything else
  if SellSpecifiedItems(oObjActive, oObjectTypes.JENNITE) > 0 then
    strName = oObjectData[oObjectTypes.JENNITE].LONGNAME;
  -- No Jennite found so try what the banker is trading
  elseif SellSpecifiedItems(oObjActive, iGemId) > 0 then
    strName = oObjectData[iGemId].LONGNAME end;
  -- Money changed hands? Set succeeded message and check for win
  if strName then
    SetSpeech(iBankerId, 60, iSTrade, strName.." SOLD FOR $"..
      format("%03u", oPlayer.M - iMoney), HasBeatenGame);
  -- Set failed speech bubble
  else SetSpeech(iBankerId, 60, iSError, "YOU HAVE NONE OF THESE!") end;
end
-- Sell callbacks ---------------------------------------------------------- --
local function GoSellFTarg() Sell(1) end;
local function GoSellHabbish() Sell(2) end;
local function GoSellGrablin() Sell(3) end;
-- Exit bank to lobby ------------------------------------------------------ --
local function GoToLobby()
  -- Play sound and exit to game
  PlayStaticSound(iSSelect);
  -- Dereference assets to garbage collector
  texBank = nil;
  -- Disable keys and hotspots
  SetKeys(true);
  SetHotSpot();
  -- Start the loading waiting procedure
  SetCallbacks(GameProc, RenderAll);
  -- Return to lobby
  InitLobby();
end
-- Speech render procedure ------------------------------------------------- --
local function ProcRender()
  -- Render original interface
  RenderAll();
  -- Draw backdrop with bankers and windows
  BlitLT(texBank, 8.0, 8.0);
  -- For each banker
  for iI = 1, #aBankerData do
    -- Get banker data and draw the gem that the banker will sell
    local aData<const> = aBankerData[iI];
    BlitSLT(texSpr, aData[4], aData[6], aData[7]);
  end
  -- Speech bubble should show?
  if iSpeechTimer > 0 then
    -- Show banker talking graphic, speech bubble and text
    local iAnimId<const> = iAnimTimer % 4;
    if iAnimId > 0 then
      BlitSLT(texBank, iAnimId + iBankerTexId, nBankerX, nBankerY);
    end
    BlitSLT(texBank, tileSpeech, nSpeechBubbleX, nSpeechBubbleY);
    PrintC(fontSpeech, nSpeechTextX, nSpeechTextY, strBankerSpeech);
  end
  -- Render tip
  RenderTip();
end
-- Main bank procedure ----------------------------------------------------- --
local function ProcLogic()
  -- Process game procedures
  GameProc();
  -- Check for change
  RefreshData();
  -- Return if no speech bubble should show
  if iSpeechTimer == 0 then return end;
  -- Decrement speech bubble timer
  iSpeechTimer = iSpeechTimer - 1;
  -- Calculate animation timer
  iAnimTimer = iSpeechTimer // 10;
  -- Return if still talking
  if iSpeechTimer > 0 then return end;
  -- Restore bank keys and hot spots
  SetKeys(true, iKeyBankId);
  SetHotSpot(iHotSpotId);
  -- Call ending callback
  if fcbSpeechCallback then fcbSpeechCallback = fcbSpeechCallback() end;
end
-- Resources loaded event callback ----------------------------------------- --
local function OnAssetsLoaded(aResources)
  -- Play bank music
  PlayMusic(aResources[2], nil, nil, nil, 237364);
  -- Load texture. We only have 12 animations, discard all the other tiles
  -- as we're using the same bitmap for other sized textures.
  texBank = aResources[1];
  -- Get treasure value modifier
  iTreasureValueModifier = GetGameTicks() // 18000;
  -- Banker data
  aBankerData = { };
  -- Initialise banker data
  RefreshData();
  -- No speech bubbles, reset win notification and set empty tip
  iSpeechTimer = 0;
  -- Set colour of speech text
  fontSpeech:SetCRGB(0.0, 0.0, 0.25);
  -- Speech render data and message
  strBankerSpeech, iBankerId, iBankerTexId, nBankerX, nBankerY,
    nSpeechBubbleX, nSpeechBubbleY, nSpeechTextX, nSpeechTextY =
      nil, nil, nil, nil, nil, nil, nil, nil, nil;
  -- Set a speech bubble above the specified characters head
  fcbSpeechCallback = nil;
  -- Get active object and objects owner
  oPlayer = oObjActive.P;
  -- Prevents duplicate win messages
  bGameWon = false;
  -- Set keys and hot spots
  SetKeys(true, iKeyBankId);
  SetHotSpot(iHotSpotId);
  -- Set the callbacks
  SetCallbacks(ProcLogic, ProcRender);
end
-- Initialise the bank screen ---------------------------------------------- --
local function InitBank()
  -- Set and check active object
  oObjActive = GetActiveObject();
  if not UtilIsTable(oObjActive) then error("Object not selected!") end;
  -- Sanity check gems available count
  if #aGemsAvailable < #aBankerStaticData then
    error("Gems available mismatch ("..#aGemsAvailable.."<"..
      #aBankerStaticData..")!")
  end
  -- Load bank texture
  LoadResources("Bank", aAssets, OnAssetsLoaded);
end
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, oAssetsData, oCursorIdData, oSfxData;
  -- Grab imports
  BlitLT, BlitSLT, Fade, GameProc, GetActiveObject, GetGameTicks,
    HaveZogsToWin, InitLobby, LoadResources, PlayMusic, PlayStaticSound,
    PrintC, RegisterHotSpot, RegisterKeys, RenderAll, RenderShadow, RenderTip,
    SellSpecifiedItems, SetCallbacks, SetHotSpot, SetKeys, SetTip, oAssetsData,
    oCursorIdData, aGemsAvailable, oObjectActions, oObjectData,
    oObjectDirections, oObjectJobs, oObjectTypes, oSfxData, fontSpeech,
    texSpr =
      GetAPI("BlitLT", "BlitSLT", "Fade", "GameProc", "GetActiveObject",
        "GetGameTicks", "HaveZogsToWin", "InitLobby", "LoadResources",
        "PlayMusic", "PlayStaticSound", "PrintC", "RegisterHotSpot",
        "RegisterKeys", "RenderAll", "RenderShadow", "RenderTip",
        "SellSpecifiedItems", "SetCallbacks", "SetHotSpot", "SetKeys",
        "SetTip", "oAssetsData", "oCursorIdData", "aGemsAvailable",
        "oObjectActions", "oObjectData", "oObjectDirections", "oObjectJobs",
        "oObjectTypes", "oSfxData", "fontSpeech", "texSpr");
  -- Setup required assets
  aAssets = { oAssetsData.bank, oAssetsData.bankm };
  -- Set sound effect ids
  iSError, iSFind, iSSelect, iSTrade =
    oSfxData.ERROR, oSfxData.FIND, oSfxData.SELECT, oSfxData.TRADE;
  -- Get cursor ids
  local iCSelect<const>, iCExit<const> =
    oCursorIdData.SELECT, oCursorIdData.EXIT;
  -- Register hotspots
  iHotSpotId = RegisterHotSpot({
    {  25, 113,  62,  70, 0, iCSelect, "SELL 1ST",    false, GoSellFTarg    },
    { 129,  95,  62,  89, 0, iCSelect, "SELL 2ND",    false, GoSellHabbish  },
    { 234,  97,  61,  87, 0, iCSelect, "SELL 3RD",    false, GoSellGrablin  },
    {  40,  24,  33,  17, 0, iCSelect, "CHECK 1ST",   false, GoPriceFTarg   },
    { 144,  24,  33,  17, 0, iCSelect, "CHECK 2ND",   false, GoPriceHabbish },
    { 248,  24,  33,  17, 0, iCSelect, "CHECK 3RD",   false, GoPriceGrablin },
    {   8,   8, 304, 200, 0, 0,        "BANK",        false, false          },
    {   0,   0,   0, 240, 3, iCExit,   "GO TO LOBBY", false, GoToLobby      }
  });
  -- Register keybinds
  local oKeys<const> = Input.KeyCodes;
  iKeyBankId = RegisterKeys("ZMTC BANK", {
    [Input.States.PRESS] = {
      { oKeys.ESCAPE, GoToLobby,      "zmtcbl",   "LEAVE"        },
      { oKeys.N1,     GoPriceFTarg,   "zmtcbcsa", "CHECK SLOT 1" },
      { oKeys.N2,     GoPriceHabbish, "zmtcbcsb", "CHECK SLOT 2" },
      { oKeys.N3,     GoPriceGrablin, "zmtcbcsc", "CHECK SLOT 3" },
      { oKeys.N8,     GoSellFTarg,    "zmtcbssa", "SELL SLOT 1"  },
      { oKeys.N9,     GoSellHabbish,  "zmtcbssb", "SELL SLOT 2"  },
      { oKeys.N0,     GoSellGrablin,  "zmtcbssc", "SELL SLOT 3"  }
    }
  });
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitBank = InitBank }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
