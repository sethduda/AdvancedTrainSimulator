params ["_trainCar"];
player setVariable ["ATRAIN_Current_Train_Passenger_Car",_trainCar];
private _localTrainCar = _trainCar getVariable ["ATRAIN_Local_Copy",_trainCar];
[player,true] call ATRAIN_fnc_hidePlayerObjectGlobal;
player enableSimulation false;
player allowDamage false;
[_localTrainCar, _trainCar getVariable "ATRAIN_Remote_First_Person_Position"] call ATRAIN_fnc_enable3rdPersonCamera;
[] call ATRAIN_fnc_enableTrainPassengerInputHandlers;
["<t size='0.6'>Press [delete] to exit train</t>",0.02,0.9,5,2,0,3001] spawn bis_fnc_dynamicText;