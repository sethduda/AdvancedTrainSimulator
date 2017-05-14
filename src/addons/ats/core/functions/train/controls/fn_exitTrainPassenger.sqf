private _trainCar = player getVariable ["ATRAIN_Current_Train_Passenger_Car",objNull];
if(!isNull _trainCar) then {
	player setVariable ["ATRAIN_Current_Train_Passenger_Car", nil];
	[] call ATRAIN_fnc_disableTrainPassengerInputHandlers;
	_localCopy = _trainCar getVariable ["ATRAIN_Local_Copy",_trainCar];
	private _trainPos = getPos _localCopy;
	private _trainVectorDir = vectorDir _localCopy;
	private _trainVectorUp = vectorUp _localCopy;
	private _trainVectorLeft = _trainVectorDir vectorCrossProduct _trainVectorUp;
	private _exitPos = _trainPos vectorAdd (_trainVectorLeft vectorMultiply 3);
	_exitPos set [2,0];
	player setPos _exitPos;
	[player,false] call ATRAIN_fnc_hidePlayerObjectGlobal;
	player enableSimulation true;
	player allowDamage true;
	[] call ATRAIN_fnc_disable3rdPersonCamera;
};
