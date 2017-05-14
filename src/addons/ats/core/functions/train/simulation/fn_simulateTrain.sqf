
params ["_train"];

private _driver = _train getVariable ["ATRAIN_Remote_Driver", objNull];
private _isTrainLocal = [_train] call ATRAIN_fnc_isTrainLocal;

private _currentSimulationTime = diag_tickTime;
private _lastSimulationTime = _train getVariable ["ATRAIN_Local_Last_Simulation_Time",_currentSimulationTime];
_train setVariable ["ATRAIN_Local_Last_Simulation_Time",_currentSimulationTime];
private _deltaSimulationTime = _currentSimulationTime - _lastSimulationTime;

if(_deltaSimulationTime > 5) then {
	_deltaSimulationTime = 0;
};

// Calculate train distance from start of path
private _trainDistanceFromFront = _train getVariable ["ATRAIN_Local_Distance_From_Front",0];
private _trainVelocity = _train getVariable ["ATRAIN_Local_Velocity",0];
_trainDistanceFromFront = _trainDistanceFromFront - (_trainVelocity * _deltaSimulationTime);

// Calculate engine alignment
private _engineLength = _train getVariable ["ATRAIN_Remote_Car_Length",6];
private _engineAlignment = [_train,_train,_trainDistanceFromFront] call ATRAIN_fnc_calculateTrainAlignment;
_train setVariable ["ATRAIN_Local_Alignment", _engineAlignment];

// Calculate rear cars alignments
private _trainCarsInRear = _train getVariable ["ATRAIN_Remote_Cars_In_Rear",[]];
private _rearCarAlignment = _engineAlignment;
private _rearCar = _train;
_carDistanceFrontStart = _trainDistanceFromFront;
_priorCarLength = _engineLength;
{
	_rearCar = _x;
	private _carLength = _rearCar getVariable ["ATRAIN_Remote_Car_Length", 6];
	_carDistanceFrontStart = _carDistanceFrontStart + ( _priorCarLength / 2 ) + ( _carLength / 2 );
	_rearCarAlignment = [_train,_rearCar,_carDistanceFrontStart] call ATRAIN_fnc_calculateTrainAlignment;
	_rearCar setVariable ["ATRAIN_Local_Alignment", _rearCarAlignment];
	_priorCarLength = _carLength;
} forEach _trainCarsInRear;
private _distanceFromEngineToRear = (_carDistanceFrontStart - _trainDistanceFromFront) + ( _priorCarLength / 2 );

// Calculate front cars alignments
private _trainCarsInFront = _train getVariable ["ATRAIN_Remote_Cars_In_Front",[]];
private _frontCarAlignment = _engineAlignment;
private _frontCar = _train;
_carDistanceFrontStart = _trainDistanceFromFront;
_priorCarLength = _engineLength;
{
	_frontCar = _x;
	private _carLength = _frontCar getVariable ["ATRAIN_Remote_Car_Length", 6];
	_carDistanceFrontStart = _carDistanceFrontStart - ( _priorCarLength / 2 ) - ( _carLength / 2 );
	_frontCarAlignment = [_train,_frontCar,_carDistanceFrontStart] call ATRAIN_fnc_calculateTrainAlignment;
	_frontCar setVariable ["ATRAIN_Local_Alignment", _frontCarAlignment];
	_priorCarLength = _carLength;
} forEach _trainCarsInFront;
private _distanceFromEngineToFront = (_trainDistanceFromFront - _carDistanceFrontStart) + ( _priorCarLength / 2 );

// Calculate track node updates
private _nodePath = _train getVariable ["ATRAIN_Local_Node_Path",[]];
private _trainNodePathDistance = _train getVariable ["ATRAIN_Local_Node_Path_Distance",0];
if((_trainDistanceFromFront - _distanceFromEngineToFront) < 0 || (_trainDistanceFromFront + _distanceFromEngineToRear) > _trainNodePathDistance) then {
	private _trainInReverse = _trainVelocity < 0;
	private _turnTurnDirection = 0;
	if(!isNull _driver) then {
		_turnTurnDirection = _driver getVariable ["ATRAIN_Remote_Turn_Direction",0];
	};
	private _trainAlignment = [_train,_frontCar,_trainDistanceFromFront - _distanceFromEngineToFront] call ATRAIN_fnc_calculateTrainAlignment;
	private _trainDirection = (_trainAlignment select 0) select 1;
	if(_trainInReverse) then {
		_trainAlignment = [_train,_rearCar,_trainDistanceFromFront + _distanceFromEngineToRear] call ATRAIN_fnc_calculateTrainAlignment;
		_trainDirection = ((_trainAlignment select 1) select 1) vectorMultiply -1;
	};
	private _trainDirectionRight = _trainDirection vectorCrossProduct [0,0,1];
	private _finalNodeIndex = _nodePath select 0;
	if(_trainInReverse) then {
		_finalNodeIndex = _nodePath select ((count _nodePath) - 1);
	};
	private _possibleNextNodes = [];
	private _mapFinalNode = ATRAIN_Map select _finalNodeIndex;
	{
		private _connectedNodeIndex = _x select 0;
		private _connectedNodeDistance = _x select 1;
		private _connectedNodePath = _x select 2;
		private _connectedNodePathStartPositionASL = (_connectedNodePath select 0);
		private _connectedNodePathSecondPositionASL = (_connectedNodePath select 1);
		private _connectedNodeDirection = _connectedNodePathStartPositionASL vectorFromTo _connectedNodePathSecondPositionASL;
		if(_trainDirection vectorDotProduct _connectedNodeDirection > 0) then {
			_possibleNextNodes pushBack [_connectedNodeIndex, _connectedNodeDirection, _connectedNodeDistance];
		};
	} forEach _mapFinalNode;
	private _nextNodeIndex = -1;
	private _nextNodeDistance = -1;
	private _nextNodeIndexMinValue = 0;
	{
		private _dirDotProduct = _trainDirectionRight vectorDotProduct (_x select 1);
		private _dirDotProductDelta = abs (_turnTurnDirection - _dirDotProduct);
		if(_nextNodeIndex == -1 || _dirDotProductDelta < _nextNodeIndexMinValue) then {
			_nextNodeIndex = _x select 0;
			_nextNodeDistance = _x select 2;
			_nextNodeIndexMinValue = _dirDotProductDelta;
		};
	} forEach _possibleNextNodes;
	if(_nextNodeIndex != -1) then {
		if(_trainInReverse) then {
			_nodePath = _nodePath + [_nextNodeIndex];
		} else {
			_nodePath = [_nextNodeIndex] + _nodePath;
			_trainDistanceFromFront = _trainDistanceFromFront + _nextNodeDistance;
		};
		_trainNodePathDistance = _trainNodePathDistance + _nextNodeDistance;
		_train setVariable ["ATRAIN_Local_Node_Path",_nodePath];
		_train setVariable ["ATRAIN_Local_Node_Path_Distance",_trainNodePathDistance];
	} else {
		if(_trainInReverse) then {
			_trainDistanceFromFront = _trainNodePathDistance - _distanceFromEngineToRear;
		} else {
			_trainDistanceFromFront = _distanceFromEngineToFront;
		};
		_train setVariable ["ATRAIN_Local_Velocity_Update",0];
	};
};

_train setVariable ["ATRAIN_Local_Distance_From_Front",_trainDistanceFromFront];

if(count _nodePath > 2) then {
	[_train, _distanceFromEngineToRear, _distanceFromEngineToFront] call ATRAIN_fnc_cleanUpNodePath;
};

// Enable lights
private _lightsEnabled = _train getVariable ["ATRAIN_Remote_Lights_Enabled", false];
private _localCopy = _train getVariable ["ATRAIN_Local_Copy", objNull];
if(!isNull _localCopy) then {
	if(_lightsEnabled && !islighton _localCopy) then {
		_localCopy enableSimulation true;
		_localCopy setPilotLight true;
	};
	if(!_lightsEnabled && islighton _localCopy) then {
		_localCopy enableSimulation true;
		_localCopy setPilotLight false;
	};
};
