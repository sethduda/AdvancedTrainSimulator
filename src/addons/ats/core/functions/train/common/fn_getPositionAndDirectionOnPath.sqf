#define CALC_POS_AND_DIR_FROM_START(trackStartASL, trackEndASL, distanceFromStart) [(trackStartASL vectorAdd ( ( trackStartASL vectorFromTo trackEndASL ) vectorMultiply distanceFromStart)), trackEndASL vectorFromTo trackStartASL]

params ["_path","_distanceFromFront",["_frontIsFirstElement",false],["_pathId",""],["_objectBeingPositioned",objNull]];

private _positionAndDirectionOnPath = [];

// Lookup Position Cache Data (To speed up position lookup)
private ["_lastPathId","_lastPathIndex","_lastPathDistance","_lastPathCount"];
if(isNull _objectBeingPositioned) then {
	_lastPathId = missionNamespace getVariable ["ATRAIN_Position_Cache_Path_id",""];
	_lastPathIndex = missionNamespace getVariable ["ATRAIN_Position_Cache_Path_Index",0];
	_lastPathDistance = missionNamespace getVariable ["ATRAIN_Position_Cache_Path_Distance",0];
	_lastPathCount = missionNamespace getVariable ["ATRAIN_Position_Cache_Path_Count",0];
} else {
	_lastPathId = _objectBeingPositioned getVariable ["ATRAIN_Position_Cache_Path_id",""];
	_lastPathIndex = _objectBeingPositioned getVariable ["ATRAIN_Position_Cache_Path_Index",0];
	_lastPathDistance = _objectBeingPositioned getVariable ["ATRAIN_Position_Cache_Path_Distance",0];
	_lastPathCount = _objectBeingPositioned getVariable ["ATRAIN_Position_Cache_Path_Count",0];
};

if(_lastPathId == _pathId && _pathId != "") then {
	
	// Lookup path position using cached data (much faster)
	
	if(_frontIsFirstElement) then {
		if( _distanceFromFront < _lastPathDistance ) then {
			if(_lastPathIndex == 0) then {
				private _pointPositionASL = (_path select 0);
				private _priorPointPositionASL = (_path select 1);
				_positionAndDirectionOnPath = CALC_POS_AND_DIR_FROM_START(_pointPositionASL, _priorPointPositionASL, _distanceFromFront);
			} else {
				private _distanceSeen = _lastPathDistance;
				for [{_i=_lastPathIndex}, {_i > 0}, {_i=_i-1}] do
				{
					private _pointPositionASL = (_path select (_i-1));
					private _priorPointPositionASL = (_path select _i);
					private _distanceBetweenPathPositions = (_pointPositionASL distance _priorPointPositionASL);
					_distanceSeen = _distanceSeen - _distanceBetweenPathPositions;
					if(_distanceSeen <= _distanceFromFront || _i == 1) then {
						_lastPathIndex = _i-1;
						_lastPathDistance = _distanceSeen;
						_distanceFromFront = _distanceFromFront - _distanceSeen;
						_positionAndDirectionOnPath = CALC_POS_AND_DIR_FROM_START(_pointPositionASL, _priorPointPositionASL, _distanceFromFront);
						_i = 0;
					};
				};
			};
		} else {
			if(_lastPathIndex == _lastPathCount - 1) then {
				private _pointPositionASL = (_path select _lastPathCount-2);
				private _priorPointPositionASL = (_path select _lastPathCount-1);
				private _distanceBetweenPathPositions = (_pointPositionASL distance _priorPointPositionASL);
				_distanceFromFront = (_distanceFromFront - _lastPathDistance) + _distanceBetweenPathPositions;
				_positionAndDirectionOnPath = CALC_POS_AND_DIR_FROM_START(_pointPositionASL, _priorPointPositionASL, _distanceFromFront);	
			} else {
				private _distanceSeen = _lastPathDistance;
				for [{_i=_lastPathIndex+1}, {_i < _lastPathCount}, {_i=_i+1}] do
				{
					private _pointPositionASL = (_path select (_i-1));
					private _priorPointPositionASL = (_path select _i);
					private _distanceBetweenPathPositions = (_pointPositionASL distance _priorPointPositionASL);
					_distanceSeen = _distanceSeen + _distanceBetweenPathPositions;
					if(_distanceSeen >= _distanceFromFront || _i == _lastPathCount - 1) then {
						_lastPathIndex = _i-1;
						_lastPathDistance = _distanceSeen - _distanceBetweenPathPositions;
						_distanceFromFront = _distanceFromFront - (_distanceSeen - _distanceBetweenPathPositions);
						_positionAndDirectionOnPath = CALC_POS_AND_DIR_FROM_START(_pointPositionASL, _priorPointPositionASL, _distanceFromFront);
						_i = _lastPathCount;
					};
				};	
			};
		};
	} else {
		if( _distanceFromFront < _lastPathDistance ) then {		
			if(_lastPathIndex == _lastPathCount - 1) then {
				private _pointPositionASL = (_path select _lastPathCount-1);
				private _priorPointPositionASL = (_path select _lastPathCount-2);
				_positionAndDirectionOnPath = CALC_POS_AND_DIR_FROM_START(_pointPositionASL, _priorPointPositionASL, _distanceFromFront);	
			} else {			
				private _distanceSeen = _lastPathDistance;
				for [{_i=_lastPathIndex+1}, {_i < _lastPathCount}, {_i=_i+1}] do
				{
					private _pointPositionASL = (_path select _i);
					private _priorPointPositionASL = (_path select (_i-1));
					private _distanceBetweenPathPositions = (_pointPositionASL distance _priorPointPositionASL);
					_distanceSeen = _distanceSeen - _distanceBetweenPathPositions;
					if(_distanceSeen <= _distanceFromFront || _i == _lastPathCount - 1) then {
						_lastPathIndex = _i;
						_lastPathDistance = _distanceSeen;
						_distanceFromFront = _distanceFromFront - _distanceSeen;
						_positionAndDirectionOnPath = CALC_POS_AND_DIR_FROM_START(_pointPositionASL, _priorPointPositionASL, _distanceFromFront);
						_i = _lastPathCount;
					};
				};	
			};
		} else {
			if(_lastPathIndex == 0) then {
				private _pointPositionASL = (_path select 1);
				private _priorPointPositionASL = (_path select 2);
				private _distanceBetweenPathPositions = (_pointPositionASL distance _priorPointPositionASL);
				_distanceFromFront = (_distanceFromFront - _lastPathDistance) + _distanceBetweenPathPositions;
				_positionAndDirectionOnPath = CALC_POS_AND_DIR_FROM_START(_pointPositionASL, _priorPointPositionASL, _distanceFromFront);		
			} else {
				private _distanceSeen = _lastPathDistance;
				for [{_i=_lastPathIndex}, {_i > 0}, {_i=_i-1}] do
				{
					private _pointPositionASL = (_path select _i);
					private _priorPointPositionASL = (_path select (_i-1));
					private _distanceBetweenPathPositions = (_pointPositionASL distance _priorPointPositionASL);
					_distanceSeen = _distanceSeen + _distanceBetweenPathPositions;
					if(_distanceSeen >= _distanceFromFront || _i == 1) then {
						_lastPathIndex = _i;
						_lastPathDistance = _distanceSeen - _distanceBetweenPathPositions;
						_distanceFromFront = _distanceFromFront - (_distanceSeen - _distanceBetweenPathPositions);
						_positionAndDirectionOnPath = CALC_POS_AND_DIR_FROM_START(_pointPositionASL, _priorPointPositionASL, _distanceFromFront);
						_i = 0;
					};
				};	
			};
		};
	};

} else {
	
	// Cannot use position cache data since path has changed
	
	private _pointCount = count _path;
	private _distanceSeen = 0;
	private _priorPoint = [];
	if(_frontIsFirstElement) then {
		for [{_i=1}, {_i < _pointCount}, {_i=_i+1}] do
		{
			private _pointPositionASL = (_path select (_i-1));
			private _priorPointPositionASL = (_path select _i);
			private _distanceBetweenPathPositions = (_pointPositionASL distance _priorPointPositionASL);
			_distanceSeen = _distanceSeen + _distanceBetweenPathPositions;
			if(_distanceSeen >= _distanceFromFront || _i == _pointCount - 1) then {
				_lastPathIndex = _i-1;
				_lastPathDistance = _distanceSeen - _distanceBetweenPathPositions;			
				_distanceFromFront = _distanceFromFront - (_distanceSeen - _distanceBetweenPathPositions);
				_positionAndDirectionOnPath = CALC_POS_AND_DIR_FROM_START(_pointPositionASL, _priorPointPositionASL, _distanceFromFront);
				_i = _pointCount;
			};
		};	
	} else {
		for [{_i=_pointCount-1}, {_i > 0}, {_i=_i-1}] do
		{
			private _pointPositionASL = (_path select _i);
			private _priorPointPositionASL = (_path select (_i-1));
			private _distanceBetweenPathPositions = (_pointPositionASL distance _priorPointPositionASL);
			_distanceSeen = _distanceSeen + _distanceBetweenPathPositions;
			if(_distanceSeen >= _distanceFromFront || _i == 1) then {
				_lastPathIndex = _i;
				_lastPathDistance = _distanceSeen - _distanceBetweenPathPositions;
				_distanceFromFront = _distanceFromFront - (_distanceSeen - _distanceBetweenPathPositions);
				_positionAndDirectionOnPath = CALC_POS_AND_DIR_FROM_START(_pointPositionASL, _priorPointPositionASL, _distanceFromFront);
				_i = 0;
			};
		};	
	};
	
	_lastPathCount = _pointCount;
	
};

// Cache position data to speed up the next lookup

if(isNull _objectBeingPositioned) then {
	missionNamespace setVariable ["ATRAIN_Position_Cache_Path_id",_pathId];
	missionNamespace setVariable ["ATRAIN_Position_Cache_Path_Index",_lastPathIndex];
	missionNamespace setVariable ["ATRAIN_Position_Cache_Path_Distance",_lastPathDistance];
	missionNamespace setVariable ["ATRAIN_Position_Cache_Path_Count",_lastPathCount];
} else {
	_objectBeingPositioned setVariable ["ATRAIN_Position_Cache_Path_id",_pathId];
	_objectBeingPositioned setVariable ["ATRAIN_Position_Cache_Path_Index",_lastPathIndex];
	_objectBeingPositioned setVariable ["ATRAIN_Position_Cache_Path_Distance",_lastPathDistance];
	_objectBeingPositioned setVariable ["ATRAIN_Position_Cache_Path_Count",_lastPathCount];
};

_positionAndDirectionOnPath;
