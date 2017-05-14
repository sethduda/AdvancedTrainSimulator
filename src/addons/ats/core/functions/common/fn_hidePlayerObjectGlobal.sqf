params ["_player","_hide"];
if(isPlayer _player) then {
	if(isServer) then {
		_player hideObjectGlobal _hide;
	} else {
		_player hideObject _hide;
		[_this, "ATRAIN_fnc_hidePlayerObjectGlobal"] call ATRAIN_fnc_RemoteExecServer;
	};
};
