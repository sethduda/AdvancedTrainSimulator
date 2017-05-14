if(!isServer) exitWith {};
while {true} do {
	if(count ATRAIN_Server_Events > 0) then {
		private _event = ATRAIN_Server_Events deleteAt 0;
		private _action = _event select 0;
		if(_action == "REGISTER") then {
			_event params ["_action","_train","_driver"];
			if([_train] call ATRAIN_fnc_attachTrainToTrackMap) then {
				private _registeredTrains = missionNamespace getVariable ["ATRAIN_Registered_Trains",[]];
				_registeredTrains pushBackUnique _train;
				_train setVariable ["ATRAIN_Remote_Driver", _driver, true];
				_train setVariable ["ATRIAN_Current_Train", _train, true];
				missionNamespace setVariable ["ATRAIN_Registered_Trains",_registeredTrains,true];
			} else {
				[[_train, _driver], {
					params ["_train", "_driver"];
					//diag_log str ["START",_this];
					if(_train getVariable ["ATRAIN_Loaded_Track_Map",false]) exitWith {};
					_train setVariable ["ATRAIN_Loaded_Track_Map",true];
					private _track = [_train] call ATRAIN_fnc_getTrackUnderTrain;
					//diag_log str ["TRACK",_track];
					if(isNull _track) exitWith {};
					["Loading Advanced Train Simulator (ATS)",0,0,99,2,0,3000] spawn bis_fnc_dynamicText;
					private _trackMap = [_track] call ATRAIN_fnc_buildTrackMap;
					[_trackMap] call ATRAIN_fnc_updateTrackMap;
					[_train, _driver] call ATRAIN_fnc_registerTrainAndDriver;
					["",0,0,1,0,0,3000] spawn bis_fnc_dynamicText;
					["",0,0,1,0,0,3001] spawn bis_fnc_dynamicText;
				}] remoteExec ["spawn", _driver];
			};
		};
		if(_action == "UNREGISTER") then {
			_event params ["_action","_train","_driver"];
			_train setVariable ["ATRAIN_Remote_Driver", nil, true];
		};
		if(_action == "UPDATETRACKMAP") then {
			_event params ["_action","_trackMap"];
			//diag_log str ["HANDLING TRACK MAP UPDATE"];
			[_trackMap] call ATRAIN_fnc_updateServerTrackMap;
		};
	};
	sleep 0.1;
};
