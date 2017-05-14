params ["_positionASL",["_ignoreObject",objNull]];
private _intersectStartASL = _positionASL vectorAdd [0,0,2];
private _intersectEndASL = _positionASL vectorAdd [0,0,-2];
private _objects = lineIntersectsWith [_intersectStartASL,_intersectEndASL,_ignoreObject];
private _foundTrain = objNull;
{
	private _object = _x;
	if(!isNull _object) then {
		_trainDef = [_object] call ATRAIN_fnc_getTrainDefinition;
		if(count _trainDef > 0) then {
			_foundTrain = _object;
		};
	};
} forEach _objects;
_foundTrain;
