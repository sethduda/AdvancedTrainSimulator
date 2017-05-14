#define ATRAIN_MAP_CONTROL (findDisplay 12 displayCtrl 51)
#define ATRAIN_MAP_DISPLAY (findDisplay 12)
#define ATRAIN_MAIN_DISPLAY (findDisplay 46)

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
