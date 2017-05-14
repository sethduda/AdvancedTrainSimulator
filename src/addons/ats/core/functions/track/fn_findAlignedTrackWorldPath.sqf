params ["_track","_approachPosVectorDir"];
private _worldPaths = [_track] call ATRAIN_fnc_getTrackWorldPaths;
private _bestTrackPathDotProduct = -1;
private _bestTrackWorldPath = [];
{
	private _pathPosition0ASL = (_x select 0);
	private _pathPosition1ASL = (_x select 1);	
	private _pathVectorDir = _pathPosition0ASL vectorFromTo _pathPosition1ASL;
	private _pathDotProduct = _approachPosVectorDir vectorDotProduct _pathVectorDir;
	if( _pathDotProduct > _bestTrackPathDotProduct || _bestTrackPathDotProduct == -1 ) then {
		_bestTrackPathDotProduct = _pathDotProduct;
		_bestTrackWorldPath = _x;
	};
} forEach _worldPaths;
_bestTrackWorldPath;
