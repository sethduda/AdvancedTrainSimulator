params ["_train","_driver"];
if(!isServer) exitWith { [_this, "ATRAIN_fnc_unregisterTrainAndDriver"] call ATRAIN_fnc_RemoteExecServer };
ATRAIN_Server_Events pushBack ["UNREGISTER",_train,_driver];
