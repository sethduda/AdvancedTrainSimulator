params ["_train","_driver"];
if(!isServer) exitWith { [_this, "ATRAIN_fnc_registerTrainAndDriver"] call ATRAIN_fnc_RemoteExecServer };
ATRAIN_Server_Events pushBack ["REGISTER",_train,_driver];
