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
		tag = "ATRAIN";
				
		class Main
		{
			file = "ats\core\functions";
			class init{postInit=1;};
		};

		class Camera
		{
			file = "ats\core\functions\camera";
			class cameraMouseMoveHandler {};
			class cameraMouseZoomHandler {};
			class cameraUpdatePosition {};
			class disable3rdPersonCamera {};
			class enable3rdPersonCamera {};
		};
		
		class Common
		{
			file = "ats\core\functions\common";
			class addEventHandler {};
			class getTypeOf {};
			class hidePlayerObjectGlobal {};
			class rebuildArrayLookupIndexes {};
			class RemoteExec {};
			class RemoteExecServer {};
			class removeAllEventHandlers {};
			class removeEventHandler {};
		};

		class Debugging
		{
			file = "ats\core\functions\debugging";
			class createMarker {};
			class getProfile {};
			class initTrackTestAction {};
			class printProfiles {};
			class profileInit {};
			class profileMethodStart {};
			class profileMethodStop {};
			class resetProfile {};
		};

		class Server
		{
			file = "ats\core\functions\server";
			class attachTrainToTrackMap {};
			class initServer {};
			class registerTrainAndDriver {};
			class serverEventHandlerLoop {};
			class unregisterTrainAndDriver {};
			class updateServerTrackMap {};
			class updateTrackMap {};
			class requestATSInstall {};
		};

		class Track
		{
			file = "ats\core\functions\track";
			class addWorldPaths {};
			class buildTrackMap {};
			class findAlignedTrackWorldPath {};
			class findConnectedTrackNodes {};
			class getTrackDefinition {};
			class getTrackMapConnection {};
			class getTracksAtPosition {};
			class getTrackUnderTrain {};
			class getTrackWorldPaths {};
			class initTracks {};
			class lookupTrackMapPosition {};
			class preloadAllTracksNearEditorPlacedConnections {};
		};
		
		class Train
		{
			file = "ats\core\functions\train";
			class initTrains {};
		};

		class TrainCommon
		{
			file = "ats\core\functions\train\common";
			class calculateTrainAlignment {};
			class getPositionAndDirectionOnPath {};
			class getTrainAtPosition {};
			class getTrainDefinition {};
			class getTrainPositionAndDirection {};
			class getTrainUnderPlayer {};
			class hideTrainObject {};
			class hideTrainObjectGlobal {};
			class hideTrainObjectLocal {};
			class hideTrainReplaceWithNew {};
			class initTrainObject {};
			class isPassengerMoving {};
			class isTrainLocal {};
			class getNearestTrainCar {};
		};

		class TrainControls
		{
			file = "ats\core\functions\train\controls";
			class attachToTrainCar {};
			class disableTrainInputHandlers {};
			class disableTrainPassengerInputHandlers {};
			class enableTrainInputHandlers {};
			class enableTrainPassengerInputHandlers {};
			class exitTrain {};
			class exitTrainPassenger {};
			class getInTrain {};
			class getInTrainPassenger {};
			class managePlayerTrainActions {};
			class passengerMoveInputHandler {};
			class rideOnTrain {};
			class rideOnTrainEventHandler {};
			class toggleCruiseControl {};
			class trainInputHandler {};
			class toggleLights {};
		};

		class TrainHud
		{
			file = "ats\core\functions\train\hud";
			class disableHud {};
			class enableHud {};
		};

		class TrainSimulation
		{
			file = "ats\core\functions\train\simulation";
			class cleanUpNodePath {};
			class drawEventHandler {};
			class drawTrain {};
			class handleSimulationNetworkUpdates {};
			class handleVelocityNetworkUpdates {};
			class setWheelSpeed {};
			class simulateTrain {};
			class simulateTrainAttachment {};
			class simulateTrainParticleEffects {};
			class simulateTrainVelocity {};
		};
		
		class TrainSound
		{
			file = "ats\core\functions\train\sound";
			class addTrainSoundDefinition {};
			class getTrainSoundDefinition {};
			class initTrainSound {};
			class simulateTrainSounds {};
		};
		
		class Sound
		{
			file = "ats\core\functions\sound";
			class attachSoundSource {};
			class createSoundSource {};
			class deleteSoundSource {};
			class detatchSoundSource {};
			class enableSoundSource {};
			class getSoundSourcePositionASL {};
			class getSoundSourceVolume {};
			class initSound {};
			class nearbySoundSourceHandler {};
			class setSoundSourcePositionASL {};
			class setSoundSourceVolume {};
			class soundSourceAttachedTo {};
			class soundSourceSimulationHandler {};
		};
		
	};
};

class CfgSounds
{
	class ATS_Train_Track_Sound
	{
		name = "";
		sound[] = {"\ats\core\sounds\train_track.ogg", db-5, 1};
		titles[] = {0,""};
	};
	class ATS_Train_Engine_Sound
	{
		name = "";
		sound[] = {"\ats\core\sounds\train_engine.ogg", db-12, 1};
		titles[] = {0,""};
	};
	class ATS_Train_Engine_Idle_Sound
	{
		name = "";
		sound[] = {"\ats\core\sounds\train_engine_idle.ogg", db-4, 1};
		titles[] = {0,""};
	};
	class ATS_Train_Steam_Engine_Sound
	{
		name = "";
		sound[] = {"\ats\core\sounds\train_steam_engine.ogg", db-0, 1};
		titles[] = {0,""};
	};
	class ATS_Train_Steam_Engine_Idle_Sound
	{
		name = "";
		sound[] = {"\ats\core\sounds\train_steam_engine_idle.ogg", db-4, 1};
		titles[] = {0,""};
	};
	class ATS_Train_Bell_Sound
	{
		name = "";
		sound[] = {"\ats\core\sounds\train_bell.ogg", db-0, 1};
		titles[] = {0,""};
	};
	class ATSHornStart
	{
		name = "";
		sound[] = {"\ats\core\sounds\horn_start.ogg", db+5, 1};
		titles[] = {0,""};
	};
	class ATSHornMiddle1
	{
		name = "";
		sound[] = {"\ats\core\sounds\horn_middle1.ogg", db+5, 1};
		titles[] = {0,""};
	};
	class ATSHornMiddle2
	{
		name = "";
		sound[] = {"\ats\core\sounds\horn_middle2.ogg", db+5, 1};
		titles[] = {0,""};
	};
	class ATSHornEnd
	{
		name = "";
		sound[] = {"\ats\core\sounds\horn_end.ogg", db+5, 1};
		titles[] = {0,""};
	};
};
