#include "camera.h"
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
