//added onMouseButtonDown/onMouseButtonClick events, made keydown/up events return appropriately
//disabled delete key to exit
private _inputHandlers = [];
_inputHandlers pushBack ["MAIN_DISPLAY","KeyDown",(["MAIN_DISPLAY","KeyDown", "[""KeyDown"",_this] call ATRAIN_fnc_trainInputHandler"] call ATRAIN_fnc_addEventHandler)];
_inputHandlers pushBack ["MAIN_DISPLAY","KeyUp",(["MAIN_DISPLAY","KeyUp", "[""KeyUp"",_this] call ATRAIN_fnc_trainInputHandler"] call ATRAIN_fnc_addEventHandler)];
player setVariable ["ATRAIN_Input_Handlers", _inputHandlers];