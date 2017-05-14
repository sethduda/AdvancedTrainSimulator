params ["_methodName",["_time",diag_tickTime]];
ATRAIN_Method_Stack pushBack [_methodName,_time];
//////diag_log (str "Start " + _methodName + ": " + str ATRAIN_Method_Stack);
([_methodName] call ATRAIN_fnc_getProfile) params ["_profileIndex","_profile"];
if(_profileIndex == -1) then {
	ATRAIN_Profiles pushBack [_methodName,0,0,0];
};	
