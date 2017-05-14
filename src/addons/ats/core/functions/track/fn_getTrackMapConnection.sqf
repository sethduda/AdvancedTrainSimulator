params ["_startNodeIndex","_connectionNodeIndex"];
private _foundConnection = [];
private _mapStartNode = ATRAIN_Map select _startNodeIndex;
{
	if((_x select 0) == _connectionNodeIndex) exitWith { _foundConnection = _x };
} forEach _mapStartNode;
_foundConnection;
