ATRAIN_RIDE_ON_TRAIN_EVENT_HANDLER_PARAMS params ["_player","_train"];

private _remoteTrain = _train getVariable ["ATRAIN_Remote_Copy",_train];
private _mainEngine = _remoteTrain getVariable ["ATRIAN_Current_Train", _remoteTrain];

private _currentTrainPositionASL = getPosASLVisual _train;
private _lastTrainPositionASL = _player getVariable ["ATRAIN_Riding_On_Train_Last_Train_Position_ASL", _currentTrainPositionASL];
private _currentTrainDir = getDir _train;
private _lastTrainDir = _player getVariable ["ATRAIN_Riding_On_Train_Last_Train_Dir", _currentTrainDir];

_player setVariable ["ATRAIN_Riding_On_Train_Last_Train_Position_ASL", _currentTrainPositionASL];
_player setVariable ["ATRAIN_Riding_On_Train_Last_Train_Dir", _currentTrainDir];

private _isPlayerMoving = [_player] call ATRAIN_fnc_isPassengerMoving;

if(_isPlayerMoving) then {	
	_player setVariable ["ATRAIN_Riding_On_Train_Last_Player_Position_Model", _train worldToModelVisual (ASLToAGL getPosASLVisual vehicle _player) ];
};

private _lastPlayerPositionModel = _player getVariable ["ATRAIN_Riding_On_Train_Last_Player_Position_Model", _train worldToModelVisual (ASLToAGL getPosASLVisual vehicle _player)];	

if(_currentTrainPositionASL distance _lastTrainPositionASL > 0) then {
	
	if(!_isPlayerMoving) then {	
		(vehicle _player) setVelocity [0,0,0];
	};
	
	(vehicle _player) setDir (getDir _player + _currentTrainDir - _lastTrainDir);
	(vehicle _player) setPosASL (AGLtoASL (_train modelToWorldVisual _lastPlayerPositionModel));

};
