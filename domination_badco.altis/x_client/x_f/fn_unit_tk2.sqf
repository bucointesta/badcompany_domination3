// by Xeno
#define THIS_FILE "fn_unit_tk2.sqf"
#include "..\..\x_setup.sqf"

if (d_sub_tk_points != 0) then {
	[format [localize "STR_DOM_MISSIONSTRING_504", param [0], param [1], d_sub_tk_points], "GLOBAL"] call d_fnc_HintChatMsg;
} else {
	[format [localize "STR_DOM_MISSIONSTRING_505", param [0], param [1]], "GLOBAL"] call d_fnc_HintChatMsg;
};