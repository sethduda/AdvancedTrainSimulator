params ["_train","_hide","_hideGlobal"];
if(_hideGlobal) then {
	_this call ATRAIN_fnc_hideTrainObjectGlobal;
} else {
	_this call ATRAIN_fnc_hideTrainObjectLocal;
};
