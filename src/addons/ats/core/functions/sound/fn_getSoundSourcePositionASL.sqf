params ["_soundSource"];
private _soundSourcePositionASL = _soundSource getVariable ["positionASL", [0,0,0]];;
private _attachedTo = [_soundSource] call ATRAIN_fnc_soundSourceAttachedTo;
_attachedTo params [["_attachedToObject",objNull], ["_attachedToModelPosition",[0,0,0]]];
if(!isNull _attachedToObject) then {
	_soundSourcePositionASL = AGLToASL (_attachedToObject modelToWorldVisual _attachedToModelPosition);
};
_soundSourcePositionASL;
