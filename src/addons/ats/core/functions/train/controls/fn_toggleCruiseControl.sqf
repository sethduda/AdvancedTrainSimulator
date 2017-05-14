private _train = player getVariable ["ATRAIN_Current_Train",objNull];
if(!isNull _train) then {
	private _cruiseControlEnabled = _train getVariable ["ATRAIN_Remote_Cruise_Control_Enabled", false];
	_train setVariable ["ATRAIN_Remote_Cruise_Control_Enabled", !_cruiseControlEnabled, true];
};
