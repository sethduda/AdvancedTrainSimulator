params ["_track"];
private _trackType = [_track] call ATRAIN_fnc_getTypeOf;
private _trackDef = [];
private _trackDefIndex = ATRAIN_Track_Definitions_Index find toLower (_trackType select 0);
if(_trackDefIndex >= 0) then {
	_trackDef = ATRAIN_Track_Definitions select _trackDefIndex;
};
_trackDef;