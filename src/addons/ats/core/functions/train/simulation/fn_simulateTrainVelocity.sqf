params ["_train"];
private _driver = _train getVariable ["ATRAIN_Remote_Driver", objNull];
private _movementDirection = 0;
if(!isNull _driver) then {
	_movementDirection = _driver getVariable ["ATRAIN_Remote_Movement_Direction",0];
};
private _currentCalcTime = diag_tickTime;
private _lastCalcTime = _train getVariable ["ATRAIN_Local_Last_Velocity_Calculation_Time",_currentCalcTime];
private _deltaCalcTime = (_currentCalcTime - _lastCalcTime);
if(_deltaCalcTime > 2) then {
	_deltaCalcTime = 0;
};
private _carCount = count (_train getVariable ["ATRAIN_Remote_Cars",[_train]]);

private _trainAccelerationMin = _train getVariable ["ATRAIN_Local_Train_Acceleration_Min", 0.7];
private _trainAccelerationMax = _train getVariable ["ATRAIN_Local_Train_Acceleration_Max", 1.2];
private _trainAccelerationRange = _trainAccelerationMax - _trainAccelerationMin;
private _trainAcceleration = _trainAccelerationMin + (_trainAccelerationRange * (1 - (((_carCount / 20) min 1))));

private _trainDragMin = _train getVariable ["ATRAIN_Local_Train_Drag_Min", 0.7];
private _trainDragMax = _train getVariable ["ATRAIN_Local_Train_Drag_Max", 1.2];
private _trainDragRange = _trainDragMax - _trainDragMin;
private _trainDrag = _trainDragMin + (_trainDragRange * (1 - ((_carCount / 20) min 1)));

private _cruiseControlEnabled = _train getVariable ["ATRAIN_Remote_Cruise_Control_Enabled", false];
private _breakEnabled = player getVariable ["ATRAIN_Remote_Break_Enabled", false];

if(_cruiseControlEnabled && !_breakEnabled) then {
	_trainDrag = 0;
};

if(_breakEnabled) then {
	_trainAcceleration = 0;
	_movementDirection = 0;
	_trainDrag = _trainDrag * 2;
};

private _trainModelReversed = _train getVariable ["ATRAIN_Remote_Is_Model_Reversed",false];
if(_trainModelReversed) then {
	_movementDirection = _movementDirection * -1;
};

private _trainMaxVelocity = _train getVariable ["ATRAIN_Remote_Train_Max_Velocity",12];
private _trainVelocity = _train getVariable ["ATRAIN_Local_Velocity",0];
_trainVelocity = (_trainVelocity + (_trainAcceleration * _movementDirection * _deltaCalcTime)) min _trainMaxVelocity max -_trainMaxVelocity;
if(_trainVelocity > 0 && _movementDirection == 0) then {
	_trainVelocity = (_trainVelocity - (_trainDrag * _deltaCalcTime)) max 0;
};
if(_trainVelocity < 0 && _movementDirection == 0) then {
	_trainVelocity = (_trainVelocity + (_trainDrag * _deltaCalcTime)) min 0;
};
private _localVelocityUpdate = _train getVariable ["ATRAIN_Local_Velocity_Update",nil];
if(!isNil "_localVelocityUpdate") then {
	_trainVelocity = _localVelocityUpdate;
	_train setVariable ["ATRAIN_Local_Velocity_Update",nil];
};
_train setVariable ["ATRAIN_Local_Velocity",_trainVelocity];
_train setVariable ["ATRAIN_Local_Last_Velocity_Calculation_Time",_currentCalcTime];

// Enable the train's engine automatically when the train starts moving
private _enginedEnabled = _train getVariable ["ATRAIN_Remote_Engine_Enabled", false];
if(_trainVelocity != 0 && !_enginedEnabled) then {
	_train setVariable ["ATRAIN_Remote_Engine_Enabled", true, true];
};
