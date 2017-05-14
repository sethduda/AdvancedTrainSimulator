params ["_params","_functionName",["_isCall",false]];
if(!isNil "ExileClient_system_network_send") then {
	["AdvancedTrainSimulatorRemoteExecServer",[_params,_functionName,_isCall]] call ExileClient_system_network_send;
} else {
	if(_isCall) then {
		_params remoteExecCall [_functionName, 2];
	} else {
		_params remoteExec [_functionName, 2];
	};
};
