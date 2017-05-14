#define ATRAIN_FNC_CAMERA_DISTANCE (missionNamespace getVariable ["ATRAIN_3rd_Person_Camera_Distance",8])
#define ATRAIN_FNC_CAMERA (missionNamespace getVariable ["ATRAIN_3rd_Person_Camera",objNull])
#define ATRAIN_FNC_CAMERA_TARGET (missionNamespace getVariable ["ATRAIN_3rd_Person_Camera_Target",objNull])
#define ATRAIN_FNC_CAMERA_X_TOTAL (missionNamespace getVariable ["ATRAIN_3rd_Person_Camera_X_Move_Total",-90])
#define ATRAIN_FNC_CAMERA_Y_TOTAL (missionNamespace getVariable ["ATRAIN_3rd_Person_Camera_Y_Move_Total",60])
#define ATRAIN_FNC_CAMERA_Y_TOTAL_PRIOR (missionNamespace getVariable ["ATRAIN_3rd_Person_Camera_Y_Move_Total_Prior",ATRAIN_FNC_CAMERA_Y_TOTAL])
#define ATRAIN_FNC_CAMERA_REL_POSITION [ATRAIN_FNC_CAMERA_DISTANCE * (cos ATRAIN_FNC_CAMERA_X_TOTAL) * (sin ATRAIN_FNC_CAMERA_Y_TOTAL), ATRAIN_FNC_CAMERA_DISTANCE * (sin ATRAIN_FNC_CAMERA_X_TOTAL) * (sin ATRAIN_FNC_CAMERA_Y_TOTAL), ATRAIN_FNC_CAMERA_DISTANCE * (cos ATRAIN_FNC_CAMERA_Y_TOTAL)]
#define ATRAIN_FNC_1ST_PERSON_ENABLED (ATRAIN_FNC_CAMERA_DISTANCE <= 3)