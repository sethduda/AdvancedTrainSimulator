params ["_train"];
private _trainType = [_train] call ATRAIN_fnc_getTypeOf;
_trainType params ["_className","_isStatic"];
if(_isStatic) then {
	_train = [_train] call ATRAIN_fnc_hideTrainReplaceWithNew;
};
private _trainDef = [_train] call ATRAIN_fnc_getTrainDefinition;
_trainDef params ["_className", "_isDrivable", "_isRideable", "_carLength", "_maxSpeed", "_positionOffset","_animateTrain", "_isModelReversed", "_particleEffects", "_isCableCar", "_firstPersonPosition"];
_train setVariable ["ATRAIN_Remote_Car_Length",_carLength,true];
_train setVariable ["ATRAIN_Remote_Train_Max_Velocity",_maxSpeed,true];
_train setVariable ["ATRAIN_Remote_Position_Offset",_positionOffset,true];
_train setVariable ["ATRAIN_Remote_Animate_Train",_animateTrain,true];
_train setVariable ["ATRAIN_Remote_Is_Model_Reversed",_isModelReversed,true];
_train setVariable ["ATRAIN_Remote_Particle_Effects",_particleEffects,true];
_train setVariable ["ATRAIN_Remote_Is_Cable_Car",_isCableCar,true];
_train setVariable ["ATRAIN_Remote_First_Person_Position",_firstPersonPosition,true];
_train enableSimulation false;

_train;