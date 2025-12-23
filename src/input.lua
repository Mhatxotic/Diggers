-- INPUT.LUA =============================================================== --
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
local error<const>, floor<const>, pairs<const>, remove<const>, tostring<const>,
  xpcall<const> = error, math.floor, pairs, table.remove, tostring, xpcall;
-- Engine function aliases ------------------------------------------------- --
local CoreStack<const>, CoreTicks<const>, DisplayReset<const>,
  InputClearStates<const>, InputGetJoyAxis<const>, InputGetJoyButton<const>,
  InputGetNumJoyAxises<const>, InputGetNumJoyButtons<const>,
  InputOnJoyState<const>, InputOnKey<const>, InputOnMouseClick<const>,
  InputOnMouseFocus<const>, InputOnMouseMove<const>, InputOnMouseScroll<const>,
  InputSetCursor<const>, InputSetCursorCentre<const>, InputSetCursorPos<const>,
  SShotFbo<const>, UtilBlank<const>, UtilClamp<const>, UtilIsBoolean<const>,
  UtilIsFunction<const>, UtilIsInteger<const>, UtilIsString<const>,
  UtilIsTable<const>, fboMain<const> =
    Core.Stack, Core.Ticks, Display.Reset, Input.ClearStates, Input.GetJoyAxis,
    Input.GetJoyButton, Input.GetNumJoyAxises, Input.GetNumJoyButtons,
    Input.OnJoyState, Input.OnKey, Input.OnMouseClick, Input.OnMouseFocus,
    Input.OnMouseMove, Input.OnMouseScroll, Input.SetCursor,
    Input.SetCursorCentre, Input.SetCursorPos, SShot.Fbo, Util.Blank,
    Util.Clamp, Util.IsBoolean, Util.IsFunction, Util.IsInteger, Util.IsString,
    Util.IsTable, Fbo.Main();
-- Diggers function and data aliases --------------------------------------- --
local oCursorIdData, InitSetup, RegisterFBUCallback, SetErrorMessage, SetTip,
  aCursorData, iTexScale, texSpr;
-- Get input press states -------------------------------------------------- --
local oStates<const> = Input.States;
local iPress<const> = oStates.PRESS;
local iRelease<const> = oStates.RELEASE;
local iRepeat<const> = oStates.REPEAT;
-- Keyboard ---------------------------------------------------------------- --
local aGlobalKeyBinds;                 -- Global keybinds (defined later)
local aKeyBank<const> = { };           -- All keys
local tKeyBankCats<const> = { };       -- All keys categorised
local aKeyBankActive;                  -- Key/state/func translation lookup
local iKeyBank = 0;                    -- Currently active keybank
-- Mouse ------------------------------------------------------------------- --
local iCursorX, iCursorY = 0, 0;       -- Cursor position
local iCursorRX, iCursorRY = 0, 0;     -- Cursor render position
local iCursorMin, iCursorMax;          -- Cursor minimum and maximum
local iCursorAdjX, iCursorAdjY;        -- Cursor origin co-ordinates
local iCArrow, iCWait, iCId;           -- Arrow, wait and current cursor id
local nWheelX, nWheelY = 0, 0;         -- Mouse wheel state
local iDragZone, iDragButton;          -- Button held and dragging?
-- Joystick ---------------------------------------------------------------- --
local nJoyAX, nJoyAY = 0, 0;           -- Joystick axis values
local aJoy<const> = { };               -- Joysticks connected data
local aJoyState<const> = { };          -- Joystick button last value
local iJoyActive;                      -- Currently active joystick
local iJoyButtonMax;                   -- Maximum joystick buttons
-- Stage ------------------------------------------------------------------- --
local iStageLeft, iStageRight;         -- Stage left and top
local iStageTop, iStageBottom;         -- Stage right and bottom
local iStageLeft, iStageRight;     -- Stage left and top divided by two
-- Hotspots ---------------------------------------------------------------- --
local aHotSpotNone<const> = { };       -- No hotspot data
local aHotSpotBank<const> = { };       -- Bank of hotspots
local aHotSpotActive = { };            -- Currently active hotspot data
local iHotSpot = 0;                    -- Currently active hotspot id
-- Mouse is in specified bounds -------------------------------------------- --
local function IsMouseInBounds(iX1, iY1, iX2, iY2)
  return iCursorX >= iX1 and iCursorY >= iY1 and
         iCursorX < iX2 and iCursorY < iY2 end;
local function IsMouseNotInBounds(iX1, iY1, iX2, iY2)
  return iCursorX < iX1 or iCursorY < iY1 or
         iCursorX >= iX2 or iCursorY >= iY2 end;
local function IsMouseXLessThan(iX) return iCursorX < iX end;
local function IsMouseXGreaterEqualThan(iX) return iCursorX >= iX end;
local function IsMouseYLessThan(iY) return iCursorY < iY end;
local function IsMouseYGreaterEqualThan(iY) return iCursorY >= iY end;
local function GetMouseX() return iCursorX end;
local function GetMouseY() return iCursorY end;
-- When a key is pressed --------------------------------------------------- --
local function OnKey(iKey, iState)
  -- Get function for key and return if it is not assigned
  local fcbCb<const> = aKeyBankActive[iState][iKey];
  if not fcbCb then return end;
  -- Protected call so we can handle errors
  local bResult<const>, sReason<const> = xpcall(fcbCb, CoreStack);
  if not bResult then SetErrorMessage(sReason) end;
end
-- Register a hotspot ------------------------------------------------------ --
local function RegisterHotSpot(aHotSpots)
  -- Must be a table
  if not UtilIsTable(aHotSpots) then
    error("Hotspot table is invalid! "..tostring(aHotSpots)) end;
  -- Walk the hotspot data array
  for iIndex = 1, #aHotSpots do
    -- Get and check hotspot
    local aHotSpot<const> = aHotSpots[iIndex];
    if not UtilIsTable(aHotSpot) then
      error("Hotspot item at index "..iIndex.." is invalid! "..
        tostring(aHotSpot)) end;
    -- Check that there is 9 parameters
    if #aHotSpot < 9 then
      error("Hotspot item at index "..iIndex.." requires 9 parameters, not "..
        #aHotSpot.."!");
    end
    -- Get mouse over function and if set?
    local fcbHover<const> = aHotSpot[7];
    if fcbHover then
      -- If it's a string?
      if UtilIsString(fcbHover) then
        -- Create a function to set the string as a tip
        local function HoverSetTip() SetTip(fcbHover) end;
        -- Overwrite the string
        aHotSpot[7] = HoverSetTip;
      -- Else if it is not a function? Throw an error
      elseif not UtilIsFunction(fcbHover) then
        error("Hotspot hover function at index "..iIndex.." is invalid! "..
          tostring(fcbHover)) end;
    end
    -- Check scroll function
    local fcbScroll<const> = aHotSpot[8];
    if fcbScroll and not UtilIsFunction(fcbScroll) then
      error("Hotspot scroll function at index "..iIndex.." is invalid! "..
        tostring(fcbScroll)) end;
    -- Get activate function and if it's set?
    local fcbActivate<const> = aHotSpot[9];
    if fcbActivate then
      -- If it is just a function than format it in a rel+press+drag func table
      if UtilIsFunction(fcbActivate) then
        aHotSpot[9] = { false, fcbActivate, false };
      -- If it is a table?
      elseif UtilIsTable(fcbActivate) then
        -- Must only contain three items (press, release and drag)
        if #fcbActivate ~= 3 then
          error("Hotspot activate table at index "..iIndex..
            " must have two entries only! "..#fcbActivate) end;
        -- Check that they're functions
        for iAFIndex = 1, #fcbActivate do
          -- Get function
          local fcbActivateFunc<const> = fcbActivate[iAFIndex];
          if fcbActivateFunc and not UtilIsFunction(fcbActivateFunc) then
            error("Hotspot activate function "..iAFIndex.." at index "..
              iIndex.." is invalid! "..tostring(fcbActivateFunc)) end;
        end
      else error("Hotspot activate table at index "..iIndex..
        " is invalid! "..tostring(fcbActivate)) end;
    -- Not specified so just convert to table with release/press funcs
    else aHotSpot[9] = { false, false, false } end;
    -- Invalid function or table
    -- If we don't have 13 parameters?
    if #aHotSpot < 13 then
      -- Backup the dimensions because they will be destroyed
      aHotSpot[10], aHotSpot[11] = aHotSpot[1], aHotSpot[2];
      aHotSpot[12], aHotSpot[13] = aHotSpot[3], aHotSpot[4];
    end
    -- Set default arrow cursor if zero else anything out of range is an error
    local iCursor<const> = aHotSpot[6];
    if iCursor == 0 then aHotSpot[6] = iCArrow;
    elseif not aCursorData[iCursor] then
      error("Hotspot item at index "..iIndex.." has invalid cursor! "..
        tostring(iCursor).." (max: "..#aCursorData..")") end;
  end
  -- Insert into the bank
  aHotSpotBank[1 + #aHotSpotBank] = aHotSpots;
  -- Return newest id
  return #aHotSpotBank;
end
-- Get hotspot data -------------------------------------------------------- --
local function GetHotSpot() return iHotSpot end;
-- Set cursor position with scale ------------------------------------------ --
local function SetCursorPos(iX, iY)
  InputSetCursorPos(iX * iTexScale, iY * iTexScale);
end
-- Set cursor -------------------------------------------------------------- --
local function SetCursor(iIdentifier)
  -- Check parameter
  if not UtilIsInteger(iIdentifier) then
    error("Cursor id integer is invalid! "..tostring(iIdentifier)) end;
  -- Get cursor data for id and check it
  local aCursorItem<const> = aCursorData[iIdentifier];
  if not UtilIsTable(aCursorItem) then
    error("Cursor id not valid! "..tostring(aCursorItem)) end;
  -- Set new cursor dynamics
  iCursorMin, iCursorMax, iCursorAdjX, iCursorAdjY =
    aCursorItem[1], aCursorItem[2], aCursorItem[3], aCursorItem[4];
  -- Set cursor id
  iCId = iIdentifier;
end
-- Do execute command if mouse is overing ---------------------------------- --
local function DoHotSpotHover(aHotSpot)
  -- Set the cursor
  SetCursor(aHotSpot[6]);
  -- Call the function if it is available?
  local fcbCb<const> = aHotSpot[7];
  if fcbCb then
    -- Protected call so we can handle errors
    local bResult<const>, sReason<const> =
      xpcall(fcbCb, CoreStack, iCursorX, iCursorY);
    if not bResult then SetErrorMessage(sReason) end;
  end
end
-- Execute command if mouse is overing ------------------------------------- --
local function CheckHotSpotHover(aHotSpot)
  -- Return if mouse not in bounds
  if not IsMouseInBounds(aHotSpot[1], aHotSpot[2],
                         aHotSpot[3], aHotSpot[4]) then return end;
  -- Do the hover
  DoHotSpotHover(aHotSpot);
  -- Success
  return true;
end
-- Recheck positions ------------------------------------------------------- --
local function CheckHotSpots()
  -- Enumerate hotspots
  for iIndex = 1, #aHotSpotActive do
    -- Check if mouse is in zone and if it was? We're done
    if CheckHotSpotHover(aHotSpotActive[iIndex]) then return end;
  end
  -- No cursor was matched so we keep the arrow cursor
  SetCursor(iCArrow);
end
-- When the mouse is clicked ----------------------------------------------- --
local function OnMouseClick(iButton, iState)
  -- if have hotspots?
  if #aHotSpotActive >= 0 then
    -- If mouse is dragging?
    if iDragZone then
      -- Button assigned is released?
      if iState == iRelease and iButton == iDragButton then
        -- Clear the drag
        iDragZone, iDragButton = nil, nil;
        -- Check hotspots
        CheckHotSpots();
      -- Do not process any more buttons while draging
      else return end;
    end
    -- Check if mouse in hotspots
    for iIndex = 1, #aHotSpotActive do
      -- Get hotspot and if cursor is in bounds?
      local aHotSpot<const> = aHotSpotActive[iIndex];
      if IsMouseInBounds(aHotSpot[1], aHotSpot[2],
                         aHotSpot[3], aHotSpot[4]) then
        -- Button pressing? Set dragging
        if iState == iPress and not iDragZone then
          iDragZone, iDragButton = iIndex, iButton end;
        -- Get the callback and run it
        local fcbCb<const> = aHotSpot[9][1 + iState];
        if fcbCb then
          -- Protected call so we can handle errors
          local bResult<const>, vResult<const> =
            xpcall(fcbCb, CoreStack, iButton, iCursorX, iCursorY);
          if not bResult then SetErrorMessage(vResult);
          -- If click was processed then run hover func to refresh position
          elseif vResult then DoHotSpotHover(aHotSpot) end;
        end
        -- Done
        return;
      end
    end
  end
end
-- When the mouse leaves the window? --------------------------------------- --
local function OnMouseFocus()
  -- Disable mouse dragging if enabled
  if iDragZone then iDragZone, iDragButton = nil, nil end;
end
-- When the mouse wheel is moved ------------------------------------------- --
local function OnMouseScroll(nX, nY)
  -- Update position
  nWheelX, nWheelY = nX, nY;
  -- Check if mouse in hotspots
  for iIndex = 1, #aHotSpotActive do
    -- Get hotspot and if cursor is in bounds?
    local aHotSpot<const> = aHotSpotActive[iIndex];
    if IsMouseInBounds(aHotSpot[1], aHotSpot[2], aHotSpot[3], aHotSpot[4]) then
      -- Get the callback and run it
      local fcbCb<const> = aHotSpot[8];
      if fcbCb then
        -- Protected call so we can handle errors
        local bResult<const>, sReason<const> =
          xpcall(fcbCb, CoreStack, nX, nY);
        if not bResult then SetErrorMessage(sReason) end;
      end
      return;
    end
  end
end
-- Joystick procedure ------------------------------------------------------ --
local function JoystickProc()
  -- Return if no joystick is available
  if not iJoyActive then return end;
  -- Axis going left?
  local nAxisX<const> = InputGetJoyAxis(iJoyActive, 0);
  if nAxisX < 0 then
    -- Reset if positive
    if nJoyAX > 0 then nJoyAX = 0 end;
    -- Update X axis acceleration
    nJoyAX = UtilClamp(nJoyAX - 0.5, -5, 0);
  -- Axis going right?
  elseif nAxisX > 0 then
    -- Reset if negative
    if nJoyAX < 0 then nJoyAX = 0 end;
    -- Update X axis acceleration
    nJoyAX = UtilClamp(nJoyAX + 0.5, 0, 5);
  -- X Axis not going left or right? Reset X axis acceleration
  else nJoyAX = 0 end;
  -- Axis going up?
  local nAxisY<const> = InputGetJoyAxis(iJoyActive, 1);
  if nAxisY < 0 then
    -- Reset if positive
    if nJoyAY > 0 then nJoyAY = 0 end;
    -- Update Y axis acceleration
    nJoyAY = UtilClamp(nJoyAY - 0.5, -5, 0);
  -- Axis going down?
  elseif nAxisY > 0 then
    -- Reset if negative
    if nJoyAY < 0 then nJoyAY = 0 end;
    -- Update Y axis acceleration
    nJoyAY = UtilClamp(nJoyAY + 0.5, 0, 5);
  -- Y Axis not going up or down? Reset Y axis acceleration
  else nJoyAY = 0 end;
  -- Axis moving?
  if nJoyAX ~= 0 or nJoyAY ~= 0 then
    -- Update mouse position
    SetCursorPos(
      UtilClamp(iCursorX + nJoyAX, iStageLeft, iStageRight - 1),
      UtilClamp(iCursorY + nJoyAY, iStageTop, iStageBottom - 1));
  -- No axis pressed
  end
  -- Check each joystick button
  for iButtonId = 1, iJoyButtonMax do
    -- Get current button state
    local iButtonZeroId<const> = iButtonId - 1;
    local iState<const> = InputGetJoyButton(iJoyActive, iButtonZeroId);
    -- Get last button state and update current state
    local iLastState<const> = aJoyState[iButtonId];
    -- Button is pressed or held?
    if iState == 1 then
      -- It was released?
      if iLastState == 0 then
        -- If it was L1 button? Simulate scroll wheel down
        if iButtonId == 5 then OnMouseScroll(0, -1);
        -- If it was R1 button? Simulate scroll wheel up
        elseif iButtonId == 6 then OnMouseScroll(0, 1);
        -- If it was L2 button? Simulate scroll wheel left
        elseif iButtonId == 7 then OnMouseScroll(-1, 0);
        -- If it was R2 button? Simulate scroll wheel right
        elseif iButtonId == 8 then OnMouseScroll(1, 0);
        -- If it was SELECT button? Show setup
        elseif iButtonId == 9 then InitSetup(1);
        -- Anything else?
        else
          -- Treat it as a mouse click
          OnMouseClick(iButtonZeroId, iPress);
          -- Update the state
          aJoyState[iButtonId] = iState;
        end
      end
    -- If button is held then send repeat command
    elseif iState >= 2 then
      -- It was pressed?
      if iLastState == 1 then
        -- Treat it as a mouse click
        OnMouseClick(iButtonZeroId, iRepeat);
        -- Update the state
        aJoyState[iButtonId] = iState;
      end
    -- Else if the button was pressed or release then simulate a release
    elseif iLastState >= 1 then
      -- Treat it as a mouse click
      OnMouseClick(iButtonId - 1, iRelease);
      -- Update the state
      aJoyState[iButtonId] = iState;
    end
  end
end
-- Check joystick states --------------------------------------------------- --
local function OnJoyState(iJ, bState)
  -- Joystick is connected? Insert into joysticks list
  if bState then aJoy[1 + #aJoy] = iJ;
  -- Joystick was removed? Find joystick and remove it
  else for iI = 1, #aJoy do
    if aJoy[iI] == iJ then remove(aJoy, iI) break end;
  end end;
  -- If we have joysticks?
  if #aJoy > 0 then
    -- Joystick id
    for iJoy = 1, #aJoy do
      -- Get joystick
      local iJoyPending<const> = aJoy[iJoy];
      -- Get number of axises and return if not have two
      local iNumAxises<const> = InputGetNumJoyAxises(iJoyPending);
      if iNumAxises >= 2 then
        -- Set the first active joystick
        iJoyActive = iJoyPending;
        -- Store maximum number of buttons
        iJoyButtonMax = InputGetNumJoyButtons(iJoyActive);
        -- Check each joystick button state
        for iIndex = 1, iJoyButtonMax do aJoyState[iIndex] = 0 end;
        -- Success
        return;
      end
    end
  end
  -- Joystick no longer valid
  iJoyActive = nil;
end
-- Get cursor -------------------------------------------------------------- --
local function GetCursor() return iCId end;
-- Update hotspot based on alignment --------------------------------------- --
local function UpdateHotSpot(aHotSpot)
  -- Update Y position
  aHotSpot[4] = aHotSpot[11] + aHotSpot[13];
  -- If position is static then just return
  local iAlignment<const> = aHotSpot[5];
  if iAlignment == 0 then
    aHotSpot[3] = aHotSpot[10] + aHotSpot[12];
  -- Left alignment?
  elseif iAlignment == 1 then
    aHotSpot[1] = iStageLeft + aHotSpot[10];
    aHotSpot[3] = aHotSpot[1] + aHotSpot[12];
  -- Right alignment?
  elseif iAlignment == 2 then
    aHotSpot[1] = iStageRight - aHotSpot[12] - aHotSpot[10];
    aHotSpot[3] = aHotSpot[1] + aHotSpot[12];
  -- Left AND right alignment?
  elseif iAlignment == 3 then
    aHotSpot[1] = iStageLeft + aHotSpot[10];
    aHotSpot[3] = iStageRight - aHotSpot[12];
  end
end
-- Update all hot spots ---------------------------------------------------- --
local function UpdateAllHotSpots()
  -- If there are no hot spots? Show a wait cursor and return
  if #aHotSpotActive == 0 then return SetCursor(iCWait) end;
  -- For each hotspot...
  for iIndex = 1, #aHotSpotActive do
    -- Get hotspot
    local aHotSpot<const> = aHotSpotActive[iIndex];
    -- Update the hotspot
    UpdateHotSpot(aHotSpot);
    -- If this hotspot is currently being hovered over?
    if CheckHotSpotHover(aHotSpot) then
      -- Enumerate the rest of the hotspots...
      for iSubIndex = iIndex + 1, #aHotSpotActive do
        -- Update but don't check this time
        UpdateHotSpot(aHotSpotActive[iSubIndex]);
      end
      -- Done
      return;
    end
  end
  -- We have hot spots but none were matched so just show an arrow cursor
  SetCursor(iCArrow);
end
-- Set a hotspot ----------------------------------------------------------- --
local function SetHotSpot(iIdentifier)
  -- No id specified?
  if iIdentifier == nil then iIdentifier = 0;
  -- Show error if invalid hotspot id
  elseif not UtilIsInteger(iIdentifier) then
    error("Hotspot id integer is invalid! "..tostring(iIdentifier)) end;
  -- Reset and return if the requested value is zero
  if iIdentifier == 0 then aHotSpotActive = aHotSpotNone;
  -- Identifer is valid
  else
    -- Set the hotspot data
    aHotSpotActive = aHotSpotBank[iIdentifier];
    if not aHotSpotActive then
      error("Hotspot id "..iIdentifier.." is invalid!") end;
  end
  -- Update active hotspots from back to front
  UpdateAllHotSpots();
  -- Set active hotspot id
  iHotSpot = iIdentifier;
  -- Disable mouse dragging if enabled
  if iDragZone then iDragZone, iDragButton = nil, nil end;
end
-- When the mouse is moved ------------------------------------------------- --
local function OnMouseMove(nX, nY)
  -- Update physical cursor bounds
  iCursorRX, iCursorRY = floor(nX), floor(nY);
  -- Return if no hotspots
  if #aHotSpotActive == 0 then
    -- Update cursor
    iCursorX, iCursorY = iCursorRX // iTexScale, iCursorRY // iTexScale;
    -- Return
    return;
  end
  -- If not hotspot is dragging? Update position and check hotspots
  if not iDragZone then
    -- Update cursor
    iCursorX, iCursorY = iCursorRX // iTexScale, iCursorRY // iTexScale;
    -- Check hotspots and return
    return CheckHotSpots();
  end
  -- Get the drag callback and if not set?
  local fcbCb<const> = aHotSpotActive[iDragZone][9][3];
  if not fcbCb then
    -- Update cursor
    iCursorX, iCursorY = iCursorRX // iTexScale, iCursorRY // iTexScale;
    -- Check hotspots and return
    return CheckHotSpots();
  end
  -- Calculate new position but don't overwrite current one just yet
  local iCursorNX<const>, iCursorNY<const> =
    iCursorRX // iTexScale, iCursorRY // iTexScale;
  -- Protected call so we can handle errors
  local bResult<const>, sReason<const> =
    xpcall(fcbCb, CoreStack, iDragButton, iCursorX, iCursorY,
      iCursorNX-iCursorX, iCursorNY-iCursorY);
  -- Now update the new cursor position
  iCursorX, iCursorY = iCursorNX, iCursorNY;
  -- Error if call failed
  if not bResult then return SetErrorMessage(sReason) end;
end
-- Categorise the keys ----------------------------------------------------- --
local function RegisterCategorise(sName, oKeys)
  -- Check that given table is valid
  if not UtilIsTable(oKeys) then
    error("Key table is invalid! "..tostring(oKeys)) end;
  -- Check and add all keys to global bank in key bank
  for iCategory, aBinds in pairs(oKeys) do
    -- Check that given table is valid
    if not UtilIsTable(aBinds) then
      error("Invalid key binds table in category "..iCategory.."! "..
        tostring(aBinds)) end;
    -- Enumerate binds
    for iIndex = 1, #aBinds do
      -- Get bind details and check default key
      local aBind<const> = aBinds[iIndex];
      if not UtilIsTable(aBind) then
        error("Invalid key bind table in category "..iCategory..":"..iIndex..
          "! "..tostring(aBind)) end;
      -- Check key
      local iKey<const> = aBind[1];
      if not UtilIsInteger(iKey) then
        error("Invalid key "..tostring(iKey).." at index "..iIndex) end;
      -- Check callback when key pressed
      local fcbCb<const> = aBind[2];
      if not UtilIsFunction(fcbCb) then
        error("Invalid callback "..tostring(fcbCb).." at index "..iIndex) end;
      -- Check label
      local sId<const> = aBind[3];
      if not UtilIsString(sId) or #sId == 0 then
        error("Invalid id "..tostring(sId).." at index "..iIndex) end;
      -- Check description
      local sDesc<const> = aBind[4];
      if not UtilIsString(sDesc) or #sDesc == 0 then
        error("Invalid label "..tostring(sDesc).." at index "..iIndex) end;
      -- Check if we've registered this and if we haven't?
      local aExisting<const> = tKeyBankCats[sId];
      if not aExisting then
        -- Must be 4 variables ONLY
        if #aBind ~= 4 then
          error("Required 4 (not "..#aBind..") members at index "..iIndex) end;
        -- Backup key (used for default key)
        aBind[5] = aBind[1];
        -- Create full name of bind for setup screen
        aBind[6] = sName..": "..aBind[4];
        -- Set data with identifier. Duplicates will overwrite each other. This
        -- is the whole point since we may need to use the same bind but for
        -- different key states.
        tKeyBankCats[1 + #tKeyBankCats] = aBind;
        tKeyBankCats[sId] = aBind;
      -- We've registered it but show error if it's a different table
      elseif aExisting ~= aBind then
        error("Duplicate identifier '"..sId.."' between '"..sDesc..
              "' and '"..aExisting[4].."' at index "..iIndex.."!");
      end
    end
  end
end
-- Register keys from other module and return to them an identifier -------- --
local function RegisterKeys(sName, oKeys)
  -- Categories the keys
  RegisterCategorise(sName, oKeys);
  -- Add keybinds to key bank
  aKeyBank[1 + #aKeyBank] = { sName, oKeys };
  -- Return identifier
  return #aKeyBank;
end
-- Return current keybinds list -------------------------------------------- --
local function GetKeyBank() return iKeyBank end;
-- Set global keys table --------------------------------------------------- --
local function SetGlobalKeyBinds(oKeys) aGlobalKeyBinds = oKeys end;
-- Set blank active key bank data ------------------------------------------ --
local function SetBlankKeyBankData()
  aKeyBankActive = {
    [iPress]   = { },                  -- Pressed keys to functions
    [iRelease] = { },                  -- Released keys to functions
    [iRepeat]  = { },                  -- Repeated keys to functions
  };
end
-- Set active keybinds ----------------------------------------------------- --
local function SetKeys(bState, iIdentifier)
  -- Check parameters
  if not UtilIsBoolean(bState) then
    error("Bad global key state: "..tostring(bState)) end;
  -- Clear keybinds list
  SetBlankKeyBankData();
  -- If we're to add the persistent keys?
  if bState then
    for iCategory, aBinds in pairs(aGlobalKeyBinds) do
      local aKeyBankActiveCat<const> = aKeyBankActive[iCategory];
      for iIndex = 1, #aBinds do
        local aBind<const> = aBinds[iIndex];
        aKeyBankActiveCat[aBind[1]] = aBind[2];
      end
    end
  end
  -- Done if no keys are to be set?
  if iIdentifier == nil then iKeyBank = 0 return end;
  -- Make sure identifier is valid
  if not UtilIsInteger(iIdentifier) then
    error("Invalid table index type: "..tostring(iIdentifier)) end;
  if iIdentifier == 0 then iKeyBank = 0 return end;
  -- Get and check identifier in key bank
  local oKeys<const> = aKeyBank[iIdentifier];
  if not UtilIsTable(oKeys) then
    error("Invalid table index not registered: "..iIdentifier) end;
  -- Add binds from key bank to currently active keybinds
  for iCategory, aBinds in pairs(oKeys[2]) do
    local aKeyBankActiveCat<const> = aKeyBankActive[iCategory];
    for iIndex = 1, #aBinds do
      local aBind<const> = aBinds[iIndex];
      aKeyBankActiveCat[aBind[1]] = aBind[2];
    end
  end
  -- Set keybank id so modules can restore a previous keybank
  iKeyBank = iIdentifier;
end
-- Clear input states ------------------------------------------------------ --
local function ClearStates()
  -- Make sure user can't input anything
  InputClearStates();
  -- Clear keyboard and mouse
  nWheelX, nWheelY = 0, 0;
end
-- Renders the mouse cursor ------------------------------------------------ --
local function CursorRender()
  texSpr:BlitSLT(CoreTicks() // 4 % iCursorMax + iCursorMin,
    iCursorRX + iCursorAdjX, iCursorRY + iCursorAdjY);
end
-- When the fbo is resized ------------------------------------------------- --
local function OnStageUpdated(...)
  -- Get stage bounds
  local _ _, _, iStageLeft, iStageTop, iStageRight, iStageBottom = ...;
  -- Clamp them to integers
  iStageLeft, iStageTop, iStageRight, iStageRight =
    floor(iStageLeft), floor(iStageTop), floor(iStageRight), floor(iStageRight);
  -- If cursor is off the left or right of the screne? Clamp it
  if iCursorX < iStageLeft then iCursorX = iStageLeft;
  elseif iCursorX >= iStageRight then iCursorX = iStageRight-1 end;
  -- If cursor if off the top or bottom of the screen? Clamp it
  if iCursorY < iStageTop then iCursorY = iStageTop;
  elseif iCursorY >= iStageBottom then iCursorY = iStageBottom-1 end;
  -- Update active hotspots from back to front
  UpdateAllHotSpots();
end
-- Disable key handlers ---------------------------------------------------- --
local function DisableKeyHandlers()
  InputOnJoyState(nil);
  InputOnKey(nil);
end
-- Restore key handlers ---------------------------------------------------- --
local function RestoreKeyHandlers()
  InputOnJoyState(OnJoyState);
  InputOnKey(OnKey);
end
-- Global function key callbacks ------------------------------------------- --
local function GkCbConfig() InitSetup(1) end;
local function GkCbBinds() InitSetup(2) end;
local function GkCbReadme() InitSetup(3) end;
local function GkCbSShot() SShotFbo(fboMain) end;
-- Script has been initialised --------------------------------------------- --
local function OnScriptLoaded(GetAPI)
  -- Get imports
  InitSetup, RegisterFBUCallback, SetErrorMessage, SetTip, aCursorData,
    oCursorIdData, iTexScale, texSpr =
      GetAPI("InitSetup", "RegisterFBUCallback", "SetErrorMessage", "SetTip",
        "aCursorData", "oCursorIdData", "iTexScale", "texSpr");
  -- Get arrow and wait cursor ids
  iCArrow, iCWait = oCursorIdData.ARROW, oCursorIdData.WAIT;
  -- Initialise keybinds list
  SetBlankKeyBankData();
  -- Enable input capture events
  InputOnJoyState(OnJoyState);
  InputOnKey(OnKey);
  InputOnMouseClick(OnMouseClick);
  InputOnMouseFocus(OnMouseFocus);
  InputOnMouseMove(OnMouseMove);
  InputOnMouseScroll(OnMouseScroll);
  -- Enable cursor clamper when fbo changes
  RegisterFBUCallback("input", OnStageUpdated);
  -- Set the global keybinds
  local oKeys<const> = Input.KeyCodes;
  aGlobalKeyBinds = { [Input.States.PRESS] = {
    { oKeys.F1,  GkCbConfig,           "gksc", "SETUP SCREEN"          };
    { oKeys.F2,  GkCbBinds,            "gksb", "SETUP KEYBINDS"        },
    { oKeys.F3,  GkCbReadme,           "gksa", "SHOW ACKNOWLEDGEMENTS" },
    { oKeys.F10, InputSetCursorCentre, "gkcc", "SET CURSOR CENTRE"     },
    { oKeys.F11, DisplayReset,         "gkwr", "RESET WINDOW SIZE"     },
    { oKeys.F12, GkCbSShot,            "gkss", "TAKE SCREENSHOT"       },
  }}
  -- Add keybinds to key bank categories for configuration
  RegisterCategorise("GLOBAL", aGlobalKeyBinds);
end
-- Exports and imports ----------------------------------------------------- --
return { F = OnScriptLoaded, A = { ClearStates = ClearStates,
  CursorRender = CursorRender, DisableKeyHandlers = DisableKeyHandlers,
  GetCursor = GetCursor, GetHotSpot = GetHotSpot, GetJoyState = GetJoyState,
  GetKeys = GetKeys, GetKeyBank = GetKeyBank, GetMouseX = GetMouseX,
  GetMouseY = GetMouseY, IsJoyHeld = IsJoyHeld, IsJoyPressed = IsJoyPressed,
  IsJoyReleased = IsJoyReleased, IsMouseInBounds = IsMouseInBounds,
  IsMouseNotInBounds = IsMouseNotInBounds,
  IsMouseXGreaterEqualThan = IsMouseXGreaterEqualThan,
  IsMouseXLessThan = IsMouseXLessThan,
  IsMouseYGreaterEqualThan = IsMouseYGreaterEqualThan,
  IsMouseYLessThan = IsMouseYLessThan, JoystickProc = JoystickProc,
  RegisterHotSpot = RegisterHotSpot, RegisterKeys = RegisterKeys,
  RestoreKeyHandlers = RestoreKeyHandlers, SetCursor = SetCursor,
  SetCursorPos = SetCursorPos, SetHotSpot = SetHotSpot, SetKeys = SetKeys,
  aKeyBank = aKeyBank, tKeyBankCats = tKeyBankCats } };
-- End-of-File ============================================================= --
