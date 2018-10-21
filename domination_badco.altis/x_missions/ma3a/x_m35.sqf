// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m35.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = "d_sm_35" call d_fnc_smmapos; // index: 35,   Capture the flag, Aktinarki
d_x_sm_type = "normal"; // "convoy"

if (hasInterface) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_857";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_776";
};

if (call d_fnc_checkSHC) then {
	[d_x_sm_pos] spawn d_fnc_sideflag;
};
