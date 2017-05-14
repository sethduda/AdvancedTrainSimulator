params ["_event","_eventParams"];

if(_event == "KeyDown") then {
	if(_eventParams select 1 in (actionKeys "MoveBack")) then {
		player setVariable ["ATRAIN_Passenger_Forward", 1];
	};
	if(_eventParams select 1 in (actionKeys "MoveForward")) then {
		player setVariable ["ATRAIN_Passenger_Backward", 1];
	};
	if(_eventParams select 1 in (actionKeys "TurnRight")) then {
		player setVariable ["ATRAIN_Passenger_Right", 1];
	};
	if(_eventParams select 1 in (actionKeys "TurnLeft")) then {
		player setVariable ["ATRAIN_Passenger_Left", 1];
	};
	if(_eventParams select 1 == 211) then { // Delete
		[] call ATRAIN_fnc_exitTrainPassenger;
	};
	if(_eventParams select 1 == 156) then {  //Numpad Enter
		if(missionNamespace getVariable ["ATRAIN_3rd_Person_Camera_Distance",8] == 3) then {
			ATRAIN_3rd_Person_Camera_Distance = 8;
		} else {
			ATRAIN_3rd_Person_Camera_Distance = 3;
		};
	};
};

if(_event == "KeyUp") then {
	if(_eventParams select 1 in (actionKeys "MoveBack")) then {
		player setVariable ["ATRAIN_Passenger_Forward", 0];
	};
	if(_eventParams select 1 in (actionKeys "MoveForward")) then {
		player setVariable ["ATRAIN_Passenger_Backward", 0];
	};
	if(_eventParams select 1 in (actionKeys "TurnRight")) then {
		player setVariable ["ATRAIN_Passenger_Right", 0];
	};
	if(_eventParams select 1 in (actionKeys "TurnLeft")) then {
		player setVariable ["ATRAIN_Passenger_Left", 0];
	};
};