params ["_player","_train"];

[] call ATRAIN_fnc_enableTrainPassengerInputHandlers;

player setVariable ["ATRAIN_Riding_On_Train_Last_Train_Position_ASL", getPosASLVisual _train];
player setVariable ["ATRAIN_Riding_On_Train_Last_Train_Dir", getDir _train];

player setVariable ["ATRAIN_Riding_On_Train_Last_Player_Position_Model", _train worldToModelVisual (ASLToAGL getPosASLVisual _player) ];

ATRAIN_RIDE_ON_TRAIN_EVENT_HANDLER_PARAMS = _this;
private _rideEventHandlerId = addMissionEventHandler ["EachFrame", {call ATRAIN_fnc_rideOnTrainEventHandler}];

while {true} do {
	private _currentTrain = [_player] call ATRAIN_fnc_getTrainUnderPlayer;
	private _currentPassengerCar = _player getVariable ["ATRAIN_Current_Train_Passenger_Car",objNull];
	if(isNull _currentTrain || _currentTrain != _train || !isNull _currentPassengerCar || !alive _player) exitWith {};
	sleep 0.1;
};
_player setVariable ["ATRAIN_Riding_On_Train", nil];	
removeMissionEventHandler ["EachFrame", _rideEventHandlerId];
[] call ATRAIN_fnc_disableTrainPassengerInputHandlers;
