params ["_trainEngine","_trainCar","_trainDistanceFromFront"];
private _carLength = _trainCar getVariable ["ATRAIN_Remote_Car_Length",6];
private _carFrontPositionAndDirection = [_trainEngine, _trainCar, _trainDistanceFromFront - (_carLength * 0.4)] call ATRAIN_fnc_getTrainPositionAndDirection;
private _carBackPositionAndDirection = [_trainEngine, _trainCar, _trainDistanceFromFront + (_carLength * 0.4)] call ATRAIN_fnc_getTrainPositionAndDirection;
[_carFrontPositionAndDirection, _carBackPositionAndDirection];
