private _inputHandlers = player getVariable ["ATRAIN_Passenger_Input_Handlers", []];
{
	_x call ATRAIN_fnc_removeEventHandler;
} forEach _inputHandlers;
