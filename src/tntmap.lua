-- TNTMAP.LUA ============================================================== --
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
-- Engine function aliases ------------------------------------------------- --
local TextureCreateTS<const>, TextureUploadEx<const>, ImageRaw<const>,
      AssetCreate<const>
      = -- ----------------------------------------------------------------- --
      Texture.CreateTS, Texture.UploadEx, Image.Raw, Asset.Create;
-- Diggers function and data aliases --------------------------------------- --
local BlitSLTWH, BlitLT, Fade, GameProc, GetGameTicks, InitContinueGame,
  aLvlData, LoadResources, PlayStaticSound, RenderAll, RenderShadow,
  RenderTip, SetCallbacks, SetHotSpot, SetKeys, aObjs, aTileData,
  oTileFlags, texSpr;
-- Locals ------------------------------------------------------------------ --
local aAssets,                         -- Assets required
      asBData;                         -- The raw pixel data asset handle
local iBSize<const> = 128 * 128 * 3;   -- Byte size of map
local iHotSpotIdDown, iHotSpotIdUp,    -- Hot spot id (up and down)
      iKeyBankIdDown, iKeyBankIdUp,    -- Key bank id (up and down)
      imTerrain,                       -- The raw pixel data bitmap handle
      iSClick, iSSelect,               -- Sound effect ids
      iTerrainPage,                    -- Terrain page (0 or 1)
      iWFlags, iSFlags,                -- Water and solid tile flag
      nNextUpdate,                     -- Next map update (updates on 1st tick)
      texMap,                          -- TNT map texture
      texTerrain;                      -- Terrain texture handle (dynamic)
-- Leave the map ----------------------------------------------------------- --
local function GoExit()
  -- Play sound
  PlayStaticSound(iSSelect);
  -- Dereference assets for garbage collector
  asBData, imTerrain, texMap, texTerrain = nil, nil, nil, nil;
  -- Start the loading waiting procedure
  SetCallbacks(GameProc, RenderAll);
  -- Continue game
  InitContinueGame(false);
end
-- Select a different page ------------------------------------------------- --
local function GoSelect(iPageId, iSoundId, iKeyBankId, iHotSpotId)
  -- Play requested sound effect
  PlayStaticSound(iSoundId);
  -- Set new page
  iTerrainPage = iPageId;
  -- Set new hotspot and keybank id
  SetHotSpot(iHotSpotId);
  SetKeys(true, iKeyBankId);
end
-- Scrolling callback functions -------------------------------------------- --
local function GoUp()
  GoSelect(0, iSSelect, iKeyBankIdDown, iHotSpotIdDown) end;
local function GoDown()
  GoSelect(1, iSSelect, iKeyBankIdUp, iHotSpotIdUp) end;
local function GoScroll(nX, nY)
  if nY > 0 and iTerrainPage == 1 then
    GoSelect(0, iSClick, iKeyBankIdDown, iHotSpotIdDown);
  elseif nY < 0 and iTerrainPage == 0 then
    GoSelect(1, iSClick, iKeyBankIdUp, iHotSpotIdUp);
  end
end
-- Render callback --------------------------------------------------------- --
local function ProcRender()
  -- Render everything
  RenderAll();
  -- Draw appropriate background
  BlitLT(texMap, 8.0, 8.0);
  -- Render shadow
  RenderShadow(8.0, 8.0, 312.0, 208.0);
  -- Render tip
  RenderTip();
  -- Draw terrain
  BlitSLTWH(texTerrain, iTerrainPage, 32, 44, 256, 128);
  -- Dim appropriate button
  texSpr:SetCRGBA(1.0, 0.0, 0.0, 0.5);
  if iTerrainPage == 0 then
    BlitSLTWH(texSpr, 1022, 140.0, 179.0, 17.0, 17.0);
  elseif iTerrainPage == 1 then
    BlitSLTWH(texSpr, 1022, 162.0, 179.0, 17.0, 17.0) end;
  texSpr:SetCRGBA(1.0, 1.0, 1.0, 1.0);
end
-- TNT map procedure ------------------------------------------------------- --
local function ProcLogic()
  -- Perform game actions
  GameProc();
  -- Done if map update interval not reached
  if GetGameTicks() < nNextUpdate then return end;
  -- Wait about another five seconds
  nNextUpdate = GetGameTicks() + 60;
  -- For each pixel row
  for iY = 0, 127 do
    -- Calculate Y position in destination bitmap
    local iBYPos<const> = (iBSize - ((iY + 1) * 384)) + 3;
    -- Calculate Y position from level data (with the index starting from 1)
    local iLYPos<const> = 1 + (iY * 128);
    -- For each pixel column
    for iX = 0, 127 do
      -- Get tile at level position and tile flags at it
      local iTId<const> = aLvlData[iLYPos + iX];
      local iTFlags<const> = aTileData[1 + iTId];
      -- Get bitmap position and then the locations of the components
      local iBPos<const> = iBYPos + (iX * 3);
      local iBPosGB<const> = iBPos - 2; -- Green/Blue (16-bit write)
      local iBPosR<const> = iBPos - 3; -- Red (8-bit write)
      -- Pixel values to write (Green/Blue + Red)
      local iIGB, iIR;
      -- Tile is clear?
      if iTId == 0 then iIGB, iIR = 0xFACE, 0x87;
      -- Tile is solid diggable block?
      elseif iTId == 3 then iIGB, iIR = 0x1A7F, 0x00;
      -- Tile is water?
      elseif iTFlags & iWFlags ~= 0 then iIGB, iIR = 0xFF00, 0x00;
      -- Tile is not destructible and not dug?
      elseif iTFlags & iSFlags == 0 then iIGB, iIR = 0x7F70, 0x7F;
      -- Other tiles
      else iIGB, iIR = 0x0000, 0x00 end;
      -- Apply pixel
      asBData:WU16LE(iBPosGB, iIGB);
      asBData:WU8(iBPosR, iIR);
    end
  end
  -- For each object, treat as POI
  for iObjectId = 1, #aObjs do
    -- Get object
    local oObj<const> = aObjs[iObjectId];
    -- Get position in pixel in bitmap for object
    local iPos<const> = (iBSize - ((oObj.AY + 1) * 384)) + (oObj.AX * 3) + 3;
    -- Make a white RGB dot
    asBData:WU16LE(iPos - 2, 0xFFFF);
    asBData:WU8(iPos - 3, 0xFF);
  end
  -- Replace the raw pixel data in the bitmap object
  imTerrain:Replace(asBData)
  -- Upload the new terrain data directly to GPU
  texTerrain:UploadEx(0, imTerrain, 0, 0);
end
-- On assets loaded event -------------------------------------------------- --
local function OnAssetsLoaded(aResources)
  -- Initialise variables
  texMap, iTerrainPage, nNextUpdate = aResources[1], 0, 0;
  -- Set hotspot and key bank ids
  SetHotSpot(iHotSpotIdDown);
  SetKeys(true, iKeyBankIdDown);
  -- Set callbacks
  SetCallbacks(ProcLogic, ProcRender);
  -- Create the first buffer for raw pixel data
  asBData = AssetCreate("TNTMap", iBSize);
  -- Generate the first image bitmap from the raw data (asBData is now empty)
  imTerrain = ImageRaw("TNTMap", asBData, 128, 128, 24, 0x1907);
  -- Generate the texture from the bitmap image (imTerrain is now empty)
  texTerrain = TextureCreateTS(imTerrain, 128, 64, 0, 0, 0);
  -- Restore raw pixel memory data size for second bitmap handle
  asBData:Resize(iBSize);
  -- Generate a new image from the swapped out image (asBData is empty again)
  imTerrain = ImageRaw("TNTMapDummy", asBData, 128, 128, 24, 0x1907);
  -- Restore raw pixel data size for the new upload
  asBData:Resize(iBSize);
end
-- Init TNT map screen function -------------------------------------------- --
local function InitTNTMap()
  LoadResources("TNTMap", aAssets, OnAssetsLoaded);
end
-- Scripts have been loaded ------------------------------------------------ --
local function OnScriptLoaded(GetAPI)
  -- Functions and variables used in this scope only
  local RegisterHotSpot, RegisterKeys, oAssetsData, oCursorIdData, oSfxData;
  -- Grab imports
  BlitSLTWH, BlitLT, Fade, GameProc, GetGameTicks, InitContinueGame,
    LoadResources, PlayStaticSound, RegisterHotSpot, RegisterKeys,
    RenderAll, RenderShadow, RenderTip, SetCallbacks, SetHotSpot,
    SetKeys, oAssetsData, oCursorIdData, aLvlData, aObjs, oSfxData,
    aTileData, oTileFlags, texSpr =
      GetAPI("BlitSLTWH", "BlitLT", "Fade", "GameProc", "GetGameTicks",
        "InitContinueGame", "LoadResources", "PlayStaticSound",
        "RegisterHotSpot", "RegisterKeys", "RenderAll", "RenderShadow",
        "RenderTip", "SetCallbacks", "SetHotSpot", "SetKeys", "oAssetsData",
        "oCursorIdData", "aLvlData", "aObjs", "oSfxData", "aTileData",
        "oTileFlags", "texSpr");
  -- Setup required assets
  aAssets = { oAssetsData.tntmap };
  -- Get sound effects
  iSSelect, iSClick = oSfxData.SELECT, oSfxData.CLICK;
  -- Get cursor ids
  local iCExit, iCSelect = oCursorIdData.EXIT, oCursorIdData.SELECT;
  -- Setup hotspots
  local aHUp<const>, aHDown<const>, aHMap<const>, aHExit<const> =
    { 140, 179,  17,  17, 0, iCSelect, "PAGE UP",   GoScroll, GoUp   },
    { 162, 179,  17,  17, 0, iCSelect, "PAGE DOWN", GoScroll, GoDown },
    {   8,   8, 304, 200, 0, 0,        "TNT MAP",   GoScroll, false  },
    {   0,   0,   0, 240, 3, iCExit,   "CLOSE",     GoScroll, GoExit }
  iHotSpotIdUp = RegisterHotSpot({ aHUp, aHMap, aHExit });
  iHotSpotIdDown = RegisterHotSpot({ aHDown, aHMap, aHExit });
  -- Register keybinds
  local oKeys<const> = Input.KeyCodes;
  local sName<const> = "IN-GAME TNT MAP";
  local iPress<const> = Input.States.PRESS;
  local aKExit<const>, aKUp<const>, aKDown<const> =
    { oKeys.ESCAPE, GoExit, "igtnte",  "LEAVE"       },
    { oKeys.UP,     GoUp,   "igtntsu", "SCROLL UP"   },
    { oKeys.DOWN,   GoDown, "igtntsd", "SCROLL DOWN" };
  iKeyBankIdUp = RegisterKeys(sName, { [iPress] = { aKUp, aKExit } });
  iKeyBankIdDown = RegisterKeys(sName, { [iPress] = { aKDown, aKExit } });
  -- Store water and solid tile flags
  iWFlags, iSFlags = oTileFlags.W, oTileFlags.D + oTileFlags.AD;
end
-- Exports and imports ----------------------------------------------------- --
return { A = { InitTNTMap = InitTNTMap }, F = OnScriptLoaded };
-- End-of-File ============================================================= --
