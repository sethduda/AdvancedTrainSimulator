params ["_trackMap"];
private _trackMapUpdated = false;
private _trackMapNodesToUpdate = [];
{
	private _nodeTrack = _x select 0;
	if!(_nodeTrack in ATRAIN_Nodes) then {
		ATRAIN_Nodes pushBack _nodeTrack;	
		ATRAIN_Map pushBack [];
		_trackMapNodesToUpdate pushBack _x;
		_trackMapUpdated = true;
		//diag_log str _x;
	};
} forEach _trackMap;

{
	private _nodeTrack = _x select 0;
	private _nodeConnections = _x select 1;
	private _nodeIndex = ATRAIN_Nodes find _nodeTrack;	
	if(_nodeIndex >= 0) then {
		private _mapConnections = [];
		{
			private _connectionNodeTrack = _x select 0;
			private _connectionNodeIndex = ATRAIN_Nodes find _connectionNodeTrack;	
			private _connectionPath = _x select 1;
			private _connectionDistance = _x select 2;
			private _connectionTracks = _x select 3;
			if(_connectionNodeIndex >= 0) then {
				_mapConnections pushBack [_connectionNodeIndex, _connectionDistance, _connectionPath];
				{
					private _connectionTrackObj = _x select 0;
					private _connectionTrackDirection = _x select 1;
					ATRAIN_Track_Node_Lookup pushBack [_connectionTrackObj, _connectionTrackDirection, _connectionNodeIndex, _nodeIndex ];						
				} forEach _connectionTracks;
			};
		} forEach _nodeConnections;
		ATRAIN_Map set [_nodeIndex, _mapConnections];
	};
} forEach _trackMapNodesToUpdate;
if(_trackMapUpdated) then {
	publicVariable "ATRAIN_Map";
};

_trackMapUpdated;
