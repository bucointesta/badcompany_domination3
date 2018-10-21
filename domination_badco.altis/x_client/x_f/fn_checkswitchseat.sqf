// by Xeno
#define THIS_FILE "fn_checkswitchseat.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

if ({(assignedVehicleRole player) select 0 == "Driver"} || {(assignedVehicleRole player) select 1 == 0}) then {
	_player action ["getOut", vehicle player];
	hintSilent "You are not allowed to drive this vehicle !";
	player removeAllEventHandlers "seatSwitchedMan";
};

