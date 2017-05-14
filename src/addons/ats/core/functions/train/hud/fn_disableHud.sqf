disableSerialization;
private _hudCtrl = uiNamespace getVariable ["ATRAIN_Hud_Control", nil];
if(!isNil "_hudCtrl") then {
	ctrlDelete _hudCtrl;
	uiNamespace setVariable ["ATRAIN_Hud_Control", nil];
};
