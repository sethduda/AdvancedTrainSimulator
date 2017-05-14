params ["_trainClass","_soundDefinition"];
if(isNil "ATRAIN_Train_Sound_Definitions") then {
	ATRAIN_Train_Sound_Definitions = [];
	ATRAIN_Train_Sound_Definitions_Index = [];
};
ATRAIN_Train_Sound_Definitions pushBack _this;
ATRAIN_Train_Sound_Definitions_Index pushBack (toLower _trainClass);