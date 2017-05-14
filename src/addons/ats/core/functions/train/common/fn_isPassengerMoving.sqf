params ["_player"];
(_player getVariable ["ATRAIN_Passenger_Forward", 0]) + (_player getVariable ["ATRAIN_Passenger_Backward", 0]) + (_player getVariable ["ATRAIN_Passenger_Right", 0]) + (_player getVariable ["ATRAIN_Passenger_Left", 0]) > 0;
