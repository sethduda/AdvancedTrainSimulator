#define ATRAIN_MAP_CONTROL (findDisplay 12 displayCtrl 51)
#define ATRAIN_MAP_DISPLAY (findDisplay 12)
#define ATRAIN_MAIN_DISPLAY (findDisplay 46)

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
