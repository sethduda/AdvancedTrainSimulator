{
	[_x] call ATRAIN_fnc_drawTrain;
} forEach (missionNamespace getVariable ["ATRAIN_Registered_Trains",[]]);
