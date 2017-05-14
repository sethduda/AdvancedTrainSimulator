  while {true} do {
    {
      private _soundSource = _x;
      private _soundSourcePositionASL = [_soundSource] call ATRAIN_fnc_getSoundSourcePositionASL;
      private _cameraPositionASL = AGLToASL (positionCameraToWorld [0,0,0]);
      private _maxDistance = _soundSource getVariable "maxDistance";
      if(_cameraPositionASL distance _soundSourcePositionASL < _maxDistance * 2) then {
        if!( _soundSource in ATRAIN_Sound_Sources_Near) then {
          ATRAIN_Sound_Sources_Near pushBack _soundSource;
        };
      } else {
        if( _soundSource in ATRAIN_Sound_Sources_Near) then {
          ATRAIN_Sound_Sources_Near = ATRAIN_Sound_Sources_Near - [_soundSource];
          _soundSource setPosASL [-1000,-1000,-1000];
          _soundSource spawn {
            sleep 0.1; // Repeat 0.1 seconds later to avoid concurrency issues
            _this setPosASL [-1000,-1000,-1000];
          };
        };
      };
    } forEach ATRAIN_Sound_Sources;
    sleep 3;
  };
