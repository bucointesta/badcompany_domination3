// by Bucointesta
//#define __DEBUG__
#define THIS_FILE "fn_checkpilotout.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated || {param [2] != player}) exitWith {};

if ({(param [1] == "driver") || (param [1] == "gunner")} && {(player getVariable "d_hud_id") != -1000}) then {
	(param [0]) removeAction (player getVariable "d_hud_id");
	player setVariable ["d_hud_id", -1000];
};

//player removeAllEventHandlers "seatSwitchedMan";