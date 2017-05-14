ATRAIN_Player_Actions = missionNamespace getVariable ["ATRAIN_Player_Actions",[]];
// start a player's eyes
private _searchStartPointASL = eyePos player;
// end 2 meters in front of where player is looking
private _searchEndPointASL = _searchStartPointASL vectorAdd ((_searchStartPointASL vectorFromTo (ATLtoASL screenToWorld [0.5,0.5])) vectorMultiply 2);
private _objects = lineIntersectsWith [_searchStartPointASL,_searchEndPointASL];
private _trainFound = objNull;
{
	if(count ([_x] call ATRAIN_fnc_getTrainDefinition) > 0) exitWith {
		_trainFound = _x;
	};
} forEach _objects;

if(!isNull _trainFound && count ATRAIN_Player_Actions == 0) then {
	_trainFound = _trainFound getVariable ["ATRAIN_Remote_Copy",_trainFound];
	private _trainDef = [_trainFound] call ATRAIN_fnc_getTrainDefinition;
	_trainDef params ["_className", "_isDrivable", "_isRideable"];
	
	// Add actions
	if(_isDrivable) then {
		private _mainEngine = _trainFound getVariable ["ATRIAN_Current_Train", _trainFound];
		private _currentDriver = _mainEngine getVariable ["ATRAIN_Remote_Driver", objNull];
		if(isNull _currentDriver || !alive _currentDriver || _currentDriver == player) then {		
			private _driveAction = player addAction ["Get in Train as Driver", {
				(_this select 3) params ["_mainEngine","_trainCar"];
				private _currentDriver = _mainEngine getVariable ["ATRAIN_Remote_Driver", objNull];
				if(isNull _currentDriver || !alive _currentDriver || _currentDriver == player) then {	
					[_mainEngine,_trainCar] call ATRAIN_fnc_getInTrain;
				};
			},[_mainEngine,_trainFound]];
			ATRAIN_Player_Actions pushBack _driveAction;
		};
	};

	private _currentTrain = _trainFound getVariable ["ATRIAN_Current_Train", objNull];
	if(!isNull _currentTrain && (_currentTrain getVariable ["ATRAIN_Local_Velocity",0]) == 0 && _currentTrain != _trainFound) then {
		private _disconnectAction = player addAction ["Disconnect Car", {
		
			private _trainCar = _this select 3;
			private _localTrainCar = _trainCar getVariable ["ATRAIN_Local_Copy", _trainCar];
			private _currentTrain = _trainCar getVariable ["ATRIAN_Current_Train", objNull];
			
			private _carsInRear = _currentTrain getVariable ["ATRAIN_Remote_Cars_In_Rear",[]];
			private _carsInFront = _currentTrain getVariable ["ATRAIN_Remote_Cars_In_Front",[]];
			private _allCars = _currentTrain getVariable ["ATRAIN_Remote_Cars",[]];
			
			private _rearCarSeen = false;
			private _newCarsInRear = [];
			{
				if(_x == _trainCar && !_rearCarSeen) then {
					_rearCarSeen = true;
				};
				if(_rearCarSeen) then {
					_x setVariable ["ATRIAN_Current_Train",nil,true];
					_x setVariable ["ATRIAN_Remote_Is_Backwards", nil, true];
					_x setPosASL (getPosASLVisual _localTrainCar);
					_x setVectorDirAndUp [vectorDir _localTrainCar, vectorUp _localTrainCar];
					_allCars = _allCars - [_x];
				} else {
					_newCarsInRear pushBack _x;
				};
			} forEach _carsInRear;
			_currentTrain setVariable ["ATRAIN_Remote_Cars_In_Rear",_newCarsInRear,true];
			
			
			
			private _frontCarSeen = false;
			private _newCarsInFront = [];
			{
				if(_x == _trainCar && !_frontCarSeen) then {
					_frontCarSeen = true;
				};		
				if(_frontCarSeen) then {
					_x setVariable ["ATRIAN_Current_Train",nil,true];
					_x setVariable ["ATRIAN_Remote_Is_Backwards", nil, true];
					_x setPosASL (getPosASLVisual _localTrainCar);
					_x setVectorDirAndUp [vectorDir _localTrainCar, vectorUp _localTrainCar];
					_allCars = _allCars - [_x];
				} else {
					_newCarsInFront pushBack _x;
				};
			} forEach _carsInFront;
			_currentTrain setVariable ["ATRAIN_Remote_Cars_In_Front",_newCarsInFront,true];

			_currentTrain setVariable ["ATRAIN_Remote_Cars",_allCars,true];

		},_trainFound];
		ATRAIN_Player_Actions pushBack _disconnectAction;
	
	};
	
	if(_isRideable) then {
		private _currentTrain = _trainFound getVariable ["ATRIAN_Current_Train", objNull];
		private _currentDriver = _currentTrain getVariable ["ATRAIN_Remote_Driver", objNull];
		if(!isNull _currentTrain && _currentTrain != _trainFound && _currentDriver != player) then {
			private _rideAction = player addAction ["Ride Train", {
				[_this select 3] call ATRAIN_fnc_getInTrainPassenger;
			},_trainFound];
			ATRAIN_Player_Actions pushBack _rideAction;
		};
	};
};

if(isNull _trainFound && count ATRAIN_Player_Actions > 0) then {
	{
		player removeAction _x;
	} forEach ATRAIN_Player_Actions;
	ATRAIN_Player_Actions = [];
};

