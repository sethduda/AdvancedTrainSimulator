params ["_train"];
private _trainDef = [];
private _trainType = [_train] call ATRAIN_fnc_getTypeOf;
private _trainDefIndex = ATRAIN_Train_Definitions_Index find toLower (_trainType select 0);
if(_trainDefIndex >= 0) then {
	_trainDef = ATRAIN_Train_Definitions select _trainDefIndex;
};
_trainDef;
