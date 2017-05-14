params ["_track",["_sourceConnection",[]]];
private _trackWorldPaths = [_track] call ATRAIN_fnc_getTrackWorldPaths;
private _connectedTrackNodes = [];
{
	private _trackWorldPath = _x;
	private _pathToNode = [];
	reverse _trackWorldPath;
	private _trackDistance = [_pathToNode, _trackWorldPath] call ATRAIN_fnc_addWorldPaths;
	private _pathToNodeCount = count _pathToNode;
	private _lastPathPosASL = _pathToNode select (_pathToNodeCount-1);
	private _secondToLastPathPosASL = _pathToNode select (_pathToNodeCount-2);
	private _trackDir =  _secondToLastPathPosASL vectorFromTo _lastPathPosASL;
	private _tracksInPath = [[_track,_trackDir]];
	private _distanceFromFront = 0;
	private _lastSeenTrack = _track;
	private _trackNodeFound = false;
	private _trackNode = objNull;
	private _sourceConnectionUsed = false;
	private _lastCameraPreloadLocation = [0,0,0];
	
	// Check to see if the path is heading back in the direction of the path we just followed
	// If it is, use the source connection path instead of retracing the steps back
	if(count _sourceConnection > 0) then {
		private _sourceConnectionPath = _sourceConnection select 1;
		private _sourceConnectionPathSecondPosition = _sourceConnectionPath select 1;
		private _currentPathSecondPosition = _pathToNode select 1;	
		if( _sourceConnectionPathSecondPosition distance _currentPathSecondPosition == 0) then {
			_connectedTrackNodes pushBack _sourceConnection;
			_sourceConnectionUsed = true;
		};
	};
	
	private _priorPositionOnPath = ([_pathToNode,_distanceFromFront + 2] call ATRAIN_fnc_getPositionAndDirectionOnPath) select 0;
	
	while {true && !_sourceConnectionUsed} do {
	
		private _positionOnPath = ([_pathToNode,_distanceFromFront] call ATRAIN_fnc_getPositionAndDirectionOnPath) select 0;
		private _directionOnPath = _priorPositionOnPath vectorFromTo _positionOnPath;
		private _tracksAtPosition = [_positionOnPath,_lastSeenTrack,_directionOnPath] call ATRAIN_fnc_getTracksAtPosition;
		_priorPositionOnPath = _positionOnPath;
		
		if(missionNamespace getVariable ["ATRAIN_Track_Debug_Enabled",false]) then {
			_arrow = "Sign_Arrow_F" createVehicle [0,0,0];
			_arrow setPosASL _positionOnPath; 	
		};

		scopeName "ATRAIN_fnc_findConnectedTrackNodes_0";
		{				
			if(_x != _lastSeenTrack) then {	
				private _trackDef = [_x] call ATRAIN_fnc_getTrackDefinition;
				_trackDef params ["_className","_modelPaths","_isSplitTrack","_isEndTrack"];
				private _trackWorldPath = ([_x] call ATRAIN_fnc_getTrackWorldPaths) select 0;
				if(_isSplitTrack || _isEndTrack) then {
					_trackWorldPath = [_x,_directionOnPath] call ATRAIN_fnc_findAlignedTrackWorldPath;
				};
				_lastTrackSeen = _x;
				if(_isSplitTrack || _isEndTrack) then {
					private _distanceAdded = [_pathToNode, _trackWorldPath, true] call ATRAIN_fnc_addWorldPaths;
					private _pathToNodeCount = count _pathToNode;
					private _lastPathPosASL = _pathToNode select (_pathToNodeCount-1);
					private _secondToLastPathPosASL = _pathToNode select (_pathToNodeCount-2);
					private _trackDir = _secondToLastPathPosASL vectorFromTo _lastPathPosASL;
					_tracksInPath pushBack [_x,_trackDir];
					_trackDistance = _trackDistance + _distanceAdded;
					_distanceFromFront = _distanceFromFront + _distanceAdded;
					_trackNodeFound = true;
					_trackNode = _x;		
					breakTo  "ATRAIN_fnc_findConnectedTrackNodes_0";
				};
				if(_x == _track) then {
					// Prevents endless track loops
					_trackNodeFound = false;
					_trackNode = objNull;
					breakTo  "ATRAIN_fnc_findConnectedTrackNodes_0";
				};
				private _distanceAdded = [_pathToNode, _trackWorldPath, false] call ATRAIN_fnc_addWorldPaths;
				private _pathToNodeCount = count _pathToNode;
				private _lastPathPosASL = _pathToNode select (_pathToNodeCount-1);
				private _secondToLastPathPosASL = _pathToNode select (_pathToNodeCount-2);
				private _trackDir = _secondToLastPathPosASL vectorFromTo _lastPathPosASL;
				_tracksInPath pushBack [_x,_trackDir];
				_trackDistance = _trackDistance + _distanceAdded;
				_distanceFromFront = _distanceFromFront + _distanceAdded;
				_lastSeenTrack = _x;
			};
		} forEach _tracksAtPosition;
	
		// Force objects to load on map as we search for tracks (does not work on dedicated server)
		if(count _tracksAtPosition == 0 && _distanceFromFront < -10) then {
			if(_lastCameraPreloadLocation distance _positionOnPath > 100 ) then {
				private _posAGL = [_positionOnPath select 0, _positionOnPath select 1, 0];
				{
					_posAGL nearObjects [_x select 0, 300];
				} forEach ATRAIN_Train_Definitions;
				_distanceFromFront = 0;
				_lastCameraPreloadLocation = _positionOnPath;
			};
		};
		
		// Track node found or no valid node found ( will search 10m beyond end of track )
		if(_trackNodeFound || _distanceFromFront < -10) exitWith {};

		if(_distanceFromFront > 0 && !(_lastSeenTrack in ATRAIN_TRACKS_NEAR_EDITOR_PLACED_CONNECTIONS)) then {
			_distanceFromFront = 0;
		} else {
			_distanceFromFront = _distanceFromFront - 1.1;
		};

	};	
	
	if(!isNull _trackNode) then {			
		_connectedTrackNodes pushBack [_trackNode,_pathToNode,_trackDistance,_tracksInPath];
	};
	
} forEach _trackWorldPaths;
_connectedTrackNodes;
