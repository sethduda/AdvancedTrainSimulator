params ["_trackMap"];
if(!isServer) exitWith { [_this, "ATRAIN_fnc_updateTrackMap"] call ATRAIN_fnc_RemoteExecServer };
ATRAIN_Server_Events pushBack ["UPDATETRACKMAP",_trackMap];
