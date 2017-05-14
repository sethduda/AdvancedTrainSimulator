params ["_train"];
private _trainCalculationsQueued = _train getVariable ["ATRAIN_Calculations_Queued",true];
private _trainCars = _train getVariable ["ATRAIN_Remote_Cars",[_train]];
private _lastAttachmentTime = _train getVariable ["ATRAIN_Local_Last_Attachment_Time",0];
private _currentTime = diag_tickTime;
private _lastSeen = _train getVariable ["ATRAIN_New_Alignment_Last_Seen",diag_tickTime];
private _timeSinceLastSeen = _currentTime - _lastSeen;
private _trainSpeed = _train getVariable ["ATRAIN_Local_Velocity",0];

private _maxAnimatedCars = missionNamespace getVariable ["ATRAIN_MAX_CARS_SIMULATED_ENABLED", 3];
private _carsWithAnimationEnabled = 0;	

{
	private _localCopy = _x getVariable ["ATRAIN_Local_Copy", objNull];
	if(isNull _localCopy) then {
		_localCopy = [_x, false, false] call ATRAIN_fnc_hideTrainReplaceWithNew;
		_localCopy setVariable ["ATRAIN_Is_Local_Copy",true];
		_localCopy setVariable ["ATRAIN_Remote_Copy",_x];
		_localCopy = [_localCopy] call ATRAIN_fnc_initTrainObject;
		if(ATRAIN_3rd_Person_Camera_Target == _x) then {
			ATRAIN_3rd_Person_Camera_Target = _localCopy;
		};
		_x setVariable ["ATRAIN_Local_Copy", _localCopy];
	};
	private _lastDrawPosition = _x getVariable ["ATRAIN_Last_Draw_Position",getPosASLVisual _localCopy];	
	private _lastDrawDirection = _x getVariable ["ATRAIN_Last_Draw_Vector_Dir",vectorDir _localCopy];
	private _newDrawDirection = _x getVariable ["ATRAIN_New_Draw_Vector_Dir",_lastDrawDirection];
	private _velocityFromLastToNewPosition = _x getVariable ["ATRAIN_Velocity_From_Last_To_New_Position",0];
	private _directionFromLastToNewPosition = _x getVariable ["ATRAIN_Direction_From_Last_To_New_Position",_lastDrawDirection];
	private _distanceFromLastToNewPosition = _x getVariable ["ATRAIN_Distance_From_Last_To_New_Position", 0];
	private _animateTrain = _x getVariable ["ATRAIN_Remote_Animate_Train",false];
	private _isCableCar = _x getVariable ["ATRAIN_Remote_Is_Cable_Car",false];
	
	// Enable in-game simulation for front and rear cars (so that it can collide with objects)
	
	if(_distanceFromLastToNewPosition > 0.01) then {
		if(_carsWithAnimationEnabled < _maxAnimatedCars) then {
			_carsWithAnimationEnabled = _carsWithAnimationEnabled + 1;
			if(!simulationEnabled _localCopy) then {
				_localCopy enableSimulation true;
			};
		} else {
			if(simulationEnabled _localCopy) then {
				_localCopy enableSimulation false;
			};
		};
	} else {
		if(simulationEnabled _localCopy) then {
			_localCopy enableSimulation false;
		};
	};
	
	if(_distanceFromLastToNewPosition > 0.01) then {
		private _distanceMovedFromLastPosition = _timeSinceLastSeen * _velocityFromLastToNewPosition;
		private _percentMovedFromLastPosition = 0;
		if(_distanceFromLastToNewPosition != 0) then {
			_percentMovedFromLastPosition = _distanceMovedFromLastPosition / _distanceFromLastToNewPosition;
		};
		_percentMovedFromLastPosition = (_percentMovedFromLastPosition max 0) min 1;
		private _currentDrawDirection = vectorNormalized ((_lastDrawDirection vectorMultiply (1-_percentMovedFromLastPosition)) vectorAdd (_newDrawDirection vectorMultiply _percentMovedFromLastPosition));
		private _currentDrawPosition = _lastDrawPosition vectorAdd (_directionFromLastToNewPosition vectorMultiply (_distanceMovedFromLastPosition min _distanceFromLastToNewPosition));
		
		if(_isCableCar) then {
			_currentDrawDirection set [2,0];
		};
		
		_localCopy setVectorDirAndUp [_currentDrawDirection,[0,0,1]];
		_localCopy setPosASL _currentDrawPosition;
		
		private _attachments = _x getVariable ["ATRAIN_Attachments",[]];
		{
			private _object = _x select 0;
			private _objectModelPos = _x select 1;
			private _objectLocalCopy = _object getVariable ["ATRAIN_Local_Copy", objNull];
			if(isNull _objectLocalCopy) then {
				_objectLocalCopy = (typeOf _object) createVehicleLocal [0,0,1000];
				_object setVariable ["ATRAIN_Local_Copy", _objectLocalCopy];
				_object hideObject true;
				_objectLocalCopy enableSimulation false;
			};
			_objectLocalCopy setVectorDirAndUp [_currentDrawDirection,[0,0,1]];
			_objectLocalCopy setPosASL ((AGLtoASL (_localCopy modelToWorld _objectModelPos)) vectorAdd [0,0,-2.4]);
		} forEach _attachments;
		
		_x setVariable ["ATRAIN_Current_Draw_Position", _currentDrawPosition];
	};
} forEach _trainCars;

if(!_trainCalculationsQueued) then {
	{
		private _newAlignment = _x getVariable ["ATRAIN_Local_Alignment",nil];
		private _localCopy = _x getVariable ["ATRAIN_Local_Copy", objNull];
		if(isNull _localCopy) exitWith {};
		private _currentPosition = _x getVariable ["ATRAIN_Current_Draw_Position", getPosASLVisual _localCopy];
		if(!isNil "_newAlignment") then {
			private _frontAlignmentPoint = _newAlignment select 0;
			private _frontAlignmentPointPosition = _frontAlignmentPoint select 0;
			private _frontAlignmentPointDirection = _frontAlignmentPoint select 1;
			private _rearAlignmentPoint = _newAlignment select 1;
			private _rearAlignmentPointPosition = _rearAlignmentPoint select 0;
			private _rearAlignmentPointDirection = _rearAlignmentPoint select 1;
			private _trainVectorDirection = _rearAlignmentPointPosition vectorFromTo _frontAlignmentPointPosition;
			private _trainPosition = _frontAlignmentPointPosition vectorAdd ((_rearAlignmentPointPosition vectorDiff _frontAlignmentPointPosition) vectorMultiply 0.5);
			private _trainIsBackwards = _x getVariable ["ATRIAN_Remote_Is_Backwards", false];
			private _animateTrain = _x getVariable ["ATRAIN_Remote_Animate_Train",false];
			if(_trainIsBackwards) then {
				_trainVectorDirection = _trainVectorDirection vectorMultiply -1;
			};
			// Offset position based on train model params
			private _positionOffset = _x getVariable ["ATRAIN_Remote_Position_Offset", [0,0,0]];
			_trainPosition = _trainPosition vectorAdd (_trainVectorDirection vectorMultiply (_positionOffset select 0));
			_trainPosition = _trainPosition vectorAdd ((_trainVectorDirection vectorCrossProduct [0,0,1]) vectorMultiply (_positionOffset select 1));
			_trainPosition = _trainPosition vectorAdd [0,0,(_positionOffset select 2)];
			_x setVariable ["ATRAIN_New_Draw_Position",_trainPosition];
			_x setVariable ["ATRAIN_New_Draw_Vector_Dir",_trainVectorDirection];
			_x setVariable ["ATRAIN_Distance_From_Last_To_New_Position",_currentPosition distance _trainPosition];
			private _velocityFromLastToNewPosition = _x getVariable ["ATRAIN_Velocity_From_Last_To_New_Position",0];
			if(_timeSinceLastSeen == 0) then {
				_velocityFromLastToNewPosition = ( _velocityFromLastToNewPosition  * 0.5);
			} else {
				private _newVelocityFromLastToNewPosition = ((_currentPosition distance _trainPosition) / _timeSinceLastSeen);
				_velocityFromLastToNewPosition = ( _velocityFromLastToNewPosition  * 0.5) + ( _newVelocityFromLastToNewPosition * 0.5);
			};
			_x setVariable ["ATRAIN_Velocity_From_Last_To_New_Position", _velocityFromLastToNewPosition ];
			_x setVariable ["ATRAIN_Direction_From_Last_To_New_Position",_currentPosition vectorFromTo _trainPosition];
			if(_animateTrain) then {
				[_localCopy,_trainSpeed,_trainIsBackwards] call ATRAIN_fnc_setWheelSpeed;
			};
		};
		_x setVariable ["ATRAIN_Last_Draw_Position",_currentPosition];
		_x setVariable ["ATRAIN_Last_Draw_Vector_Dir",vectorDir _localCopy];
	} forEach _trainCars;
	_train setVariable ["ATRAIN_Calculations_Queued",true];
	_train setVariable ["ATRAIN_New_Alignment_Last_Seen",_currentTime];
};

