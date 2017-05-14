params ["_params","_functionName","_target",["_isCall",false]];
if(!isNil "ExileClient_system_network_send") then {
	["AdvancedTrainSimulatorRemoteExecClient",[_params,_functionName,_target,_isCall]] call ExileClient_system_network_send;
} else {
	if(_isCall) then {
		_params remoteExecCall [_functionName, _target];
	} else {
		_params remoteExec [_functionName, _target];
	};
};
