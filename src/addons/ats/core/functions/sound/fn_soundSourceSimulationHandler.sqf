  while {true} do {
    {
      private _tickTime = diag_tickTime;
      private _soundSource = _x;
      if(_soundSource getVariable "enabled") then {

        // Set sound source position
        private _cameraPositionASL = AGLToASL (positionCameraToWorld [0,0,0]);
        private _soundSourcePositionASL = [_soundSource] call ATRAIN_fnc_getSoundSourcePositionASL;
        private _volume = [_soundSource] call ATRAIN_fnc_getSoundSourceVolume;
        private _maxDistance = _soundSource getVariable "maxDistance";
        if(_volume < 1) then {
        	// Move sound source further away from position to simulate volume
          _soundSourcePositionASL = _soundSourcePositionASL vectorAdd ((_cameraPositionASL vectorFromTo _soundSourcePositionASL) vectorMultiply (((-_volume)+1) * (_maxDistance)));
        };	
        _soundSource setPosASL _soundSourcePositionASL;

        // Play sound source sound
        private _lastPlayTime = _soundSource getVariable "lastPlayTime";
        private _repeatLength = _soundSource getVariable "repeatLength";
        private _repeat = _soundSource getVariable "repeat";
        private _sound = _soundSource getVariable "sound";
        private _pitch = _soundSource getVariable "pitch";
        if( (_repeat || _lastPlayTime == 0) && _tickTime - _lastPlayTime > (_repeatLength) ) then {
          _soundSource say3D [_sound, _maxDistance, _pitch];
          _soundSource setVariable ["lastPlayTime", _tickTime];
        };

      };
    } forEach ATRAIN_Sound_Sources_Near;
    sleep 0.1;
  };
