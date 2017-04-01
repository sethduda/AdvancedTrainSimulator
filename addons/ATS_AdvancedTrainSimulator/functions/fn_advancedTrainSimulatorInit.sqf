/*
The MIT License (MIT)

Copyright (c) 2017 Seth Duda

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/


#define ATRAIN_FNC_CAMERA_DISTANCE (missionNamespace getVariable ["ATRAIN_3rd_Person_Camera_Distance",8])
#define ATRAIN_FNC_CAMERA (missionNamespace getVariable ["ATRAIN_3rd_Person_Camera",objNull])
#define ATRAIN_FNC_CAMERA_TARGET (missionNamespace getVariable ["ATRAIN_3rd_Person_Camera_Target",objNull])
#define ATRAIN_FNC_CAMERA_X_TOTAL (missionNamespace getVariable ["ATRAIN_3rd_Person_Camera_X_Move_Total",-90])
#define ATRAIN_FNC_CAMERA_Y_TOTAL (missionNamespace getVariable ["ATRAIN_3rd_Person_Camera_Y_Move_Total",60])
#define ATRAIN_FNC_CAMERA_Y_TOTAL_PRIOR (missionNamespace getVariable ["ATRAIN_3rd_Person_Camera_Y_Move_Total_Prior",ATRAIN_FNC_CAMERA_Y_TOTAL])
#define ATRAIN_FNC_CAMERA_REL_POSITION [ATRAIN_FNC_CAMERA_DISTANCE * (cos ATRAIN_FNC_CAMERA_X_TOTAL) * (sin ATRAIN_FNC_CAMERA_Y_TOTAL), ATRAIN_FNC_CAMERA_DISTANCE * (sin ATRAIN_FNC_CAMERA_X_TOTAL) * (sin ATRAIN_FNC_CAMERA_Y_TOTAL), ATRAIN_FNC_CAMERA_DISTANCE * (cos ATRAIN_FNC_CAMERA_Y_TOTAL)]

#define ATRAIN_MAP_CONTROL (findDisplay 12 displayCtrl 51)
#define ATRAIN_MAP_DISPLAY (findDisplay 12)
#define ATRAIN_MAIN_DISPLAY (findDisplay 46)


#define PROFILE_START(METHOD_NAME) 
#define PROFILE_STOP
#define PROFILE_START2(METHOD_NAME) [METHOD_NAME,diag_tickTime] call ATRAIN_fnc_profileMethodStart
#define PROFILE_STOP2 [diag_tickTime] call ATRAIN_fnc_profileMethodStop

if (!isServer) exitWith {};

ATRAIN_Advanced_Train_Simulator_Install = {

if(!isNil "ATRAIN_INIT") exitWith {};
ATRAIN_INIT = true;

diag_log "Advanced Train Simulator (ATS) 1.1 Loading...";

ATRAIN_fnc_cameraUpdatePosition = {
	private _cam = ATRAIN_FNC_CAMERA;
	if(!isNil "_cam") then {

		private _targetObject = vehicle ATRAIN_FNC_CAMERA_TARGET;
		private _targetPosition = getPosASLVisual _targetObject;
		private _bbr = boundingBoxReal _targetObject;
		private _p1 = _bbr select 0;
		private _p2 = _bbr select 1;
		private _maxHeight = abs ((_p2 select 2) - (_p1 select 2));
		_targetPosition = _targetPosition vectorAdd [0,0,_maxHeight * 0.5];
		private _cameraPosition = ATRAIN_FNC_CAMERA_REL_POSITION vectorAdd _targetPosition;
		if((ASLToATL _cameraPosition) select 2 < 0) then {
			ATRAIN_3rd_Person_Camera_Y_Move_Total = ATRAIN_FNC_CAMERA_Y_TOTAL min ATRAIN_FNC_CAMERA_Y_TOTAL_PRIOR;
			_cameraPosition = ATRAIN_FNC_CAMERA_REL_POSITION vectorAdd _targetPosition;
		};
		private _lookVector = _cameraPosition vectorFromTo _targetPosition;
		private _cameraUpVector = (_lookVector vectorCrossProduct [0,0,1]) vectorCrossProduct _lookVector;
		_cam setPosASL _cameraPosition;
		_cam setVectorDirAndUp [_lookVector,_cameraUpVector];
		ATRAIN_3rd_Person_Camera_Y_Move_Total_Prior = ATRAIN_FNC_CAMERA_Y_TOTAL;
		ATRAIN_3rd_Person_Camera_Last_Position = _cameraPosition;
	};
};

ATRAIN_fnc_cameraMouseMoveHandler = {
	private ["_cam","_distance","_target"];
	ATRAIN_3rd_Person_Camera_X_Move_Total = ATRAIN_FNC_CAMERA_X_TOTAL + (-(_this select 1)*0.2);
	ATRAIN_3rd_Person_Camera_Y_Move_Total = ATRAIN_FNC_CAMERA_Y_TOTAL + (-(_this select 2)*0.2);
	ATRAIN_3rd_Person_Camera_Y_Move_Total = ATRAIN_FNC_CAMERA_Y_TOTAL max 20 min 160;
};

ATRAIN_fnc_disable3rdPersonCamera = {
	if(!isNull ATRAIN_FNC_CAMERA) then {
		
		removeMissionEventHandler ["EachFrame", ATRAIN_3rd_Person_Camera_Frame_Handler];
		["MAIN_DISPLAY","MouseMoving", ATRAIN_Mouse_Move_Handler] call ATRAIN_fnc_removeEventHandler;
		["MAIN_DISPLAY","MouseZChanged", ATRAIN_Mouse_Zoom_Handler] call ATRAIN_fnc_removeEventHandler;
		["MAIN_DISPLAY","KeyDown", ATRAIN_3rd_Person_Camera_Map_Handler1] call ATRAIN_fnc_removeEventHandler;
		["MAIN_DISPLAY","MouseButtonDown", ATRAIN_3rd_Person_Camera_Map_Handler2] call ATRAIN_fnc_removeEventHandler;
		
		ATRAIN_FNC_CAMERA cameraEffect ["Terminate", "Back"];
		camDestroy ATRAIN_FNC_CAMERA;
		
		missionNamespace setVariable ["ATRAIN_3rd_Person_Camera_Distance",nil];
		missionNamespace setVariable ["ATRAIN_3rd_Person_Camera",nil];
		missionNamespace setVariable ["ATRAIN_3rd_Person_Camera_X_Move_Total",nil];
		missionNamespace setVariable ["ATRAIN_3rd_Person_Camera_Y_Move_Total",nil];
		missionNamespace setVariable ["ATRAIN_3rd_Person_Camera_Y_Move_Total_Prior",nil];
		missionNamespace setVariable ["ATRAIN_3rd_Person_Camera_Last_Position",nil];
		missionNamespace setVariable ["ATRAIN_3rd_Person_Camera_Frame_Handler",nil];
		missionNamespace setVariable ["ATRAIN_Mouse_Move_Handler",nil];
		missionNamespace setVariable ["ATRAIN_Mouse_Zoom_Handler",nil];
		missionNamespace setVariable ["ATRAIN_3rd_Person_Camera_Map_Handler1",nil];
		missionNamespace setVariable ["ATRAIN_3rd_Person_Camera_Map_Handler2",nil];

	};
};

ATRAIN_fnc_enable3rdPersonCamera = {
	_this spawn {
		params ["_object",["_followDirection",false]];
		waitUntil {time > 0};
		showCinemaBorder false;
		ATRAIN_3rd_Person_Camera_Target = _object;
		ATRAIN_3rd_Person_Camera = "camera" camCreate (_object modelToWorld [0,0,0]); 
		ATRAIN_3rd_Person_Camera cameraEffect ["internal", "BACK"];
		ATRAIN_Mouse_Move_Handler = ["MAIN_DISPLAY","MouseMoving", "_this call ATRAIN_fnc_cameraMouseMoveHandler"] call ATRAIN_fnc_addEventHandler;
		ATRAIN_Mouse_Zoom_Handler = ["MAIN_DISPLAY","MouseZChanged", "_this call ATRAIN_fnc_cameraMouseZoomHandler"] call ATRAIN_fnc_addEventHandler;
		ATRAIN_3rd_Person_Camera_Frame_Handler = addMissionEventHandler ["EachFrame", {[] call ATRAIN_fnc_cameraUpdatePosition; false}];
		
		ATRAIN_fnc_remoteCameraMapHandler = {
			if(visibleMap) exitWith {};
			private ["_event","_eventParams","_actionKeys"];
			_event = param [0];
			_eventParams = param [1];
			_actionKeys = actionKeys "ShowMap";
			if(_event == "KeyDown" || _event == "MouseButtonDown") then {
				if( (_eventParams select 1) in _actionKeys || (65536 + (_eventParams select 1)) in _actionKeys ) then {
					[] spawn {
						ATRAIN_FNC_CAMERA cameraEffect ["Terminate", "Back"];
						openMap true;
						waitUntil {!visibleMap};
						if(!isNil "ATRAIN_3rd_Person_Camera") then {
							ATRAIN_3rd_Person_Camera cameraEffect ["internal", "BACK"];
						};
					};
				};
			};
			
		};	

		ATRAIN_3rd_Person_Camera_Map_Handler1 = ["MAIN_DISPLAY","KeyDown", "[""KeyDown"",_this] call ATRAIN_fnc_remoteCameraMapHandler"] call ATRAIN_fnc_addEventHandler;
		ATRAIN_3rd_Person_Camera_Map_Handler2 = ["MAIN_DISPLAY","MouseButtonDown", "[""MouseButtonDown"",_this] call ATRAIN_fnc_remoteCameraMapHandler"] call ATRAIN_fnc_addEventHandler;

		waitUntil {isNull ATRAIN_FNC_CAMERA || isNull _object};
		[] call ATRAIN_fnc_disable3rdPersonCamera;
	};
};

ATRAIN_fnc_cameraMouseZoomHandler = {
	private ["_mouseZoom","_distance"];
	_mouseZoom = (_this select 1);
	if(_mouseZoom > 0) then {
		_mouseZoom = 1;
	} else {
		_mouseZoom = -1;
	};
	_distance =	ATRAIN_FNC_CAMERA_DISTANCE;
	ATRAIN_3rd_Person_Camera_Distance = (_distance - _mouseZoom) max 3 min 60;
};

ATRAIN_fnc_addEventHandler = {
	params ["_handlerType","_eventType","_eventScript"];

	waitUntil {!isNull ATRAIN_MAP_CONTROL && !isNull ATRAIN_MAIN_DISPLAY && !isNull ATRAIN_MAP_DISPLAY};

	private _allEventHandlers = uiNamespace getVariable ["ATRAIN_All_Event_Handlers",[]];
	
	private _eventId = -1;
	if(_handlerType == "MAIN_DISPLAY") then {
		_eventId = ATRAIN_MAIN_DISPLAY displayAddEventHandler [_eventType, _eventScript + "; false"];
	};
	if(_handlerType == "MAP_DISPLAY") then {
		_eventId = ATRAIN_MAP_DISPLAY displayAddEventHandler [_eventType, _eventScript+ "; false"];
	};
	if(_handlerType == "MAP_CONTROL") then {
		_eventId = ATRAIN_MAP_CONTROL ctrlAddEventHandler [_eventType, _eventScript+ "; false"];
	};
	
	_allEventHandlers pushBack [_handlerType, _eventType, _eventId];
	uiNamespace setVariable ["ATRAIN_All_Event_Handlers",_allEventHandlers];
	
	_eventId;
};

ATRAIN_fnc_removeEventHandler = {
	params ["_handlerType","_eventType","_eventHandlerId"];

	waitUntil {!isNull ATRAIN_MAP_CONTROL && !isNull ATRAIN_MAIN_DISPLAY && !isNull ATRAIN_MAP_DISPLAY};

	if(_eventHandlerId >= 0) then {
		if(_handlerType == "MAIN_DISPLAY") then {
			ATRAIN_MAIN_DISPLAY displayRemoveEventHandler [_eventType, _eventHandlerId];
		};
		if(_handlerType == "MAP_DISPLAY") then {
			ATRAIN_MAP_DISPLAY displayRemoveEventHandler [_eventType, _eventHandlerId];
		};
		if(_handlerType == "MAP_CONTROL") then {
			ATRAIN_MAP_CONTROL ctrlRemoveEventHandler [_eventType, _eventHandlerId];
		};
		
		private _allEventHandlers = uiNamespace getVariable ["ATRAIN_All_Event_Handlers",[]];
		private _newAllEventHandlers = [];
		{
			if( _x select 0 != _handlerType || _x select 1 !=  _eventType || _x select 2 != _eventHandlerId ) then {
				_newAllEventHandlers pushBack _x;
			};
		} forEach _allEventHandlers;
		uiNamespace setVariable ["ATRAIN_All_Event_Handlers",_newAllEventHandlers];
		
	};
};

ATRAIN_fnc_removeAllEventHandlers = {
	private _allEventHandlers = uiNamespace getVariable ["ATRAIN_All_Event_Handlers",[]];
	{
		_x call ATRAIN_fnc_removeEventHandler;
	} forEach _allEventHandlers;
};

if(hasInterface) then {
	// Remove all existing event handlers on script start
	[] call ATRAIN_fnc_removeAllEventHandlers;
};

ATRAIN_fnc_getTracksAtPosition = {
	PROFILE_START("ATRAIN_fnc_getTracksAtPosition");
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
				//[_positionASL] call CREATE_MARKER;
				_foundTracks pushBack _object;
				_didFindTracks = true;
			};
		};
	} forEach _objects;
	PROFILE_STOP;
	_foundTracks;
};

ATRAIN_fnc_getTrainAtPosition = {
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
};

// [Class Name, Center Point Offset, Is Split Track, Is End Track,Memory Point Height Offset]
ATRAIN_Track_Definitions = [ 
 ["Land_Track_01_3m_F",0,false,false], 
 ["Land_Track_01_7deg_F",0.15,false,false], 
 ["Land_Track_01_10m_F",0,false,false], 
 ["Land_Track_01_15deg_F",0.3,false,false], 
 ["Land_Track_01_20m_F",0,false,false], 
 ["Land_Track_01_30deg_F",0.6,false,false], 
 ["Land_Track_01_bridge_F",0,false,false], 
 ["Land_Track_01_bumper_F",0,false,true], 
 ["Land_Track_01_turnout_left_F",0.55,true,false], 
 ["Land_Track_01_turnout_right_F",-0.55,true,false],
 ["Land_straight40",0,false,false,0.06],
 ["Land_straight25",0,false,false,0.06],
 ["Land_left_turn",1,true,false,0.06],
 ["Land_right_turn",-1,true,false,0.06],
 ["Land_curveL25",0.3,false,false,0.06],
 ["Land_Bridge",0,false,false,0.06],
 ["Land_terminator_concrete",0,false,true,0.06],
 ["Land_straight_down40",0,false,false,0.06]
];

// [Class Name, Is Drivable, Is Rideable, Length In Meters, Model Position Offset, Animate Train ]
ATRAIN_Train_Definitions = [
	["Land_Locomotive_01_v1_F", true, false, 5.3, 12, [0,0,0.052],true],
	["Land_Locomotive_01_v2_F", true, false, 5.3, 12, [0,0,0.052],true],
	["Land_Locomotive_01_v3_F", true, false, 5.3, 12, [0,0,0.052],true],
	["Land_RailwayCar_01_passenger_F", false, true, 5.5, 12, [0,0,0.06],true],
	["Land_RailwayCar_01_sugarcane_empty_F", false, true, 3.2, 12, [0,0,0.052],true],
	["Land_RailwayCar_01_sugarcane_F", false, true, 3.2, 12, [0,0,0.052],true],
	["Land_RailwayCar_01_tank_F", false, true, 5.5, 12, [0,0,0.08],true],
	["Land_loco_742_blue", true, false, 13.5, 19.4, [0,0.05,-0.14],false],
	["Land_loco_742_red", true, false, 13.5, 19.4, [0,0.05,-0.14],false],
	["Land_wagon_box", false, true, 12, 19.4, [0,-0.43,0.02],false],
	["Land_wagon_flat", false, true, 17.1, 19.4, [0,-0.02,0.04],false],
	["Land_wagon_tanker", false, true, 11.5, 19.4, [0,-0.05,0.02],false],
	["Land_blue_loco", true, false, 13.5, 19.4,  [0,0.05,-0.14],false],
	["Land_red_loco", true, false, 13.5, 19.4,  [0,0.05,-0.14],false]
];

ATRAIN_Object_Model_To_Type_Map = [
	["track_01_3m_f.p3d","Land_Track_01_3m_F"],
	["track_01_7deg_f.p3d","Land_Track_01_7deg_F"],
	["track_01_10m_f.p3d","Land_Track_01_10m_F"],
	["track_01_15deg_f.p3d","Land_Track_01_15deg_F"],
	["track_01_20m_f.p3d","Land_Track_01_20m_F"],
	["track_01_30deg_f.p3d","Land_Track_01_30deg_F"],
	["track_01_bridge_f.p3d","Land_Track_01_bridge_F"],
	["track_01_bumper_f.p3d","Land_Track_01_bumper_F"],
	["track_01_turnout_left_f.p3d","Land_Track_01_turnout_left_F"],
	["track_01_turnout_right_f.p3d","Land_Track_01_turnout_right_F"],
	["locomotive_01_v1_f.p3d","Land_Locomotive_01_v1_F"],
	["locomotive_01_v2_f.p3d","Land_Locomotive_01_v2_F"],
	["locomotive_01_v3_f.p3d","Land_Locomotive_01_v3_F"],
	["railwaycar_01_passenger_f.p3d","Land_RailwayCar_01_passenger_F"],
	["railwaycar_01_sugarcane_empty_f.p3d","Land_RailwayCar_01_sugarcane_empty_F"],
	["railwaycar_01_sugarcane_f.p3d","Land_RailwayCar_01_sugarcane_F"],
	["railwaycar_01_tank_f.p3d","Land_RailwayCar_01_tank_F"]
];

// Returns [Class Name, Is Static]
ATRAIN_fnc_getTypeOf = {
	PROFILE_START("ATRAIN_fnc_getTypeOf");
	params ["_object"];
	private _typeOfArray = [typeOf _object,false];
	if( (_typeOfArray select 0) != "" ) exitWith { PROFILE_STOP; _typeOfArray };
	private _objectString = str _object;
	{
		if( (_objectString find (_x select 0)) > 0 ) exitWith {
			_typeOfArray = [_x select 1,true];
		};
	} forEach ATRAIN_Object_Model_To_Type_Map;
	PROFILE_STOP;
	_typeOfArray;
};

ATRAIN_fnc_getTrackDefinition = {
	PROFILE_START("ATRAIN_fnc_getTrackDefinition");
	params ["_track"];
	private _trackDef = [];
	private _trackType = [_track] call ATRAIN_fnc_getTypeOf;
	{
		if((_trackType select 0) == (_x select 0)) exitWith {
			_trackDef = _x;
		};
	} forEach ATRAIN_Track_Definitions;
	PROFILE_STOP;
	_trackDef;
};

ATRAIN_fnc_getTrainDefinition = {
	PROFILE_START("ATRAIN_fnc_getTrainDefinition");
	params ["_train"];
	private _trainDef = [];
	private _trainType = [_train] call ATRAIN_fnc_getTypeOf;
	{
		if((_trainType select 0) == (_x select 0)) exitWith {
			_trainDef = _x;
		};
	} forEach ATRAIN_Train_Definitions;
	PROFILE_STOP;
	_trainDef;
};

ATRAIN_fnc_addWorldPaths = {
	PROFILE_START("ATRAIN_fnc_addWorldPaths");

	params ["_path", "_addPath",["_replaceOverlapWithAddedPath",false]];
	
	if(count _addPath < 2) exitWith { PROFILE_STOP; 0; };
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
		PROFILE_STOP;
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
	PROFILE_STOP;

	_distanceAddedToPath;
};

ATRAIN_Method_Stack = [];

ATRAIN_Profiles = [];

ATRAIN_fnc_profileMethodStart = {
	params ["_methodName",["_time",diag_tickTime]];
	ATRAIN_Method_Stack pushBack [_methodName,_time];
	//////diag_log (str "Start " + _methodName + ": " + str ATRAIN_Method_Stack);
	([_methodName] call ATRAIN_fnc_getProfile) params ["_profileIndex","_profile"];
	if(_profileIndex == -1) then {
		ATRAIN_Profiles pushBack [_methodName,0,0,0];
	};	
};

ATRAIN_fnc_profileMethodStop = {
	params [["_time",diag_tickTime]];
	private _stackElement = ATRAIN_Method_Stack deleteAt ((count ATRAIN_Method_Stack) - 1);
	_stackElement params ["_methodName","_startTime"];
	([_methodName] call ATRAIN_fnc_getProfile) params ["_profileIndex","_profile"];
	private _totalTime = (_time - _startTime);
	_profile params ["_pName","_pCount","_pTotal","_pSelf"];
	_profile set [1,_pCount + 1];
	_profile set [2,_pTotal + _totalTime];
	_profile set [3,_pSelf + _totalTime];
	ATRAIN_Profiles set [_profileIndex,_profile];
	if(count ATRAIN_Method_Stack > 0) then {
		private _caller = ATRAIN_Method_Stack select ((count ATRAIN_Method_Stack) - 1);
		_caller params ["_callerMethodName","_callerStartTime"];
		([_callerMethodName] call ATRAIN_fnc_getProfile) params ["_callerProfileIndex","_callerProfile"];
		_callerProfile params ["_cName","_cCount","_cTotal","_cSelf"];
		_callerProfile set [3,_cSelf - _totalTime];
		ATRAIN_Profiles set [_callerProfileIndex,_callerProfile];
	};
};

ATRAIN_fnc_getProfile = {
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
};

ATRAIN_fnc_printProfiles = {
	{
		////diag_log str _x;
	} forEach ATRAIN_Profiles;
};

#define CALC_POS_AND_DIR_FROM_START(trackStartASL, trackEndASL, distanceFromStart) [(trackStartASL vectorAdd ( ( trackStartASL vectorFromTo trackEndASL ) vectorMultiply distanceFromStart)), trackEndASL vectorFromTo trackStartASL]

//ATRAIN_fnc_getPositionAndDirectionOnPath = {
ATRAIN_fnc_getPositionAndDirectionOnPath = {
	PROFILE_START("ATRAIN_fnc_getPositionAndDirectionOnPath");
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
	
	PROFILE_STOP;
	_positionAndDirectionOnPath;
};

ATRAIN_fnc_findAlignedTrackWorldPath = {
	PROFILE_START("ATRAIN_fnc_findAlignedTrackWorldPath");
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
	PROFILE_STOP;
	_bestTrackWorldPath;
};

ATRAIN_COUNT = 0;
ATRAIN_TIME = 0;

ATRAIN_fnc_findConnectedTrackNodes = {
	params ["_track",["_sourceConnection",[]]];
	private _trackWorldPaths = [_track] call ATRAIN_fnc_getTrackWorldPaths;
	private _connectedTrackNodes = [];
	{
		private _trackWorldPath = _x;
		private _pathToNode = [];
		reverse _trackWorldPath;
		private _trackDistance = [_pathToNode, _trackWorldPath] call ATRAIN_fnc_addWorldPaths;
		private _pathToNodeCount = count _pathToNode;
		private _lastPathPosASL = _pathToNode select (_pathToNodeCount-1);
		private _secondToLastPathPosASL = _pathToNode select (_pathToNodeCount-2);
		private _trackDir =  _secondToLastPathPosASL vectorFromTo _lastPathPosASL;
		private _tracksInPath = [[_track,_trackDir]];
		private _distanceFromFront = 0;
		private _lastSeenTrack = _track;
		private _trackNodeFound = false;
		private _trackNode = objNull;
		private _sourceConnectionUsed = false;
		private _lastCameraPreloadLocation = [0,0,0];
		
		// Check to see if the path is heading back in the direction of the path we just followed
		// If it is, use the source connection path instead of retracing the steps back
		if(count _sourceConnection > 0) then {
			private _sourceConnectionPath = _sourceConnection select 1;
			private _sourceConnectionPathSecondPosition = _sourceConnectionPath select 1;
			private _currentPathSecondPosition = _pathToNode select 1;	
			if( _sourceConnectionPathSecondPosition distance _currentPathSecondPosition == 0) then {
				_connectedTrackNodes pushBack _sourceConnection;
				_sourceConnectionUsed = true;
			};
		};
		
		private _priorPositionOnPath = ([_pathToNode,_distanceFromFront + 2] call ATRAIN_fnc_getPositionAndDirectionOnPath) select 0;
		
		while {true && !_sourceConnectionUsed} do {
		
			private _positionOnPath = ([_pathToNode,_distanceFromFront] call ATRAIN_fnc_getPositionAndDirectionOnPath) select 0;
			private _directionOnPath = _priorPositionOnPath vectorFromTo _positionOnPath;
			private _tracksAtPosition = [_positionOnPath,_lastSeenTrack,_directionOnPath] call ATRAIN_fnc_getTracksAtPosition;
			_priorPositionOnPath = _positionOnPath;
			
			if(missionNamespace getVariable ["ATRAIN_Track_Debug_Enabled",false]) then {
				_arrow = "Sign_Arrow_F" createVehicle [0,0,0];
				_arrow setPosASL _positionOnPath; 	
			};

			scopeName "ATRAIN_fnc_findConnectedTrackNodes_0";
			{				
				if(_x != _lastSeenTrack) then {	
					private _trackDef = [_x] call ATRAIN_fnc_getTrackDefinition;
					_trackDef params ["_className","_modelPaths","_isSplitTrack","_isEndTrack"];
					private _trackWorldPath = ([_x] call ATRAIN_fnc_getTrackWorldPaths) select 0;
					if(_isSplitTrack || _isEndTrack) then {
						_trackWorldPath = [_x,_directionOnPath] call ATRAIN_fnc_findAlignedTrackWorldPath;
					};
					_lastTrackSeen = _x;
					if(_isSplitTrack || _isEndTrack) then {
						private _distanceAdded = [_pathToNode, _trackWorldPath, true] call ATRAIN_fnc_addWorldPaths;
						private _pathToNodeCount = count _pathToNode;
						private _lastPathPosASL = _pathToNode select (_pathToNodeCount-1);
						private _secondToLastPathPosASL = _pathToNode select (_pathToNodeCount-2);
						private _trackDir = _secondToLastPathPosASL vectorFromTo _lastPathPosASL;
						_tracksInPath pushBack [_x,_trackDir];
						_trackDistance = _trackDistance + _distanceAdded;
						_distanceFromFront = _distanceFromFront + _distanceAdded;
						_trackNodeFound = true;
						_trackNode = _x;		
						breakTo  "ATRAIN_fnc_findConnectedTrackNodes_0";
					};
					if(_x == _track) then {
						// Prevents endless track loops
						_trackNodeFound = false;
						_trackNode = objNull;
						breakTo  "ATRAIN_fnc_findConnectedTrackNodes_0";
					};
					private _distanceAdded = [_pathToNode, _trackWorldPath, false] call ATRAIN_fnc_addWorldPaths;
					private _pathToNodeCount = count _pathToNode;
					private _lastPathPosASL = _pathToNode select (_pathToNodeCount-1);
					private _secondToLastPathPosASL = _pathToNode select (_pathToNodeCount-2);
					private _trackDir = _secondToLastPathPosASL vectorFromTo _lastPathPosASL;
					_tracksInPath pushBack [_x,_trackDir];
					_trackDistance = _trackDistance + _distanceAdded;
					_distanceFromFront = _distanceFromFront + _distanceAdded;
					_lastSeenTrack = _x;
				};
			} forEach _tracksAtPosition;
		
			// Force objects to load on map as we search for tracks (does not work on dedicated server)
			if(count _tracksAtPosition == 0 && _distanceFromFront < -10) then {
				if(_lastCameraPreloadLocation distance _positionOnPath > 100 ) then {
					private _posAGL = [_positionOnPath select 0, _positionOnPath select 1, 0];
					{
						_posAGL nearObjects [_x select 0, 300];
					} forEach ATRAIN_Train_Definitions;
					_distanceFromFront = 0;
					_lastCameraPreloadLocation = _positionOnPath;
				};
			};
			
			// Track node found or no valid node found ( will search 10m beyond end of track )
			if(_trackNodeFound || _distanceFromFront < -10) exitWith {};

			if(_distanceFromFront > 0 && !(_lastSeenTrack in ATRAIN_TRACKS_NEAR_EDITOR_PLACED_CONNECTIONS)) then {
				_distanceFromFront = 0;
			} else {
				_distanceFromFront = _distanceFromFront - 1.1;
			};

		};	
		
		if(!isNull _trackNode) then {			
			_connectedTrackNodes pushBack [_trackNode,_pathToNode,_trackDistance,_tracksInPath];
		};
		
	} forEach _trackWorldPaths;
	_connectedTrackNodes;
};

ATRAIN_fnc_buildTrackMap = {
	PROFILE_START("ATRAIN_fnc_buildTrackMap");
	PROFILE_START2("ATRAIN_fnc_buildTrackMap");
	params ["_track"];
	private _startNodes = [_track] call ATRAIN_fnc_findConnectedTrackNodes;
	if(count _startNodes == 0) exitWith {PROFILE_STOP; []};
	private _firstStartNode = _startNodes select 0;
	private _firstStartNodeTrack = _firstStartNode select 0;
	private _nodesToProcess = [[_firstStartNodeTrack]];
	private _nodeMap = [];
	while { count _nodesToProcess > 0 } do {
		private _currentNodeToProcess = _nodesToProcess deleteAt 0;
		private _currentNodeTrack = _currentNodeToProcess select 0;
		private _nodeSeen = false;
		{
			if(_x select 0 == _currentNodeTrack) exitWith {
				_nodeSeen = true;
			};
		} forEach _nodeMap;
		if(!_nodeSeen) then {
			private _connectedNodes = _currentNodeToProcess call ATRAIN_fnc_findConnectedTrackNodes;
			_nodeMap pushBack [_currentNodeTrack,_connectedNodes];
			{
				private _connectedNodeTrack = _x select 0;
				private _reversePathCopy = ((_x select 1) + []);
				reverse _reversePathCopy;
				private _pathDistance = _x select 2;
				private _connectionTracks = [];
				{
					_connectionTracks pushBack [_x select 0, (_x select 1) vectorMultiply -1];
				} forEach (_x select 3);
				_nodesToProcess pushBack [_connectedNodeTrack,[_currentNodeTrack,_reversePathCopy,_pathDistance,_connectionTracks]];
				if(missionNamespace getVariable ["ATRAIN_Track_Debug_Enabled",false]) then {
					private _path = _x select 1;
					{
						[_x] call CREATE_MARKER;
					} forEach _path;
				};
			} forEach _connectedNodes;
		};
	};
	PROFILE_STOP;
	PROFILE_STOP2;
	_nodeMap;
};


CREATE_MARKER = {
	PROFILE_START("CREATE_MARKER");
	private ["_markerPosition","_markerColor","_markerName","_markerText"];
	if( isNil "createDotMarker_id" ) then {
		createDotMarker_id = 0;
	} else {		
		createDotMarker_id = createDotMarker_id + 1;
	};
	_markerPosition = [_this, 0] call BIS_fnc_param;
	_markerColor = [_this, 1, "Default"] call BIS_fnc_param;
	_markerText = [_this, 2, ""] call BIS_fnc_param;
	_markerName = format ["createDotMarker_%1", createDotMarker_id];
	_markerName = createMarker [_markerName,_markerPosition];
	_markerName setMarkerShape "ICON";
	_markerName setMarkerType "mil_dot";
	_markerName setMarkerColor _markerColor;
	_markerName setMarkerText _markerText;
		PROFILE_STOP;
	_markerName;
};

ARROWS = [];

/*
player addAction ["Test Track", {
	
	_timeStart2 = 0;
	_timeEnd2 = 0;
	_timeStart = diag_tickTime;
	{
		deleteVehicle _x;
	} forEach ARROWS;
	private _tracks = [getPosASL player,player] call ATRAIN_fnc_getTracksAtPosition;
	if(count _tracks > 0) then {
		private _track = _tracks select 0;

		_map = [_track] call ATRAIN_fnc_buildTrackMap;
		_totalDistance = 0;
		{
			private _node = _x;
			//diag_log str ["NODE",_x select 0];
			private _nodeConnections = _node select 1;
			{
				//diag_log str [_x select 0, _x select 2];
				private _connectionPath = _x select 1;
				private _connectionDistance = _x select 2;
				_totalDistance = _totalDistance + (_connectionDistance / 2);
				//{
				//	//diag_log _x;
				//} forEach _connectionPath;
			} forEach _nodeConnections;
		} forEach _map;
		hint ("DONE" + str _totalDistance); 

		private _nodes = [_track] call ATRAIN_fnc_findConnectedTrackNodes;
		
		{
			private _path = _x select 1;
			{
				_arrow = "Sign_Arrow_F" createVehicle [0,0,0];
				_arrow setPosASL _x;
				ARROWS pushBack _arrow;
			} forEach _path;
		} forEach _nodes;
	};
	//[] call ATRAIN_fnc_printProfiles;
	//_timeEnd = diag_tickTime;
	//hintSilent str [(_timeEnd - _timeStart),(_timeEnd2 - _timeStart2),ATRAIN_COUNT,ATRAIN_TIME];
}];
*/

ATRAIN_fnc_getTrackWorldPaths = {
	params ["_track"];
	private _trackDef = [_track] call ATRAIN_fnc_getTrackDefinition;
	if(count _trackDef == 0) exitWith {PROFILE_STOP; [];};
	_trackDef params ["_className","_centerOffset","_isIntersection","_isTermination",["_heightOffset",0]];
	private _map1 = _track selectionPosition "map1";
	_map1 = _map1 vectorAdd [0,0,_heightOffset];
	private _map2 = _track selectionPosition "map2";
	_map2 = _map2 vectorAdd [0,0,_heightOffset];
	private _map3 = _track selectionPosition "map3";
	_map3 = _map3 vectorAdd [0,0,_heightOffset];
	private _trackWorldPaths = [];

	if(!_isIntersection && !_isTermination) then {
		private _worldPath = [];
		_worldPath pushBack (AGLtoASL (_track modelToWorld (_map1)));
		if(_centerOffset != 0) then {
			private _pathMidpoint = _map1 vectorAdd ((_map2 vectorDiff _map1) vectorMultiply 0.5);
			_pathMidpoint = _pathMidpoint vectorAdd (((vectorUp _track) vectorCrossProduct (_map1 vectorFromTo _map2)) vectorMultiply _centerOffset);
			_worldPath pushBack (AGLtoASL (_track modelToWorld (_pathMidpoint)));
		};
		_worldPath pushBack (AGLtoASL (_track modelToWorld (_map2)));
		_trackWorldPaths pushBack _worldPath;
	};
	
	if(_isTermination) then {
		private _pathMidpoint = _map1 vectorAdd ((_map2 vectorDiff _map1) vectorMultiply 0.5);
		_trackWorldPaths pushBack [AGLtoASL (_track modelToWorld (_map1)), AGLtoASL (_track modelToWorld (_pathMidpoint))];
		_trackWorldPaths pushBack [AGLtoASL (_track modelToWorld (_map2)), AGLtoASL (_track modelToWorld (_pathMidpoint))];
	};
	
	if(_isIntersection) then {
		private _pathMidpoint = _map1 vectorAdd ((_map2 vectorDiff _map1) vectorMultiply 0.9);
		_trackWorldPaths pushBack [AGLtoASL (_track modelToWorld (_map1)), AGLtoASL (_track modelToWorld (_pathMidpoint))];
		_trackWorldPaths pushBack [AGLtoASL (_track modelToWorld (_map2)), AGLtoASL (_track modelToWorld (_pathMidpoint))];
		private _worldPath = [];
		_worldPath pushBack (AGLtoASL (_track modelToWorld (_map3)));
		private _pathMidpoint2 = _map3 vectorAdd ((_pathMidpoint vectorDiff _map3) vectorMultiply 0.5);
		_pathMidpoint2 = _pathMidpoint2 vectorAdd (((vectorUp _track) vectorCrossProduct (_map3 vectorFromTo _pathMidpoint)) vectorMultiply _centerOffset);
		_worldPath pushBack (AGLtoASL (_track modelToWorld (_pathMidpoint2)));
		_worldPath pushBack (AGLtoASL (_track modelToWorld (_pathMidpoint)));
		_trackWorldPaths pushBack _worldPath;
	};
	_trackWorldPaths;
};

ATRAIN_RemoteExec = {
	params ["_params","_functionName","_target",["_isCall",false]];
	if(!isNil "ExileClient_system_network_send") then {
		["AdvancedTrainSimulatorRemoteExecClient",[_params,_functionName,_target,_isCall]] call ExileClient_system_network_send;
	} else {
		if(_isCall) then {
			_params remoteExecCall [_functionName, _target];
		} else {
			_params remoteExec [_functionName, _target];
		};
	};
};

ATRAIN_RemoteExecServer = {
	params ["_params","_functionName",["_isCall",false]];
	if(!isNil "ExileClient_system_network_send") then {
		["AdvancedTrainSimulatorRemoteExecServer",[_params,_functionName,_isCall]] call ExileClient_system_network_send;
	} else {
		if(_isCall) then {
			_params remoteExecCall [_functionName, 2];
		} else {
			_params remoteExec [_functionName, 2];
		};
	};
};

ATRAIN_fnc_getTrackUnderTrain = {
	PROFILE_START("ATRAIN_fnc_getTrackUnderTrain");
	params ["_train"];
	private _trainPositionASL = getPosASLVisual _train;
	private _trainVectorDir = vectorDir _train;
	private _tracks = [_trainPositionASL,_train,_trainVectorDir] call ATRAIN_fnc_getTracksAtPosition;
	private _foundTrack = objNull;
	if(count _tracks > 0) then {
		_foundTrack = _tracks select 0;
	};
	PROFILE_STOP;
	_foundTrack;
};

ATRAIN_fnc_getTrainUnderPlayer = {
	params ["_player"];
	[getPosASLVisual _player,_player] call ATRAIN_fnc_getTrainAtPosition;
};

/*
[
	[Track, Track Vector Dir, Start Node Track, End Node Track],
	...
]
*/
if (isNil "ATRAIN_Track_Node_Lookup") then {
	ATRAIN_Track_Node_Lookup = [];
};

/*
[
	Track Object,
	...
]
*/
if (isNil "ATRAIN_Nodes") then {
	ATRAIN_Nodes = [];
};

/*
Map: [
	Node: [
		Connection: [
			Node Index, 
			Distance,
			Path: [   
 				Point: [Pos, Dir, Up], ...
			]
		],
		...
	],
	...
]
*/

if (isNil "ATRAIN_Map") then {
	ATRAIN_Map = [];
};

ATRAIN_fnc_getTrackMapConnection = {
	params ["_startNodeIndex","_connectionNodeIndex"];
	private _foundConnection = [];
	private _mapStartNode = ATRAIN_Map select _startNodeIndex;
	{
		if((_x select 0) == _connectionNodeIndex) exitWith { _foundConnection = _x };
	} forEach _mapStartNode;
	_foundConnection;
};

ATRAIN_fnc_lookupTrackMapPosition = {
	params ["_train"];
	private _track = [_train] call ATRAIN_fnc_getTrackUnderTrain;
	if(isNull _track) exitWith {[]};
	//diag_log str ["LOOKUP", _track];
	private _trackMapPosition = [];
	private _foundTrackLookup = [];
	scopeName "ATRAIN_fnc_lookupTrackMapPosition_0";
	{
		if(_x select 0 == _track) then {
			if( vectorDir _train vectorDotProduct (_x select 1) > 0 ) then {
				_foundTrackLookup = _x;
				breakTo "ATRAIN_fnc_lookupTrackMapPosition_0";
			};
		};
	} forEach ATRAIN_Track_Node_Lookup;
	
	////diag_log str ATRAIN_Track_Node_Lookup;
	
	if(count _foundTrackLookup > 0) then {
		_foundTrackLookup params ["_track","_direction","_startNodeIndex","_endNodeIndex"];
		private _connection = [_startNodeIndex, _endNodeIndex] call ATRAIN_fnc_getTrackMapConnection;
		private _connectionDistance = _connection select 1;
		private _connectionPath = _connection select 2;
		private _distanceFromStart = 0;
		private _foundDistanceFromStart = 0;
		private _lastPathPointPosASL = [];
		private _trianPositionASL = getPosASL _train;
		scopeName "ATRAIN_fnc_lookupTrackMapPosition_1";
		{
			private _currentPathPointPosASL = _x;
			if( count _lastPathPointPosASL > 0 ) then {
				private _positionDotProduct = (_trianPositionASL vectorFromTo _lastPathPointPosASL) vectorDotProduct (_trianPositionASL vectorFromTo _currentPathPointPosASL);
				if(_positionDotProduct <= 0) then {
					_foundDistanceFromStart = _distanceFromStart + (_lastPathPointPosASL distance _trianPositionASL);
					breakTo "ATRAIN_fnc_lookupTrackMapPosition_1";
				};
				_distanceFromStart = _distanceFromStart + (_lastPathPointPosASL distance _currentPathPointPosASL);
			};
			_lastPathPointPosASL = _currentPathPointPosASL;
		} forEach _connectionPath;	
		_trackMapPosition = [_startNodeIndex, _endNodeIndex, _foundDistanceFromStart, _connectionDistance];
	};
	// [Start Node Index, End Node Index, Distance From Start, Total Distance]
	_trackMapPosition;
};

ATRAIN_fnc_updateServerTrackMap = {
	params ["_trackMap"];
	private _trackMapUpdated = false;
	private _trackMapNodesToUpdate = [];
	{
		private _nodeTrack = _x select 0;
		if!(_nodeTrack in ATRAIN_Nodes) then {
			ATRAIN_Nodes pushBack _nodeTrack;	
			ATRAIN_Map pushBack [];
			_trackMapNodesToUpdate pushBack _x;
			_trackMapUpdated = true;
			//diag_log str _x;
		};
	} forEach _trackMap;
	
	{
		private _nodeTrack = _x select 0;
		private _nodeConnections = _x select 1;
		private _nodeIndex = ATRAIN_Nodes find _nodeTrack;	
		if(_nodeIndex >= 0) then {
			private _mapConnections = [];
			{
				private _connectionNodeTrack = _x select 0;
				private _connectionNodeIndex = ATRAIN_Nodes find _connectionNodeTrack;	
				private _connectionPath = _x select 1;
				private _connectionDistance = _x select 2;
				private _connectionTracks = _x select 3;
				if(_connectionNodeIndex >= 0) then {
					_mapConnections pushBack [_connectionNodeIndex, _connectionDistance, _connectionPath];
					{
						private _connectionTrackObj = _x select 0;
						private _connectionTrackDirection = _x select 1;
						ATRAIN_Track_Node_Lookup pushBack [_connectionTrackObj, _connectionTrackDirection, _connectionNodeIndex, _nodeIndex ];						
					} forEach _connectionTracks;
				};
			} forEach _nodeConnections;
			ATRAIN_Map set [_nodeIndex, _mapConnections];
		};
	} forEach _trackMapNodesToUpdate;
	if(_trackMapUpdated) then {
		publicVariable "ATRAIN_Map";
	};
	
	_trackMapUpdated;
};

ATRAIN_fnc_attachTrainToTrackMap = {
	params ["_train"];
	//diag_log "Attaching Train to Track Map";
	private _nodePath = _train getVariable ["ATRAIN_Local_Node_Path",[]];
	// Exit if train already attached to the track
	if(count _nodePath > 0) exitWith {true};
	private _localTrain = _train getVariable ["ATRAIN_Local_Copy",_train];
	private _trackMapPosition = [_localTrain] call ATRAIN_fnc_lookupTrackMapPosition;
	if(count _trackMapPosition == 0) exitWith { false };
	_trackMapPosition params ["_startNodeIndex","_endNodeIndex","_distanceFromStart","_trackDistance"];
	_train setVariable ["ATRAIN_Local_Node_Path",[_startNodeIndex, _endNodeIndex],true];
	_train setVariable ["ATRAIN_Local_Distance_From_Front",_distanceFromStart,true];
	_train setVariable ["ATRAIN_Local_Node_Path_Distance",_trackDistance,true];
	true;
};


ATRAIN_Server_Events = [];

ATRAIN_fnc_unregisterTrainAndDriver = {
	params ["_train","_driver"];
	if(!isServer) exitWith { [_this, "ATRAIN_fnc_unregisterTrainAndDriver"] call ATRAIN_RemoteExecServer };
	ATRAIN_Server_Events pushBack ["UNREGISTER",_train,_driver];
};

ATRAIN_fnc_registerTrainAndDriver = {
	params ["_train","_driver"];
	if(!isServer) exitWith { [_this, "ATRAIN_fnc_registerTrainAndDriver"] call ATRAIN_RemoteExecServer };
	ATRAIN_Server_Events pushBack ["REGISTER",_train,_driver];
};

ATRAIN_fnc_updateTrackMap = {
	params ["_trackMap"];
	if(!isServer) exitWith { [_this, "ATRAIN_fnc_updateTrackMap"] call ATRAIN_RemoteExecServer };
	ATRAIN_Server_Events pushBack ["UPDATETRACKMAP",_trackMap];
};

ATRAIN_fnc_serverEventHandlerLoop = {
	if(!isServer) exitWith {};
	while {true} do {
		if(count ATRAIN_Server_Events > 0) then {
			private _event = ATRAIN_Server_Events deleteAt 0;
			private _action = _event select 0;
			if(_action == "REGISTER") then {
				_event params ["_action","_train","_driver"];
				if([_train] call ATRAIN_fnc_attachTrainToTrackMap) then {
					private _registeredTrains = missionNamespace getVariable ["ATRAIN_Registered_Trains",[]];
					_registeredTrains pushBackUnique _train;
					_train setVariable ["ATRAIN_Remote_Driver", _driver, true];
					_train setVariable ["ATRIAN_Current_Train", _train, true];
					missionNamespace setVariable ["ATRAIN_Registered_Trains",_registeredTrains,true];
				} else {
					[[_train, _driver], {
						params ["_train", "_driver"];
						//diag_log str ["START",_this];
						if(_train getVariable ["ATRAIN_Loaded_Track_Map",false]) exitWith {};
						_train setVariable ["ATRAIN_Loaded_Track_Map",true];
						private _track = [_train] call ATRAIN_fnc_getTrackUnderTrain;
						//diag_log str ["TRACK",_track];
						if(isNull _track) exitWith {};
						["Loading Advanced Train Simulator (ATS)",0,0,99,2,0,3000] spawn bis_fnc_dynamicText;
						private _trackMap = [_track] call ATRAIN_fnc_buildTrackMap;				
						[_trackMap] call ATRAIN_fnc_updateTrackMap;
						[_train, _driver] call ATRAIN_fnc_registerTrainAndDriver;
						["",0,0,1,0,0,3000] spawn bis_fnc_dynamicText;
						["",0,0,1,0,0,3001] spawn bis_fnc_dynamicText;
					}] remoteExec ["spawn", _driver];
				};
			};
			if(_action == "UNREGISTER") then {
				_event params ["_action","_train","_driver"];
				_train setVariable ["ATRAIN_Remote_Driver", nil, true];
			};
			if(_action == "UPDATETRACKMAP") then {
				_event params ["_action","_trackMap"];
				//diag_log str ["HANDLING TRACK MAP UPDATE"];
				[_trackMap] call ATRAIN_fnc_updateServerTrackMap;
			};
		};
		sleep 0.1;
	};
};

[] spawn ATRAIN_fnc_serverEventHandlerLoop;

ATRAIN_fnc_hideTrainObject = {
	params ["_train","_hide","_hideGlobal"];
	if(_hideGlobal) then {
		_this call ATRAIN_fnc_hideTrainObjectGlobal;
	} else {
		_this call ATRAIN_fnc_hideTrainObjectLocal;
	};
};

ATRAIN_fnc_hideTrainObjectLocal = {
	params ["_train","_hide"];
	private _trainDef = [_train] call ATRAIN_fnc_getTrainDefinition;
	if(count _trainDef > 0) then {
		_train hideObject _hide;
	};
};

ATRAIN_fnc_hideTrainObjectGlobal = {
	params ["_train","_hide"];
	if(isServer) then {
		private _trainDef = [_train] call ATRAIN_fnc_getTrainDefinition;
		if(count _trainDef > 0) then {
			_train hideObjectGlobal _hide;
		};
	} else {
		_this call ATRAIN_fnc_hideTrainObjectLocal;
		[_this, "ATRAIN_fnc_hideTrainObjectGlobal"] call ATRAIN_RemoteExecServer;
	};
};

ATRAIN_fnc_hidePlayerObjectGlobal = {
	params ["_player","_hide"];
	if(isPlayer _player) then {
		if(isServer) then {
			_player hideObjectGlobal _hide;
		} else {
			_player hideObject _hide;
			[_this, "ATRAIN_fnc_hidePlayerObjectGlobal"] call ATRAIN_RemoteExecServer;
		};
	};
};

ATRAIN_fnc_hideTrainReplaceWithNew = {
	params ["_train",["_oldObjectIsHiddenGlobal",true],["_newObjectIsGlobal",true]];
	private _newTrain = objNull;
	private _trainType = [_train] call ATRAIN_fnc_getTypeOf;
	_trainType params ["_className","_isStatic"];
	[_train, true, _oldObjectIsHiddenGlobal] call ATRAIN_fnc_hideTrainObject;
	private _waitStartTime = diag_tickTime;
	waitUntil {
		if (diag_tickTime - _waitStartTime > 10) exitWith {true};
		if (isNull _train) exitWith {true};
		isObjectHidden _train;
	};
	if(isObjectHidden _train) then {
		if(_newObjectIsGlobal) then {
			_newTrain = createVehicle [_className, ASLToAGL getPosASLVisual _train, [], 0, "CAN_COLLIDE"];
		} else {
			_newTrain = _className createVehicleLocal ASLToAGL (getPosASLVisual _train);
		};
		_newTrain setVectorDirAndUp [vectorDir _train, vectorUp _train];
		_newTrain setPosASL (getPosASLVisual _train);
	};
	_newTrain;
};

ATRAIN_fnc_initTrainObject = {
	params ["_train"];
	private _trainType = [_train] call ATRAIN_fnc_getTypeOf;
	_trainType params ["_className","_isStatic"];
	if(_isStatic) then {
		_train = [_train] call ATRAIN_fnc_hideTrainReplaceWithNew;
	};
	private _trainDef = [_train] call ATRAIN_fnc_getTrainDefinition;
	_trainDef params ["_className", "_isDrivable", "_isRideable", "_carLength", "_maxSpeed", "_positionOffset","_animateTrain"];
	_train setVariable ["ATRAIN_Remote_Car_Length",_carLength,true];
	_train setVariable ["ATRAIN_Remote_Train_Max_Velocity",_maxSpeed,true];
	_train setVariable ["ATRAIN_Remote_Position_Offset",_positionOffset,true];
	_train setVariable ["ATRAIN_Remove_Animate_Train",_animateTrain,true];
	_train enableSimulation false;
	_train;
};

ATRAIN_fnc_exitTrain = {
	private _train = player getVariable ["ATRAIN_Current_Train",objNull];
	private _trainCar = player getVariable ["ATRAIN_Current_Train_Car",objNull];
	if(!isNull _train) then {
		player setVariable ["ATRAIN_Current_Train", nil];
		player setVariable ["ATRAIN_Current_Train_Car", nil];
		[_train,player] call ATRAIN_fnc_unregisterTrainAndDriver;
		[] call ATRAIN_fnc_disableTrainInputHandlers;
		_localCopy = _trainCar getVariable ["ATRAIN_Local_Copy",_trainCar];
		private _trainPos = getPos _localCopy;
		private _trainVectorDir = vectorDir _localCopy;
		private _trainVectorUp = vectorUp _localCopy;
		private _trainVectorLeft = _trainVectorDir vectorCrossProduct _trainVectorUp;
		private _exitPos = _trainPos vectorAdd (_trainVectorLeft vectorMultiply 3);
		_exitPos set [2,0];
		player setPos _exitPos;
		[player,false] call ATRAIN_fnc_hidePlayerObjectGlobal;
		player enableSimulation true;
		player allowDamage true;
		[] call ATRAIN_fnc_disable3rdPersonCamera;
		[] spawn ATRAIN_fnc_disableHud;
	};
};

ATRAIN_fnc_getInTrain = {
	params ["_train","_trainCar"];
	private _trainAndCarSame = _train == _trainCar;
	_train = _train getVariable ["ATRAIN_Remote_Copy",_train];
	_train = [_train] call ATRAIN_fnc_initTrainObject;
	if(_trainAndCarSame) then {
		_trainCar = _train;
	};
	player setVariable ["ATRAIN_Current_Train",_train];
	player setVariable ["ATRAIN_Current_Train_Car",_trainCar];
	[_train,player] call ATRAIN_fnc_registerTrainAndDriver;
	[player,true] call ATRAIN_fnc_hidePlayerObjectGlobal;
	player enableSimulation false;
	player allowDamage false;
	private _localTrainCar = _trainCar getVariable ["ATRAIN_Local_Copy",_trainCar];
	[_localTrainCar] call ATRAIN_fnc_enable3rdPersonCamera;
	[] call ATRAIN_fnc_enableTrainInputHandlers;
	["<t size='0.6'>Press [delete] to exit train</t>",0.02,0.9,5,2,0,3001] spawn bis_fnc_dynamicText;
	[] spawn ATRAIN_fnc_enableHud;
};


ATRAIN_fnc_exitTrainPassenger = {
	private _trainCar = player getVariable ["ATRAIN_Current_Train_Passenger_Car",objNull];
	if(!isNull _trainCar) then {
		player setVariable ["ATRAIN_Current_Train_Passenger_Car", nil];
		[] call ATRAIN_fnc_disableTrainPassengerInputHandlers;
		_localCopy = _trainCar getVariable ["ATRAIN_Local_Copy",_trainCar];
		private _trainPos = getPos _localCopy;
		private _trainVectorDir = vectorDir _localCopy;
		private _trainVectorUp = vectorUp _localCopy;
		private _trainVectorLeft = _trainVectorDir vectorCrossProduct _trainVectorUp;
		private _exitPos = _trainPos vectorAdd (_trainVectorLeft vectorMultiply 3);
		_exitPos set [2,0];
		player setPos _exitPos;
		[player,false] call ATRAIN_fnc_hidePlayerObjectGlobal;
		player enableSimulation true;
		player allowDamage true;
		[] call ATRAIN_fnc_disable3rdPersonCamera;
	};
};

ATRAIN_fnc_getInTrainPassenger = {
	params ["_trainCar"];
	player setVariable ["ATRAIN_Current_Train_Passenger_Car",_trainCar];
	private _localTrainCar = _trainCar getVariable ["ATRAIN_Local_Copy",_trainCar];
	[player,true] call ATRAIN_fnc_hidePlayerObjectGlobal;
	player enableSimulation false;
	player allowDamage false;
	[_localTrainCar] call ATRAIN_fnc_enable3rdPersonCamera;
	[] call ATRAIN_fnc_enableTrainPassengerInputHandlers;
	["<t size='0.6'>Press [delete] to exit train</t>",0.02,0.9,5,2,0,3001] spawn bis_fnc_dynamicText;
};

ATRAIN_fnc_enableHud = {
	disableSerialization;
	[] call ATRAIN_fnc_disableHud;
	private _hudCtrl = uiNamespace getVariable ["ATRAIN_Hud_Control", nil];
	if(isNil "_hudCtrl") then {
		private _h = (getnumber (configfile >> "RscStructuredText" >> "size")) * 5;
		private _w = safezoneW - 0.05;
		_hudCtrl = (findDisplay 46) ctrlCreate ["RscStructuredText", -1];
		private _pos = [safeZoneX, safeZoneY + safeZoneH - _h, _w, _h];
		_hudCtrl ctrlSetPosition _pos;
		_hudCtrl ctrlCommit 0;
		uiNamespace setVariable ["ATRAIN_Hud_Control", _hudCtrl];
		private _train = player getVariable ["ATRAIN_Current_Train",objNull];
		while {!isNull _train} do {
			private _speed = round ((_train getVariable ["ATRAIN_Local_Velocity",0]) * 3.6);
			private _cars = (count (_train getVariable ["ATRAIN_Remote_Cars",[_train]])) - 1;
			private _cruiseControlEnabled = _train getVariable ["ATRAIN_Remote_Cruise_Control_Enabled", false];
			private _cruiseControlHud = "";
			if(_cruiseControlEnabled) then {
				_cruiseControlHud = " (CC)";
			};
			private _ctrltxt =  ("<t color= '#FFFFFF' size='2' shadow= '1' shadowColor='#000000' align='right'>" + str _cars + " cars&#160;&#160;<br/>" + str abs _speed + _cruiseControlHud + " km/h</t>");
			_ctrltxt = parseText _ctrltxt;
			_hudCtrl ctrlsetStructuredText _ctrltxt;
			sleep 0.5;
			_hudCtrl = uiNamespace getVariable ["ATRAIN_Hud_Control", nil];
			_train = player getVariable ["ATRAIN_Current_Train",objNull];
		};
		[] call ATRAIN_fnc_disableHud;
	};
};

ATRAIN_fnc_disableHud = {
	disableSerialization;
	private _hudCtrl = uiNamespace getVariable ["ATRAIN_Hud_Control", nil];
	if(!isNil "_hudCtrl") then {
		ctrlDelete _hudCtrl;
		uiNamespace setVariable ["ATRAIN_Hud_Control", nil];
	};
};

ATRAIN_fnc_toggleCruiseControl = {
	private _train = player getVariable ["ATRAIN_Current_Train",objNull];
	if(!isNull _train) then {
		private _cruiseControlEnabled = _train getVariable ["ATRAIN_Remote_Cruise_Control_Enabled", false];
		_train setVariable ["ATRAIN_Remote_Cruise_Control_Enabled", !_cruiseControlEnabled, true];
	};
};

ATRAIN_fnc_enableTrainInputHandlers = {
	private _inputHandlers = [];
	_inputHandlers pushBack ["MAIN_DISPLAY","KeyDown",(["MAIN_DISPLAY","KeyDown", "if(_this select 1 == 211) then { [] call ATRAIN_fnc_exitTrain }"] call ATRAIN_fnc_addEventHandler)];
	_inputHandlers pushBack ["MAIN_DISPLAY","KeyDown",(["MAIN_DISPLAY","KeyDown", "[""KeyDown"",_this] call ATRAIN_fnc_trainMoveInputHandler"] call ATRAIN_fnc_addEventHandler)];
	_inputHandlers pushBack ["MAIN_DISPLAY","KeyUp",(["MAIN_DISPLAY","KeyUp", "[""KeyUp"",_this] call ATRAIN_fnc_trainMoveInputHandler"] call ATRAIN_fnc_addEventHandler)];
	player setVariable ["ATRAIN_Input_Handlers", _inputHandlers];
};

ATRAIN_fnc_enableTrainPassengerInputHandlers = {
	
	player setVariable ["ATRAIN_Passenger_Forward", 0];
	player setVariable ["ATRAIN_Passenger_Backward", 0];
	player setVariable ["ATRAIN_Passenger_Right", 0];
	player setVariable ["ATRAIN_Passenger_Left", 0];
	
	private _inputHandlers = [];
	_inputHandlers pushBack ["MAIN_DISPLAY","KeyDown",(["MAIN_DISPLAY","KeyDown", "if(_this select 1 == 211) then { [] call ATRAIN_fnc_exitTrainPassenger }"] call ATRAIN_fnc_addEventHandler)];
	_inputHandlers pushBack ["MAIN_DISPLAY","KeyDown",(["MAIN_DISPLAY","KeyDown", "[""KeyDown"",_this] call ATRAIN_fnc_passengerMoveInputHandler"] call ATRAIN_fnc_addEventHandler)];
	_inputHandlers pushBack ["MAIN_DISPLAY","KeyUp",(["MAIN_DISPLAY","KeyUp", "[""KeyUp"",_this] call ATRAIN_fnc_passengerMoveInputHandler"] call ATRAIN_fnc_addEventHandler)];
	player setVariable ["ATRAIN_Passenger_Input_Handlers", _inputHandlers];
};

ATRAIN_fnc_disableTrainInputHandlers = {
	private _inputHandlers = player getVariable ["ATRAIN_Input_Handlers", []];
	{
		_x call ATRAIN_fnc_removeEventHandler;
	} forEach _inputHandlers;
};

ATRAIN_fnc_disableTrainPassengerInputHandlers = {
	private _inputHandlers = player getVariable ["ATRAIN_Passenger_Input_Handlers", []];
	{
		_x call ATRAIN_fnc_removeEventHandler;
	} forEach _inputHandlers;
};

ATRAIN_fnc_trainMoveInputHandler = {
	params ["_event","_eventParams"];
	if(_event == "KeyDown") then {
		if(_eventParams select 1 in (actionKeys "MoveBack")) then {
			player setVariable ["ATRAIN_Remote_Movement_Direction", -1, true];
		};
		if(_eventParams select 1 in (actionKeys "MoveForward")) then {
			player setVariable ["ATRAIN_Remote_Movement_Direction", 1, true];
		};
		if(_eventParams select 1 in (actionKeys "TurnRight")) then {
			player setVariable ["ATRAIN_Remote_Turn_Direction", 1, true];
		};
		if(_eventParams select 1 in (actionKeys "TurnLeft")) then {
			player setVariable ["ATRAIN_Remote_Turn_Direction", -1, true];
		};
		if(_eventParams select 1 == 48) then {  //B
			player setVariable ["ATRAIN_Remote_Break_Enabled", true, true];
		};
	};
	if(_event == "KeyUp") then {
		if(_eventParams select 1 in (actionKeys "MoveBack")) then {
			player setVariable ["ATRAIN_Remote_Movement_Direction", 0, true];
		};
		if(_eventParams select 1 in (actionKeys "MoveForward")) then {
			player setVariable ["ATRAIN_Remote_Movement_Direction", 0, true];
		};
		if(_eventParams select 1 in (actionKeys "TurnRight")) then {
			player setVariable ["ATRAIN_Remote_Turn_Direction", 0, true];
		};
		if(_eventParams select 1 in (actionKeys "TurnLeft")) then {
			player setVariable ["ATRAIN_Remote_Turn_Direction", 0, true];
		};
		if(_eventParams select 1 == 46) then {  // C
			[] call ATRAIN_fnc_toggleCruiseControl;
		};
		if(_eventParams select 1 == 48) then {  //B
			player setVariable ["ATRAIN_Remote_Break_Enabled", false, true];
		};
	};
};	

ATRAIN_fnc_passengerMoveInputHandler = {
	params ["_event","_eventParams"];
	if(_event == "KeyDown") then {
		if(_eventParams select 1 in (actionKeys "MoveBack")) then {
			player setVariable ["ATRAIN_Passenger_Forward", 1];
		};
		if(_eventParams select 1 in (actionKeys "MoveForward")) then {
			player setVariable ["ATRAIN_Passenger_Backward", 1];
		};
		if(_eventParams select 1 in (actionKeys "TurnRight")) then {
			player setVariable ["ATRAIN_Passenger_Right", 1];
		};
		if(_eventParams select 1 in (actionKeys "TurnLeft")) then {
			player setVariable ["ATRAIN_Passenger_Left", 1];
		};
	};
	if(_event == "KeyUp") then {
		if(_eventParams select 1 in (actionKeys "MoveBack")) then {
			player setVariable ["ATRAIN_Passenger_Forward", 0];
		};
		if(_eventParams select 1 in (actionKeys "MoveForward")) then {
			player setVariable ["ATRAIN_Passenger_Backward", 0];
		};
		if(_eventParams select 1 in (actionKeys "TurnRight")) then {
			player setVariable ["ATRAIN_Passenger_Right", 0];
		};
		if(_eventParams select 1 in (actionKeys "TurnLeft")) then {
			player setVariable ["ATRAIN_Passenger_Left", 0];
		};
	};
};	

ATRAIN_fnc_calculateTrainAlignment = {
	params ["_trainEngine","_trainCar","_trainDistanceFromFront"];
	private _carLength = _trainCar getVariable ["ATRAIN_Remote_Car_Length",6];
	private _carFrontPositionAndDirection = [_trainEngine, _trainCar, _trainDistanceFromFront - (_carLength * 0.4)] call ATRAIN_fnc_getTrainPositionAndDirection;
	private _carBackPositionAndDirection = [_trainEngine, _trainCar, _trainDistanceFromFront + (_carLength * 0.4)] call ATRAIN_fnc_getTrainPositionAndDirection;
	[_carFrontPositionAndDirection, _carBackPositionAndDirection];
};


ATRAIN_fnc_getTrainPositionAndDirection = {
	params ["_trainEngine","_trainCar","_trainDistanceFromFront"];
	private _nodePath = _trainEngine getVariable ["ATRAIN_Local_Node_Path",[]];
	private _nodePathCount = count _nodePath;
	if(_nodePathCount == 2) exitWith {
		private _startNodeIndex = _nodePath select 0;
		private _endNodeIndex = _nodePath select 1;
		private _mapConnection = [_startNodeIndex, _endNodeIndex] call ATRAIN_fnc_getTrackMapConnection;
		[_mapConnection select 2, _trainDistanceFromFront, true, (str _startNodeIndex + "-" + str _endNodeIndex), _trainCar] call ATRAIN_fnc_getPositionAndDirectionOnPath;
	};
	private _distanceSeen = 0;
	private _priorNodeIndex = -1;
	private _positioning = [];
	for [{_i=0}, {_i < _nodePathCount}, {_i=_i+1}] do
	{
		private _currentNodeIndex = _nodePath select _i;
		if(_priorNodeIndex >= 0) then {
			private _mapConnection = [_priorNodeIndex, _currentNodeIndex] call ATRAIN_fnc_getTrackMapConnection;
			private _distanceBetweeNodes = _mapConnection select 1;
			_distanceSeen = _distanceSeen + _distanceBetweeNodes;
			if((_trainDistanceFromFront < _distanceSeen) || ((_nodePathCount-1) == _i)) then {
				private _distanceFromStartNode = _trainDistanceFromFront - (_distanceSeen - _distanceBetweeNodes);
				_positioning = [_mapConnection select 2, _distanceFromStartNode, true, (str _priorNodeIndex + "-" + str _currentNodeIndex), _trainCar] call ATRAIN_fnc_getPositionAndDirectionOnPath;
				_i = _nodePathCount;
			};
		};
		_priorNodeIndex = _currentNodeIndex;
	};	
	_positioning;
};

ATRAIN_fnc_cleanUpNodePath = {
	params ["_train","_distanceFromEngineToRear","_distanceFromEngineToFront"];
	private _nodePath = _train getVariable ["ATRAIN_Local_Node_Path",[]];
	if(count _nodePath <= 2) exitWith {};
	private _trainDistanceFromStart = _train getVariable ["ATRAIN_Local_Distance_From_Front",0];
	private _trainNodePathDistance = _train getVariable ["ATRAIN_Local_Node_Path_Distance",0];
	private _frontStartNodeIndex = _nodePath select 0;
	private _frontEndNodeIndex = _nodePath select 1;
	private _connection = [_frontStartNodeIndex, _frontEndNodeIndex] call ATRAIN_fnc_getTrackMapConnection;
	private _distanceBetweeNodes = _connection select 1;
	if(_trainDistanceFromStart - _distanceFromEngineToFront > _distanceBetweeNodes) then {
		_nodePath deleteAt 0;
		_trainDistanceFromStart = _trainDistanceFromStart - _distanceBetweeNodes;
		_trainNodePathDistance = _trainNodePathDistance - _distanceBetweeNodes;
	};
	
	private _rearStartNodeIndex = _nodePath select ((count _nodePath) - 2);
	private _rearEndNodeIndex = _nodePath select ((count _nodePath) - 1);
	_connection = [_rearStartNodeIndex, _rearEndNodeIndex] call ATRAIN_fnc_getTrackMapConnection;
	_distanceBetweeNodes = _connection select 1;
	if(_trainDistanceFromStart + _distanceFromEngineToRear < _trainNodePathDistance - _distanceBetweeNodes) then {
		_nodePath deleteAt ((count _nodePath) - 1);
		_trainNodePathDistance = _trainNodePathDistance - _distanceBetweeNodes;
	};
	_train setVariable ["ATRAIN_Local_Node_Path",_nodePath];
	_train setVariable ["ATRAIN_Local_Node_Path_Distance",_trainNodePathDistance];
	_train setVariable ["ATRAIN_Local_Distance_From_Front",_trainDistanceFromStart];
};

ATRAIN_fnc_setWheelSpeed = {
	params ["_trainCar","_speed","_isBackwards"];
	private _isLocalCopy = _trainCar getVariable ["ATRAIN_Is_Local_Copy",false];
	if(!_isLocalCopy) exitWith {};
	private _currentPhase = _trainCar animationSourcePhase "Wheels_source";
	if(_speed == 0) then {
		_trainCar animateSource ["Wheels_source",_currentPhase];
	} else {
		private _phaseDirection  = 1;
		if( _speed < 0 ) then {
			_phaseDirection = -1;
		};
		if( _isBackwards ) then {
			_phaseDirection = _phaseDirection * -1;
		};
		private _newPhase = _currentPhase + (10 * _phaseDirection);
		private _animationSpeed = (abs _speed) / 6;
		_trainCar animateSource ["Wheels_source",_newPhase, _animationSpeed];
	};
};

ATRAIN_fnc_drawTrain = {
	params ["_train"];
	private _trainCalculationsQueued = _train getVariable ["ATRAIN_Calculations_Queued",true];
	private _trainCars = _train getVariable ["ATRAIN_Remote_Cars",[_train]];
	private _lastAttachmentTime = _train getVariable ["ATRAIN_Local_Last_Attachment_Time",0];
	private _currentTime = diag_tickTime;
	private _lastSeen = _train getVariable ["ATRAIN_New_Alignment_Last_Seen",diag_tickTime];
	private _timeSinceLastSeen = _currentTime - _lastSeen;
	private _trainSpeed = _train getVariable ["ATRAIN_Local_Velocity",0];
	
	private _maxAnimatedCars = missionNamespace getVariable ["ATRAIN_MAX_CARS_SIMULATED_ENABLED", 3];
	private _carsWithAnimationEnabled = 0;	
	
	{
		private _localCopy = _x getVariable ["ATRAIN_Local_Copy", objNull];
		if(isNull _localCopy) then {
			_localCopy = [_x, false, false] call ATRAIN_fnc_hideTrainReplaceWithNew;
			_localCopy setVariable ["ATRAIN_Is_Local_Copy",true];
			_localCopy setVariable ["ATRAIN_Remote_Copy",_x];
			_localCopy = [_localCopy] call ATRAIN_fnc_initTrainObject;
			if(ATRAIN_3rd_Person_Camera_Target == _x) then {
				ATRAIN_3rd_Person_Camera_Target = _localCopy;
			};
			_x setVariable ["ATRAIN_Local_Copy", _localCopy];
		};
		private _lastDrawPosition = _x getVariable ["ATRAIN_Last_Draw_Position",getPosASLVisual _localCopy];	
		private _lastDrawDirection = _x getVariable ["ATRAIN_Last_Draw_Vector_Dir",vectorDir _localCopy];
		private _newDrawDirection = _x getVariable ["ATRAIN_New_Draw_Vector_Dir",_lastDrawDirection];
		private _velocityFromLastToNewPosition = _x getVariable ["ATRAIN_Velocity_From_Last_To_New_Position",0];
		private _directionFromLastToNewPosition = _x getVariable ["ATRAIN_Direction_From_Last_To_New_Position",_lastDrawDirection];
		private _distanceFromLastToNewPosition = _x getVariable ["ATRAIN_Distance_From_Last_To_New_Position", 0];
		private _animateTrain = _x getVariable ["ATRAIN_Remove_Animate_Train",false];
		
		// Enable in-game simulation for front and rear cars (so that it can collide with objects)
		
		if(_distanceFromLastToNewPosition > 0.01) then {
			if(_carsWithAnimationEnabled < _maxAnimatedCars) then {
				_carsWithAnimationEnabled = _carsWithAnimationEnabled + 1;
				if(!simulationEnabled _localCopy) then {
					_localCopy enableSimulation true;
				};
			} else {
				if(simulationEnabled _localCopy) then {
					_localCopy enableSimulation false;
				};
			};
		} else {
			if(simulationEnabled _localCopy) then {
				_localCopy enableSimulation false;
			};
		};
		
		if(_distanceFromLastToNewPosition > 0.01) then {
			private _distanceMovedFromLastPosition = _timeSinceLastSeen * _velocityFromLastToNewPosition;
			private _percentMovedFromLastPosition = 0;
			if(_distanceFromLastToNewPosition != 0) then {
				_percentMovedFromLastPosition = _distanceMovedFromLastPosition / _distanceFromLastToNewPosition;
			};
			_percentMovedFromLastPosition = (_percentMovedFromLastPosition max 0) min 1;
			private _currentDrawDirection = vectorNormalized ((_lastDrawDirection vectorMultiply (1-_percentMovedFromLastPosition)) vectorAdd (_newDrawDirection vectorMultiply _percentMovedFromLastPosition));
			private _currentDrawPosition = _lastDrawPosition vectorAdd (_directionFromLastToNewPosition vectorMultiply (_distanceMovedFromLastPosition min _distanceFromLastToNewPosition));
			
			_localCopy setVectorDirAndUp [_currentDrawDirection,[0,0,1]];
			_localCopy setPosASL _currentDrawPosition;
			
			private _attachments = _x getVariable ["ATRAIN_Attachments",[]];
			{
				private _object = _x select 0;
				private _objectModelPos = _x select 1;
				private _objectLocalCopy = _object getVariable ["ATRAIN_Local_Copy", objNull];
				if(isNull _objectLocalCopy) then {
					_objectLocalCopy = (typeOf _object) createVehicleLocal [0,0,1000];
					_object setVariable ["ATRAIN_Local_Copy", _objectLocalCopy];
					_object hideObject true;
					_objectLocalCopy enableSimulation false;
				};
				_objectLocalCopy setVectorDirAndUp [_currentDrawDirection,[0,0,1]];
				_objectLocalCopy setPosASL ((AGLtoASL (_localCopy modelToWorld _objectModelPos)) vectorAdd [0,0,-2.4]);
			} forEach _attachments;
			
			_x setVariable ["ATRAIN_Current_Draw_Position", _currentDrawPosition];
		};
	} forEach _trainCars;

	if(!_trainCalculationsQueued) then {
		{
			private _newAlignment = _x getVariable ["ATRAIN_Local_Alignment",nil];
			private _localCopy = _x getVariable ["ATRAIN_Local_Copy", objNull];
			if(isNull _localCopy) exitWith {};
			private _currentPosition = _x getVariable ["ATRAIN_Current_Draw_Position", getPosASLVisual _localCopy];
			if(!isNil "_newAlignment") then {
				private _frontAlignmentPoint = _newAlignment select 0;
				private _frontAlignmentPointPosition = _frontAlignmentPoint select 0;
				private _frontAlignmentPointDirection = _frontAlignmentPoint select 1;
				private _rearAlignmentPoint = _newAlignment select 1;
				private _rearAlignmentPointPosition = _rearAlignmentPoint select 0;
				private _rearAlignmentPointDirection = _rearAlignmentPoint select 1;
				private _trainVectorDirection = _rearAlignmentPointPosition vectorFromTo _frontAlignmentPointPosition;
				private _trainPosition = _frontAlignmentPointPosition vectorAdd ((_rearAlignmentPointPosition vectorDiff _frontAlignmentPointPosition) vectorMultiply 0.5);
				private _trainIsBackwards = _x getVariable ["ATRIAN_Remote_Is_Backwards", false];
				private _animateTrain = _x getVariable ["ATRAIN_Remove_Animate_Train",false];
				if(_trainIsBackwards) then {
					_trainVectorDirection = _trainVectorDirection vectorMultiply -1;
				};
				// Offset position based on train model params
				private _positionOffset = _x getVariable ["ATRAIN_Remote_Position_Offset", [0,0,0]];
				_trainPosition = _trainPosition vectorAdd (_trainVectorDirection vectorMultiply (_positionOffset select 0));
				_trainPosition = _trainPosition vectorAdd ((_trainVectorDirection vectorCrossProduct [0,0,1]) vectorMultiply (_positionOffset select 1));
				_trainPosition = _trainPosition vectorAdd [0,0,(_positionOffset select 2)];
				_x setVariable ["ATRAIN_New_Draw_Position",_trainPosition];
				_x setVariable ["ATRAIN_New_Draw_Vector_Dir",_trainVectorDirection];
				_x setVariable ["ATRAIN_Distance_From_Last_To_New_Position",_currentPosition distance _trainPosition];
				private _velocityFromLastToNewPosition = _x getVariable ["ATRAIN_Velocity_From_Last_To_New_Position",0];
				if(_timeSinceLastSeen == 0) then {
					_velocityFromLastToNewPosition = ( _velocityFromLastToNewPosition  * 0.5);
				} else {
					private _newVelocityFromLastToNewPosition = ((_currentPosition distance _trainPosition) / _timeSinceLastSeen);
					_velocityFromLastToNewPosition = ( _velocityFromLastToNewPosition  * 0.5) + ( _newVelocityFromLastToNewPosition * 0.5);
				};
				_x setVariable ["ATRAIN_Velocity_From_Last_To_New_Position", _velocityFromLastToNewPosition ];
				_x setVariable ["ATRAIN_Direction_From_Last_To_New_Position",_currentPosition vectorFromTo _trainPosition];
				if(_animateTrain) then {
					[_localCopy,_trainSpeed,_trainIsBackwards] call ATRAIN_fnc_setWheelSpeed;
				};
			};
			_x setVariable ["ATRAIN_Last_Draw_Position",_currentPosition];
			_x setVariable ["ATRAIN_Last_Draw_Vector_Dir",vectorDir _localCopy];
		} forEach _trainCars;
		_train setVariable ["ATRAIN_Calculations_Queued",true];
		_train setVariable ["ATRAIN_New_Alignment_Last_Seen",_currentTime];
	};

};

ATRAIN_fnc_simulateTrainVelocity = {
	params ["_train"];
	private _driver = _train getVariable ["ATRAIN_Remote_Driver", objNull];
	private _movementDirection = 0;
	if(!isNull _driver) then {
		_movementDirection = _driver getVariable ["ATRAIN_Remote_Movement_Direction",0];
	};
	private _currentCalcTime = diag_tickTime;
	private _lastCalcTime = _train getVariable ["ATRAIN_Local_Last_Velocity_Calculation_Time",_currentCalcTime];
	private _deltaCalcTime = (_currentCalcTime - _lastCalcTime);
	if(_deltaCalcTime > 2) then {
		_deltaCalcTime = 0;
	};
	private _carCount = count (_train getVariable ["ATRAIN_Remote_Cars",[_train]]);
	
	private _trainAccelerationMin = _train getVariable ["ATRAIN_Local_Train_Acceleration_Min", 0.7];
	private _trainAccelerationMax = _train getVariable ["ATRAIN_Local_Train_Acceleration_Max", 1.2];
	private _trainAccelerationRange = _trainAccelerationMax - _trainAccelerationMin;
	private _trainAcceleration = _trainAccelerationMin + (_trainAccelerationRange * (1 - (((_carCount / 20) min 1))));
	
	private _trainDragMin = _train getVariable ["ATRAIN_Local_Train_Drag_Min", 0.7];
	private _trainDragMax = _train getVariable ["ATRAIN_Local_Train_Drag_Max", 1.2];
	private _trainDragRange = _trainDragMax - _trainDragMin;
	private _trainDrag = _trainDragMin + (_trainDragRange * (1 - ((_carCount / 20) min 1)));
	
	private _cruiseControlEnabled = _train getVariable ["ATRAIN_Remote_Cruise_Control_Enabled", false];
	private _breakEnabled = player getVariable ["ATRAIN_Remote_Break_Enabled", false];
	
	if(_cruiseControlEnabled && !_breakEnabled) then {
		_trainDrag = 0;
	};
	
	if(_breakEnabled) then {
		_trainAcceleration = 0;
		_movementDirection = 0;
		_trainDrag = _trainDrag * 2;
	};
	
	private _trainMaxVelocity = _train getVariable ["ATRAIN_Remote_Train_Max_Velocity",12];
	private _trainVelocity = _train getVariable ["ATRAIN_Local_Velocity",0];
	_trainVelocity = (_trainVelocity + (_trainAcceleration * _movementDirection * _deltaCalcTime)) min _trainMaxVelocity max -_trainMaxVelocity;
	if(_trainVelocity > 0 && _movementDirection == 0) then {
		_trainVelocity = (_trainVelocity - (_trainDrag * _deltaCalcTime)) max 0;
	};
	if(_trainVelocity < 0 && _movementDirection == 0) then {
		_trainVelocity = (_trainVelocity + (_trainDrag * _deltaCalcTime)) min 0;
	};
	private _localVelocityUpdate = _train getVariable ["ATRAIN_Local_Velocity_Update",nil];
	if(!isNil "_localVelocityUpdate") then {
		_trainVelocity = _localVelocityUpdate;
		_train setVariable ["ATRAIN_Local_Velocity_Update",nil];
	};
	_train setVariable ["ATRAIN_Local_Velocity",_trainVelocity];
	_train setVariable ["ATRAIN_Local_Last_Velocity_Calculation_Time",_currentCalcTime];
};

ATRAIN_fnc_isTrainLocal = {
	params ["_train"];
	private _driver = _train getVariable ["ATRAIN_Remote_Driver", objNull];
	if(isServer && isNull _driver) exitWith {true};
	if(!isNull _driver && local _driver) exitWith {true};
	false;
};

#define NETWORK_UPDATE_INTERVAL 1

ATRAIN_fnc_handleVelocityNetworkUpdates = {
	params ["_train"];
	private _isTrainLocal = [_train] call ATRAIN_fnc_isTrainLocal;	
	if(_isTrainLocal) then {
		private _currentTime = diag_tickTime;
		private _lastUpdateTime = _train getVariable ["ATRAIN_Local_Last_Velocity_Network_Update_Time",0];
		if(_currentTime - _lastUpdateTime > NETWORK_UPDATE_INTERVAL) then {
			private _trainVelocity = _train getVariable ["ATRAIN_Local_Velocity",0];
			private _trainRemoteVelocity = _train getVariable ["ATRAIN_Remote_Velocity",0];
			if(_trainVelocity != _trainRemoteVelocity) then {
				//diag_log ("Sent Network Message: " + str _trainVelocity);
				_train setVariable ["ATRAIN_Remote_Velocity",_trainVelocity,true];
			};
			_train setVariable ["ATRAIN_Local_Last_Velocity_Network_Update_Time",_currentTime];
		};
	} else {
		private _trainRemoteVelocity = _train getVariable ["ATRAIN_Remote_Velocity",nil];
		if(!isNil "_trainRemoteVelocity") then {
			//diag_log ("Received Network Message: " + str _trainRemoteVelocity);
			_train setVariable ["ATRAIN_Local_Velocity",_trainRemoteVelocity];
			_train setVariable ["ATRAIN_Remote_Velocity",nil];
		};
	};
};

ATRAIN_fnc_simulateTrainAttachment = {
	params ["_train"];
	
	private _trainVelocity = _train getVariable ["ATRAIN_Local_Velocity",0];
	private _trainCars = _train getVariable ["ATRAIN_Remote_Cars",[_train]];
	private _trainCarsInRear = _train getVariable ["ATRAIN_Remote_Cars_In_Rear",[]];
	private _trainCarsInFront = _train getVariable ["ATRAIN_Remote_Cars_In_Front",[]];
	
	// Check for cars in rear
	private _rearCar = _train;
	if(count _trainCarsInRear > 0) then {
		_rearCar = _trainCarsInRear select ((count _trainCarsInRear)-1);
	};
	private _rearCarLocal = _rearCar getVariable ["ATRAIN_Local_Copy", objNull];
	if(isNull _rearCarLocal) exitWith {};
	private _rearCarPosASL = getPosASLVisual _rearCarLocal;
	private _rearCarSearchVectorDir = vectorDir _rearCarLocal;
	private _rearCarIsBackwards = _rearCar getVariable ["ATRIAN_Remote_Is_Backwards", false];
	if(!_rearCarIsBackwards) then {
		_rearCarSearchVectorDir = _rearCarSearchVectorDir vectorMultiply -1;
	};
	private _rearCarLength = _rearCar getVariable ["ATRAIN_Remote_Car_Length",6];
	private _intersectStartASL = _rearCarPosASL vectorAdd (_rearCarSearchVectorDir vectorMultiply (_rearCarLength*0.45)) vectorAdd [0,0,3];
	private _intersectEndASL = _intersectStartASL vectorAdd [0,0,-3];
	private _newCars = lineIntersectsWith [_intersectStartASL,_intersectEndASL,_rearCarLocal];
	{
		private _car = _x;
		if(_car getVariable ["ATRAIN_Is_Local_Copy",false]) then {
			_car = _car getVariable ["ATRAIN_Remote_Copy",objNull];
		};
		if(!isNull _car) then {
			private _trainDef = [_car] call ATRAIN_fnc_getTrainDefinition;
			if(count _trainDef > 0 && !(_car in _trainCarsInFront) && !(_car in _trainCarsInRear) && _car != _train && isNull (_car getVariable ["ATRIAN_Current_Train",objNull])) then {
				private _carIsBackwards = (_rearCarSearchVectorDir vectorDotProduct (vectorDir _car)) > 0;
				_car = [_car] call ATRAIN_fnc_initTrainObject;
				_car setVariable ["ATRIAN_Remote_Is_Backwards", _carIsBackwards, true];
				_car setVariable ["ATRIAN_Current_Train", _train, true];
				_trainCarsInRear pushBackUnique _car;
				_trainCars pushBackUnique _car;
				_train setVariable ["ATRAIN_Remote_Cars_In_Rear",_trainCarsInRear,true];
				_train setVariable ["ATRAIN_Remote_Cars",_trainCars,true];
				_train setVariable ["ATRAIN_Local_Velocity_Update", _trainVelocity / 2];
				_train setVariable ["ATRAIN_Local_Last_Attachment_Time",diag_tickTime];
			};
		};
	} forEach _newCars;
		
	// Check for cars in front
	
	private _frontCar = _train;
	if(count _trainCarsInFront > 0) then {
		_frontCar = _trainCarsInFront select ((count _trainCarsInFront)-1);
	};
	private _frontCarLocal = _frontCar getVariable ["ATRAIN_Local_Copy", objNull];
	if(isNull _frontCarLocal) exitWith {};
	private _frontCarPosASL = getPosASLVisual _frontCarLocal;
	private _frontCarSearchVectorDir = vectorDir _frontCarLocal;
	private _frontCarIsBackwards = _frontCar getVariable ["ATRIAN_Remote_Is_Backwards", false];
	if(_frontCarIsBackwards) then {
		_frontCarSearchVectorDir = _frontCarSearchVectorDir vectorMultiply -1;
	};
	private _frontCarLength = _frontCar getVariable ["ATRAIN_Remote_Car_Length",6];
	private _intersectStartASL = _frontCarPosASL vectorAdd (_frontCarSearchVectorDir vectorMultiply (_frontCarLength*0.45)) vectorAdd [0,0,3];
	private _intersectEndASL = _intersectStartASL vectorAdd [0,0,-3];
	private _newCars = lineIntersectsWith [_intersectStartASL,_intersectEndASL,_frontCarLocal];
	{
		private _car = _x;
		if(_car getVariable ["ATRAIN_Is_Local_Copy",false]) then {
			_car = _car getVariable ["ATRAIN_Remote_Copy",objNull];
		};
		if(!isNull _car) then {
			private _trainDef = [_car] call ATRAIN_fnc_getTrainDefinition;
			if(count _trainDef > 0 && !(_car in _trainCarsInFront) && !(_car in _trainCarsInRear) && _car != _train && isNull (_car getVariable ["ATRIAN_Current_Train",objNull])) then {
				private _carIsBackwards = (_frontCarSearchVectorDir vectorDotProduct (vectorDir _car)) < 0;
				_car = [_car] call ATRAIN_fnc_initTrainObject;
				_car setVariable ["ATRIAN_Remote_Is_Backwards", _carIsBackwards, true];
				_car setVariable ["ATRIAN_Current_Train", _train, true];
				_trainCarsInFront pushBackUnique _car;
				_trainCars pushBackUnique _car;
				_train setVariable ["ATRAIN_Remote_Cars_In_Front",_trainCarsInFront,true];
				_train setVariable ["ATRAIN_Remote_Cars",_trainCars,true];
				_train setVariable ["ATRAIN_Local_Velocity_Update",_trainVelocity / 2];
				_train setVariable ["ATRAIN_Local_Last_Attachment_Time",diag_tickTime];
			};
			
		};
	} forEach _newCars;

};

ATRAIN_fnc_simulateTrain = {
	
	params ["_train"];
	
	private _driver = _train getVariable ["ATRAIN_Remote_Driver", objNull];
	private _isTrainLocal = [_train] call ATRAIN_fnc_isTrainLocal;	

	private _currentSimulationTime = diag_tickTime;
	private _lastSimulationTime = _train getVariable ["ATRAIN_Local_Last_Simulation_Time",_currentSimulationTime];
	_train setVariable ["ATRAIN_Local_Last_Simulation_Time",_currentSimulationTime];
	private _deltaSimulationTime = _currentSimulationTime - _lastSimulationTime;
	
	if(_deltaSimulationTime > 5) then {
		_deltaSimulationTime = 0;
	};
	
	// Calculate train distance from start of path
	private _trainDistanceFromFront = _train getVariable ["ATRAIN_Local_Distance_From_Front",0];
	private _trainVelocity = _train getVariable ["ATRAIN_Local_Velocity",0];
	_trainDistanceFromFront = _trainDistanceFromFront - (_trainVelocity * _deltaSimulationTime);
	
	// Calculate engine alignment
	private _engineLength = _train getVariable ["ATRAIN_Remote_Car_Length",6];
	private _engineAlignment = [_train,_train,_trainDistanceFromFront] call ATRAIN_fnc_calculateTrainAlignment;
	_train setVariable ["ATRAIN_Local_Alignment", _engineAlignment];
	
	// Calculate rear cars alignments
	private _trainCarsInRear = _train getVariable ["ATRAIN_Remote_Cars_In_Rear",[]];
	private _rearCarAlignment = _engineAlignment;
	private _rearCar = _train;
	_carDistanceFrontStart = _trainDistanceFromFront;
	_priorCarLength = _engineLength;
	{
		_rearCar = _x;
		private _carLength = _rearCar getVariable ["ATRAIN_Remote_Car_Length", 6];
		_carDistanceFrontStart = _carDistanceFrontStart + ( _priorCarLength / 2 ) + ( _carLength / 2 );
		_rearCarAlignment = [_train,_rearCar,_carDistanceFrontStart] call ATRAIN_fnc_calculateTrainAlignment;
		_rearCar setVariable ["ATRAIN_Local_Alignment", _rearCarAlignment];		
		_priorCarLength = _carLength;
	} forEach _trainCarsInRear;
	private _distanceFromEngineToRear = (_carDistanceFrontStart - _trainDistanceFromFront) + ( _priorCarLength / 2 );
	
	// Calculate front cars alignments
	private _trainCarsInFront = _train getVariable ["ATRAIN_Remote_Cars_In_Front",[]];
	private _frontCarAlignment = _engineAlignment;
	private _frontCar = _train;
	_carDistanceFrontStart = _trainDistanceFromFront;
	_priorCarLength = _engineLength;
	{
		_frontCar = _x;
		private _carLength = _frontCar getVariable ["ATRAIN_Remote_Car_Length", 6];
		_carDistanceFrontStart = _carDistanceFrontStart - ( _priorCarLength / 2 ) - ( _carLength / 2 );
		_frontCarAlignment = [_train,_frontCar,_carDistanceFrontStart] call ATRAIN_fnc_calculateTrainAlignment;
		_frontCar setVariable ["ATRAIN_Local_Alignment", _frontCarAlignment];		
		_priorCarLength = _carLength;
	} forEach _trainCarsInFront;
	private _distanceFromEngineToFront = (_trainDistanceFromFront - _carDistanceFrontStart) + ( _priorCarLength / 2 );

	// Calculate track node updates
	private _nodePath = _train getVariable ["ATRAIN_Local_Node_Path",[]];
	private _trainNodePathDistance = _train getVariable ["ATRAIN_Local_Node_Path_Distance",0];
	if((_trainDistanceFromFront - _distanceFromEngineToFront) < 0 || (_trainDistanceFromFront + _distanceFromEngineToRear) > _trainNodePathDistance) then {
		private _trainInReverse = _trainVelocity < 0;
		private _turnTurnDirection = 0;
		if(!isNull _driver) then {
			_turnTurnDirection = _driver getVariable ["ATRAIN_Remote_Turn_Direction",0];
		};
		private _trainAlignment = [_train,_frontCar,_trainDistanceFromFront - _distanceFromEngineToFront] call ATRAIN_fnc_calculateTrainAlignment;
		private _trainDirection = (_trainAlignment select 0) select 1;
		if(_trainInReverse) then {
			_trainAlignment = [_train,_rearCar,_trainDistanceFromFront + _distanceFromEngineToRear] call ATRAIN_fnc_calculateTrainAlignment;
			_trainDirection = ((_trainAlignment select 1) select 1) vectorMultiply -1;
		};
		private _trainDirectionRight = _trainDirection vectorCrossProduct [0,0,1];
		private _finalNodeIndex = _nodePath select 0;
		if(_trainInReverse) then {
			_finalNodeIndex = _nodePath select ((count _nodePath) - 1);
		};
		private _possibleNextNodes = [];
		private _mapFinalNode = ATRAIN_Map select _finalNodeIndex;
		{
			private _connectedNodeIndex = _x select 0;
			private _connectedNodeDistance = _x select 1;
			private _connectedNodePath = _x select 2;
			private _connectedNodePathStartPositionASL = (_connectedNodePath select 0);
			private _connectedNodePathSecondPositionASL = (_connectedNodePath select 1);
			private _connectedNodeDirection = _connectedNodePathStartPositionASL vectorFromTo _connectedNodePathSecondPositionASL;
			if(_trainDirection vectorDotProduct _connectedNodeDirection > 0) then {
				_possibleNextNodes pushBack [_connectedNodeIndex, _connectedNodeDirection, _connectedNodeDistance];
			};
		} forEach _mapFinalNode;
		private _nextNodeIndex = -1;
		private _nextNodeDistance = -1;
		private _nextNodeIndexMinValue = 0;
		{
			private _dirDotProduct = _trainDirectionRight vectorDotProduct (_x select 1);
			private _dirDotProductDelta = abs (_turnTurnDirection - _dirDotProduct);
			if(_nextNodeIndex == -1 || _dirDotProductDelta < _nextNodeIndexMinValue) then {
				_nextNodeIndex = _x select 0;
				_nextNodeDistance = _x select 2;
				_nextNodeIndexMinValue = _dirDotProductDelta;
			};
		} forEach _possibleNextNodes;
		if(_nextNodeIndex != -1) then {
			if(_trainInReverse) then {
				_nodePath = _nodePath + [_nextNodeIndex];
			} else {
				_nodePath = [_nextNodeIndex] + _nodePath;
				_trainDistanceFromFront = _trainDistanceFromFront + _nextNodeDistance;
			};
			_trainNodePathDistance = _trainNodePathDistance + _nextNodeDistance;
			_train setVariable ["ATRAIN_Local_Node_Path",_nodePath];
			_train setVariable ["ATRAIN_Local_Node_Path_Distance",_trainNodePathDistance];
		} else {
			if(_trainInReverse) then {
				_trainDistanceFromFront = _trainNodePathDistance - _distanceFromEngineToRear;
			} else {
				_trainDistanceFromFront = _distanceFromEngineToFront;
			};
			_train setVariable ["ATRAIN_Local_Velocity_Update",0];
		};
	};

	_train setVariable ["ATRAIN_Local_Distance_From_Front",_trainDistanceFromFront];
	
	if(count _nodePath > 2) then {
		[_train, _distanceFromEngineToRear, _distanceFromEngineToFront] call ATRAIN_fnc_cleanUpNodePath;
	};

};

ATRAIN_fnc_handleSimulationNetworkUpdates = {
	params ["_train"];
	private _isTrainLocal = [_train] call ATRAIN_fnc_isTrainLocal;	
	if(_isTrainLocal) then {
		private _currentTime = diag_tickTime;
		private _lastUpdateTime = _train getVariable ["ATRAIN_Local_Last_Simulation_Network_Update_Time",0];
		if(_currentTime - _lastUpdateTime > NETWORK_UPDATE_INTERVAL) then {
			private _distanceFromFront = _train getVariable ["ATRAIN_Local_Distance_From_Front",0];
			private _nodePath = _train getVariable ["ATRAIN_Local_Node_Path",[]];
			private _nodePathDistance = _train getVariable ["ATRAIN_Local_Node_Path_Distance",0];
			private _simulationState = [_distanceFromFront, _nodePath, _nodePathDistance];
			private _remoteSimulationState = _train getVariable ["ATRAIN_Remote_Simulation_State",[]];
			if(str _simulationState != str _remoteSimulationState) then {
				//diag_log ("Sending Network Message: " + str _remoteSimulationState);
				_train setVariable ["ATRAIN_Remote_Simulation_State",_simulationState,true];
			};
			_train setVariable ["ATRAIN_Local_Last_Simulation_Network_Update_Time",_currentTime];
		};
	} else {
		private _remoteSimulationState = _train getVariable ["ATRAIN_Remote_Simulation_State",nil];
		if(!isNil "_remoteSimulationState") then {
			//diag_log ("Received Network Message: " + str _remoteSimulationState);
			_train setVariable ["ATRAIN_Local_Distance_From_Front",_remoteSimulationState select 0];
			_train setVariable ["ATRAIN_Local_Node_Path",_remoteSimulationState select 1];
			_train setVariable ["ATRAIN_Local_Node_Path_Distance",_remoteSimulationState select 2];
			_train setVariable ["ATRAIN_Remote_Simulation_State",nil];
		};
	};
};

ATRAIN_fnc_attachToTrainCar = {
	params ["_object","_trainCar","_attachmentPosition"];
	_trainCar = _trainCar getVariable ["ATRAIN_Remote_Copy",_trainCar];
	private _attachments = _trainCar getVariable ["ATRAIN_Attachments",[]];
	_attachments pushBack [_object,_attachmentPosition];
	_trainCar setVariable ["ATRAIN_Attachments",_attachments,true];
	_object attachTo [_trainCar, _attachmentPosition];
};


ATRAIN_Player_Actions = [];

ATRAIN_fnc_managePlayerTrainActions = {
	// start a player's eyes
	private _searchStartPointASL = eyePos player;
	// end 2 meters in front of where player is looking
	private _searchEndPointASL = _searchStartPointASL vectorAdd ((_searchStartPointASL vectorFromTo (ATLtoASL screenToWorld [0.5,0.5])) vectorMultiply 2);
	private _objects = lineIntersectsWith [_searchStartPointASL,_searchEndPointASL];
	private _trainFound = objNull;
	{
		if(count ([_x] call ATRAIN_fnc_getTrainDefinition) > 0) exitWith {
			_trainFound = _x;
		};
	} forEach _objects;
	if(!isNull _trainFound && count ATRAIN_Player_Actions == 0) then {
		_trainFound = _trainFound getVariable ["ATRAIN_Remote_Copy",_trainFound];
		private _trainDef = [_trainFound] call ATRAIN_fnc_getTrainDefinition;
		_trainDef params ["_className", "_isDrivable", "_isRideable"];
		
		// Add actions
		if(_isDrivable) then {
			private _mainEngine = _trainFound getVariable ["ATRIAN_Current_Train", _trainFound];
			private _currentDriver = _mainEngine getVariable ["ATRAIN_Remote_Driver", objNull];
			if(isNull _currentDriver || !alive _currentDriver || _currentDriver == player) then {		
				private _driveAction = player addAction ["Get in Train as Driver", {
					(_this select 3) params ["_mainEngine","_trainCar"];
					private _currentDriver = _mainEngine getVariable ["ATRAIN_Remote_Driver", objNull];
					if(isNull _currentDriver || !alive _currentDriver || _currentDriver == player) then {	
						[_mainEngine,_trainCar] call ATRAIN_fnc_getInTrain;
					};
				},[_mainEngine,_trainFound]];
				ATRAIN_Player_Actions pushBack _driveAction;
			};
		};

		private _currentTrain = _trainFound getVariable ["ATRIAN_Current_Train", objNull];
		if(!isNull _currentTrain && (_currentTrain getVariable ["ATRAIN_Local_Velocity",0]) == 0 && _currentTrain != _trainFound) then {
			private _disconnectAction = player addAction ["Disconnect Car", {
			
				private _trainCar = _this select 3;
				private _localTrainCar = _trainCar getVariable ["ATRAIN_Local_Copy", _trainCar];
				private _currentTrain = _trainCar getVariable ["ATRIAN_Current_Train", objNull];
				
				private _carsInRear = _currentTrain getVariable ["ATRAIN_Remote_Cars_In_Rear",[]];
				private _carsInFront = _currentTrain getVariable ["ATRAIN_Remote_Cars_In_Front",[]];
				private _allCars = _currentTrain getVariable ["ATRAIN_Remote_Cars",[]];
				
				private _rearCarSeen = false;
				private _newCarsInRear = [];
				{
					if(_x == _trainCar && !_rearCarSeen) then {
						_rearCarSeen = true;
					};
					if(_rearCarSeen) then {
						_x setVariable ["ATRIAN_Current_Train",nil,true];
						_x setVariable ["ATRIAN_Remote_Is_Backwards", nil, true];
						_x setPosASL (getPosASLVisual _localTrainCar);
						_x setVectorDirAndUp [vectorDir _localTrainCar, vectorUp _localTrainCar];
						_allCars = _allCars - [_x];
					} else {
						_newCarsInRear pushBack _x;
					};
				} forEach _carsInRear;
				_currentTrain setVariable ["ATRAIN_Remote_Cars_In_Rear",_newCarsInRear,true];
				
				
				
				private _frontCarSeen = false;
				private _newCarsInFront = [];
				{
					if(_x == _trainCar && !_frontCarSeen) then {
						_frontCarSeen = true;
					};		
					if(_frontCarSeen) then {
						_x setVariable ["ATRIAN_Current_Train",nil,true];
						_x setVariable ["ATRIAN_Remote_Is_Backwards", nil, true];
						_x setPosASL (getPosASLVisual _localTrainCar);
						_x setVectorDirAndUp [vectorDir _localTrainCar, vectorUp _localTrainCar];
						_allCars = _allCars - [_x];
					} else {
						_newCarsInFront pushBack _x;
					};
				} forEach _carsInFront;
				_currentTrain setVariable ["ATRAIN_Remote_Cars_In_Front",_newCarsInFront,true];

				_currentTrain setVariable ["ATRAIN_Remote_Cars",_allCars,true];

			},_trainFound];
			ATRAIN_Player_Actions pushBack _disconnectAction;
		
		};
		
		if(_isRideable) then {
			private _currentTrain = _trainFound getVariable ["ATRIAN_Current_Train", objNull];
			private _currentDriver = _currentTrain getVariable ["ATRAIN_Remote_Driver", objNull];
			if(!isNull _currentTrain && _currentTrain != _trainFound && _currentDriver != player) then {
				private _rideAction = player addAction ["Ride Train", {
					[_this select 3] call ATRAIN_fnc_getInTrainPassenger;
				},_trainFound];
				ATRAIN_Player_Actions pushBack _rideAction;
			};
		};
	};
	
	if(isNull _trainFound && count ATRAIN_Player_Actions > 0) then {
		{
			player removeAction _x;
		} forEach ATRAIN_Player_Actions;
		ATRAIN_Player_Actions = [];
	};
	
};


if(hasInterface) then {
	[] spawn {
		while {true} do {
			[] call ATRAIN_fnc_managePlayerTrainActions;
			sleep 0.1;
		};
	};
};
		
ATRAIN_fnc_isPassengerMoving = {
	params ["_player"];
	(_player getVariable ["ATRAIN_Passenger_Forward", 0]) + (_player getVariable ["ATRAIN_Passenger_Backward", 0]) + (_player getVariable ["ATRAIN_Passenger_Right", 0]) + (_player getVariable ["ATRAIN_Passenger_Left", 0]) > 0;
};

ATRAIN_RIDE_ON_TRAIN_EVENT_HANDLER_PARAMS = [];

ATRAIN_fnc_rideOnTrainEventHandler = {
	ATRAIN_RIDE_ON_TRAIN_EVENT_HANDLER_PARAMS params ["_player","_train"];

	private _remoteTrain = _train getVariable ["ATRAIN_Remote_Copy",_train];
	private _mainEngine = _remoteTrain getVariable ["ATRIAN_Current_Train", _remoteTrain];
	
	private _currentTrainPositionASL = getPosASLVisual _train;
	private _lastTrainPositionASL = _player getVariable ["ATRAIN_Riding_On_Train_Last_Train_Position_ASL", _currentTrainPositionASL];
	private _currentTrainDir = getDir _train;
	private _lastTrainDir = _player getVariable ["ATRAIN_Riding_On_Train_Last_Train_Dir", _currentTrainDir];
	
	_player setVariable ["ATRAIN_Riding_On_Train_Last_Train_Position_ASL", _currentTrainPositionASL];
	_player setVariable ["ATRAIN_Riding_On_Train_Last_Train_Dir", _currentTrainDir];
	
	private _isPlayerMoving = [_player] call ATRAIN_fnc_isPassengerMoving;
	
	if(_isPlayerMoving) then {	
		_player setVariable ["ATRAIN_Riding_On_Train_Last_Player_Position_Model", _train worldToModelVisual (ASLToAGL getPosASLVisual vehicle _player) ];
	};
	
	private _lastPlayerPositionModel = _player getVariable ["ATRAIN_Riding_On_Train_Last_Player_Position_Model", _train worldToModelVisual (ASLToAGL getPosASLVisual vehicle _player)];	

	if(_currentTrainPositionASL distance _lastTrainPositionASL > 0) then {
		
		if(!_isPlayerMoving) then {	
			(vehicle _player) setVelocity [0,0,0];
		};
		
		(vehicle _player) setDir (getDir _player + _currentTrainDir - _lastTrainDir);
		(vehicle _player) setPosASL (AGLtoASL (_train modelToWorldVisual _lastPlayerPositionModel));

	};
};

ATRAIN_fnc_rideOnTrain = {
	params ["_player","_train"];
	
	[] call ATRAIN_fnc_enableTrainPassengerInputHandlers;
	
	player setVariable ["ATRAIN_Riding_On_Train_Last_Train_Position_ASL", getPosASLVisual _train];
	player setVariable ["ATRAIN_Riding_On_Train_Last_Train_Dir", getDir _train];
	
	player setVariable ["ATRAIN_Riding_On_Train_Last_Player_Position_Model", _train worldToModelVisual (ASLToAGL getPosASLVisual _player) ];
	
	ATRAIN_RIDE_ON_TRAIN_EVENT_HANDLER_PARAMS = _this;
	private _rideEventHandlerId = addMissionEventHandler ["EachFrame", {call ATRAIN_fnc_rideOnTrainEventHandler}];
	
	while {true} do {
		private _currentTrain = [_player] call ATRAIN_fnc_getTrainUnderPlayer;
		private _currentPassengerCar = _player getVariable ["ATRAIN_Current_Train_Passenger_Car",objNull];
		if(isNull _currentTrain || _currentTrain != _train || !isNull _currentPassengerCar || !alive _player) exitWith {};
		sleep 0.1;
	};
	_player setVariable ["ATRAIN_Riding_On_Train", nil];	
	removeMissionEventHandler ["EachFrame", _rideEventHandlerId];
	[] call ATRAIN_fnc_disableTrainPassengerInputHandlers;
};

ATRAIN_fnc_drawEventHandler = {
	{
		[_x] call ATRAIN_fnc_drawTrain;
	} forEach (missionNamespace getVariable ["ATRAIN_Registered_Trains",[]]);
};

ATRAIN_TRACKS_NEAR_EDITOR_PLACED_CONNECTIONS = [];

ATRAIN_fnc_preloadAllTracksNearEditorPlacedConnections = {
	{
		private _isSplitTrack = _x select 2;
		private _isEndTrack = _x select 3;
		private _trackClassName = _x select 0;
		if(_isSplitTrack || _isEndTrack) then {
			// Loop over every mission object of that class
			private _missionTrackObjects = allMissionObjects _trackClassName;
			{
				// Loop over every path in the track object
				private _track = _x;
				private _trackWorldPaths = [_track] call ATRAIN_fnc_getTrackWorldPaths;
				{
					// Find tracks under the track path's end points
					private _positionASL = _x select 0;
					private _tracksAtPosition = [_positionASL,_track] call ATRAIN_fnc_getTracksAtPosition;
					{
						private _trackType = [_x] call ATRAIN_fnc_getTypeOf;
						_trackType params ["_className","_isStatic"];
						if(_isStatic) then {
							ATRAIN_TRACKS_NEAR_EDITOR_PLACED_CONNECTIONS pushBackUnique _x;
						};
					} forEach _tracksAtPosition
				} forEach _trackWorldPaths;
			} forEach _missionTrackObjects;
		};
	} forEach ATRAIN_Track_Definitions;
};

ATRAIN_fnc_init = {

	[] call ATRAIN_fnc_preloadAllTracksNearEditorPlacedConnections;

	// Start train drawing handler
	addMissionEventHandler ["EachFrame", {call ATRAIN_fnc_drawEventHandler}];

	// Start train speed simulation handler
	[] spawn {
		while {true} do {
			private _registeredTrains = missionNamespace getVariable ["ATRAIN_Registered_Trains",[]];
			{
				[_x] call ATRAIN_fnc_simulateTrainVelocity;
				[_x] call ATRAIN_fnc_handleVelocityNetworkUpdates;
			} forEach _registeredTrains;
			sleep 0.1;
		};
	};

	// Start train attachment simulation handler
	[] spawn {
		while {true} do {
			private _registeredTrains = missionNamespace getVariable ["ATRAIN_Registered_Trains",[]];
			{
				if([_x] call ATRAIN_fnc_isTrainLocal) then {
					[_x] call ATRAIN_fnc_simulateTrainAttachment;
				};
			} forEach _registeredTrains;
			sleep 0.1;
		};
	};

	// Start train position simulation handler
	[] spawn {
		while {true} do {
			private _registeredTrains = missionNamespace getVariable ["ATRAIN_Registered_Trains",[]];
			{
				if(_x getVariable ["ATRAIN_Calculations_Queued",true]) then {
					[_x] call ATRAIN_fnc_simulateTrain;
					[_x] call ATRAIN_fnc_handleSimulationNetworkUpdates;
					_x setVariable ["ATRAIN_Calculations_Queued",false];
				};
			} forEach _registeredTrains;
			sleep 0.1;
		};
	};

	// Start attach player to moving train handler
	if(hasInterface) then {
		[] spawn {
			while {true} do {
				private _ridingOnTrain = player getVariable ["ATRAIN_Riding_On_Train", objNull];
				private _currentPassengerCar = player getVariable ["ATRAIN_Current_Train_Passenger_Car",objNull];
				if(isNull _ridingOnTrain && isNull _currentPassengerCar) then {
					if((getPosATL player) select 2 > 0.5) then {
						private _train = [player] call ATRAIN_fnc_getTrainUnderPlayer;
						if(!isNull _train) then {
							player setVariable ["ATRAIN_Riding_On_Train", _train];
							[player,_train] spawn ATRAIN_fnc_rideOnTrain;
						};
					};
				};
				sleep 0.5;
			};
		};
	};

	if(isServer) then {
		
		// Adds support for exile network calls (Only used when running exile) //

		ExileServer_AdvancedTrainSimulator_network_AdvancedTrainSimulatorRemoteExecServer = {
			params ["_sessionId", "_messageParameters",["_isCall",false]];
			_messageParameters params ["_params","_functionName"];
			if(_isCall) then {
				_params call (missionNamespace getVariable [_functionName,{}]);
			} else {
				_params spawn (missionNamespace getVariable [_functionName,{}]);
			};
		};

		ExileServer_AdvancedTrainSimulator_network_AdvancedTrainSimulatorRemoteExecClient = {
			params ["_sessionId", "_messageParameters"];
			_messageParameters params ["_params","_functionName","_target",["_isCall",false]];
			if(_isCall) then {
				_params remoteExecCall [_functionName, _target];
			} else {
				_params remoteExec [_functionName, _target];
			};
		};
		
	};

};

[] call ATRAIN_fnc_init;

diag_log "Advanced Train Simulator (ATS) Loaded";

};

publicVariable "ATRAIN_Advanced_Train_Simulator_Install";

[] call ATRAIN_Advanced_Train_Simulator_Install;
// Install Advanced Train Simulator on all clients (plus JIP) //
remoteExecCall ["ATRAIN_Advanced_Train_Simulator_Install", -2,true];