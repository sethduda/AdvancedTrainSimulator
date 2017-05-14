
ATRAIN_Train_Definitions = missionNamespace getVariable ["ATRAIN_Train_Definitions",[]];

// [Class Name, Is Drivable, Is Rideable, Length In Meters, maxspeed, Model Position Offset, Animate Train, Is Direction Reversed, Particle Effects, Is Cable Car]
ATRAIN_Train_Definitions append [
	["ATS_Trains_A2Locomotive_Driveable_Blue", true, false, 13.5, 47.22, [0,0,0],true,false, [], false, [0,0,0]],
	["ATS_Trains_A2Locomotive_Driveable_Red", true, false, 13.5, 47.22, [0,0,0],true,false, [], false, [0,0,0]],
	["Land_Locomotive_01_v1_F", true, false, 5.3, 12, [0,0,0.052],true,false, [], false, [1.2,-0.8,-0.6]],
	["Land_Locomotive_01_v2_F", true, false, 5.3, 12, [0,0,0.052],true,false, [], false, [1.2,-0.8,-0.6]],
	["Land_Locomotive_01_v3_F", true, false, 5.3, 12, [0,0,0.052],true,false, [], false, [1.2,-0.8,-0.6]],
	["Land_RailwayCar_01_passenger_F", false, true, 5.5, 12, [0,0,0.06],true,false, [], false, [-0.6,1.3,-1]],
	["Land_RailwayCar_01_sugarcane_empty_F", false, true, 3.2, 12, [0,0,0.052],true,false, [], false, [0,0,0]],
	["Land_RailwayCar_01_sugarcane_F", false, false, 3.2, 12, [0,0,0.052],true,false, [], false, [0,0,0]],
	["Land_RailwayCar_01_tank_F", false, false, 5.5, 12, [0,0,0.08],true,false, [], false, [0,0,0]],
	["Land_loco_742_blue", true, false, 13.5, 19.4, [0,0.05,-0.14],false,false, [], false, [1.1,-3.4,-1.3]],
	["Land_loco_742_red", true, false, 13.5, 19.4, [0,0.05,-0.14],false,false, [], false, [1.1,-3.4,-1.3]],
	["Land_wagon_box", false, true, 12, 19.4, [0,-0.43,0.02],false,false, [], false, [-0.8,0.1,-0.9]],  
	["Land_wagon_flat", false, true, 17.1, 19.4, [0,-0.02,0.04],false,false, [], false, [0,0,0.5]],
	["Land_wagon_tanker", false, false, 11.5, 19.4, [0,-0.05,0.02],false,false, [], false, [0,0,0]],
	["ATS_Trains_Steam_Small", true, false, 12, 19.4,  [0,0,0],false,false, [["steam","steam"]], false, [0.6,0,-1.1] ],
	["ATS_Trains_Steam_Large", true, false, 12.5, 19.4,  [0,0,0],false,false, [["steam","steam"]], false , [1,-2.3,-1.2]],
	["ATS_Trains_Cable_Car", true, true, 2, 8, [0,0,-7.32],true,false, [], true, [0,0,0]],
	["ATS_Trains_AE_Engine", true, false, 19.6, 40,  [0,0,0],false,false, [], false, [0.5,6.8,-1.3] ],
	["ATS_Trains_AE_Wagon", false, true, 24, 40,  [0,0,0],false,false, [], false, [-0.9,-0.2,-1.8] ],
	["ATS_Trains_SD60_Engine", true, false, 20, 31.1,  [0,0,0],false,false, [], false, [1.8,7.4,-1.3] ],
	["ATS_Trains_SD60_Flatbed", false, true, 17.25, 31.1,  [0,0,0],false,false, [], false, [0,0,0] ],
	["ATS_Trains_SD60_Oil_Tank", false, false, 17.5, 31.1,  [0,0,0],false,false, [], false, [0,0,0] ],
	["ATS_Trains_SD60_Open_Wagon", false, true, 16, 31.1,  [0,0,0],false,false, [], false, [1.1,0.1,0.2] ],
	["ATS_Trains_SD60_Covered_Wagon", false, true, 18, 31.1,  [0,0,0],false,false, [], false, [2,0,-1.8] ],
	["ATS_Trains_SD60_Covered_Wagon_Black", false, true, 18, 31.1,  [0,0,0],false,false, [], false, [2,0,-1.8] ],
	["ATS_Trains_SD60_Covered_Wagon_Blue", false, true, 18, 31.1,  [0,0,0],false,false, [], false, [2,0,-1.8] ],
	["ATS_Trains_SD60_Covered_Wagon_Green", false, true, 18, 31.1,  [0,0,0],false,false, [], false, [2,0,-1.8] ],
	["ATS_Trains_SD60_Covered_Wagon_Grey", false, true, 18, 31.1,  [0,0,0],false,false, [], false, [2,0,-1.8] ],
	["ATS_Trains_VL_Elgolova", true, true, 18.8, 19.4, [0,0,0],false,true, [], false, [0.7,-7.89999,-2]],
	["ATS_Trains_VL_EW", true, true, 18.8, 19.4, [0,0,0],false,true, [], false, [-1,-1.7,-1.5]],
	["ATS_Trains_VL_EE", true, true, 18.8, 19.4, [0,0,0],false,true, [], false, [-1,-1.7,-3.1]],  
	["ATS_Trains_VL_M62", true, true, 17.35, 19.4, [0,0,0],false,true, [], false, [-0.9,-6.9,-1.6]],
	["ATS_Trains_VL_VL10", true, false, 16, 19.4, [0,0,0],false,true, [], false, [0.9,-6.4,-2.9]],
	["ATS_Trains_VL_TVZ", true, true, 23.5, 19.4, [0,0,0],false,true, [], false, [1.1,0.3,-2]],
	["ATS_Trains_VL_CH4", true, true, 19.5, 19.4, [0,0,0],false,true, [], false, [0.7,8.09999,-2.9]],
	["ATS_Trains_VL_CI", false, false, 12, 19.4, [0,0,0],false,true, [], false, [0,0,0]],
	// Test Trains Below
	["Land_wagon_flat_dozer", false, false, 17.1, 19.4, [0,-0.02,0.04],false,false, [], false, [0,0,0]],
	["Land_wagon_flat_container01", false, false, 17.1, 19.4, [0,-0.02,0.04],false,false, [], false, [0,0,0]],
	["Land_wagon_flat_container02", false, false, 17.1, 19.4, [0,-0.02,0.04],false,false, [], false, [0,0,0]],
	["Land_wagon_flat_container03", false, false, 17.1, 19.4, [0,-0.02,0.04],false,false, [], false, [0,0,0]],
	["Land_wagon_flat_excavator", false, false, 17.1, 19.4, [0,-0.02,0.04],false,false, [], false, [0,0,0]],
	["Land_wagon_flat_lav", false, false, 17.1, 19.4, [0,-0.02,0.04],false,false, [], false, [0,0,0]],
	["Land_wagon_flat_lumber", false, false, 17.1, 19.4, [0,-0.02,0.04],false,false, [], false, [0,0,0]],
	["Land_blue_loco", true, false, 13.5, 19.4,  [0,0.05,-0.14],false,false, [], false, [0,0,0]],
	["Land_red_loco", true, false, 13.5, 19.4,  [0,0.05,-0.14],false,false, [], false, [0,0,0]],
	["ATS_A2Wagon_Box", false, true, 12, 19.4, [0,-0.43,0.02],false,false, [], false, [0,0,0]],
	["ATS_A2Wagon_Flat", false, true, 17.1, 19.4, [0,-0.02,0.04],false,false, [], false, [0,0,0]],
	["ATS_A2Wagon_Tanker", false, false, 11.5, 19.4, [0,-0.05,0.02],false,false, [], false, [0,0,0]]
];

ATRAIN_Object_Model_To_Type_Map = missionNamespace getVariable ["ATRAIN_Object_Model_To_Type_Map",[]];

ATRAIN_Object_Model_To_Type_Map append [
	["locomotive_01_v1_f.p3d",["Land_Locomotive_01_v1_F",true]],
	["locomotive_01_v2_f.p3d",["Land_Locomotive_01_v2_F",true]],
	["locomotive_01_v3_f.p3d",["Land_Locomotive_01_v3_F",true]],
	["railwaycar_01_passenger_f.p3d",["Land_RailwayCar_01_passenger_F",true]],
	["railwaycar_01_sugarcane_empty_f.p3d",["Land_RailwayCar_01_sugarcane_empty_F",true]],
	["railwaycar_01_sugarcane_f.p3d",["Land_RailwayCar_01_sugarcane_F",true]],
	["railwaycar_01_tank_f.p3d",["Land_RailwayCar_01_tank_F",true]],
	["ats_trains_steam_small.p3d",["ATS_Trains_Steam_Small",true]],
	["ats_trains_steam_large.p3d",["ATS_Trains_Steam_Large",true]],
	["ats_trains_cable_car.p3d",["ATS_Trains_Cable_Car",true]],
	["ats_trains_sd60_engine.p3d",["ATS_Trains_SD60_Engine",true]],
	["ats_trains_sd60_flatbed.p3d",["ATS_Trains_SD60_Flatbed",true]],
	["ats_trains_sd60_oil_tank.p3d",["ATS_Trains_SD60_Oil_Tank",true]],
	["ats_trains_sd60_open_wagon.p3d",["ATS_Trains_SD60_Open_Wagon",true]],
	["ats_trains_sd60_covered_wagon.p3d",["ATS_Trains_SD60_Covered_Wagon",true]],
	["ats_trains_sd60_covered_wagon_black.p3d",["ATS_Trains_SD60_Covered_Wagon_Black",true]],
	["ats_trains_sd60_covered_wagon_blue.p3d",["ATS_Trains_SD60_Covered_Wagon_Blue",true]],
	["ats_trains_sd60_covered_wagon_green.p3d",["ATS_Trains_SD60_Covered_Wagon_Green",true]],
	["ats_trains_sd60_covered_wagon_grey.p3d",["ATS_Trains_SD60_Covered_Wagon_Grey",true]],
	["ats_trains_ae_engine.p3d",["ATS_Trains_AE_Engine",true]],
	["ats_trains_ae_wagon.p3d",["ATS_Trains_AE_Wagon",true]],
	// Test Objects Below
	["blue_loco.p3d",["Land_blue_loco",true]],
	["red_loco.p3d",["Land_red_loco",true]],
	["wagon_box.p3d",["ATS_A2Wagon_Box",true]],
	["wagon_flat.p3d",["ATS_A2Wagon_Flat",true]],
	["wagon_tanker.p3d",["ATS_A2Wagon_Tanker",true]]
];

[] call ATRAIN_fnc_rebuildArrayLookupIndexes;

[] call ATRAIN_fnc_initTrainSound;

// Start train drawing handler
addMissionEventHandler ["EachFrame", {call ATRAIN_fnc_drawEventHandler}];

// Start player action handler
if(hasInterface) then {
	[] spawn {
		while {true} do {
			[] call ATRAIN_fnc_managePlayerTrainActions;
			sleep 0.1;
		};
	};
};

// Start train particle effects simulation handler
[] spawn {
	while {true} do {
		private _registeredTrains = missionNamespace getVariable ["ATRAIN_Registered_Trains",[]];
		{
			[_x] call ATRAIN_fnc_simulateTrainParticleEffects;
		} forEach _registeredTrains;
		sleep 1;
	};
};

// Start train speed simulation handler
[] spawn {
	while {true} do {
		private _registeredTrains = missionNamespace getVariable ["ATRAIN_Registered_Trains",[]];
		{
			[_x] call ATRAIN_fnc_simulateTrainVelocity;
			[_x] call ATRAIN_fnc_handleVelocityNetworkUpdates;
		} forEach _registeredTrains;
		sleep 0.1;
	};
};

// Start train attachment simulation handler
[] spawn {
	while {true} do {
		private _registeredTrains = missionNamespace getVariable ["ATRAIN_Registered_Trains",[]];
		{
			if([_x] call ATRAIN_fnc_isTrainLocal) then {
				[_x] call ATRAIN_fnc_simulateTrainAttachment;
			};
		} forEach _registeredTrains;
		sleep 0.1;
	};
};

// Start train position simulation handler
[] spawn {
	while {true} do {
		private _registeredTrains = missionNamespace getVariable ["ATRAIN_Registered_Trains",[]];
		{
			if(_x getVariable ["ATRAIN_Calculations_Queued",true]) then {
				[_x] call ATRAIN_fnc_simulateTrain;
				[_x] call ATRAIN_fnc_handleSimulationNetworkUpdates;
				_x setVariable ["ATRAIN_Calculations_Queued",false];
			};
		} forEach _registeredTrains;
		sleep 0.1;
	};
};

// Start attach player to moving train handler
if(hasInterface) then {
	[] spawn {
		while {true} do {
			private _ridingOnTrain = player getVariable ["ATRAIN_Riding_On_Train", objNull];
			private _currentPassengerCar = player getVariable ["ATRAIN_Current_Train_Passenger_Car",objNull];
			if(isNull _ridingOnTrain && isNull _currentPassengerCar) then {
				if((getPosATL player) select 2 > 0.5) then {
					private _train = [player] call ATRAIN_fnc_getTrainUnderPlayer;
					if(!isNull _train) then {
						player setVariable ["ATRAIN_Riding_On_Train", _train];
						[player,_train] spawn ATRAIN_fnc_rideOnTrain;
					};
				};
			};
			sleep 0.5;
		};
	};
};

// Update player position to follow train
if(hasInterface) then {
	[] spawn {
		while {true} do {
			private _currentCar = player getVariable ["ATRAIN_Current_Train_Car",objNull];
			if(isNull _currentCar) then {
				_currentCar = player getVariable ["ATRAIN_Current_Train_Passenger_Car",objNull];
			};
			if(!isNull _currentCar) then {
				private _localCar = _currentCar getVariable ["ATRAIN_Local_Copy",_currentCar];
				player setPos (getPos _localCar);
			};
			sleep 10;
		};
	};
};

