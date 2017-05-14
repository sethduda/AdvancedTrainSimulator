params ["_track"];
private _trackDef = [_track] call ATRAIN_fnc_getTrackDefinition;
if(count _trackDef == 0) exitWith {[];};
_trackDef params ["_className","_centerOffset","_isIntersection","_isTermination",["_heightOffset",0]];
private _map1 = _track selectionPosition "map1";
_map1 = _map1 vectorAdd [0,0,_heightOffset];
private _map2 = _track selectionPosition "map2";
_map2 = _map2 vectorAdd [0,0,_heightOffset];
private _map3 = _track selectionPosition "map3";
_map3 = _map3 vectorAdd [0,0,_heightOffset];

private _trackWorldPaths = [];

if(!_isIntersection && !_isTermination) then {
	private _worldPath = [];
	_worldPath pushBack (AGLtoASL (_track modelToWorld (_map1)));
	private _trackPosition = _track selectionPosition "track1";
	if(_trackPosition distance [0,0,0] != 0) then {
		private _trackIndex = 1;
		while {_trackPosition distance [0,0,0] != 0} do {
			_worldPath pushBack (AGLtoASL (_track modelToWorld (_trackPosition)));
			_trackIndex = _trackIndex + 1;
			_trackPosition = _track selectionPosition (format ["track%1", _trackIndex]);
		};
	} else {		
		if(_centerOffset != 0) then {
			private _pathMidpoint = _map1 vectorAdd ((_map2 vectorDiff _map1) vectorMultiply 0.5);
			_pathMidpoint = _pathMidpoint vectorAdd (((vectorUp _track) vectorCrossProduct (_map1 vectorFromTo _map2)) vectorMultiply _centerOffset);
			_worldPath pushBack (AGLtoASL (_track modelToWorld (_pathMidpoint)));
		};
	};
	_worldPath pushBack (AGLtoASL (_track modelToWorld (_map2)));
	_trackWorldPaths pushBack _worldPath;
};

if(_isTermination) then {
	private _pathMidpoint = _map1 vectorAdd ((_map2 vectorDiff _map1) vectorMultiply 0.5);
	_trackWorldPaths pushBack [AGLtoASL (_track modelToWorld (_map1)), AGLtoASL (_track modelToWorld (_pathMidpoint))];
	_trackWorldPaths pushBack [AGLtoASL (_track modelToWorld (_map2)), AGLtoASL (_track modelToWorld (_pathMidpoint))];
};

if(_isIntersection) then {
	private _pathMidpoint = _map1 vectorAdd ((_map2 vectorDiff _map1) vectorMultiply 0.9);
	_trackWorldPaths pushBack [AGLtoASL (_track modelToWorld (_map1)), AGLtoASL (_track modelToWorld (_pathMidpoint))];
	_trackWorldPaths pushBack [AGLtoASL (_track modelToWorld (_map2)), AGLtoASL (_track modelToWorld (_pathMidpoint))];
	private _worldPath = [];
	_worldPath pushBack (AGLtoASL (_track modelToWorld (_map3)));
	private _pathMidpoint2 = _map3 vectorAdd ((_pathMidpoint vectorDiff _map3) vectorMultiply 0.5);
	_pathMidpoint2 = _pathMidpoint2 vectorAdd (((vectorUp _track) vectorCrossProduct (_map3 vectorFromTo _pathMidpoint)) vectorMultiply _centerOffset);
	_worldPath pushBack (AGLtoASL (_track modelToWorld (_pathMidpoint2)));
	_worldPath pushBack (AGLtoASL (_track modelToWorld (_pathMidpoint)));
	_trackWorldPaths pushBack _worldPath;
};
_trackWorldPaths;
