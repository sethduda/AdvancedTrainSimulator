if(isServer) then {
	
	ATRAIN_Server_Events = [];
	
	[] spawn ATRAIN_fnc_serverEventHandlerLoop;
	
	// Remotely installs ATS (if clients doesn't have it installed)
	[[], {
		if(isNil "ATRAIN_fnc_init") then {
			if(!isNil "ExileClient_system_network_send") then {
				["AdvancedTrainSimulatorRemoteExecServer",[[clientOwner],"ATRAIN_fnc_requestATSInstall",false]] call ExileClient_system_network_send;
			} else {
				[clientOwner] remoteExec ["ATRAIN_fnc_requestATSInstall", 2];
			};
		};
	}] remoteExec ["spawn", -2, true];

	// Adds support for exile network calls (Only used when running exile) //

	ExileServer_AdvancedTrainSimulator_network_AdvancedTrainSimulatorRemoteExecServer = {
		params ["_sessionId", "_messageParameters",["_isCall",false]];
		_messageParameters params ["_params","_functionName"];
		if(_isCall) then {
			_params call (missionNamespace getVariable [_functionName,{}]);
		} else {
			_params spawn (missionNamespace getVariable [_functionName,{}]);
		};
	};

	ExileServer_AdvancedTrainSimulator_network_AdvancedTrainSimulatorRemoteExecClient = {
		params ["_sessionId", "_messageParameters"];
		_messageParameters params ["_params","_functionName","_target",["_isCall",false]];
		if(_isCall) then {
			_params remoteExecCall [_functionName, _target];
		} else {
			_params remoteExec [_functionName, _target];
		};
	};
	
};