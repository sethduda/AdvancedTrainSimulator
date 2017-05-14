params ["_trainCar","_speed","_isBackwards"];
private _isLocalCopy = _trainCar getVariable ["ATRAIN_Is_Local_Copy",false];
if(!_isLocalCopy) exitWith {};
private _currentPhase = _trainCar animationSourcePhase "Wheels_source";
if(_speed == 0) then {
	_trainCar animateSource ["Wheels_source",_currentPhase];
} else {
	private _phaseDirection  = 1;
	if( _speed < 0 ) then {
		_phaseDirection = -1;
	};
	if( _isBackwards ) then {
		_phaseDirection = _phaseDirection * -1;
	};
	private _newPhase = _currentPhase + (10 * _phaseDirection);
	private _animationSpeed = (abs _speed) / 6;
	_trainCar animateSource ["Wheels_source",_newPhase, _animationSpeed];
};
