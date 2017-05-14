params ["_positionASL",["_ignoreObject",objNull],["_approachDirectionVector",[0,0,0]]];
private _intersectStartASL = _positionASL vectorAdd [0,0,2] vectorAdd (_approachDirectionVector vectorMultiply -4);
private _intersectEndASL = _positionASL vectorAdd [0,0,-2] vectorAdd (_approachDirectionVector vectorMultiply 4);
private _objects = lineIntersectsWith [_intersectStartASL,_intersectEndASL,_ignoreObject];
private _foundTracks = [];
private _didFindTracks = false;
private _trackDef = [];
{
	private _object = _x;
	if(!isNull _object) then {
		_trackDef = [_object] call ATRAIN_fnc_getTrackDefinition;
		if(count _trackDef > 0) then {
			_foundTracks pushBack _object;
			_didFindTracks = true;
		};
	};
} forEach _objects;
_foundTracks;
