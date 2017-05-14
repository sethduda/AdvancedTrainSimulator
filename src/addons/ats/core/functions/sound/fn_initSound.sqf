  if(!isNil "ATRAIN_Sound_Source_Init") exitWith {};
ATRAIN_Sound_Source_Init = true;
  ATRAIN_Sound_Sources = missionNamespace getVariable ["ATRAIN_Sound_Sources",[]];
  ATRAIN_Sound_Sources_Near = missionNamespace getVariable ["ATRAIN_Sound_Sources_Near",[]];
  // Start loop to detect, track and show nearby sound sources
  [] spawn ATRAIN_fnc_nearbySoundSourceHandler;
  // Start loop to handle sound source simulation (volume + attachments)
[] spawn ATRAIN_fnc_soundSourceSimulationHandler;
