params ["_train","_distanceFromEngineToRear","_distanceFromEngineToFront"];
private _nodePath = _train getVariable ["ATRAIN_Local_Node_Path",[]];
if(count _nodePath <= 2) exitWith {};
private _trainDistanceFromStart = _train getVariable ["ATRAIN_Local_Distance_From_Front",0];
private _trainNodePathDistance = _train getVariable ["ATRAIN_Local_Node_Path_Distance",0];
private _frontStartNodeIndex = _nodePath select 0;
private _frontEndNodeIndex = _nodePath select 1;
private _connection = [_frontStartNodeIndex, _frontEndNodeIndex] call ATRAIN_fnc_getTrackMapConnection;
private _distanceBetweeNodes = _connection select 1;
if(_trainDistanceFromStart - _distanceFromEngineToFront > _distanceBetweeNodes) then {
	_nodePath deleteAt 0;
	_trainDistanceFromStart = _trainDistanceFromStart - _distanceBetweeNodes;
	_trainNodePathDistance = _trainNodePathDistance - _distanceBetweeNodes;
};

private _rearStartNodeIndex = _nodePath select ((count _nodePath) - 2);
private _rearEndNodeIndex = _nodePath select ((count _nodePath) - 1);
_connection = [_rearStartNodeIndex, _rearEndNodeIndex] call ATRAIN_fnc_getTrackMapConnection;
_distanceBetweeNodes = _connection select 1;
if(_trainDistanceFromStart + _distanceFromEngineToRear < _trainNodePathDistance - _distanceBetweeNodes) then {
	_nodePath deleteAt ((count _nodePath) - 1);
	_trainNodePathDistance = _trainNodePathDistance - _distanceBetweeNodes;
};
_train setVariable ["ATRAIN_Local_Node_Path",_nodePath];
_train setVariable ["ATRAIN_Local_Node_Path_Distance",_trainNodePathDistance];
_train setVariable ["ATRAIN_Local_Distance_From_Front",_trainDistanceFromStart];
