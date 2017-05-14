disableSerialization;
[] call ATRAIN_fnc_disableHud;
private _hudCtrl = uiNamespace getVariable ["ATRAIN_Hud_Control", nil];
if(isNil "_hudCtrl") then {
	private _h = (getnumber (configfile >> "RscStructuredText" >> "size")) * 5;
	private _w = safezoneW - 0.05;
	_hudCtrl = (findDisplay 46) ctrlCreate ["RscStructuredText", -1];
	private _pos = [safeZoneX, safeZoneY + safeZoneH - _h, _w, _h];
	_hudCtrl ctrlSetPosition _pos;
	_hudCtrl ctrlCommit 0;
	uiNamespace setVariable ["ATRAIN_Hud_Control", _hudCtrl];
	private _train = player getVariable ["ATRAIN_Current_Train",objNull];
	while {!isNull _train} do {
		private _speed = round ((_train getVariable ["ATRAIN_Local_Velocity",0]) * 3.6);
		private _cars = (count (_train getVariable ["ATRAIN_Remote_Cars",[_train]])) - 1;
		private _cruiseControlEnabled = _train getVariable ["ATRAIN_Remote_Cruise_Control_Enabled", false];
		private _cruiseControlHud = "";
		if(_cruiseControlEnabled) then {
			_cruiseControlHud = " (CC)";
		};
		private _ctrltxt =  ("<t color= '#FFFFFF' size='2' shadow= '1' shadowColor='#000000' align='right'>" + str _cars + " cars&#160;&#160;<br/>" + str abs _speed + _cruiseControlHud + " km/h</t>");
		_ctrltxt = parseText _ctrltxt;
		_hudCtrl ctrlsetStructuredText _ctrltxt;
		sleep 0.5;
		_hudCtrl = uiNamespace getVariable ["ATRAIN_Hud_Control", nil];
		_train = player getVariable ["ATRAIN_Current_Train",objNull];
	};
	[] call ATRAIN_fnc_disableHud;
};
