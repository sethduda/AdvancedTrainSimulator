params ["_train"];
//diag_log "Attaching Train to Track Map";
private _nodePath = _train getVariable ["ATRAIN_Local_Node_Path",[]];
// Exit if train already attached to the track
if(count _nodePath > 0) exitWith {true};
private _localTrain = _train getVariable ["ATRAIN_Local_Copy",_train];
private _trackMapPosition = [_localTrain] call ATRAIN_fnc_lookupTrackMapPosition;
if(count _trackMapPosition == 0) exitWith { false };
_trackMapPosition params ["_startNodeIndex","_endNodeIndex","_distanceFromStart","_trackDistance"];
_train setVariable ["ATRAIN_Local_Node_Path",[_startNodeIndex, _endNodeIndex],true];
_train setVariable ["ATRAIN_Local_Distance_From_Front",_distanceFromStart,true];
_train setVariable ["ATRAIN_Local_Node_Path_Distance",_trackDistance,true];
true;
