params ["_object","_trainCar","_attachmentPosition"];
_trainCar = _trainCar getVariable ["ATRAIN_Remote_Copy",_trainCar];
private _attachments = _trainCar getVariable ["ATRAIN_Attachments",[]];
_attachments pushBack [_object,_attachmentPosition];
_trainCar setVariable ["ATRAIN_Attachments",_attachments,true];
_object attachTo [_trainCar, _attachmentPosition];
