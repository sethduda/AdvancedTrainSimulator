params ["_clientId"];

if(!isServer) exitWith {};

// Find and cache all functions to remotely install
if(isNil "ATRAIN_Functions_To_Install") then {
	ATRAIN_Functions_To_Install = [];
	private _cfg = "true" configClasses (configFile >> 'CfgFunctions' >> 'ATS');
	{
		_cfgFunctions = "true" configClasses (configFile >> 'CfgFunctions' >> 'ATS' >> (configName _x));
		{
			ATRAIN_Functions_To_Install pushBack (format['ATRAIN_fnc_%1', configName _x]);
		} forEach _cfgFunctions;
	} forEach _cfg;
}; 

if( count ATRAIN_Functions_To_Install > 0 ) then {

	// Remotely install all functions
	{
		_clientId publicVariableClient _x;
	} forEach ATRAIN_Functions_To_Install;

	// Remotely init ATS
	[[ATRAIN_Functions_To_Install], {
		params ["_functionsToInstall"];
		{ waitUntil { !isNil _x } } forEach _functionsToInstall;
		[] spawn ATRAIN_fnc_init;
	}] remoteExec ["spawn", _clientId];

};