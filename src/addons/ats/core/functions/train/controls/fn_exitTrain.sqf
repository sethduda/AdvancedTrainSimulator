//added setdir +180, removeeventhandler "killed"
private _train = player getVariable ["ATRAIN_Current_Train",objNull];
private _trainCar = player getVariable ["ATRAIN_Current_Train_Car",objNull];

ATS_checkSimulation = {
	params ["_train"];
	if !(simulationEnabled _train) then {
		_train enableSimulation true;
	};
};


if(!isNull _train) then {
	player setVariable ["ATRAIN_Current_Train", nil];
	player setVariable ["ATRAIN_Current_Train_Car", nil];
	[_train,player] call ATRAIN_fnc_unregisterTrainAndDriver;
	[] call ATRAIN_fnc_disableTrainInputHandlers;
	_localCopy = _trainCar getVariable ["ATRAIN_Local_Copy",_trainCar];
	private _trainPos = getPos _localCopy;
	private _trainVectorDir = vectorDir _localCopy;
	private _trainVectorUp = vectorUp _localCopy;
	private _trainVectorLeft = _trainVectorDir vectorCrossProduct _trainVectorUp;
	private _exitPos = _trainPos vectorAdd (_trainVectorLeft vectorMultiply 3);
	_exitPos set [2,0];
	player setPos _exitPos;
	player setdir (getdir player + 180);
	[player,false] call ATRAIN_fnc_hidePlayerObjectGlobal;
	player enableSimulation true;
	player allowDamage true;
	[] call ATRAIN_fnc_disable3rdPersonCamera;
	[] spawn ATRAIN_fnc_disableHud;
	_localCopy removeEventHandler ["Killed", 0];

	if (isEngineOn _train) then {
		[_train] call ATS_checkSimulation;
		_localCopy engineOn false;
	};

	true //return for keyhandler
};
