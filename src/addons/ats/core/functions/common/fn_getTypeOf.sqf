params ["_object"];
private _typeOfArray = [typeOf _object,false];
if( (_typeOfArray select 0) != "" ) exitWith { _typeOfArray };
private _modelName = ((str _object) splitString ": ") param [1, ""];
private _modelToTypeMapIndex = ATRAIN_Object_Model_To_Type_Map_Index find (toLower _modelName);
if(_modelToTypeMapIndex >= 0) then {
	_typeOfArray = (ATRAIN_Object_Model_To_Type_Map select _modelToTypeMapIndex) select 1;
};
_typeOfArray;
