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
