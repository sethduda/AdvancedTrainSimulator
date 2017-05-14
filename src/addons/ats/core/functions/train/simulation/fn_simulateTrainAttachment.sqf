params ["_train"];

private _trainVelocity = _train getVariable ["ATRAIN_Local_Velocity",0];
private _trainCars = _train getVariable ["ATRAIN_Remote_Cars",[_train]];
private _trainCarsInRear = _train getVariable ["ATRAIN_Remote_Cars_In_Rear",[]];
private _trainCarsInFront = _train getVariable ["ATRAIN_Remote_Cars_In_Front",[]];
_carLengthMultiplier = 0.53;

// Check for cars in rear
if(_trainVelocity < 0) then {
	private _rearCar = _train;
	if(count _trainCarsInRear > 0) then {
		_rearCar = _trainCarsInRear select ((count _trainCarsInRear)-1);
	};
	private _rearCarLocal = _rearCar getVariable ["ATRAIN_Local_Copy", objNull];
	if(isNull _rearCarLocal) exitWith {};
	private _rearCarPosASL = getPosASLVisual _rearCarLocal;
	private _rearCarSearchVectorDir = vectorDir _rearCarLocal;
	private _rearCarIsBackwards = _rearCar getVariable ["ATRIAN_Remote_Is_Backwards", false];
	if(!_rearCarIsBackwards) then {
		_rearCarSearchVectorDir = _rearCarSearchVectorDir vectorMultiply -1;
	};
	private _rearCarLength = _rearCar getVariable ["ATRAIN_Remote_Car_Length",6];
	private _intersectStartASL = _rearCarPosASL vectorAdd (_rearCarSearchVectorDir vectorMultiply (_rearCarLength*_carLengthMultiplier)) vectorAdd [0,0,3];
	private _intersectEndASL = _intersectStartASL vectorAdd [0,0,-3];
	private _newCars = lineIntersectsWith [_intersectStartASL,_intersectEndASL,_rearCarLocal];
	{
		private _car = _x;
		if(_car getVariable ["ATRAIN_Is_Local_Copy",false]) then {
			_car = _car getVariable ["ATRAIN_Remote_Copy",objNull];
		};
		if(!isNull _car) then {
			private _trainDef = [_car] call ATRAIN_fnc_getTrainDefinition;
			if(count _trainDef > 0 && !(_car in _trainCarsInFront) && !(_car in _trainCarsInRear) && _car != _train && isNull (_car getVariable ["ATRIAN_Current_Train",objNull])) then {
				private _carIsBackwards = (_rearCarSearchVectorDir vectorDotProduct (vectorDir _car)) > 0;
				_car = [_car] call ATRAIN_fnc_initTrainObject;
				_car setVariable ["ATRIAN_Remote_Is_Backwards", _carIsBackwards, true];
				_car setVariable ["ATRIAN_Current_Train", _train, true];
				_trainCarsInRear pushBackUnique _car;
				_trainCars pushBackUnique _car;
				_train setVariable ["ATRAIN_Remote_Cars_In_Rear",_trainCarsInRear,true];
				_train setVariable ["ATRAIN_Remote_Cars",_trainCars,true];
				_train setVariable ["ATRAIN_Local_Velocity_Update", _trainVelocity / 2];
				_train setVariable ["ATRAIN_Local_Last_Attachment_Time",diag_tickTime];
			};
		};
	} forEach _newCars;
};


// Check for cars in front
if(_trainVelocity > 0) then {
	private _frontCar = _train;
	if(count _trainCarsInFront > 0) then {
		_frontCar = _trainCarsInFront select ((count _trainCarsInFront)-1);
	};
	private _frontCarLocal = _frontCar getVariable ["ATRAIN_Local_Copy", objNull];
	if(isNull _frontCarLocal) exitWith {};
	private _frontCarPosASL = getPosASLVisual _frontCarLocal;
	private _frontCarSearchVectorDir = vectorDir _frontCarLocal;
	private _frontCarIsBackwards = _frontCar getVariable ["ATRIAN_Remote_Is_Backwards", false];
	if(_frontCarIsBackwards) then {
		_frontCarSearchVectorDir = _frontCarSearchVectorDir vectorMultiply -1;
	};
	private _frontCarLength = _frontCar getVariable ["ATRAIN_Remote_Car_Length",6];
	private _intersectStartASL = _frontCarPosASL vectorAdd (_frontCarSearchVectorDir vectorMultiply (_frontCarLength*_carLengthMultiplier)) vectorAdd [0,0,3];
	private _intersectEndASL = _intersectStartASL vectorAdd [0,0,-3];
	private _newCars = lineIntersectsWith [_intersectStartASL,_intersectEndASL,_frontCarLocal];
	{
		private _car = _x;
		if(_car getVariable ["ATRAIN_Is_Local_Copy",false]) then {
			_car = _car getVariable ["ATRAIN_Remote_Copy",objNull];
		};
		if(!isNull _car) then {
			private _trainDef = [_car] call ATRAIN_fnc_getTrainDefinition;
			if(count _trainDef > 0 && !(_car in _trainCarsInFront) && !(_car in _trainCarsInRear) && _car != _train && isNull (_car getVariable ["ATRIAN_Current_Train",objNull])) then {
				private _carIsBackwards = (_frontCarSearchVectorDir vectorDotProduct (vectorDir _car)) < 0;
				_car = [_car] call ATRAIN_fnc_initTrainObject;
				_car setVariable ["ATRIAN_Remote_Is_Backwards", _carIsBackwards, true];
				_car setVariable ["ATRIAN_Current_Train", _train, true];
				_trainCarsInFront pushBackUnique _car;
				_trainCars pushBackUnique _car;
				_train setVariable ["ATRAIN_Remote_Cars_In_Front",_trainCarsInFront,true];
				_train setVariable ["ATRAIN_Remote_Cars",_trainCars,true];
				_train setVariable ["ATRAIN_Local_Velocity_Update",_trainVelocity / 2];
				_train setVariable ["ATRAIN_Local_Last_Attachment_Time",diag_tickTime];
			};

		};
	} forEach _newCars;
};