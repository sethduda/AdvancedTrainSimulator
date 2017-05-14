params ["_profileName"];
private _profile = [];
private _profileIndex = -1;
{
	if(_x select 0 == _profileName) exitWith {
		_profile = _x;
		_profileIndex = _forEachIndex;
	};
} forEach ATRAIN_Profiles;
[_profileIndex,_profile];
