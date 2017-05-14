params ["_soundSource","_isEnabled"];
  _soundSource setVariable ["enabled", _isEnabled];
  if(!_isEnabled) then {
  	_soundSource setPosASL [-1000,-1000,-1000];
  	_soundSource spawn {
  		sleep 0.1; // Repeat 0.1 seconds later to avoid concurrency issues
  		_this setPosASL [-1000,-1000,-1000];
	};
};
