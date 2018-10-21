// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m26.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = "d_sm_26" call d_fnc_smmapos; // Specop camp near Agios Konstantinos
d_x_sm_type = "normal"; // "convoy"

if (hasInterface) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_846";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_760";
};

if (call d_fnc_checkSHC) then {
	[d_x_sm_pos select 0] spawn d_fnc_sidespecops;
};
