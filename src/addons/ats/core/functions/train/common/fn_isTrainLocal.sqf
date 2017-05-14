params ["_train"];
private _driver = _train getVariable ["ATRAIN_Remote_Driver", objNull];
if(isServer && isNull _driver) exitWith {true};
if(!isNull _driver && local _driver) exitWith {true};
false;
