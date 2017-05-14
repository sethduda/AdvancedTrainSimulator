
ATRAIN_Track_Definitions = missionNamespace getVariable ["ATRAIN_Track_Definitions",[]];

// [Class Name, Center Point Offset, Is Split Track, Is End Track,Memory Point Height Offset]
ATRAIN_Track_Definitions append [ 
	["Land_Track_01_3m_F",0,false,false], 
	["Land_Track_01_7deg_F",0.15,false,false], 
	["Land_Track_01_10m_F",0,false,false], 
	["Land_Track_01_15deg_F",0.3,false,false], 
	["Land_Track_01_20m_F",0,false,false], 
	["Land_Track_01_30deg_F",0.6,false,false], 
	["Land_Track_01_bridge_F",0,false,false], 
	["Land_Track_01_bumper_F",0,false,true], 
	["Land_Track_01_turnout_left_F",0.55,true,false], 
	["Land_Track_01_turnout_right_F",-0.55,true,false], 
	["ATS_Tracks_Cable_Wire",0,false,false], 
	["ATS_Tracks_Cable_Wire_50",0,false,false], 
	["ATS_Tracks_Cable_Wire_Stop",0,false,true],
	["ATS_Tracks_Cable_Pole",0,false,false],
	// Test Tracks Below
	["Land_straight40",0,false,false,0.06],
	["Land_left_turn",1,true,false,0.06],
	["Land_right_turn",-1,true,false,0.06],
	["Land_straight25",0,false,false,0.06],
	["Land_Bridge",0,false,false,0.06],
	["Land_terminator_concrete",0,false,true,0.06],
	["Land_straight_down40",0,false,false,0.06],
	["Land_stonebridge",0,false,false,0.06],
	["Land_Bridgehalf",0,false,false,0.06],
	["Land_road_xing_25",0,false,false,0.06],
	["Land_xroad_10",0,false,false,0.06],
	["Land_xroad_25",0,false,false,0.06],
	["Land_curveR25_5",0.3,false,false,0.06],
	["Land_curveL30_20",0.3,false,false,0.06],
	["Land_curveL25_10",0.3,false,false,0.06],
	["Land_curveL25_5",0.3,false,false,0.06]
];


ATRAIN_Object_Model_To_Type_Map = missionNamespace getVariable ["ATRAIN_Object_Model_To_Type_Map",[]];

ATRAIN_Object_Model_To_Type_Map append [
	["track_01_3m_f.p3d",["Land_Track_01_3m_F",true]],
	["track_01_7deg_f.p3d",["Land_Track_01_7deg_F",true]],
	["track_01_10m_f.p3d",["Land_Track_01_10m_F",true]],
	["track_01_15deg_f.p3d",["Land_Track_01_15deg_F",true]],
	["track_01_20m_f.p3d",["Land_Track_01_20m_F",true]],
	["track_01_30deg_f.p3d",["Land_Track_01_30deg_F",true]],
	["track_01_bridge_f.p3d",["Land_Track_01_bridge_F",true]],
	["track_01_bumper_f.p3d",["Land_Track_01_bumper_F",true]],
	["track_01_turnout_left_f.p3d",["Land_Track_01_turnout_left_F",true]],
	["track_01_turnout_right_f.p3d",["Land_Track_01_turnout_right_F",true]],
	["ats_tracks_cable_pole.p3d",["ATS_Tracks_Cable_Pole",true]],
	["ats_tracks_cable_wire.p3d",["ATS_Tracks_Cable_Wire",true]],
	["ats_tracks_cable_wire_50.p3d",["ATS_Tracks_Cable_Wire_50",true]],
	["ats_tracks_cable_wire_stop.p3d",["ATS_Tracks_Cable_Wire_Stop",true]],
	// Test Objects Below
	["straight40.p3d",["Land_straight40",true]],
	["right_turn.p3d",["Land_left_turn",true]],
	["right_turn.p3d",["Land_right_turn",true]],
	["straight25.p3d",["Land_straight25",true]],
	["Bridge.p3d",["Land_Bridge",true]],
	["straight_down40.p3d",["Land_terminator_concrete",true]],
	["terminator_concrete.p3d",["Land_straight_down40",true]],
	["stonebridge.p3d",["Land_stonebridge",true]],
	["Bridgehalf.p3d",["Land_Bridgehalf",true]],
	["road_xing_25.p3d",["Land_road_xing_25",true]],
	["xroad_10.p3d",["Land_xroad_10",true]],
	["xroad_25.p3d",["Land_xroad_25",true]],
	["curveR25_5.p3d",["Land_curveR25_5",true]],
	["curveL30_20.p3d",["Land_curveL30_20",true]],
	["curveL25_10.p3d",["Land_curveL25_10",true]],
	["curveL25_5.p3d",["Land_curveL25_5",true]]
];


[] call ATRAIN_fnc_rebuildArrayLookupIndexes;

[] call ATRAIN_fnc_preloadAllTracksNearEditorPlacedConnections;

/*
[
	[Track, Track Vector Dir, Start Node Track, End Node Track],
	...
]
*/
ATRAIN_Track_Node_Lookup = missionNamespace getVariable ["ATRAIN_Track_Node_Lookup",[]];


/*
[
	Track Object,
	...
]
*/
ATRAIN_Nodes = missionNamespace getVariable ["ATRAIN_Nodes",[]];

/*
Map: [
	Node: [
		Connection: [
			Node Index, 
			Distance,
			Path: [   
 				Point: [Pos, Dir, Up], ...
			]
		],
		...
	],
	...
]
*/
ATRAIN_Map = missionNamespace getVariable ["ATRAIN_Map",[]];
