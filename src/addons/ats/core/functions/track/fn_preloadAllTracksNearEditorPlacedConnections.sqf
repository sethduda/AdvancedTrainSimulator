ATRAIN_TRACKS_NEAR_EDITOR_PLACED_CONNECTIONS = [];
{
	private _isSplitTrack = _x select 2;
	private _isEndTrack = _x select 3;
	private _trackClassName = _x select 0;
	if(_isSplitTrack || _isEndTrack) then {
		// Loop over every mission object of that class
		private _missionTrackObjects = allMissionObjects _trackClassName;
		{
			// Loop over every path in the track object
			private _track = _x;
			private _trackWorldPaths = [_track] call ATRAIN_fnc_getTrackWorldPaths;
			{
				// Find tracks under the track path's end points
				private _positionASL = _x select 0;
				private _tracksAtPosition = [_positionASL,_track] call ATRAIN_fnc_getTracksAtPosition;
				{
					private _trackType = [_x] call ATRAIN_fnc_getTypeOf;
					_trackType params ["_className","_isStatic"];
					if(_isStatic) then {
						ATRAIN_TRACKS_NEAR_EDITOR_PLACED_CONNECTIONS pushBackUnique _x;
					};
				} forEach _tracksAtPosition
			} forEach _trackWorldPaths;
		} forEach _missionTrackObjects;
	};
} forEach ATRAIN_Track_Definitions;
