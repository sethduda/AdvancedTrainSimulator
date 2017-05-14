private _allEventHandlers = uiNamespace getVariable ["ATRAIN_All_Event_Handlers",[]];
{
	_x call ATRAIN_fnc_removeEventHandler;
} forEach _allEventHandlers;
