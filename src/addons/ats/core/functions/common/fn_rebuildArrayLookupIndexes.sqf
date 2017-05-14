ATRAIN_Track_Definitions_Index = [];
ATRAIN_Track_Definitions = missionNamespace getVariable ["ATRAIN_Track_Definitions",[]];
{
	ATRAIN_Track_Definitions_Index pushBack (toLower (_x select 0));
} forEach ATRAIN_Track_Definitions;
ATRAIN_Train_Definitions_Index = [];
ATRAIN_Train_Definitions = missionNamespace getVariable ["ATRAIN_Train_Definitions",[]];
{
	ATRAIN_Train_Definitions_Index pushBack (toLower (_x select 0));
} forEach ATRAIN_Train_Definitions;
ATRAIN_Object_Model_To_Type_Map_Index = [];
ATRAIN_Object_Model_To_Type_Map = missionNamespace getVariable ["ATRAIN_Object_Model_To_Type_Map",[]];
{
	ATRAIN_Object_Model_To_Type_Map_Index pushBack (toLower (_x select 0));
} forEach ATRAIN_Object_Model_To_Type_Map;