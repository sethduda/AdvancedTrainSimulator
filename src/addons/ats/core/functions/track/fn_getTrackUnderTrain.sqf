params ["_train"];
private _trainPositionASL = getPosASLVisual _train;
private _trainVectorDir = vectorDir _train;
private _offset = _train getVariable ["ATRAIN_Remote_Position_Offset",[0,0,0]];
_trainPositionASL = _trainPositionASL vectorAdd (_offset vectorMultiply -1);
private _tracks = [_trainPositionASL,_train,_trainVectorDir] call ATRAIN_fnc_getTracksAtPosition;
private _foundTrack = objNull;
if(count _tracks > 0) then {
	_foundTrack = _tracks select 0;
};
_foundTrack;
