params ["_trainEngine","_trainCar","_trainDistanceFromFront"];
private _nodePath = _trainEngine getVariable ["ATRAIN_Local_Node_Path",[]];
private _nodePathCount = count _nodePath;
if(_nodePathCount == 2) exitWith {
	private _startNodeIndex = _nodePath select 0;
	private _endNodeIndex = _nodePath select 1;
	private _mapConnection = [_startNodeIndex, _endNodeIndex] call ATRAIN_fnc_getTrackMapConnection;
	[_mapConnection select 2, _trainDistanceFromFront, true, (str _startNodeIndex + "-" + str _endNodeIndex), _trainCar] call ATRAIN_fnc_getPositionAndDirectionOnPath;
};
private _distanceSeen = 0;
private _priorNodeIndex = -1;
private _positioning = [];
for [{_i=0}, {_i < _nodePathCount}, {_i=_i+1}] do
{
	private _currentNodeIndex = _nodePath select _i;
	if(_priorNodeIndex >= 0) then {
		private _mapConnection = [_priorNodeIndex, _currentNodeIndex] call ATRAIN_fnc_getTrackMapConnection;
		private _distanceBetweeNodes = _mapConnection select 1;
		_distanceSeen = _distanceSeen + _distanceBetweeNodes;
		if((_trainDistanceFromFront < _distanceSeen) || ((_nodePathCount-1) == _i)) then {
			private _distanceFromStartNode = _trainDistanceFromFront - (_distanceSeen - _distanceBetweeNodes);
			_positioning = [_mapConnection select 2, _distanceFromStartNode, true, (str _priorNodeIndex + "-" + str _currentNodeIndex), _trainCar] call ATRAIN_fnc_getPositionAndDirectionOnPath;
			_i = _nodePathCount;
		};
	};
	_priorNodeIndex = _currentNodeIndex;
};	
_positioning;
