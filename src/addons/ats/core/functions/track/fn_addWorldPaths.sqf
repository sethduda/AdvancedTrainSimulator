params ["_path", "_addPath",["_replaceOverlapWithAddedPath",false]];

if(count _addPath < 2) exitWith { 0; };
private _distanceAddedToPath = 0;
private _pathSize = count _path;

// Initialize path if it contains no points
if(_pathSize == 0) exitWith {
	private _lastSeenPathPointPositionASL = _addPath select 0;
	{
		_path pushBack _x;
		_distanceAddedToPath = _distanceAddedToPath + (_lastSeenPathPointPositionASL distance _x);
		_lastSeenPathPointPositionASL = _x;
	} forEach _addPath;
	_distanceAddedToPath;
};

private _lastPathPointPosASL = _path select (_pathSize - 1);
private _secondToLastPathPointPosASL = _path select (_pathSize - 2);		
private _pathUnitVectorDir = _secondToLastPathPointPosASL vectorFromTo _lastPathPointPosASL;

// Align direction of paths
private _addPathFirstPointPosASL = _addPath select 0;
private _addPathSecondPointPosASL = _addPath select 1;
private _addPathVectorDir = _addPathFirstPointPosASL vectorFromTo _addPathSecondPointPosASL;
private _pathDotProduct = _pathUnitVectorDir vectorDotProduct _addPathVectorDir;
if( _pathDotProduct < 0 ) then {
	reverse _addPath;
};

// Remove overlapping points from path before adding new path (if requested)
if(_replaceOverlapWithAddedPath) then {
	private _resizeTo = _pathSize;
	private _addPathFirstPointPosASL = _addPath select 0;
	for [{_i=_pathSize-1}, {_i > 1}, {_i=_i-1}] do
	{	
		private _pathPointPosASL = (_path select _i);
		private _priorPathPointPosASL = (_path select _i - 1);
		private _pathUnitVectorDir = _priorPathPointPosASL vectorFromTo _pathPointPosASL;
		private _unitVectorDirToNewPathPoint = _pathPointPosASL vectorFromTo _addPathFirstPointPosASL;
		if( _pathUnitVectorDir vectorDotProduct _unitVectorDirToNewPathPoint <= 0 ) then {
			_resizeTo = _resizeTo - 1;
			_distanceAddedToPath = _distanceAddedToPath - (_priorPathPointPosASL distance _pathPointPosASL);
		} else {
			_i = 0;
		};
	};
	if(_resizeTo < _pathSize) then {
		_path resize _resizeTo;
		_pathSize = _resizeTo;
	};
	_lastPathPointPosASL = (_path select (_pathSize - 1));
};

// Add the the new path onto the existing path
{
	private _unitVectorDirToNewPathPoint = _lastPathPointPosASL vectorFromTo _x;
	if( _pathUnitVectorDir vectorDotProduct _unitVectorDirToNewPathPoint > 0 ) then {
		// Merges points together (reduces number of points slightly)
		/*if(_pathUnitVectorDir vectorDotProduct _unitVectorDirToNewPathPoint == 1 && !_replaceOverlapWithAddedPath && _pathSize > 2) then {
			_pathSize = (_pathSize-1);
			_path resize _pathSize;
		};*/
		_path pushBack _x;
		_distanceAddedToPath = _distanceAddedToPath + (_lastPathPointPosASL distance _x);
		_lastPathPointPosASL = _x;				
	};
} forEach _addPath;	
_distanceAddedToPath;
