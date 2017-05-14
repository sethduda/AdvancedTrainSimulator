params ["_train"];

#define ENGINE_DISTANCE 50
#define ENGINE_MAX_SPEED 10
#define ENGINE_IDLE_DISTANCE 50
#define ENGINE_IDLE_MAX_SPEED 10
#define TRACK_DISTANCE 75
#define TRACK_MAX_SPEED 10
#define HORN_DISTANCE 600
#define BELL_DISTANCE 100

private _closestCar = [_train] call ATRAIN_fnc_getNearestTrainCar;
private _closestCarLocal = _closestCar getVariable ["ATRAIN_Local_Copy",_closestCar];
private _engineCarLocal = _train getVariable ["ATRAIN_Local_Copy",_train];

// Don't simulate sounds if train is more than 2k away
if(player distance _closestCarLocal > 1200) exitWith {};

// Don't simulate sound if cars aren't local yet
if(_engineCarLocal == _train || _closestCarLocal == _closestCar) exitWith {};

private _trainSpeed = abs (_train getVariable ["ATRAIN_Local_Velocity",0]);

// Get the sound def and cache if not defined yet
private _soundDef = _train getVariable ["ATRAIN_Sound_Def", nil];
if(isNil "_soundDef") then {
	_soundDef = [_train] call ATRAIN_fnc_getTrainSoundDefinition;
	_train setVariable ["ATRAIN_Sound_Def", _soundDef];
};

if(count _soundDef == 0) exitWith {};

_soundDef params ["_engineSound","_engineIdleSound", "_trackSound", "_bellSound"];

// Simulate track sound
private _trackSoundSource = _train getVariable ["TRAIN_Track_Sound_Source", objNull];
if(isNull _trackSoundSource) then {
	_trackSoundSource = [_trackSound select 0,TRACK_DISTANCE,true,_trackSound select 1] call ATRAIN_fnc_createSoundSource;
	_train setVariable ["TRAIN_Track_Sound_Source", _trackSoundSource];
};
[_trackSoundSource, _closestCarLocal] call ATRAIN_fnc_attachSoundSource;
if(_trainSpeed == 0) then {
	[_trackSoundSource, false] call ATRAIN_fnc_enableSoundSource;
} else {
	[_trackSoundSource, true] call ATRAIN_fnc_enableSoundSource;
	[_trackSoundSource, (_trainSpeed min TRACK_MAX_SPEED)/TRACK_MAX_SPEED ] call ATRAIN_fnc_setSoundSourceVolume;
};

// Simulate engine idle sound
private _remoteEngineEnabled = _train getVariable ["ATRAIN_Remote_Engine_Enabled", true];
private _engineIdleSoundSource = _train getVariable ["TRAIN_Engine_Idle_Sound_Source", objNull];
if(isNull _engineIdleSoundSource) then {
	_engineIdleSoundSource = [_engineIdleSound select 0,ENGINE_IDLE_DISTANCE,true,_engineIdleSound select 1] call ATRAIN_fnc_createSoundSource;
	_train setVariable ["TRAIN_Engine_Idle_Sound_Source", _engineIdleSoundSource];
	[_engineIdleSoundSource, true] call ATRAIN_fnc_enableSoundSource;
	[_engineIdleSoundSource, _engineCarLocal] call ATRAIN_fnc_attachSoundSource;
};
if(_remoteEngineEnabled) then {
	[_engineIdleSoundSource, true] call ATRAIN_fnc_enableSoundSource;
	[_engineIdleSoundSource, (1-((_trainSpeed min ENGINE_IDLE_MAX_SPEED)/ENGINE_IDLE_MAX_SPEED)) max 0.8] call ATRAIN_fnc_setSoundSourceVolume;
} else {
	[_engineIdleSoundSource, false] call ATRAIN_fnc_enableSoundSource;
};


// Simulate engine sound
private _engineSoundSource = _train getVariable ["TRAIN_Engine_Sound_Source", objNull];
if(isNull _engineSoundSource) then {
	_engineSoundSource = [_engineSound select 0,ENGINE_DISTANCE,true,_engineSound select 1] call ATRAIN_fnc_createSoundSource;
	_train setVariable ["TRAIN_Engine_Sound_Source", _engineSoundSource];
	[_engineSoundSource, _engineCarLocal] call ATRAIN_fnc_attachSoundSource;
};
if(_trainSpeed == 0) then {
	[_engineSoundSource, false] call ATRAIN_fnc_enableSoundSource;
} else {
	[_engineSoundSource, true] call ATRAIN_fnc_enableSoundSource;
	[_engineSoundSource, (_trainSpeed min ENGINE_MAX_SPEED)/ENGINE_MAX_SPEED] call ATRAIN_fnc_setSoundSourceVolume;
};

// Simulate horn sound
private _driver = _train getVariable ["ATRAIN_Remote_Driver", objNull];
private _remoteHornEnabled = _driver getVariable ["ATRAIN_Remote_Horn_Enabled", false];
private _localHornEnabled = _train getVariable ["ATRAIN_Local_Horn_Enabled", false];
if(_remoteHornEnabled && !_localHornEnabled) then {
	_train setVariable ["ATRAIN_Local_Horn_Enabled", true];
	[_train, _driver] spawn {
		params ["_train","_driver"];
		private _localCopy = _train getVariable ["ATRAIN_Local_Copy", objNull];
		if(!isNull _localCopy) then {
			_localCopy say3D ["ATSHornStart", HORN_DISTANCE, 1];
			sleep 0.99;
			while { !isNull _driver && alive _driver && _driver getVariable ["ATRAIN_Remote_Horn_Enabled", false]} do {
				if((floor random 2) > 0) then {
					_localCopy say3D ["ATSHornMiddle1", HORN_DISTANCE, 1];
				} else {
					_localCopy say3D ["ATSHornMiddle2", HORN_DISTANCE, 1];
				};
				sleep 0.99;
			};
			_localCopy say3D ["ATSHornEnd", HORN_DISTANCE, 1];
			sleep 1;
		};
		_train setVariable ["ATRAIN_Local_Horn_Enabled", false];
	};
};

// Simulate bell sound
private _remoteBellEnabled = _driver getVariable ["ATRAIN_Remote_Bell_Enabled", false];
private _localBellEnabled = _train getVariable ["ATRAIN_Local_Bell_Enabled", false];
if(_remoteBellEnabled && !_localBellEnabled) then {
	private _bellSoundSource = _train getVariable ["TRAIN_Bell_Sound_Source", objNull];
	if(isNull _bellSoundSource) then {
		_bellSoundSource = [_bellSound select 0,BELL_DISTANCE,true,_bellSound select 1] call ATRAIN_fnc_createSoundSource;
		_train setVariable ["TRAIN_Bell_Sound_Source", _bellSoundSource];
		[_bellSoundSource, _engineCarLocal] call ATRAIN_fnc_attachSoundSource;
	};
	[_bellSoundSource, true] call ATRAIN_fnc_enableSoundSource;
	[_bellSoundSource, 1] call ATRAIN_fnc_setSoundSourceVolume;
	[_bellSoundSource, _driver, _train] spawn {
		params ["_bellSoundSource", "_driver", "_train"];
		while { alive _driver && _driver getVariable ["ATRAIN_Remote_Bell_Enabled", false] } do {
			sleep 0.5;
		};
		// Fade bell sound out
		for [{_i=1}, {_i>0}, {_i=_i-0.05}] do
		{
			[_bellSoundSource, _i] call ATRAIN_fnc_setSoundSourceVolume;
			sleep 0.1;
		};
		[_bellSoundSource, false] call ATRAIN_fnc_enableSoundSource;
		_train setVariable ["ATRAIN_Local_Bell_Enabled", false];
	};
};



