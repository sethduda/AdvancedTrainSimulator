#include "camera.h"
_this spawn {
	params ["_object",["_modelPosition",[0,0,0]]];
	waitUntil {time > 0};
	showCinemaBorder false;
	ATRAIN_3rd_Person_Camera_Target = _object;
	ATRAIN_3rd_Person_Camera_Target_Model_Position = _modelPosition;
	ATRAIN_3rd_Person_Camera = "camera" camCreate (_object modelToWorldVisual _modelPosition); 
	ATRAIN_3rd_Person_Camera cameraEffect ["internal", "BACK"];
	ATRAIN_3rd_Person_Camera camSetFocus [-1, -1];
	ATRAIN_3rd_Person_Camera camCommit 0;
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
		
		/*
		
		Used for finding driver/rider positions 
		
		if(_eventParams select 1 in (actionKeys "MoveBack")) then {
			ATRAIN_3rd_Person_Camera_Target_Model_Position = ATRAIN_3rd_Person_Camera_Target_Model_Position vectorAdd [0,0,-0.1];
		};
		if(_eventParams select 1 in (actionKeys "MoveForward")) then {
			ATRAIN_3rd_Person_Camera_Target_Model_Position = ATRAIN_3rd_Person_Camera_Target_Model_Position vectorAdd [0,0,0.1];
		};
		if(_eventParams select 1 in (actionKeys "TurnRight")) then {
			ATRAIN_3rd_Person_Camera_Target_Model_Position = ATRAIN_3rd_Person_Camera_Target_Model_Position vectorAdd [0,0.1,0];
		};
		if(_eventParams select 1 in (actionKeys "TurnLeft")) then {
			ATRAIN_3rd_Person_Camera_Target_Model_Position = ATRAIN_3rd_Person_Camera_Target_Model_Position vectorAdd [0,-0.1,0];
		};
		if(_eventParams select 1 == 35) then {  //H
			ATRAIN_3rd_Person_Camera_Target_Model_Position = ATRAIN_3rd_Person_Camera_Target_Model_Position vectorAdd [0.1,0,0];
		};
		if(_eventParams select 1 == 34) then {  //G
			ATRAIN_3rd_Person_Camera_Target_Model_Position = ATRAIN_3rd_Person_Camera_Target_Model_Position vectorAdd [-0.1,0,0];
		};
		copyToClipboard (str ATRAIN_3rd_Person_Camera_Target_Model_Position);
		
		*/
		
		
	};	

	ATRAIN_3rd_Person_Camera_Map_Handler1 = ["MAIN_DISPLAY","KeyDown", "[""KeyDown"",_this] call ATRAIN_fnc_remoteCameraMapHandler"] call ATRAIN_fnc_addEventHandler;
	ATRAIN_3rd_Person_Camera_Map_Handler2 = ["MAIN_DISPLAY","MouseButtonDown", "[""MouseButtonDown"",_this] call ATRAIN_fnc_remoteCameraMapHandler"] call ATRAIN_fnc_addEventHandler;

	waitUntil {isNull ATRAIN_FNC_CAMERA || isNull _object};
	[] call ATRAIN_fnc_disable3rdPersonCamera;
};
