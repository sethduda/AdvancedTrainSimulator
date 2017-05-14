  params ["_soundSource"];
  if(!isNull _soundSource) then {
  ATRAIN_Sound_Sources = ATRAIN_Sound_Sources - [_soundSource];
  ATRAIN_Sound_Sources_Near = ATRAIN_Sound_Sources_Near - [_soundSource];
  	deleteVehicle _soundSource;
};
