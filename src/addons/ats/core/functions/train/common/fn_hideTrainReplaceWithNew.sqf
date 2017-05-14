//added killed eventhandler, epe contact eventhandlers, lock 2
params ["_train",["_oldObjectIsHiddenGlobal",true],["_newObjectIsGlobal",true]];
private _newTrain = objNull;
private _trainType = [_train] call ATRAIN_fnc_getTypeOf;
_trainType params ["_className","_isStatic"];
[_train, true, _oldObjectIsHiddenGlobal] call ATRAIN_fnc_hideTrainObject;
private _waitStartTime = diag_tickTime;

ATS_canDestruct = {
	params ["_train"];
	if (alive _train) then {
		true
	} else {
		false
	};
};

ATS_trainDestroyed = {
	params ["_train"];
	private _remoteTrainCarKilled = _train getVariable ["ATRAIN_Remote_Copy",_trainCarKilled];
	if(!isNull _remoteTrainCarKilled) then {
	    _remoteTrainCarKilled setVariable ["ATRAIN_Remote_Killed", true, true];
	};
	[] call ATRAIN_fnc_exitTrain;
	[] call ATRAIN_fnc_exitTrainPassenger;
	_train removeEventHandler ["Killed",0];
	/*_train removeEventHandler ["EpeContact",0];
	_train removeEventHandler ["EpeContactStart",0];
	_train removeEventHandler ["EpeContactEnd",0];*/
};

waitUntil {
	if (diag_tickTime - _waitStartTime > 10) exitWith {true};
	if (isNull _train) exitWith {true};
	isObjectHidden _train;
};
if(isObjectHidden _train) then {//should always be true, triggered after the waituntil isObjectHidden _train
	if(_newObjectIsGlobal) then {
		_newTrain = createVehicle [_className, ASLToAGL getPosASLVisual _train, [], 0, "CAN_COLLIDE"];
	} else {
		_newTrain = _className createVehicleLocal ASLToAGL (getPosASLVisual _train);
	};
	_newTrain setVectorDirAndUp [vectorDir _train, vectorUp _train];
	_newTrain setPosASL (getPosASLVisual _train);

	if ([_newTrain] call ATS_canDestruct) then {
		/*_newTrain addEventHandler
		["EpeContact",
			{
				params ["_obj1","_obj2","_sel1","_sel2","_force"];
				_obj1 setdammage ATRAIN_TEMPDAMAGE_OBJ1;
				_obj2 setdammage ATRAIN_TEMPDAMAGE_OBJ2;
			}
		];
		_newTrain addEventHandler
		["EpeContactStart",
			{
				params ["_obj1","_obj2","_sel1","_sel2","_force"];
				_obj1 allowDamage false;
				_obj2 allowDamage false;
				_obj1 globalChat "DAMAGE FALSE";
			}
		];
		_newTrain addEventHandler
		["EpeContactEnd",
			{
				params ["_obj1","_obj2","_sel1","_sel2","_force"];
				_obj1 allowDamage true;
				_obj2 allowDamage true;
				_obj1 globalChat "DAMAGE true";
			}
		];*/
		_newTrain addEventHandler ["Killed", {[_this select 0] call ATS_trainDestroyed}];
		_newTrain lock 2;
	};
};
_newTrain;