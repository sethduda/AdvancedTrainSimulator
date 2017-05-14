params ["_train"];
private _trainSoundDef = [];
private _trainType = [_train] call ATRAIN_fnc_getTypeOf;
private _trainSoundDefIndex = ATRAIN_Train_Sound_Definitions_Index find toLower (_trainType select 0);
if(_trainSoundDefIndex >= 0) then {
	_trainSoundDef = (ATRAIN_Train_Sound_Definitions select _trainSoundDefIndex) select 1;
};
_trainSoundDef;
