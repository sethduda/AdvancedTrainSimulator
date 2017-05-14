params ["_train"];
private _isTrainLocal = [_train] call ATRAIN_fnc_isTrainLocal;	
if(_isTrainLocal) then {
	private _currentTime = diag_tickTime;
	private _lastUpdateTime = _train getVariable ["ATRAIN_Local_Last_Velocity_Network_Update_Time",0];
	if(_currentTime - _lastUpdateTime > 1) then {
		private _trainVelocity = _train getVariable ["ATRAIN_Local_Velocity",0];
		private _trainRemoteVelocity = _train getVariable ["ATRAIN_Remote_Velocity",0];
		if(_trainVelocity != _trainRemoteVelocity) then {
			//diag_log ("Sent Network Message: " + str _trainVelocity);
			_train setVariable ["ATRAIN_Remote_Velocity",_trainVelocity,true];
		};
		_train setVariable ["ATRAIN_Local_Last_Velocity_Network_Update_Time",_currentTime];
	};
} else {
	private _trainRemoteVelocity = _train getVariable ["ATRAIN_Remote_Velocity",nil];
	if(!isNil "_trainRemoteVelocity") then {
		//diag_log ("Received Network Message: " + str _trainRemoteVelocity);
		_train setVariable ["ATRAIN_Local_Velocity",_trainRemoteVelocity];
		_train setVariable ["ATRAIN_Remote_Velocity",nil];
	};
};
