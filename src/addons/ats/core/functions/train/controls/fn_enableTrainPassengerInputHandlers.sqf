
player setVariable ["ATRAIN_Passenger_Forward", 0];
player setVariable ["ATRAIN_Passenger_Backward", 0];
player setVariable ["ATRAIN_Passenger_Right", 0];
player setVariable ["ATRAIN_Passenger_Left", 0];

private _inputHandlers = [];
_inputHandlers pushBack ["MAIN_DISPLAY","KeyDown",(["MAIN_DISPLAY","KeyDown", "[""KeyDown"",_this] call ATRAIN_fnc_passengerMoveInputHandler"] call ATRAIN_fnc_addEventHandler)];
_inputHandlers pushBack ["MAIN_DISPLAY","KeyUp",(["MAIN_DISPLAY","KeyUp", "[""KeyUp"",_this] call ATRAIN_fnc_passengerMoveInputHandler"] call ATRAIN_fnc_addEventHandler)];
player setVariable ["ATRAIN_Passenger_Input_Handlers", _inputHandlers];