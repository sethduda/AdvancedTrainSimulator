#include "camera.h"
private ["_cam","_distance","_target"];
private _factor = 0.2;
if(ATRAIN_FNC_CAMERA_DISTANCE == 3) then {
	_factor = 0.4;
};
ATRAIN_3rd_Person_Camera_X_Move_Total = ATRAIN_FNC_CAMERA_X_TOTAL + (-(_this select 1)*_factor);
ATRAIN_3rd_Person_Camera_Y_Move_Total = ATRAIN_FNC_CAMERA_Y_TOTAL + (-(_this select 2)*_factor);
if(ATRAIN_FNC_1ST_PERSON_ENABLED) then {
	ATRAIN_3rd_Person_Camera_Y_Move_Total = ATRAIN_FNC_CAMERA_Y_TOTAL max 40 min 160;
} else {
	ATRAIN_3rd_Person_Camera_Y_Move_Total = ATRAIN_FNC_CAMERA_Y_TOTAL max 20 min 160;
};
