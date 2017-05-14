#include "camera.h"
private ["_mouseZoom","_distance"];
_mouseZoom = (_this select 1);
if(_mouseZoom > 0) then {
	_mouseZoom = 1;
} else {
	_mouseZoom = -1;
};
_distance =	ATRAIN_FNC_CAMERA_DISTANCE;
ATRAIN_3rd_Person_Camera_Distance = (_distance - _mouseZoom) max 3 min 60;
