
#define DEFAULT_ENGINE ["ATS_Train_Engine_Sound", 55]
#define DEFAULT_ENGINE_IDLE ["ATS_Train_Engine_Idle_Sound", 55]
#define DEFAULT_TRACK ["ATS_Train_Track_Sound", 26]
#define DEFAULT_BELL ["ATS_Train_Bell_Sound", 56.6]

{ _x call ATRAIN_fnc_addTrainSoundDefinition } forEach [
	["ATS_Trains_A2Locomotive_Driveable_Blue", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]],
	["ATS_Trains_A2Locomotive_Driveable_Red", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]],
	["Land_Locomotive_01_v1_F", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]],
	["Land_Locomotive_01_v2_F", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]],
	["Land_Locomotive_01_v3_F", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]],
	["Land_loco_742_blue", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]],
	["Land_loco_742_red", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]],
	["ATS_Trains_Steam_Small", [["ATS_Train_Steam_Engine_Sound", 57], ["ATS_Train_Steam_Engine_Idle_Sound", 35], DEFAULT_TRACK, DEFAULT_BELL]],
	["ATS_Trains_Steam_Large", [["ATS_Train_Steam_Engine_Sound", 57], ["ATS_Train_Steam_Engine_Idle_Sound", 35], DEFAULT_TRACK, DEFAULT_BELL]],
	["ATS_Trains_Cable_Car", []],
	["ATS_Trains_AE_Engine", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]],
	["ATS_Trains_SD60_Engine", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]],
	["ATS_Trains_VL_Elgolova", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]],
	["ATS_Trains_VL_EW", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]],
	["ATS_Trains_VL_EE", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]],
	["ATS_Trains_VL_M62", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]],
	["ATS_Trains_VL_VL10", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]],
	["ATS_Trains_VL_TVZ", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]],
	["ATS_Trains_VL_CH4", [DEFAULT_ENGINE, DEFAULT_ENGINE_IDLE, DEFAULT_TRACK, DEFAULT_BELL]]
];

// Check if the client has sounds installed
private _config = getArray ( configFile / "CfgSounds" / "ATS_Train_Engine_Sound" / "sound" );
private _configMission = getArray ( missionConfigFile / "CfgSounds" / "ATS_Train_Engine_Sound" / "sound" );
private _hasSounds = (count _config > 0 || count _configMission > 0);

// Start train sound simulation handler
if(hasInterface && _hasSounds) then {
	[] spawn {
		while {true} do {
			private _registeredTrains = missionNamespace getVariable ["ATRAIN_Registered_Trains",[]];
			{
				[_x] call ATRAIN_fnc_simulateTrainSounds;
			} forEach _registeredTrains;
			sleep 0.1;
		};
	};
};