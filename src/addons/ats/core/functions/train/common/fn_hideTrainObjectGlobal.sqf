params ["_train","_hide"];
if(isServer) then {
	private _trainDef = [_train] call ATRAIN_fnc_getTrainDefinition;
	if(count _trainDef > 0) then {
		_train hideObjectGlobal _hide;
	};
} else {
	_this call ATRAIN_fnc_hideTrainObjectLocal;
	[_this, "ATRAIN_fnc_hideTrainObjectGlobal"] call ATRAIN_fnc_RemoteExecServer;
};
