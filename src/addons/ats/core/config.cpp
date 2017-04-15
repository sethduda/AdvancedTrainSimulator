#define private 0
#define protected 1
#define public 2

class CfgPatches
{
	class ATS_Core
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {};
	};
};

class CfgNetworkMessages
{
	
	class AdvancedTrainSimulatorRemoteExecClient
	{
		module = "AdvancedTrainSimulator";
		parameters[] = {"ARRAY","STRING","OBJECT","BOOL"};
	};
	
	class AdvancedTrainSimulatorRemoteExecServer
	{
		module = "AdvancedTrainSimulator";
		parameters[] = {"ARRAY","STRING","BOOL"};
	};
	
};

class CfgFunctions 
{
	class ATS
	{
		class AdvancedTrainSimulator
		{
			file = "\ats\core\functions";
			class advancedTrainSimulatorInit{postInit=1};
		};
	};
};

class CfgVehicles {
	class House_F;
	class ATS_Trains_Base : House_F {
		armor = 150;
		scope = private;
		mapSize = 0.7;
		accuracy = 0.5;
		editorCategory = "ATS_Category";
		editorSubCategory = "ATS_Trains_Subcategory";
		icon = "iconObject_2x5";
	};
	class ATS_Tracks_Base : House_F {
		armor = 150;
		scope = private;
		mapSize = 0.7;
		accuracy = 0.5;
		editorCategory = "ATS_Category";
		editorSubCategory = "ATS_Tracks_Subcategory";
		icon = "iconObject_2x5";
		destrType = "DestructNo";
	};
};

class CfgEditorCategories
{
	class ATS_Category
	{
		displayName = "ATS";
	};
};

class CfgEditorSubcategories
{
	class ATS_Trains_Subcategory
	{
		displayName = "Trains";
	};
	class ATS_Tracks_Subcategory
	{
		displayName = "Tracks";
	};
	class ATS_Structures_Subcategory
	{
		displayName = "Structures";
	};
};