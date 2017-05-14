params ["_train","_trainCar"];
private _trainAndCarSame = _train == _trainCar;
_train = _train getVariable ["ATRAIN_Remote_Copy",_train];
_train = [_train] call ATRAIN_fnc_initTrainObject;
if(_trainAndCarSame) then {
	_trainCar = _train;
};

ATS_checkSimulation = {
	params ["_train"];
	if !(simulationEnabled _train) then {
		_train enableSimulation true;
	};
};

player setVariable ["ATRAIN_Current_Train",_train];
player setVariable ["ATRAIN_Current_Train_Car",_trainCar];
[_train,player] call ATRAIN_fnc_registerTrainAndDriver;
[player,true] call ATRAIN_fnc_hidePlayerObjectGlobal;
player enableSimulation false;
player allowDamage false;
private _localTrainCar = _trainCar getVariable ["ATRAIN_Local_Copy",_trainCar];
[_localTrainCar, _trainCar getVariable "ATRAIN_Remote_First_Person_Position"] call ATRAIN_fnc_enable3rdPersonCamera;
[] call ATRAIN_fnc_enableTrainInputHandlers;
[] spawn ATRAIN_fnc_enableHud;
["<t size='0.6'>Press [delete] to exit train</t>",0.02,0.9,5,2,0,3001] spawn bis_fnc_dynamicText;