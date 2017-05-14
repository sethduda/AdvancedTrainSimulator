params ["_soundSource"];
((_soundSource getVariable ["volume", 1]) min 1) max 0;
