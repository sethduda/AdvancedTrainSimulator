ARROWS = [];
player addAction ["Test Track", {
	
	_timeStart2 = 0;
	_timeEnd2 = 0;
	_timeStart = diag_tickTime;
	{
		deleteVehicle _x;
	} forEach ARROWS;
	private _tracks = [getPosASL player,player] call ATRAIN_fnc_getTracksAtPosition;
	if(count _tracks > 0) then {
		private _track = _tracks select 0;

		_map = [_track] call ATRAIN_fnc_buildTrackMap;
		_totalDistance = 0;
		{
			private _node = _x;
			//diag_log str ["NODE",_x select 0];
			private _nodeConnections = _node select 1;
			{
				//diag_log str [_x select 0, _x select 2];
				private _connectionPath = _x select 1;
				private _connectionDistance = _x select 2;
				_totalDistance = _totalDistance + (_connectionDistance / 2);
				//{
				//	//diag_log _x;
				//} forEach _connectionPath;
			} forEach _nodeConnections;
		} forEach _map;
		hint ("DONE" + str _totalDistance); 

		private _nodes = [_track] call ATRAIN_fnc_findConnectedTrackNodes;
		
		{
			private _path = _x select 1;
			{
				_arrow = "Sign_Arrow_F" createVehicle [0,0,0];
				_arrow setPosASL _x;
				ARROWS pushBack _arrow;
			} forEach _path;
		} forEach _nodes;
	};
	//[] call ATRAIN_fnc_printProfiles;
	//_timeEnd = diag_tickTime;
	//hintSilent str [(_timeEnd - _timeStart),(_timeEnd2 - _timeStart2),ATRAIN_COUNT,ATRAIN_TIME];
}];