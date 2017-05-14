params ["_train"];
private _track = [_train] call ATRAIN_fnc_getTrackUnderTrain;
if(isNull _track) exitWith {[]};
//diag_log str ["LOOKUP", _track];
private _trackMapPosition = [];
private _foundTrackLookup = [];
scopeName "ATRAIN_fnc_lookupTrackMapPosition_0";
{
	if(_x select 0 == _track) then {
		if( vectorDir _train vectorDotProduct (_x select 1) > 0 ) then {
			_foundTrackLookup = _x;
			breakTo "ATRAIN_fnc_lookupTrackMapPosition_0";
		};
	};
} forEach ATRAIN_Track_Node_Lookup;

////diag_log str ATRAIN_Track_Node_Lookup;

if(count _foundTrackLookup > 0) then {
	_foundTrackLookup params ["_track","_direction","_startNodeIndex","_endNodeIndex"];
	private _connection = [_startNodeIndex, _endNodeIndex] call ATRAIN_fnc_getTrackMapConnection;
	private _connectionDistance = _connection select 1;
	private _connectionPath = _connection select 2;
	private _distanceFromStart = 0;
	private _foundDistanceFromStart = 0;
	private _lastPathPointPosASL = [];
	private _trianPositionASL = getPosASL _train;
	scopeName "ATRAIN_fnc_lookupTrackMapPosition_1";
	{
		private _currentPathPointPosASL = _x;
		if( count _lastPathPointPosASL > 0 ) then {
			private _positionDotProduct = (_trianPositionASL vectorFromTo _lastPathPointPosASL) vectorDotProduct (_trianPositionASL vectorFromTo _currentPathPointPosASL);
			if(_positionDotProduct <= 0) then {
				_foundDistanceFromStart = _distanceFromStart + (_lastPathPointPosASL distance _trianPositionASL);
				breakTo "ATRAIN_fnc_lookupTrackMapPosition_1";
			};
			_distanceFromStart = _distanceFromStart + (_lastPathPointPosASL distance _currentPathPointPosASL);
		};
		_lastPathPointPosASL = _currentPathPointPosASL;
	} forEach _connectionPath;	
	_trackMapPosition = [_startNodeIndex, _endNodeIndex, _foundDistanceFromStart, _connectionDistance];
};
// [Start Node Index, End Node Index, Distance From Start, Total Distance]
_trackMapPosition;
