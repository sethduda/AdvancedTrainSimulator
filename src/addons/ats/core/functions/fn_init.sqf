
diag_log "Advanced Train Simulator (ATS) Loading...";

if(hasInterface) then {
	[] call ATRAIN_fnc_removeAllEventHandlers;
};

[] call ATRAIN_fnc_initTracks;

[] call ATRAIN_fnc_initTrains;

[] call ATRAIN_fnc_initServer;

[] call ATRAIN_fnc_initSound;

diag_log "Advanced Train Simulator (ATS) Loaded";