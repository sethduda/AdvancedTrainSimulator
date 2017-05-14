params ["_train","_hide"];
private _trainDef = [_train] call ATRAIN_fnc_getTrainDefinition;
if(count _trainDef > 0) then {
	_train hideObject _hide;
};
