private _train = player getVariable ["ATRAIN_Current_Train",objNull];
if(!isNull _train) then {
	private _lightsEnabled = _train getVariable ["ATRAIN_Remote_Lights_Enabled", false];
	_train setVariable ["ATRAIN_Remote_Lights_Enabled", !_lightsEnabled, true];
};
