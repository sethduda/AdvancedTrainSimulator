class CfgPatches
{
	class ATS_AdvancedTrainSimulator
	{
		units[] = {"ATS_AdvancedTrainSimulator"};
		requiredVersion = 1.0;
		requiredAddons[] = {"A3_Modules_F"};
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
	class SA
	{
		class AdvancedTrainSimulator
		{
			file = "\ATS_AdvancedTrainSimulator\functions";
			class advancedTrainSimulatorInit{postInit=1};
		};
	};
};