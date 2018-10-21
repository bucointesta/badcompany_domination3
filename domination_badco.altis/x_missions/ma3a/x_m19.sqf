// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m19.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = "d_sm_19" call d_fnc_smmapos; // index: 19,   Convoy Faros to Zaros, start and end position
d_x_sm_type = "convoy"; // "convoy"

if (hasInterface) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_838";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_753";
};

if (call d_fnc_checkSHC) then {
	[d_x_sm_pos select 0, d_x_sm_pos select 1, markerDir "d_sm_19"] spawn d_fnc_sideconvoy;
};
