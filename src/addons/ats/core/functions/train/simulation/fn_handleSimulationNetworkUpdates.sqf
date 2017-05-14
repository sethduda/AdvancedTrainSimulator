params ["_train"];
private _isTrainLocal = [_train] call ATRAIN_fnc_isTrainLocal;	
if(_isTrainLocal) then {
	private _currentTime = diag_tickTime;
	private _lastUpdateTime = _train getVariable ["ATRAIN_Local_Last_Simulation_Network_Update_Time",0];
	if(_currentTime - _lastUpdateTime > 1) then {
		private _distanceFromFront = _train getVariable ["ATRAIN_Local_Distance_From_Front",0];
		private _nodePath = _train getVariable ["ATRAIN_Local_Node_Path",[]];
		private _nodePathDistance = _train getVariable ["ATRAIN_Local_Node_Path_Distance",0];
		private _simulationState = [_distanceFromFront, _nodePath, _nodePathDistance];
		private _remoteSimulationState = _train getVariable ["ATRAIN_Remote_Simulation_State",[]];
		if(str _simulationState != str _remoteSimulationState) then {
			//diag_log ("Sending Network Message: " + str _remoteSimulationState);
			_train setVariable ["ATRAIN_Remote_Simulation_State",_simulationState,true];
		};
		_train setVariable ["ATRAIN_Local_Last_Simulation_Network_Update_Time",_currentTime];
	};
} else {
	private _remoteSimulationState = _train getVariable ["ATRAIN_Remote_Simulation_State",nil];
	if(!isNil "_remoteSimulationState") then {
		//diag_log ("Received Network Message: " + str _remoteSimulationState);
		_train setVariable ["ATRAIN_Local_Distance_From_Front",_remoteSimulationState select 0];
		_train setVariable ["ATRAIN_Local_Node_Path",_remoteSimulationState select 1];
		_train setVariable ["ATRAIN_Local_Node_Path_Distance",_remoteSimulationState select 2];
		_train setVariable ["ATRAIN_Remote_Simulation_State",nil];
	};
};
