#include "camera.h"
private _cam = ATRAIN_FNC_CAMERA;
if(!isNil "_cam") then {
	private _targetObject = vehicle ATRAIN_FNC_CAMERA_TARGET;
	private _bbr = boundingBoxReal _targetObject;
	private _p1 = _bbr select 0;
	private _p2 = _bbr select 1;
	private _maxHeight = abs ((_p2 select 2) - (_p1 select 2));
	private _targetModelPosition = ATRAIN_3rd_Person_Camera_Target_Model_Position vectorAdd [0,0,_maxHeight * 0.5];
	private _targetPosition = AGLToASL (_targetObject modelToWorldVisual _targetModelPosition);
	private _cameraPosition =  AGLToASL (_targetObject modelToWorldVisual (ATRAIN_FNC_CAMERA_REL_POSITION vectorAdd _targetModelPosition));
	if((ASLToATL _cameraPosition) select 2 < 0) then {
		ATRAIN_3rd_Person_Camera_Y_Move_Total = ATRAIN_FNC_CAMERA_Y_TOTAL min ATRAIN_FNC_CAMERA_Y_TOTAL_PRIOR;
		_cameraPosition = ATRAIN_FNC_CAMERA_REL_POSITION vectorAdd _targetPosition;
	};
	private _lookVector = _cameraPosition vectorFromTo _targetPosition;
	private _cameraUpVector = (_lookVector vectorCrossProduct [0,0,1]) vectorCrossProduct _lookVector;
	if(ATRAIN_FNC_1ST_PERSON_ENABLED) then {
		_cam setPosASL _targetPosition;
	} else {
		_cam setPosASL _cameraPosition;
	};
	
	_cam setVectorDirAndUp [_lookVector,_cameraUpVector];
	
	ATRAIN_3rd_Person_Camera_Y_Move_Total_Prior = ATRAIN_FNC_CAMERA_Y_TOTAL;
	ATRAIN_3rd_Person_Camera_Last_Position = _cameraPosition;
};
