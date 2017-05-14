params ["_train"];

private _currentCar = player getVariable ["ATRAIN_Current_Train_Car",objNull];
if(isNull _currentCar) then {
	_currentCar = player getVariable ["ATRAIN_Current_Train_Passenger_Car",objNull];
};

// If player is in the engine or passenger car, return it
if(!isNull _currentCar) exitWith { _currentCar };

// Otherwise, find the train car closest to the player's camera

private _minDistance = 0;
private _closestCar = objNull;
private _cameraPositionASL = AGLToASL (positionCameraToWorld [0,0,0]);
private _cars = _train getVariable ["ATRAIN_Remote_Cars",[_train]];
{
	private _localCar = _x getVariable ["ATRAIN_Local_Copy",_x];
	if( isNull _closestCar || (visiblePositionASL _localCar) distance _cameraPositionASL < _minDistance) then {
		_minDistance = (visiblePositionASL _localCar) distance _cameraPositionASL;
		_closestCar = _x;
	};
} forEach _cars;

_closestCar;